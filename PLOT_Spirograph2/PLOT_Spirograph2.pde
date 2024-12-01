import processing.svg.*;  //<>//
import java.util.*;


class Orbit
{

  float x;
  float y;
  float r;

  float speed;
  float angle;
  int steps;

  int direction;

  float ratio;

  boolean innerCircle;

  boolean odd;

  Orbit parent;
  Orbit child;

  Orbit (float x, float y, float r, boolean inner, Orbit p)
  {
    this.x = x;
    this.y = y;
    this.r = r;

    innerCircle = inner;

    parent = p;
    child = null;
    angle = (parent == null ? random(TWO_PI) : parent.angle );
    speed = 1;
    steps = floor(random(10, 199));
    ratio = (parent == null ? 1 : parent.ratio + (parent.r / r) + 1 * (innerCircle ? -1 : 1));
    direction = (parent == null ? -1 : parent.direction * (innerCircle ? 1 : -1));

    odd  = (parent == null ? true : !parent.odd);
  }

  // preinitialized chilc
  private Orbit addChild(Orbit child)
  {
    this.child = child;
    return child;
  }

  Orbit addChild(float newradius, boolean innerCircle) {

    float newx = x + r + newradius;
    float newy = y;

    return addChild(new Orbit(newx, newy, newradius, innerCircle, this));
  }


  void update()
  {
    int steppos = (useSteps ? steps : 1 );
    for (int i = 0; i < steppos; i++) {

      angle += speed ;
      if ( parent != null) {

        // angle += parent.speed;

        float factor = innerCircle ? -1 : 1;
        float rsum = parent.r + r * factor;

        float rad = radians(angle * direction  * ratio); // * (float)(Math.PI / 180);

        x = parent.x + rsum * cos(rad);
        y = parent.y - rsum * sin(rad);
      }
    }
  }

  void show()
  {

    // circle
    stroke(color(239, 0, 0));
    strokeWeight(1);
    noFill();

    ellipse(x, y, r*2, r*2);

    // radius
    float rad = radians(angle * direction * ratio); // * (float)(Math.PI / 180);

    float xx = x + cos(rad) * r;
    float yy = y - sin(rad) * r;

    stroke(color(239, 0, 0, 100));
    strokeWeight(0.6);

    line(x, y, xx, yy);
  }
}

class Settings {


  ArrayList<Float> radii;
  ArrayList<Float> pitches;
  ArrayList<Float> drawPitches;
  ArrayList<Float> spinPitches;

  ArrayList<Character> types;

  ArrayList<Integer> directions;

  // center
  float centerX;
  float centerY;
  float i = 0;
  Point penStart;
  float penRad;

  Settings()
  {
    radii = new ArrayList<Float>(); // float[circles];
    pitches  = new ArrayList<Float>(); // new float[circles];
    drawPitches  = new ArrayList<Float>(); // new float[circles];
    spinPitches  = new ArrayList<Float>(); // new float[circles];
    types = new ArrayList<Character>(); // new char[circles];
    directions = new ArrayList<Integer>(); // new int[circles];

    penRad = random(-20, 100);
  }
}

class Point {
  float x;
  float y;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}




//---------------------------------
int minCircles = 2;
int maxCircles = 3;

float penDistance = 150; // random(-20, 100);

boolean bExportSVG = false;
boolean showCircles = true;
boolean showPath = false;
boolean useSteps = false;
int globalSpeed = 1;
int globalSpeedSteps = 5;
color backgroundColor = 51;
String baseFilename ="";

//---------------------------------

ArrayList<PVector> path;
ArrayList<Orbit> circles;

Orbit centerCircle;
Orbit drawingCircle;

float drawingPos_xx;
float drawingPos_yy;

Settings settings;


//---------------------------------

void setup()
{
  size (900, 900);
  frameRate(20);
  background(backgroundColor);
  noFill();

  if (!initFromFile())
  {
    init();    
  }
}

boolean initFromFile() {

  boolean initialized = false;

  circles = new ArrayList<Orbit> ();

  try
  {
    JSONObject json = loadJSONObject("spiro.json");
    JSONObject settings = json.getJSONObject("settings");

    penDistance = settings.getFloat("penDistance");
    int Nrcircles =   settings.getInt("circles");

    showCircles = settings.getBoolean("showCircles");
    showPath = settings.getBoolean("showPath");
    useSteps = settings.getBoolean("useSteps");
    globalSpeed = settings.getInt("globalSpeed");

    for ( int i = 0; i < Nrcircles; i++ )
    {
      JSONObject circlej = json.getJSONObject("circle"+i);

      float newradius = circlej.getFloat("r");
      boolean innerCircle = circlej.getBoolean("innerCircle");
      // int steps = circlej.getInt("steps");
      
      if ( i == 0)
      {
        centerCircle = new Orbit(width/2, height/2, newradius, false, null);
        drawingCircle = centerCircle;
      } else
      {
        drawingCircle = drawingCircle.addChild(newradius, innerCircle);
      }

      circles.add(drawingCircle);
      
    }

    initializeSettings();

    path = new ArrayList<PVector> ();

    initialized = true;
  }
  catch (Exception x )
  {
    //println("XXX: "+x.toString());
    println(" --- This is OK --> if you want to initialize from file name it <spiro.json>");
  }

  return initialized;
}

void init() {

  penDistance = random(-20, 100);

  path = new ArrayList<PVector> ();
  circles = new ArrayList<Orbit> ();

  centerCircle = new Orbit(width/2, height/2, random(width/5), false, null);
  circles.add(centerCircle);

  drawingCircle = centerCircle;

  for ( int i = 0; i < floor(random(minCircles, maxCircles)); i++) {
    float newradius = random(10, width/6);
    boolean innerCircle = random(1) > 0.5 ? true : false;
    drawingCircle = drawingCircle.addChild(newradius, innerCircle);
    circles.add(drawingCircle);
  }
  
  initializeSettings();
  
}

void initializeSettings() {

  settings = new Settings();

  settings.centerX = width/2;
  settings.centerY = height/2;

  settings.penRad = penDistance;
  settings.radii.add( circles.get(0).r);
  settings.types.add( ' ' );
  settings.pitches.add( 1.0 );
  //settings.pitches[1] = 1;

  for ( int c = 1; c < circles.size(); c++) {
    Orbit circle = circles.get(c);

    settings.radii.add( circle.r );
    settings.types.add( circle.innerCircle ? 'h' : 'e' );

    if (circle.innerCircle)
    {
      if (c > 1) {
        settings.drawPitches.add( settings.spinPitches.get(c - 2));
        settings.spinPitches.add( settings.radii.get(c - 1) / settings.radii.get(c) - 1);

        if (settings.types.get(c - 1) == 'h') {
          settings.directions.add( settings.directions.get(c - 1));
        } else {
          settings.directions.add( settings.directions.get(c - 1) * -1);
        }
      } else {
        settings.directions.add( 1) ; // ?
        settings.directions.add( 1) ;
        settings.drawPitches.add(1.0);
        settings.spinPitches.add( settings.radii.get(c - 1) / settings.radii.get(c) - 1);
      }
    } else {
      // settings.types.add( 'e' ); // ??????????????????
      if (c > 1) {
        settings.drawPitches.add( settings.spinPitches.get(c - 2));
        settings.spinPitches.add( settings.radii.get(c - 1) / settings.radii.get(c) + 1);
        if (settings.types.get(c - 1) == 'h') {
          settings.directions.add( settings.directions.get(c - 1));
        } else {
          settings.directions.add( settings.directions.get(c - 1) * -1);
        }
      } else {

        settings.directions.add(1);  // ?
        settings.directions.add(1);
        settings.drawPitches.add(1.0);
        settings.spinPitches.add( settings.radii.get(c - 1) / settings.radii.get(c) + 1);
      }
    }
  }
}

Point circlePoint(float a, float b, float r, float ng) {
  float rad = ng * (PI / 180);
  float y = r * sin(rad);
  float x = r * cos(rad);

  x = a + x;
  y = b - y;

  return new Point(x, y);
}

void drawOneCircle(float x, float y, float r, boolean fill) {

  // circle
  stroke(color(239, 0, 0));
  strokeWeight(2);
  noFill();

  if (fill)
    fill(color(239, 239, 0, 100));

  ellipse(x, y, r*2, r*2);

  if (fill)
    noFill();
}

void drawCircles() {

  int c = 1;
  var i = settings.i;

  float thisRad = 0;
  float prevRad = 0;
  float centerRad = 0;
  float thisPitch = 0;
  // float prevPitch = 0;
  float prevSpinPitch = 0;
  float prevDrawPitch = 0;
  // float pen;
  float penPitch=1;
  float zoom = 1;

  //draw Stator
  if ( showCircles) {
    drawOneCircle( settings.centerX, settings.centerY, settings.radii.get(0) * zoom, false);
  }

  //start at the center
  Point pt = new Point( settings.centerX, settings.centerY);

//   println( settings.types );

  c = 1;
  //draw rotor Circles
  while (c < (settings.radii.size())) {

    //set radii, applying zoom
    thisRad = settings.radii.get(c) * zoom;
    prevRad = settings.radii.get(c - 1) * zoom;

    if (settings.types.get(c) == 'h') {
      //hypitrochoid: circle inside
      centerRad = prevRad - thisRad;
    } else {
      //eptrochoid: circle outside
      centerRad = prevRad + thisRad;
    }

    //pitches are cumulative, so extract previous from array.
    if (c > 1) {
      // prevPitch = prevPitch + settings.pitches[c - 2];
      prevSpinPitch = prevSpinPitch + settings.spinPitches.get(c - 2);
      prevDrawPitch = prevDrawPitch + settings.drawPitches.get(c - 2);
    } else {
      // prevPitch = 0;
      prevSpinPitch = 0;
      prevDrawPitch = 0;
    }

    //set travel direction
    float mult = settings.directions.get(c);

    //set draw pitch
    thisPitch = (settings.drawPitches.get(c - 1) + prevDrawPitch) * mult;

    //set pen pitch

    if (settings.types.get(c) == 'h') {
      penPitch = (settings.spinPitches.get(c - 1) + prevSpinPitch) * mult * -1;
    } else {
      penPitch = (settings.spinPitches.get(c - 1) + prevSpinPitch) * mult;
    }

    //draw this rotor
    Point pt2 = circlePoint(pt.x, pt.y, centerRad, i * thisPitch);
    if ( showCircles) {
      drawOneCircle(pt2.x, pt2.y, thisRad, false);
    }

    //draw radius
    //pen pitch set in last circle iteration
    Point penPt = circlePoint(pt2.x, pt2.y, thisRad, i * penPitch);
    if ( showCircles) {
      strokeWeight(0.5);
      line (pt2.x, pt2.y, penPt.x, penPt.y);
    }
    pt.x = pt2.x;
    pt.y = pt2.y;

    c++;
  }

  //draw Pen
  //pen pitch set in last circle iteration
  Point penPt = circlePoint(pt.x, pt.y, settings.penRad * zoom, i * penPitch);
  
  //mark our starting point
  if (settings.i == 0) {
    settings.penStart = penPt;
  }

  //line from center to pen
  if ( showCircles) {
    line (pt.x, pt.y, penPt.x, penPt.y);

    //circle for pen Point
    drawOneCircle(penPt.x, penPt.y, 5, true);
  }

  //update curve points
  path.add(new PVector(penPt.x, penPt.y));
}


void draw()
{
  // background(51);
  background(255);
  noFill();

  boolean wasShow = showCircles;
  boolean wasShowPath = showPath;

  showCircles = false;

  // calc-only
  for ( int i=0; i < globalSpeed; i++) {
    drawCircles();
    settings.i ++;
  }

  showCircles = wasShow;

  // just to show circles
  if (showCircles)
    drawCircles();


  if (bExportSVG)
  {
    showCircles = false;
    showPath = true;
    beginRecord(SVG, baseFilename+".svg");
  }

  // draw path
  if (showPath) {
    stroke(51);
    strokeWeight(0.2);

    beginShape();
    for (PVector xy : path) {
      vertex( xy.x, xy.y);
    }
    endShape();
  }
  if (bExportSVG)
  {
    endRecord();
    bExportSVG = false;
    showCircles=wasShow;
    showPath=wasShowPath;
  }
}



String timestamp()
{
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

// --------------------------------------------------

void setBaseFilename() {

  baseFilename = "frames/plot-"+timestamp();
}

void saveSettings()
{
  JSONObject json = new JSONObject();

  Orbit current = centerCircle;

  int i = 0;

  while (current != null) {

    JSONObject circle = new JSONObject();
    circle.setFloat("r", current.r);
    circle.setBoolean("innerCircle", current.innerCircle);

    json.setJSONObject("circle"+i, circle);
    i += 1;
    current = current.child;
  }

  JSONObject settings = new JSONObject();
  settings.setFloat("penDistance", penDistance);
  settings.setInt("circles", i);
  settings.setBoolean("showCircles", showCircles);
  settings.setBoolean("showPath", showPath);
  settings.setBoolean("useSteps", useSteps);
  settings.setInt("globalSpeed", globalSpeed);

  json.setJSONObject("settings", settings);

  saveJSONObject(json, baseFilename+".json");
}

void save()
{
  setBaseFilename();
  saveFrame(baseFilename + ".png");
  saveSettings();
  bExportSVG = true;
}

void keyPressed()
{
  if (key != ESC)
  {
    switch (key)
    {
    case 's':
      {
        // casing();
        save();
        break;
      }
    case 'x':
      {
        init();
        break;
      }
    case 'c':
      {
        showCircles = !showCircles;
        break;
      }
    case 'p':
      {
        showPath = !showPath;
        break;
      }
    case 'u':
      {
        path.clear();
        useSteps = !useSteps;
        break;
      }
    case '+':
      {
        globalSpeed += globalSpeedSteps;
        break;
      }
    case '-':
      {
        globalSpeed -= globalSpeedSteps;
        if ( globalSpeed <= 0)
          globalSpeed = 1;
        break;
      }
    }
  }
}

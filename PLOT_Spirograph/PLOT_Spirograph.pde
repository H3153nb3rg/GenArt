import processing.svg.*;
import java.util.*;


class Orbit
{

  float x;
  float y;
  float r;

  float speed;
  float angle;
  int steps;

  float ratio;

  boolean innerCircle;

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
    angle = random(TWO_PI);
    speed = 0.01;
    steps = floor(random(10, 199));
    ratio = random(-2, 2);
  }

  Orbit addChild(Orbit child)
  {
    this.child = child;
    return child;
  }

  Orbit addChild() {
    float newradius = random(10, width/4); // r * random(0.2, 1.5);
    float newx = x + r + newradius; //(newradius * (random(0, 1) < 0.5 ? -1 : 1));
    float newy = y;
    innerCircle = random(1) > 0.5 ? true : false;

    return addChild(new Orbit(newx, newy, newradius, innerCircle, this));
  }


  void update()
  {
    int steppos = (useSteps ? steps : 1 );
    for (int i = 0; i < steppos; i++) {

      angle += speed ;
      if ( parent != null) {

        angle += parent.speed;

        float factor = innerCircle ? -1 : 1;
        float rsum = r *factor + parent.r;

        x = parent.x + rsum * cos(angle*ratio);
        y = parent.y + rsum * sin(angle*ratio);
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
    float xx = x + cos(angle) * r;
    float yy = y + sin(angle) * r;

    stroke(color(239, 0, 0, 100));
    strokeWeight(0.6);

    line(x, y, xx, yy);
  }
}

//---------------------------------
int minCircles = 2;
int maxCircles = 5;

float penDistance = random(-20, 100);

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

Orbit centerCircle ;

void setup()
{
  size (900, 900);


  background(backgroundColor);
  noFill();

  if (!initFromFile())
  {
    init();
  }
}

boolean initFromFile() {

  boolean initialized = false;

  try
  {

    Orbit next = centerCircle;

    JSONObject json = loadJSONObject("spiro.json");

    JSONObject settings = json.getJSONObject("settings");
    penDistance = settings.getFloat("penDistance");
    int circles =   settings.getInt("circles");

    showCircles = settings.getBoolean("showCircles");
    showPath = settings.getBoolean("showPath");
    useSteps = settings.getBoolean("useSteps");
    globalSpeed = settings.getInt("globalSpeed");

    for ( int i =0; i < circles; i++ )
    {
      JSONObject circlej = json.getJSONObject("circle"+i);

      if ( i == 0)
      {
        centerCircle = new Orbit(width/2, height/2, random(width/5), false, null);
        next = centerCircle;
      } else
      {
        next = next.addChild();
      }

      next.x = circlej.getFloat("x");
      next.y = circlej.getFloat("y");
      next.r = circlej.getFloat("r");
      next.speed = circlej.getFloat("speed");
      next.angle = circlej.getFloat("angle");
      next.steps = circlej.getInt("steps");
      next.ratio = circlej.getFloat("ratio");
      next.innerCircle = circlej.getBoolean("innerCircle");
    }

    path = new ArrayList<PVector> ();

    initialized = true;
  }
  catch (Exception x )
  {
    println("XXX: "+x.toString());
  }


  return initialized;
}

void init() {

  path = new ArrayList<PVector> ();

  centerCircle = new Orbit(width/2, height/2, random(width/5), false, null);

  Orbit next = centerCircle;
  for ( int i = 0; i < floor(random(minCircles, maxCircles)); i++) {
    next = next.addChild();
  }
}


void update(int iterations) {

  for ( int i = 0; i < iterations; i++) {

    Orbit current = centerCircle;
    Orbit last = centerCircle;

    current = centerCircle;
    last = centerCircle;

    while (current != null) {

      current.update();

      last = current;

      current = current.child;
    }

    // calc the point
    float xx = last.x + cos(last.angle) * penDistance;
    float yy = last.y + sin(last.angle) * penDistance;

    path.add(new PVector(xx, yy));
  }
}

void draw() {

  background(51);
  noFill();

  boolean wasShow = showCircles;
  boolean wasShowPath = showPath;

  update(globalSpeed);

  if ( showCircles) {
    Orbit current = centerCircle;
    Orbit last = centerCircle;

    current = centerCircle;
    last = centerCircle;

    while (current != null) {
      current.show();
      last = current;

      current = current.child;
    }

    // the dot
    float xx = last.x + cos(last.angle) * penDistance;
    float yy = last.y + sin(last.angle) * penDistance;

    line (last.x, last.y, xx, yy);

    stroke(color(239, 239, 0, 100));
    fill(color(239, 239, 0, 100));
    ellipse(xx, yy, 5, 5);
    noFill();
  }

  if (bExportSVG)
  {
    showCircles = false;
    showPath = true;
    beginRecord(SVG, baseFilename+".svg");
  }

  if (showPath) {
    stroke(255);
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
    circle.setFloat("x", current.x);
    circle.setFloat("y", current.y);
    circle.setFloat("r", current.r);
    circle.setFloat("speed", current.speed);
    circle.setFloat("angle", current.angle);
    circle.setInt("steps", current.steps);
    circle.setFloat("ratio", current.ratio);
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

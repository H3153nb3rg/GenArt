import java.text.SimpleDateFormat;
import java.util.Date;
import java.time.Instant;
import nice.palettes.*;

//import com.cage.colorharmony.*;

// import processing.javafx.*;

import micycle.pgs.*;
import micycle.pgs.commons.*;
import micycle.pgs.color.*;
import micycle.peasygradients.colorspace.*;
import micycle.peasygradients.gradient.*;
import micycle.peasygradients.utilities.fastLog.*;
import micycle.peasygradients.utilities.*;
import micycle.peasygradients.*;

boolean UHD = false;     // for screen 16:9 or print 2:3

int seed;               // = millis();
int scaleFactor = 10;   // for highres printing
int iteration = 0;

// A2 4:5
// A3 3:4
// A4 2:3


//ColorHarmony colorHarmony = new ColorHarmony(this, 15, 55, 20, 65);

PeasyGradients renderer;
ColorPalette palette;


//--------------------------------------

color[][] colors = {{#E81010, #4C80B7, #1A4A7C, #179CBC}, // colorHarmony.Monochromatic();//Triads();//Complementary(); // Monochromatic();  // Analogous();//
  { #574f47, #5b6061, #5e8195, #a1c6d6, #f1dacf},
  { #f35c48, #387d7d, #5cb786, #9bd6a0, #d3e9b4 },
  { #fd1034, #01ffe6, #262903, #018a78, #03d3bb, #7affec, #dafefa},
  { #091b3b, #0f346a, #2c4993, #435da5, #9497bb, #c0becc, #cdcfd1}, // #f5d275,
  { #AA1803, #BD613C, #F1BAA1, #BCAF4D, #6D8C00 },
  { #314448, #536d6c, #536d6c, #c7d3bf, #e0dab8 },
  { #469597, #5BA199, #BBC6C8, #E5E3E4, #DDBEAA },
  { #338309, #C9D46C, #E48716, #FAAB01, #DFBCB2},
  { #6A7865, #95A59E, #7AA7D2, #A8C9EA, #DCE0EB },
  { #033540, #015366, #63898C, #A7D1D2, #E0F4F5 },
  { #65483D, #9E8279, #FDBF6E, #BC2041, #564C55},
  { #1D0F0F, #453C41, #7B7C81, #D4DBE2, #7B586B},
  { #474745, #889293, #B7C1C3, #CCD6D8, #E3E8EB},
  { #3A362E, #7C7B6F, #DDCACE, #E9A098, #D45F5F},
  { #2f5f02, #648c01, #abce00, #caefb3, #f3fbec},
  { #63a91f, #c6dc93, #b0d3bf, #589d62, #1a512e}
};

//--------------------------------------

int minLayer = 6;

int maxHoles = 35;
int minHoles = 10;

//int minRadiusDiv = 4;
//int maxRadiusDiv = 12;

int minCircleDist = 10;
int maxiterShadow = 20;

float border = 0.09;

color background_color = #FFF3EFE4;
color[] paletti;

PGraphics currentLayer;
PGraphics maskLayer;

PGraphics shadowMaskLayer;
PGraphics shadowLayer;

BorderInfo borderInfo;

boolean shaded = false;
boolean useFixedColor = true;

ArrayList<LayerInfo> currentLayerInfo;

void settings()
{
  if (UHD) {
    size(3840/4, 2160/4);
    scaleFactor = 4;
    border = 0.08;
  } else {
    size(600, 900);//, FX2D);
    scaleFactor = 10;
  }
}

void setup() {

  renderer = new PeasyGradients(this);

  //topLayer = createGraphics(width, height);
  currentLayer = createGraphics(width, height);
  maskLayer = createGraphics(width, height);
  shadowLayer  = createGraphics(width, height);
  shadowMaskLayer  = createGraphics(width, height);

  init();

  noLoop();
}

void init()
{
  seed = (int)Instant.now().getEpochSecond();
  randomSeed(seed);
  noiseSeed(seed);

  borderInfo = new BorderInfo(width, height, seed, border);
  palette = new ColorPalette(this);
}


int ortho = 0;

void draw() {

  currentLayerInfo = createLayerInfo(width, height);

  render(width, height, borderInfo.getDisplacement(),
    getGraphics(),
    currentLayer,
    maskLayer,
    shadowLayer,
    currentLayerInfo
    );

  if (borderInfo.isShowFraming()) {

    borderInfo.drawCasing(getGraphics());
  }
}

color[] getColor() {

  if ( useFixedColor) {
    paletti = colors[floor(random(colors.length))];
  } else {
    paletti = palette.getPalette(floor(random(palette.getPaletteCount())));
  }
  return paletti;
}



ArrayList<LayerInfo> createLayerInfo(int w, int h) {

  ArrayList<LayerInfo> layerInfos = new  ArrayList<LayerInfo>();

  color[] backcolor = getColor();  // get palette for whole stack
  int maxLayer = backcolor.length;
  //int maxLayer = backcolor.length >= minLayer ? backcolor.length : minLayer;

  //if ( backcolor.length < minLayer)
  //  shaded = true;

  iteration++;

  ArrayList<Circle2D> circlesBelow = null;

  for (int i = 0; i< maxLayer; i++) {

    LayerInfo li = new LayerInfo();

    int factorX = 0;
    int factorY = 10;
    int factorR = 15;

    ArrayList<Circle2D> circles;

    //if ((circlesBelow != null) && ( i <6)) {
    //  circles = getDependantHoles(circlesBelow, factorX, factorY, factorR);
    //} else {
    //  // circles = getHoles(w, h, minRadiusDiv + (maxLayer-i)/2, maxRadiusDiv);
    //  if (i < 6) {
    //    circles = getHoles(w, h, 80, 85, minCircleDist + (((maxLayer > 6 ? 6 : maxLayer) + 4)*factorR));
    //  } else {
    //    circles = getHoles(w, h, 3, 8, minCircleDist);
    //  }
    //}
    //circlesBelow = circles;

    circles = getHoles(w, h, 2+ (maxLayer-i)/3, 20, minCircleDist);

    color backgroundColor = backcolor[i % backcolor.length];                  //colors[i % colors.length];

    li.setCircles(circles);
    li.setColor(backgroundColor);

    layerInfos.add(li);
  }

  return layerInfos;
}

void scaleLayerInfo(ArrayList<LayerInfo> layerInfos, float scaleFactor) {

  layerInfos.forEach( layerInfo -> {

    layerInfo.getCircles().forEach( circle -> {

      circle.x *= scaleFactor;
      circle.y *= scaleFactor;
      circle.radius *= scaleFactor;
    }
    );
  }
  );
}


void render(int w, int h, int dpos,
  PGraphics baselayer,
  PGraphics currentLayer,
  PGraphics maskLayer,
  PGraphics shadowLayer,
  ArrayList<LayerInfo> layerInfos) {

  PGraphics lastLayer = null;

  baselayer.beginDraw();
  baselayer.background(255);
  baselayer.endDraw();

  for (int i = 0; i< layerInfos.size(); i++) {

    ArrayList<Circle2D> circles = layerInfos.get(i).getCircles();    //getHoles(w, h, minRadiusDiv + (maxLayer-i)/2, maxRadiusDiv);

    // PShape holes = getHoles(true, w, h, minRadiusDiv, maxRadiusDiv);

    // Zeichne die untere Ebene
    currentLayer.beginDraw();
    currentLayer.noStroke();

    color backgroundColor = layerInfos.get(i).getColor(); // colors[floor(random(colors.length))];

    if (shaded) {// (( i == layerInfos.size()-1) && (shaded)) { //  ( lastLayer != null) { //
      //Gradient gradient = new Gradient(color(red(backgroundColor)-10, green(backgroundColor)-10, blue(backgroundColor)-10, 10), color(red(backgroundColor)+10, green(backgroundColor)+10, blue(backgroundColor), 255));

      // Gradient gradient = new Gradient( color(200), color(230)); // new Gradient( backcolor[(i-1) % backcolor.length], backcolor[i % backcolor.length]  ); //new Gradient( color(200), color(230));
      Gradient gradient = new Gradient( color(red(backgroundColor)-30, green(backgroundColor)-30, blue(backgroundColor)-30), color(red(backgroundColor)+30, green(backgroundColor)+30, blue(backgroundColor)+30));
      //Gradient gradient = new Gradient( colorSchemes[floor(random(colorSchemes.length))]);
      gradient.setInterpolationMode(Interpolation.SMOOTH_STEP);

      renderer.setRenderTarget(currentLayer);
      renderer.linearGradient(gradient, (int(random(4)) * 360) / 4); //map(floor(random(360)), 0, 360, 0, TWO_PI));//  PI/2); // gradient, angle
    } else
    {
      currentLayer.background(backgroundColor); // 255-i*(255/maxLayer), 0, 0);
    }

    currentLayer.endDraw();


    //  Maske
    if ( lastLayer != null) {
      maskLayer.beginDraw();

      maskLayer.background(255);
      maskLayer.fill(0);

      for (int c = 0; c < circles.size(); c++) {
        Circle2D circle = circles.get(c);
        maskLayer.circle( circle.getX(), circle.getY(), circle.getRadius()*2);
      }

      //      maskLayer.shape(holes);

      // shadows
      currentLayer.mask(maskLayer);

      // shadow
      shadowLayer.beginDraw();
      shadowLayer.noStroke();
      shadowLayer.background(255);

      // shadowLayer.filter(BLUR, 7);

      for (int c = 0; c < circles.size(); c++) {
        Circle2D circle = circles.get(c);

        for ( int s = maxiterShadow; s >= -1; s--) {
          shadowLayer.fill(color(90), s*maxiterShadow);
          shadowLayer.circle(circle.getX()+(maxiterShadow-s), circle.getY(), circle.getRadius()*2-(maxiterShadow-s));
          shadowLayer.fill(255);
          shadowLayer.circle(circle.getX()+(maxiterShadow+1-s), circle.getY(), circle.getRadius()*2-(maxiterShadow+2-s));
        }
      }

      //for ( int s = maxiter; s >= -1; s--) {

      //  shadowLayer.fill(color(90), s*maxiter);

      //  // holes.fill(color(90), s*maxiter);

      //  shadowLayer.shape(holes, (maxiter-s), 0);
      //  shadowLayer.fill(255);
      //  //  holes.fill(color(255));
      //  shadowLayer.shape(holes, (maxiter+1-s), 0);
      //}

      shadowLayer.endDraw();
    }

    // show merged layers
    baselayer.beginDraw();
    if (borderInfo.isShowFraming()) {
      baselayer.clip(dpos, dpos, w-dpos*2, h-dpos*2);
    }
    baselayer.image(currentLayer, 0, 0);
    if ( lastLayer != null) {
      if (borderInfo.isShowFraming()) {
        baselayer.blend(shadowLayer, dpos, dpos, w-dpos*2, h-dpos*2, dpos, dpos, w-dpos*2, h-dpos*2, DARKEST);
      } else {
        baselayer.blend(shadowLayer, 0, 0, w, h, 0, 0, w, h, DARKEST);
      }
    }
    if (borderInfo.isShowFraming()) {
      baselayer.noClip();
    }
    baselayer.endDraw();

    lastLayer = currentLayer;
  }
}

void highResRender() {

  int highres_width  = width * scaleFactor;
  int highres_height = height * scaleFactor;

  PGraphics highres = createGraphics(highres_width, highres_height);

  PGraphics currentLayer = createGraphics(highres_width, highres_height);
  PGraphics maskLayer = createGraphics(highres_width, highres_height);
  PGraphics shadowLayer  = createGraphics(highres_width, highres_height);
  // PGraphics shadowMaskLayer  = createGraphics(highres_width, highres_height);

  BorderInfo hrBorderInfo = new BorderInfo(highres_width, highres_height, seed, border);
  hrBorderInfo.setShowFraming(borderInfo.isShowFraming());
  hrBorderInfo.setShowText(borderInfo.isShowText());
  hrBorderInfo.setShowInnerBorder(borderInfo.isShowInnerBorder());

  //int inner_border = floor(border * highres_width);
  //int highres_dpos = inner_border / 2;

  int oldmaxiterShadow = maxiterShadow;
  maxiterShadow = 25;

  scaleLayerInfo(currentLayerInfo, scaleFactor);

  render(highres_width, highres_height, hrBorderInfo.getDisplacement(), highres, currentLayer, maskLayer, shadowLayer, currentLayerInfo);

  if (hrBorderInfo.isShowFraming()) {
    hrBorderInfo.drawCasing(highres);
  }
  scaleLayerInfo(currentLayerInfo, 1/scaleFactor);

  maxiterShadow = oldmaxiterShadow;

  //beginRecord(highres);
  //highres.scale(scaleFactor);
  //highres.smooth();
  ////render(width * scaleFactor, height * scaleFactor);

  //endRecord();

  highres.save("frames/" + seed + " - "+iteration + (UHD ? " - UHD" : " - print") + ".png");
}

PShape getHoles(boolean getCircles, int w, int h, int minRadiusDiv, int maxRadiusDiv, int additionalCircleDist) {

  PShape blobs=null;

  if (getCircles) {
    ArrayList<Circle2D> circles = getHoles(w, h, minRadiusDiv, maxRadiusDiv, additionalCircleDist);

    blobs = createShape(GROUP);

    for (int c = 0; c < circles.size(); c++) {
      Circle2D circle = circles.get(c);

      PShape blob = createShape(ELLIPSE, circle.getX(), circle.getY(), circle.getRadius() * 2, circle.getRadius() * 2);
      blob.setFill(color(0));
      blobs.addChild(blob);
    }
  } else
  {
    // nyi
  }


  return blobs;
}


ArrayList<Circle2D> getDependantHoles(ArrayList<Circle2D> circles, int factorX, int factorY, int factorR)
{
  ArrayList<Circle2D> circlesModified = new ArrayList<Circle2D>();

  circles.forEach( circle -> {

    Circle2D dependentCircle = new Circle2D( circle.x += factorX, circle.y += factorY, circle.radius += factorR);

    circlesModified.add(dependentCircle);
  }
  );

  return circlesModified;
}

ArrayList<Circle2D> getHoles(int w, int h, int minRadiusDiv, int maxRadiusDiv, int minCircleDist)
{
  ArrayList<Circle2D> circles = new ArrayList<Circle2D>();

  int nrCircles = floor(random(minHoles, maxHoles));

  for (int r = minRadiusDiv; r <= maxRadiusDiv; r++) {
    int i = 0;

    // while ((circles.size() < nrCircles) && (i < 1000)) {
    while ( (i < 10000)) {

      int x = floor( random(0, w));
      int y = floor( random(0, h));
      int radius = (w<h ? w : h)/r; // floor(width / random( minRadiusDiv, maxRadiusDiv));
      //int radius = w/(r+2);
      // println(radius);
      Circle2D circle = new Circle2D( x, y, radius);

      if ( checkIfAllowed(circles, circle, minCircleDist, true)) {
        circles.add(circle);
      }
      i++;
    }
  }
  return circles;
}

boolean checkIfAllowed(ArrayList<Circle2D> circles, Circle2D circle, int minCircleDist, boolean overlapped)
{
  boolean invalid = false;

  for (int i = 0; i < circles.size() && !invalid; i++)
  {
    if (overlapped) {
      invalid = circle.overlaps( circles.get(i), minCircleDist);
    } else {
      invalid = circles.get(i).inCircle(circle.x, circle.y);
    }
  }

  return !invalid;
}


void keyPressed() {

  if (key != ESC)
  {

    switch (key)
    {
    case 's':
      {
        // casing();
        saveFrame("frames/####.tif");
        break;
      }
    case 'S':
      {
        highResRender();
        break;
      }
    case 'f' :
      {
        borderInfo.setShowFraming(!borderInfo.isShowFraming());
        redraw();
        break;
      }
    case 't' :
      {
        borderInfo.setShowText(!borderInfo.isShowText());
        redraw();
        break;
      }
    case 'l' :
      {
        useFixedColor = !useFixedColor;
        redraw();
        break;
      }
    case '+':
      {
        ortho += 1;
        redraw();
        break;
      }
    case '-':
      {
        ortho -= 1;
        redraw();
        break;
      }
    case 'w':
      {
        shaded = !shaded;
        redraw();
        break;
      }
    case ' ':
      {
        redraw();
        break;
      }
    }
  }
}

color[] takeColorFromImage(String fn, int maxpal) {

  color[] palette = new color[maxpal];
  // clear background to begin
  background(0xFFFFFFFF);

  // load color source
  PImage b;
  b = loadImage(fn);
  image(b, 0, 0);

  // initialize palette length
  int numpal=0;

  // find all distinct colors
  for (int x=0; x<b.width; x++) {
    for (int y=0; y<b.height; y++) {
      color c = get(x, y);
      boolean exists = false;
      for (int n=0; n<numpal; n++) {
        if (c==palette[n]) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        // add color to palette
        if (numpal<maxpal) {
          palette[numpal] = c;
          numpal++;
        } else {
          break;
        }
      }
    }
  }
  background(255);
  return palette;
}

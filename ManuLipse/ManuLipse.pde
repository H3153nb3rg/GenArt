import java.text.SimpleDateFormat;
import java.util.Date;
import java.time.Instant;
import java.util.Collection;

import nice.palettes.*;

import org.gicentre.handy.*;

HandyRenderer handyPencilRenderer; //, h2, h3, h4;

// int colors = ['#f70640,#f78e2c,#fdd903,#cae509,#63be93,#81cfe5,#299dbf,#38187d,#a4459f,#f654a9,#2F0A30'];
color[] colors = {#0d8cf1, #0eb4f0, #0b770d, #0b0e13, #EFB6F9, #FF9521, #f60402, #cdd3e7, #F4E6FF};
color[] paletti = colors;

int minIterations = 5;
int maxIterations = 25;

int randx = 10;

BorderInfo borderInfo;
ColorPalette palette;

int seed;
boolean useFixedColor = true;
boolean useLerp = true;
boolean useRoughness = false;
boolean useHandy = true;
boolean clear = false;
float border = 0.09;

int scaleFactor = 10;

void setup() {
  size(900, 1350); //1350);
  rectMode(CENTER);
  noLoop();

  init();
}

void init()
{
  seed = (int)Instant.now().getEpochSecond();
  randomSeed(seed);
  noiseSeed(seed);

  //handyPencilRenderer = HandyPresets.createPencil(this);
  //  handyPencilRenderer = HandyPresets.createColouredPencil(this);
  handyPencilRenderer = HandyPresets.createWaterAndInk(this);
  //h4 = HandyPresets.createMarker(this);

  //  handyPencilRenderer.setHachurePerturbationAngle(75);

  borderInfo = new BorderInfo(width, height, seed, border);
  borderInfo.setShowInnerBorder(false);
  palette = new ColorPalette(this);
}


void draw() {

  if (clear || borderInfo.isShowFraming())
  {
    clear = false;
    background(255);
  }
  if (borderInfo.isShowFraming())
  {
    clip(borderInfo.getDisplacement(), borderInfo.getDisplacement(), borderInfo.getInnerSizeX(), borderInfo.getInnerSizeY());
  }


  //int a = floor(random(minIterations, maxIterations));
  //for (int j = 0; j < a; j++)
  //  drawCircle(width>>1, height>>1, floor(random(width/2, width*2)), random(1) > 0.7 ? true : false);
  drawLines(width>>1, height>>1, width);


  if (borderInfo.isShowFraming()) {
    borderInfo.drawCasing(getGraphics());
  }
}

void drawLines(int x, int y, int width)
{
  translate(random(x-width, x+width), random(0,y));
  
  int ix1 = floor(random(paletti.length));
  int ix2 = floor(random(paletti.length));
  while (ix1 == ix2) ix2 = floor(random(paletti.length));

  color c1 = paletti[ix1];
  color c2 = paletti[ix2];

  int a = floor(random(minIterations, maxIterations));
  int b = floor(random(minIterations, maxIterations));
    for (int j = 0; j < a; j++) {
      for (int i = 0; i < b; i++) {

        color c3 = lerpColor(c1 < c2 ? c1 : c2, c1 < c2 ? c2 : c1, float((i*j))/(a*b));
        stroke(c3, random(199, 255));
        rotate( random(PI));
        int x1 = floor(random(-10, width+10));
        int x2 = floor(random(-randx, randx));
        int y1 = floor(random(-10, 0));
        int y2 = height;

        handyPencilRenderer.setStrokeColour(c3);
        handyPencilRenderer.setRoughness(random(7, 10));
        handyPencilRenderer.setStrokeWeight(random(0.2, 0.7));
        handyPencilRenderer.line(x1, y1, x1+x2, y2);
      }
    }
  
}

void drawCircle(int x, int y, int width, boolean circ)
{
  translate(random(x-width, x+width), y);
  //if (!circ) rectMode(CENTER);
  //else ellipseMode(CENTER);

  int ix1 = floor(random(paletti.length));
  int ix2 = floor(random(paletti.length));
  while (ix1 == ix2) ix2 = floor(random(paletti.length));

  color c1 = paletti[ix1];
  color c2 = paletti[ix2];
  noFill();

  handyPencilRenderer.setIsHandy(useHandy);

  int a = floor(random(minIterations, maxIterations));
  int b = floor(random(minIterations, maxIterations));

  for (int j = 0; j < a; j++) {
    for (int i = 0; i < b; i++) {

      color c3 = lerpColor(c1 < c2 ? c1 : c2, c1 < c2 ? c2 : c1, float((i*j))/(a*b));
      rotate( random(PI));

      // handyPencilRenderer.setFillColour(c1);
      stroke(c3, random(99, 255));
      handyPencilRenderer.setStrokeColour(c3);
      handyPencilRenderer.setRoughness(random(3, 9));
      handyPencilRenderer.setStrokeWeight(random(0.1, 0.4));
      //    handyPencilRenderer.setSecondaryColour(c1);
      //handyPencilRenderer.setUseSecondaryColour(true);

      int x1 = floor(random(-width, width));
      int x2 = floor(random(width, width<<1));
      int y1 = floor(random(-height, height));
      int y2 = floor(random(height, height<<1));

      handyPencilRenderer.line(x1, y1, x2, y2);

      if (circ)
        handyPencilRenderer.ellipse(x, y, random(width/2, width*1), random(width/2, width*1));
      else

        handyPencilRenderer.line(x1, y1, x2, y2);
      //handyPencilRenderer.rect(x, y, random(width/4, width*2), random(width/4, width*2));
    }
  }
}

void keyPressed() {

  if (key != ESC)
  {
    switch (key)
    {
    case 's':
      {
        // casing();
        // saveFrame("frames/####.png");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");
        String name = borderInfo.getLastName() != null ?   borderInfo.getLastName() : dateFormat.format( new Date() );
        saveFrame("frames/"+ name +".png");
        break;
      }
      //case 'S':
      //  {
      //    highResRender();
      //    break;
      //  }
    case 'f' :
      {
        borderInfo.setShowFraming(!borderInfo.isShowFraming());

        redraw();
        break;
      }
    case 'c' :
      {
        clear = true;
        redraw();
        break;
      }
    case 'l' :
      {
        paletti = palette.getPalette(floor(random(palette.getPaletteCount())));
        redraw();
        break;
      }
    case '+':
      {
        randx += 1;
        redraw();
        break;
      }
    case '-':
      {
        if (randx > 5)
          randx -= 1;
        redraw();
        break;
      }
      //case 'w':
      //  {
      //    shaded = !shaded;
      //    redraw();
      //    break;
      //  }
    case ' ':
      {
        redraw();
        break;
      }
    }
  }
}

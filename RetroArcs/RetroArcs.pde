import java.text.SimpleDateFormat;
import java.util.Date;
import java.time.Instant;
import java.util.Collection;
import nice.palettes.*;

import org.gicentre.handy.*;

String filenames[] = {"starry-night.png", "soft-shades.png", "roaring-twenties.png", "pop-art.png", "pastel-dusk.png", "outrun.png", "miami-1976.png", "impressionism.png", "bauhaus.png", "longStickhorse.gif" };

color[] colors = {#0d8cf1, #0eb4f0, #0b770d, #0b0e13, #EFB6F9, #FF9521, #f60402, #cdd3e7, #F4E6FF};
color[] paletti = colors;


int maxSplit = 9;
int maxpal = 512;
int numpal = 0;
color[] goodcolor;

HandyRenderer handyPencilRenderer; //, h2, h3, h4;
BorderInfo borderInfo;
ColorPalette palette;

  int seed;

boolean useHandy = true;
boolean useRoughness = false;
boolean useFixedColor = true;

color background_color = #FFF3EFE4;

float border = 0.09;
int scaleFactor = 10;

int maxIter = 1;
int split = 3;



void setup() {
  size(900, 900);
  noLoop();
  noStroke();
  ellipseMode(RADIUS);

  init();
}

void init()
{
  seed = (int)Instant.now().getEpochSecond();
  randomSeed(seed);
  noiseSeed(seed);


  borderInfo = new BorderInfo(width, height, seed, border);
  borderInfo.setShowInnerBorder(false);

  handyPencilRenderer = HandyPresets.createPencil(this);

  palette = new ColorPalette(this);

  getColors();
}

void getColor() {
  int fnix = floor(random(filenames.length ));
  goodcolor=takeColorFromImage(filenames[fnix]);
}

color[] getColors() {
  if ( useFixedColor ) {
    getColor();
  } else {
    goodcolor=palette.getPalette(floor(random(palette.getPaletteCount())));
  }
  return goodcolor;
}

void reloadPalette() {
  palette.refresh(99);
}


void draw() {
  background(background_color);
  ellipseMode(RADIUS);

  drawSquare(borderInfo.getDisplacement(), borderInfo.getDisplacement(), borderInfo.getInnerSizeX(), maxIter);

  if (borderInfo.isShowFraming()) {
    borderInfo.drawCasing(getGraphics());
  }
}



void drawSquare(int x, int y, int w, int iter)
{

  color c1 = goodcolor[floor(random(goodcolor.length))];
  color c2 = goodcolor[floor(random(goodcolor.length))];

  while (c1 == c2) {
    c2 = goodcolor[floor(random(goodcolor.length))];
  }

  fill(c1, 128);
  //  rect(x, y, x+w, y+w);
  rect(x, y, w, w);

  fill(c2, floor(random(50, 200))); // keep white pixels

  int ix = floor(random(0, 4));

  if (useHandy) {
    handyPencilRenderer.setHachurePerturbationAngle(useRoughness ? 75 : 15);

    handyPencilRenderer.setIsHandy(useHandy);
    handyPencilRenderer.setFillColour(c2);
    handyPencilRenderer.setStrokeColour(c1);
    handyPencilRenderer.setRoughness(useRoughness ? floor(random(2, 7)) : 1);
    handyPencilRenderer.setIsAlternating(true);
    handyPencilRenderer.setSecondaryColour(c1);
    handyPencilRenderer.setUseSecondaryColour(true);
    handyPencilRenderer.setFillGap(random(0.4, 0.7));
    handyPencilRenderer.setFillWeight(useRoughness ? random(0.2,0.7) : 0.1);
  }


  switch (ix) {
  case 0:
    arc(x+w, y, w, w, PI-PI/2, PI);
    if (useHandy)handyPencilRenderer.arc(x+w, y, w, w, PI-PI/2, PI);

    break;
  case 1:
    arc(x+w, y+w, w, w, PI, PI+PI/2);
    if (useHandy)handyPencilRenderer.arc(x+w, y+w, w, w, PI, PI+PI/2);
    break;
  case 2:
    arc(x, y+w, w, w, PI+PI/2, PI*2);
    if (useHandy)handyPencilRenderer.arc(x, y+w, w, w, PI+PI/2, PI*2);
    break;
  case 3:
    arc(x, y, w, w, PI*2, PI*2+PI/2);
    if (useHandy)handyPencilRenderer.arc(x, y, w, w, PI*2, PI*2+PI/2);
    break;
  }


  if (iter > 0) {

    for (int cellx=x; cellx < w; cellx += w/split) {
      for (int celly=y; celly < w; celly += w/split) {
        drawSquare(cellx, celly, w/split, iter-1);
      }
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
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");
        String name = borderInfo.getLastName() != null ?   borderInfo.getLastName() : dateFormat.format( new Date() );
        saveFrame("frames/"+ name +".png");
        break;
      }

    case 'c':
      {
        getColors();
        redraw();
        break;
      }
    case 'h':
      {
        useHandy = !useHandy;
        redraw();
        break;
      }
    case 'l':
      {
        useFixedColor = !useFixedColor;
        redraw();
        break;
      }
    case 'r':
      {
        useRoughness = !useRoughness;
        redraw();
        break;
      }
    case '+':
      {
        if (split < maxSplit)
          split ++;

        redraw();
        break;
      }
    case 'f' :
      {
        borderInfo.setShowFraming(!borderInfo.isShowFraming());
        redraw();
        break;
      }
    case '-':
      {
        if (split >1)
          split --;

        redraw();
        break;
      }
    default:

      redraw();
    }
  }
}


color[] takeColorFromImage(String fn) {

  color[] palette = new color[maxpal];
  // clear background to begin
  background(0xFFFFFFFF);

  // load color source
  PImage b;
  b = loadImage(fn);
  image(b, 0, 0);

  // initialize palette length
  numpal=0;

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

import java.text.SimpleDateFormat;
import java.util.Date;
import java.time.Instant;
import micycle.pgs.*;
import micycle.pgs.commons.*;
import micycle.pgs.color.*;
import micycle.peasygradients.colorspace.*;
import micycle.peasygradients.gradient.*;
import micycle.peasygradients.utilities.fastLog.*;
import micycle.peasygradients.utilities.*;
import micycle.peasygradients.*;
import com.cage.colorharmony.*;

ColorHarmony colorHarmony = new ColorHarmony(this, 15, 55, 20, 65);


color colorSchemes[][] = {
  {#F27EA9, #366CD9},// { #5EADF2, #636E73, #F2E6D8},
  {#D962AF, #58A6A6}, //{ #8AA66F, #F29F05, #F26D6D},
  {#222940, #D98E04}, { #F2A950, #BF3E21}, // #F2F2F2},
  {#1B618C, #55CCD9},// { #F2BC57, #F2DAAC, #F24949},
  {#074A59, #F2C166}, //{ #F28241, #F26B5E, #F2F2F2},
  {#023059, #459DBF},// { #87BF60, #D9D16A, #F2F2F2},
  {#632973, #02734A}, //{ #F25C05, #F29188, #F2E0DF},
  {#8D95A6, #0A7360},// { #F28705, #D98825, #F2F2F2},
  {#4146A6, #063573}, //{ #5EC8F2, #8C4E03, #D98A29},
  {#034AA6, #72B6F2},// { #73BFB1, #F2A30F, #F26F63},
  {#303E8C, #F2AE2E}, //{ #F28705, #D91414, #F2F2F2},
  {#424D8C, #84A9BF}// { #C1D9CE, #F2B705, #F25C05}
};



int maxIter = 2;
int split = 3;
int maxsplit = 5;

float border = 0.08;

BorderInfo borderInfo;

int seed;               // = millis();


PeasyGradients renderer;

void setup() {
  size(900, 900);
  noLoop();

  init();
}

void init() {

  seed = (int)Instant.now().getEpochSecond();
  randomSeed(seed);
  noiseSeed(seed);

  borderInfo = new BorderInfo(width, height, seed, border);
}

color[] getColors() {

  color[] colors = colorSchemes[floor(random(colorSchemes.length))];

  //switch (floor(random(0, 5))) {

  //case 0:
  //  colors = colorHarmony.Complementary(2);
  //  break;
  //case 1:
  //  colors = colorHarmony.Analogous(2);
  //  break;
  //case 2:
  //  colors = colorHarmony.Monochromatic(2);
  //  break;
  //case 3:
  //  colors = colorHarmony.Triads(2);
  //  break;
  //default:
  //  int n=2;
  //  colors = new color[n];
  //  for (int i=0; i<n; i++) {
  //    colors[i] = color(random(255), random(128), random(128));
  //  }
  //}
  return colors;
}



void drawSquare(float x, float y, int w, int iter)
{
  PGraphics rectangle, circle, circleMask;

  renderer = new PeasyGradients(this);

  Gradient gradient = new Gradient( colorSchemes[floor(random(colorSchemes.length))]);
  gradient.setInterpolationMode(Interpolation.SMOOTH_STEP);

  rectangle = createGraphics(w, w);
  renderer.setRenderTarget(rectangle); // render into rectangle PGraphics
  renderer.linearGradient(gradient, (int(random(4)) * 360) / 4);

  circle = createGraphics(w, w);
  renderer.setRenderTarget(circle);  // render into circle PGraphics
  //renderer.radialGradient(gradient, new PVector(w/2, w/2), 0.5); // gradient, midpoint, zoom

  gradient = new Gradient( getColors());

  renderer.radialGradient(gradient, new PVector(w, w), 1);
  // renderer.linearGradient(gradient, PI/2); // gradient, angle


  // circle is currently a square image of a radial gradient, so needs masking to be circular
  circleMask = createGraphics(w, w);
  circleMask.beginDraw();
  circleMask.fill(255); // keep white pixels
  circleMask.ellipseMode(RADIUS);

  switch (floor(random(5))) {
  case 0:
    circleMask.arc(w, w, w, w, PI, PI+PI/2);
    break;
  case 1:
    circleMask.arc(0, w, w, w, PI+PI/2, PI*2);
    break;
  case 2:
    circleMask.arc(0, 0, w, w, PI*2, PI*2+PI/2);
    break;
  case 3:
    circleMask.arc(w, 0, w, w, PI/2, PI);
    break;
  }

  circleMask.endDraw();

  circle.mask(circleMask);

  tint(255, floor(random(60, 80)));

  image(rectangle, x, y);

  if (iter < maxIter) {

    for (float cellx=x; cellx < x+(w/split)*split; cellx += w/split) {
      for (float celly=y; celly < y+(w/split)*split; celly += w/split) {
        drawSquare(cellx, celly, w/split, iter+1);
      }
    }
  }

  //  imageMode(CENTER);
  push();

  blendMode(ADD);
  tint(255, floor(random(20, 50)));

  if (random(1) >= 0.5) {
    translate(w, 0);
    rotate(radians(90));
  }

  image(circle, x, y);
  pop();
}

void render() {
  background(255);
  blendMode(BLEND);
  ellipseMode(RADIUS);

  drawSquare(borderInfo.getDisplacement(), borderInfo.getDisplacement(), borderInfo.getInnerSizeX(), 0);
}

void draw() {
  render();

  if (borderInfo.isShowFraming()) {
    borderInfo.drawCasing(getGraphics());
  }
}

void keyPressed() {

  if (key != ESC)
  {
    switch (key)
    {
    case 's':
      {
        saveFrame("frames/####.tif");
        break;
      }
    case 'f':
      {
        borderInfo.setShowFraming(!borderInfo.isShowFraming());
        break;
      }
    case 'x':
      {
        init();
        redraw();
        break;
      }
    case '+':
      {
        if (split < maxsplit)
        {
          split ++;
          redraw();
        }
        break;
      }
    case '-':
      {
        if (split >1)
        {
          split --;
          redraw();
        }
        break;
      }
    default:

      redraw();
    }
  }
}

import micycle.pgs.*;
import micycle.pgs.commons.*;
import micycle.pgs.color.*;
import micycle.peasygradients.colorspace.*;
import micycle.peasygradients.gradient.*;
import micycle.peasygradients.utilities.fastLog.*;
import micycle.peasygradients.utilities.*;
import micycle.peasygradients.*;


color colorSchemes[][] = {
  {#F27EA9, #366CD9},// #5EADF2, #636E73, #F2E6D8},
  {#D962AF, #58A6A6}, // #8AA66F, #F29F05, #F26D6D},
  {#222940, #D98E04}, // #F2A950, #BF3E21, #F2F2F2},
  {#1B618C, #55CCD9}, // #F2BC57, #F2DAAC, #F24949},
  {#074A59, #F2C166}, // #F28241, #F26B5E, #F2F2F2},
  {#023059, #459DBF}, // #87BF60, #D9D16A, #F2F2F2},
  {#632973, #02734A}, // #F25C05, #F29188, #F2E0DF},
  {#8D95A6, #0A7360}, // #F28705, #D98825, #F2F2F2},
  {#4146A6, #063573}, // #5EC8F2, #8C4E03, #D98A29},
  {#034AA6, #72B6F2}, // #73BFB1, #F2A30F, #F26F63},
  {#303E8C, #F2AE2E}, // #F28705, #D91414, #F2F2F2},
  {#424D8C, #84A9BF} // #C1D9CE, #F2B705, #F25C05}
};

int maxIter = 2;
int split = 4;

PeasyGradients renderer;

// final Gradient pinkToYellow = new Gradient(color(227, 140, 185), color(255, 241, 166));

void setup() {
  size(800, 800);
  noLoop();
}

//void paint() {

//  renderer = new PeasyGradients(this);

//  rectangle = createGraphics(250, 250);
//  renderer.setRenderTarget(rectangle); // render into rectangle PGraphics
//  renderer.linearGradient(pinkToYellow, PI/2); // gradient, angle

//  circle = createGraphics(400, 400);
//  renderer.setRenderTarget(circle);  // render into circle PGraphics
//  renderer.radialGradient(pinkToYellow, new PVector(200, 200), 0.5); // gradient, midpoint, zoom

//  // circle is currently a square image of a radial gradient, so needs masking to be circular
//  circleMask = createGraphics(400, 400);
//  circleMask.beginDraw();
//  circleMask.fill(255); // keep white pixels
//  // circleMask.circle(200, 200, 400);
//  circleMask.arc(0, 0, 400, 400, 0, HALF_PI);

//  circleMask.endDraw();

//  circle.mask(circleMask);
//}

void drawSquare(int x, int y, int w, int iter)
{
  PGraphics rectangle, circle, circleMask;

  renderer = new PeasyGradients(this);

  Gradient gradient = new Gradient( colorSchemes[floor(random(colorSchemes.length))]);
  gradient.setInterpolationMode(Interpolation.SMOOTH_STEP);

  rectangle = createGraphics(w, w);
  renderer.setRenderTarget(rectangle); // render into rectangle PGraphics
  renderer.linearGradient(gradient, (int(random(4)) * 360) / 4); //map(floor(random(360)), 0, 360, 0, TWO_PI));//  PI/2); // gradient, angle

  circle = createGraphics(w, w);
  renderer.setRenderTarget(circle);  // render into circle PGraphics
  //renderer.radialGradient(gradient, new PVector(w/2, w/2), 0.5); // gradient, midpoint, zoom
  gradient = new Gradient( colorSchemes[floor(random(colorSchemes.length))]);
  renderer.radialGradient(gradient, new PVector(w, w), 1);
  // renderer.linearGradient(gradient, PI/2); // gradient, angle


  // circle is currently a square image of a radial gradient, so needs masking to be circular
  circleMask = createGraphics(w, w);
  circleMask.beginDraw();
  circleMask.fill(255); // keep white pixels
  // circleMask.circle(200, 200, 400);
  //circleMask.arc(0, 0, w, w, 0, HALF_PI);
  circleMask.ellipseMode(RADIUS);
  circleMask.arc(w, w, w, w, PI, PI+PI/2);
  circleMask.endDraw();

  circle.mask(circleMask);

  tint(255, floor(random(60,80)));

  image(rectangle, x, y);
  //println(iter, w);
  if (iter < maxIter) {

    for (int cellx=x; cellx < x+w; cellx += w/split) {
      for (int celly=y; celly < y+w; celly += w/split) {

        //if (random(1) >= 0.5)
        drawSquare(cellx, celly, w/split, iter+1);
      }
    }
    //if (random(1) >= 0.5) drawSquare(x, y, w/2);
    //if (random(1) >= 0.5) drawSquare(x+w/2, y, w/2);
    //if (random(1) >= 0.5) drawSquare(x, y+w/2, w/2);
    //if (random(1) >= 0.5) drawSquare(x+w/2, y+w/2, w/2);
  }

  //  imageMode(CENTER);
  push();
  blendMode(BLEND);
  tint(255, floor(random(20,90)));

  if (random(1) >= 0.5) {
    translate(width, 0);
    rotate(radians(90));
  }
  
  image(circle, x, y);
  pop();
}





void draw() {
  background(255);
  blendMode(BLEND);
  ellipseMode(RADIUS);

  drawSquare(0, 0, width, 0);
  //imageMode(CENTER);
  //translate(width,0);
  //rotate(radians(90));
  //arc(width, height, width, width, PI, PI+PI/2);

  //paint();

  //image(rectangle, 250, 250);
  //blendMode(BLEND);

  //image(circle, 250, 250);

  ////blendMode(BLEND);

  ////image(circle, 250, 250);
}

void keyPressed() {
  redraw();
}

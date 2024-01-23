// Jim Fandango 2023
// Honoring Vera Molnár : (Des)Ordres, 1974
// https://dam.org/museum/artists_ui/artists/molnar-vera/des-ordres/

import java.text.SimpleDateFormat;
import java.util.Date;

color font_color = #77282828;


// FONT
int sigFontSize = 20;
int titFontSize = 25;

PFont titleFont;
PFont signatureFont; // Moonbeam

float border = 0.15;
int inner_size;
int inner_border;
// size and displacement calculations
int scl;
int dpos;


int w = 900;
int h = 900;
int cols = 10;
int rows = 10;
int borderwidth = 2;

color[] frameColors = {color(238, 246, 152), color(208, 131, 136), color(204, 100, 131), color(131, 135, 170), color(94, 169, 183), color(94, 169, 183)};
color backgroundColor = color(242, 239, 231);     // (231,228,222);

boolean colorMode = false;
boolean rectMode = false;
boolean clear = false;

void settings()
{
  size(w, h);
}

void setup() {

  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);
  background(backgroundColor);
  noFill();
  noLoop();

  init();
}

void init() {

  inner_size = floor(width * (1 - border));
  inner_border = floor(border * width);
  dpos = inner_border / 2;

  titleFont = createFont("Century Gothic", titFontSize);
  signatureFont = createFont("Century Gothic", sigFontSize); // Moonbeam
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
    case 'c':
      {
        colorMode = !colorMode;
        redraw();
        break;
      }
    case 'r':
      {
        rectMode = !rectMode;
        redraw();
        break;
      }
    case '+':
      {
        cols++;
        rows++;
        redraw();
        break;
      }
    case '-':
      {
        if (cols > 1)
        {
          cols--;
          rows--;
        }
        redraw();
        break;
      }
    case 'x':
      {
        clear=true;
        redraw();
        break;
      }
    case ' ':
      {
        redraw();
        break;
      }
    };
  }
}

void draw()
{

  if ( clear)
  {
    clear = false;
    background(backgroundColor);

    noFill();
  }

  drawCasing();
  noFill();

  int cellWidth = width / (cols + borderwidth);
  int cellHeight = height / (rows + borderwidth);

  translate(cellWidth * 1.5, cellHeight * 1.5);

  for (int col = 0; col < cols; col++) {
    for (int row = 0; row < rows; row++) {
      drawCell(col * cellWidth, row * cellHeight, cellWidth, cellHeight);
    }
  }
}



/**
 * drawCell : draws randomly distorted rectangles.
 */
void drawCell(int _cx, int _cy, int _cellWidth, int _cellHeight) {

  int rectMax = 10;
  float distort = 0.1;


  for (int rectCnt = 0; rectCnt < rectMax; rectCnt++) {

    // calculates corner points of the distorted rectangle
    int hW = _cellWidth * rectCnt / rectMax / 2;
    int hH = _cellHeight * rectCnt / rectMax / 2;

    Point[] cornerPoints  = new Point[4];

    int evenDisort = (int)((1 + random(-1, 1) * distort));

    cornerPoints[0] = new Point( (int)(_cx - (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hW),
      (int)(_cy - (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hH) );
    cornerPoints[1] = new Point( (int)(_cx + (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hW),
      (int)(_cy - (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hH) );
    cornerPoints[2] = new Point( (int)(_cx + (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hW),
      (int)(_cy + (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hH) );
    cornerPoints[3] = new Point( (int)(_cx - (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hW),
      (int)(_cy + (rectMode ? evenDisort : (1 + random(-1, 1) * distort)) * hH) );

    if (colorMode) {
      stroke(frameColors[(int)random(1, frameColors.length)-1]);
    } else {
      stroke(0, 2, random(30, 96), 100);
    }

    strokeWeight(random(2));

    beginShape();
    for (int corner = 0; corner < 5; corner++) {
      vertex(cornerPoints[corner % 4].x, cornerPoints[corner % 4].y);
    }
    endShape();
  }
}

void drawCasing()
{

  //noFill();
  //strokeWeight(1);

  //rect( inner_border, inner_border, width - inner_border, height - inner_border);

  drawTitle();
  drawSignature();
}


void drawSignature()
{
  int fontSize = 20;
  int pos = floor(height - fontSize *1.5) ;

  fill(font_color);

  translate(pos, pos);
  textAlign(RIGHT, CENTER);

  textFont(signatureFont);

  text("Yo-Shi", 0, 0);
  translate(-pos, -pos);
}

void drawTitle()
{
  int fontSize = 25;
  int pos = floor(fontSize *1) ;

  fill(font_color);

  translate(pos, pos);
  textAlign(LEFT, CENTER);

  textFont(titleFont);

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");

  String header = getClass().getName() + " - " + dateFormat.format( new Date() );

  text(header, 0, 0);
  translate(-pos, -pos);
}

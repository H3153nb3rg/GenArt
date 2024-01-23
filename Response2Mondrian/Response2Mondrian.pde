import java.text.SimpleDateFormat;
import java.util.Date;

color[] colors = {color(246, 2, 1), color(31, 127, 201), color(253, 237, 1), color(2, 2, 8)};
color backgroundColor = color(254, 255, 250);
color font_color = #77282828;

int max_recursions = 11;
int recursions = 9;

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

void setup() {
  size(900, 900);
  background(backgroundColor);
  // noLoop();
  strokeWeight(2);
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



void draw() {

  background(backgroundColor);

  drawSquare(dpos, dpos, inner_size, recursions);

  drawCasing();
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
    case '+':
      {
        if ( recursions < max_recursions)
        {
          recursions++;
          redraw();
        }
        break;
      }
    case '-':
      {
        if (recursions > 2)
        {
          recursions--;
          redraw();
        }
        break;
      }
    default:
      {
        redraw();
        break;
      }
    }
  }
}


void drawSquare(float x, float y, float a, int n) {
  if (n <= 0)
    return;

  if (random(1) < 0.4)
    fill(colors[floor(random(colors.length))]);
  else
    fill(backgroundColor);

  square(x, y, a);

  if (random(1) < 2 * (10 - n)/10.0)
    return;

  n--;
  drawSquare(x, y, a/2, n);
  drawSquare(x + a/2, y, a/2, n);
  drawSquare(x, y + a/2, a/2, n);
  drawSquare(x + a/2, y+ a/2, a/2, n);
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

  PFont myFont = createFont("Century Gothic", fontSize); // Moonbeam
  textFont(myFont);

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

  //PFont myFont = createFont("Bauhaus 93", fontSize);
  PFont myFont = createFont("Century Gothic", fontSize);
  textFont(myFont);

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");

  String header = getClass().getName() + " - " + dateFormat.format( new Date() );

  text(header, 0, 0);
  translate(-pos, -pos);
}

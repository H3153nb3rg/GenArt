import java.text.SimpleDateFormat;
import java.util.Date;



// FONT
int sigFontSize = 20;
int titFontSize = 25;

//PFont myFont = createFont("Bauhaus 93", fontSize);
PFont titleFont;
PFont signatureFont; // Moonbeam

// color background_color = #FFF3EFE4;
color background_color = 0xEFEFEF;
color font_color = #77282828;
color stroke_color = #FF282828;

  int maxArcs = 25;
int minArcs = 5;
int n = maxArcs;

float width_rads[] = new float[n];
float seeds[] = new float[n];
color colors[];// = new color[n];

float border_prc = 0.15;
int inner_size;
int inner_border;

// size and displacement calculations
int dpos;


int border = 10; // frame around image
int xstep = 2; // stepsize (resolution) in x direction
int ystep = border; // rows
float lastx;
float lasty;

void setup() {
  size(900, 900);
  background(background_color);
  strokeWeight(1);
  stroke(stroke_color); // stroke color black
  noLoop();
  noFill();

  initialize();
}

void initialize() {

  n = floor(random(minArcs, maxArcs));

  inner_size = floor(width * (1 - border_prc));
  inner_border = floor(border_prc * width);
  // size and displacement calculations
  dpos = inner_border / 2;

  border = dpos;

  titleFont = createFont("Century Gothic", titFontSize);
  signatureFont = createFont("Century Gothic", sigFontSize); // Moonbeam
}


void draw() {
  background(background_color);


  for (int i = border; i <= height-(border+ystep/2); i+=ystep) {
    for (int x = border; x <= width-border; x +=xstep) {

      float y = noise(random(border, border+ystep))*15; // random noise

      if (x == border) {
        lastx= 0;
      }
      if (lastx > 0) {
        line(x, y+i, lastx, lasty+i);
      }
      lastx = x;
      lasty = y;
    }
  }

  int xx = floor(random(dpos, width-border));
  int yy = floor(random(dpos, width-border));

  fill(color(0xFFFF0000));
  textAlign(RIGHT, CENTER);
  textFont(signatureFont);

  text(" ♥ ", xx, yy);


  drawCasing();
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
  int pos = floor(height - sigFontSize *1.5) ;

  fill(font_color);

  translate(pos, pos);
  textAlign(RIGHT, CENTER);

  textFont(signatureFont);

  text("Yo-Shi", 0, 0);
  translate(-pos, -pos);
}

void drawTitle()
{

  int pos = floor(titFontSize *1) ;

  fill(font_color);

  translate(pos, pos);
  textAlign(LEFT, CENTER);

  textFont(titleFont);

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");

  String header = getClass().getName() + " - " + dateFormat.format( new Date() );

  text(header, 0, 0);
  translate(-pos, -pos);
}

void keyPressed()
{
  if (key != ESC)
  {

    switch (key)
    {
    case 's':
      {
        saveFrame("frames/####.tif");
        break;
      }
    default:
      redraw();
      //redraw();
    }
  }
}

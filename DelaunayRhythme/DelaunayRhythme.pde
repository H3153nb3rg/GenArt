// Jim andango 2023
// based on robert-delaunay
// https://upload.wikimedia.org/wikipedia/commons/d/dd/Robert_Delaunay%2C_Rythmes%2C_1934.jpg

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

// color background_color = #FFF3EFE4;
color background_color = #FFDFD1BF;


color colorArcs[] = { color(158, 169, 195), color(150, 3, 4), color(24, 101, 85), color(90, 150, 33), color(217, 99, 0), color(165, 208, 160), color(254, 245, 84), color(58, 73, 147), color(251, 178, 67), color(118, 116, 101) };
color monoArcs[] = { color(31, 27, 25), color(255, 255, 254) };


color quarter1[] = { color(96, 35, 69), color(195, 107, 44), color(212, 198, 174), color(129, 57, 94), color(159, 178, 200), color(184, 99, 132), color(222, 35, 34)};
color quarter2[] = { color(46, 79, 124), color(88, 95, 62), color(141, 37, 38), color(39, 44, 67), color(242, 194, 65), color(81, 103, 144), color(225, 65, 51) };
color quarter3[] = { color(170, 48, 37), color(210, 186, 188), color(61, 50, 56), color(63, 55, 56), color(238, 168, 46), color(110, 134, 95), color(92, 128, 178)};
color quarter4[] = { color(148, 41, 52), color(83, 109, 166), color(40, 40, 50), color(193, 53, 50), color(236, 203, 194), color(233, 142, 44), color(60, 120, 176) };

color circleColors[][] = { quarter1, quarter2, quarter3, quarter4};

color backgroundColor = color(245, 230, 215); // color(206,189,171); // color(243,238,232);
//color backgroundColor = color(254, 255, 250);


boolean hasChanged = true;
boolean shuffle = false;

//int dimension = 800;

//void settings()
//{
//    size(dimension,dimension);
//}

void setup() {

  size(900, 900);
  
  smooth();
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


void draw()
{
  background(backgroundColor);
  //translate( dpos, dpos);
  drawCasing();


  int centerX = width - ( width /3);
  int centerY = ( height /6);

  int radius = (width/3);

  float deg = 135.0;
  int iterations = 3; //  (int)random( 3,6 );
  int arcs = (int)random( 2, 6 );

  noStroke();

  for (int i = 0; i < iterations; i++)
  {
    // upper large
    if (On())
    {
      for (int j = 0; j < arcs+i; j ++) {
        fill(colorArcs[(int)random(colorArcs.length)]);
        arc(centerX, centerY, (radius  + 50 *i*2 ) - 50*j, (radius  + 50 *(i*2)) - 50*j, radians(deg), radians(deg+180));
      }
    }

    // lower large
    if (On())
    {
      for (int j = 0; j < arcs+i; j ++) {
        fill(colorArcs[(int)random(colorArcs.length)]);
        arc(centerX, centerY, (radius  + 50 *i*2) - 50*j, (radius  + 50 *i*2) - 50*j, radians(deg+180), radians(deg+360));
      }
    }

    // mono arcs

    int odd = (int)random(0, monoArcs.length);
    int even = abs(odd -1);

    for (int j = 0; j < arcs; j ++) {

      fill(monoArcs[(odd+j)%2]);
      arc(centerX, centerY, (radius  - 100) - 50*j, (radius  - 100) - 50*j, radians(deg), radians(deg+180));

      fill(monoArcs[(even+j)%2]);
      arc(centerX, centerY, (radius  - 100) - 50*j, (radius  - 100) - 50*j, radians(deg+180), radians(deg+360));
    }

    translate( -205, 205);
  }
}

boolean On()
{
  return random(0, 1) > 0.5;
}

void keyPressed()
{
  if (key != ESC)
  {
    if (key=='s')
      saveFrame("frames/####.tif");
        
    if (key == ' ')
      shuffle = !shuffle;

    redraw();
  }
}

void shuffleArray(color[] array) {

  for (int i = array.length-1; i > 0; i--) {

    int k = (int)random(array.length);

    // Swap array elements.
    color tmp = array[k];
    array[k] = array[i-1];
    array[i-1] = tmp;
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

  textFont(titleFont );

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");

  String header = getClass().getName() + " - " + dateFormat.format( new Date() );

  text(header, 0, 0);
  translate(-pos, -pos);
}

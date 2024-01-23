import java.text.SimpleDateFormat;
import java.util.Date;
// Svanen 17
// https://dearsam.at/poster/svanen-no-17-by-hilma-af-klint

color[] palette1 = {#E3DED8, #2E2E2E};
color[] palette2 = {#6987B5, #D7BB68, #daa390};

color background = color(175, 76, 58);

float border = 0.09;


int inner_size;
int inner_border;
// size and displacement calculations
int scl;
int dpos;

//color background_color = #FFF3EFE4;
//color background_color = #FFDFD1BF;
color font_color = #77282828;
boolean framing = true;

void setup() {
  size(900, 900);
  colorMode(RGB);
  noLoop();

  init();
}

void init() {

  inner_size = floor(width * (1 - border));
  inner_border = floor(border * width);
  dpos = inner_border / 2;
}

void arcs(int diam, color col1, color col2) {
  noStroke();

  fill(col1);
  arc(0, 0, diam, diam, 0, PI);

  fill(col2);
  arc(0, 0, diam, diam, PI, TWO_PI);
}

void draw() {
  if (framing) {
    background(255);
    clip(dpos, dpos, width-inner_border, width-inner_border);
  }
  background(background);

  pushMatrix();
  translate(width / 2, height / 2);
  rotate(PI / 2);

  for (int i = width/2; i > 0; i -= 50) {
    arcs(i, palette1[floor(random(palette1.length))], palette2[floor(random(palette2.length))]);
  }
  popMatrix();
  if (framing) {
    noClip();
    drawCasing();
  }
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
        saveFrame("frames/####.tif");
        break;
      }
      //case '+':
      //{
      //    squaresInARow++;

      //    break;
      //}
      //case '-':
      //{
      //  if (squaresInARow > 1)
      //  {
      //    squaresInARow--;

      //  }
      //    break;
      //}
      //case 'x':
      //  {
      //    clear=true;
      //    redraw();
      //    break;
      //  }
      //case 'c':
      //  {
      //    change=true;
      //    break;
      //  }
    case 'f' :
      {
        framing = !framing;
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

void drawCasing()
{

  noFill();
  strokeWeight(1);
  stroke(0x282828);

  rect( dpos, dpos, width - dpos*2, height - dpos*2);

  drawTitle();
  drawSignature();
}


void drawSignature()
{
  int fontSize = 20;
  int pos = floor(height - fontSize * 2.3);

  fill(font_color, 99);

  textAlign(RIGHT, CENTER);

  PFont myFont = createFont("Century Gothic", fontSize); // Moonbeam
  textFont(myFont);

  text("Yo-Shi", width-dpos, pos);
}

void drawTitle()
{
  int fontSize = 25;
  int pos = floor(fontSize *1.5) ;

  fill(font_color, 128);

  textAlign(LEFT, CENTER);

  PFont myFont = createFont("Century Gothic", fontSize);
  textFont(myFont);

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmsss");

  String header = getClass().getName() + " - " + dateFormat.format( new Date() );

  text(header, dpos, pos);
}

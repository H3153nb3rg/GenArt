import java.text.SimpleDateFormat;
import java.util.Date;

import nice.palettes.*;

import org.gicentre.handy.*;


HandyRenderer handyPencilRenderer;

int min_cols = 3;
int max_cols = 12;
float border = 0.15;

boolean tilt = true;

int cols = 3; //floor(random(min_cols, max_cols));

boolean centerOnly = true;

int inner_size;
int inner_border;
// size and displacement calculations
int scl;
int dpos;

boolean useFixedColor = true;
boolean useLerp = true;
boolean useRoughness = false;
boolean useHandy = true;

int roughy = 0;

color background_color = #FFF3EFE4;
//color background_color = #FFDFD1BF;
color font_color = #77282828;

//color tileColors[]  = {
//  0xFF144184, // blue
//  0xFF144184, // blue
//  0xFF144184, // blue
//  0xFFBFA21A, // yellow
//  0xFFBFA21A, // yellow
//  0xFFBFA21A, // yellow
//  0xFF99281A, // red
//  0xFF99281A, // red
//  0xFF99281A, // red
//  0xFF99281A, // red
//  0xFF222222, // black
//  0xFFF0F3F7, // white
//  0xFFF0F3F7  // white
//};

color tileColors[]  = {
  0xFF015EAD, // blue
  0xFF015EAD, // blue
  0xFF015EAD, // blue
  0xFFF3BA30, // yellow
  0xFFF3BA30, // yellow
  0xFFF3BA30, // yellow
  0xFFEE1B27, // red
  0xFFEE1B27, // red
  0xFFEE1B27, // red
  0xFFEE1B27, // red
  0xFF222222, // black
  0xFF222222, // black
  0xFF222222, // black
  0xFFF0F3F7, // white
  0xFFF0F3F7  // white
};

ArrayList<Tile> tiles = new ArrayList<Tile>();

void setup()
{
  size(900, 900);
  noLoop();
  colorMode(RGB);
  init();

  // Uncomment the following two lines to see the available fonts
  //String[] fontList = PFont.list();
  //printArray(fontList);
}

void init() {

  inner_size = floor(width * (1 - border));
  inner_border = floor(border * width);
  // size and displacement calculations
  scl = inner_size / cols;
  dpos = inner_border / 2;

  int rows = ceil(cols * ( height *1.0 / width));

  //handyPencilRenderer = HandyPresets.createPencil(this);
  //  handyPencilRenderer = HandyPresets.createColouredPencil(this);
  handyPencilRenderer = HandyPresets.createWaterAndInk(this);
  //h4 = HandyPresets.createMarker(this);

  //  handyPencilRenderer.setHachurePerturbationAngle(75);

  //  palette = new ColorPalette(this);

  tiles.clear();

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {

      if (((centerOnly) && (x == (cols-1)/2) && ( y == (rows-1) /2)) || (!centerOnly)) {
        tiles.add( new Tile(x * scl + dpos, y * scl + dpos, scl));
      }
    }
  }
}

void draw()
{

  background(background_color);
  noStroke();

  for (int i = 0; i < tiles.size(); i++) {
    tiles.get(i).draw();
  }

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
    case '0':
      {
        roughy = 0;
        redraw();
        break;
      }
    case '1':
      {
        roughy = 2;
        redraw();
        break;
      }
    case '2':
      {
        roughy = 3;
        redraw();
        break;
      }
    case '3':
      {
        roughy = 4;
        redraw();
        break;
      }
    case '4':
      {
        roughy = 5;
        redraw();
        break;
      }
    case '5':
      {
        roughy = 6;
        redraw();
        break;
      }
    case '6':
      {
        roughy = 7;
        redraw();
        break;
      }
    case '7':
      {
        roughy = 8;
        redraw();
        break;
      }
    case '8':
      {
        roughy = 9;
        redraw();
        break;
      }
    case '9':
      {
        roughy = 10;
        redraw();
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
        if (cols < max_cols)
        {
          cols ++;
          init();
          redraw();
        }
        break;
      }
    case '-':
      {
        if (cols >min_cols)
        {
          cols --;
          init();
          redraw();
        }
        break;
      }
    case 't':
      {
        tilt = !tilt;
      }
    default:

      redraw();
    }
  }
}

void drawCasing()
{

  //noFill();
  //strokeWeight(1);

  //stroke(0x282828);

  //rect( dpos, dpos, width - dpos*2, height - dpos*2);

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


class Tile {

  int x;
  int y;

  float border;
  float border_dpos;
  float scl;
  float rotation;

  color lastColor;

  Tile(int x, int y, int scl ) {

    this.x = x;
    this.y = y;

    this.border = 0.1;
    this.scl = scl * (1 - border);
    this.border_dpos = this.border * scl / 2;

    rotation = (random(2) * PI / 2 + random(-0.0002, 0.0001)) / 90 * random(-1, 1);
  }

  color getColor() {
    color c =  tileColors[ floor(random(tileColors.length))];

    while ( c == lastColor)
      c =  tileColors[ floor(random(tileColors.length))];

    lastColor = c;
    return c;
  }


  void draw()
  {
    pushMatrix();
    translate(x+border_dpos, y+border_dpos);

    // jitter
    if ( tilt) {
      translate(scl / 2, scl / 2);
      rotate(rotation);
      translate(-scl / 2, -scl / 2);
    }

    color fillColor = getColor();
    int figure = floor(random(15));

    fill(fillColor);
    //-------

    handyPencilRenderer.setIsHandy(useHandy);


    handyPencilRenderer.setRoughness(roughy);
    handyPencilRenderer.setStrokeWeight(random(0.1, 0.4));
    handyPencilRenderer.setStrokeColour(fillColor);

    switch (figure) {

    case 0: // 2 arcs
      {
        float rho = scl ; // / 2;

        pushMatrix();
        translate(scl / 2, scl / 2);

        for (int i = 0; i < 2; i++) {
          rotate(PI * i);

          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          handyPencilRenderer.arc(-scl / 2, 0, rho, rho, -PI / 2, PI / 2);
        }
        popMatrix();

        break;
      }
    case 1: // Square
      {

        float side = scl * 0.75;

        pushMatrix();
        translate(scl / 2, scl / 2);

        handyPencilRenderer.rect(-side / 2, -side / 2, side, side);

        popMatrix();
        break;
      }
    case 2:  // one circle in the middle
      {

        float rho = scl / 1.5;

        pushMatrix();
        translate(scl / 2, scl / 2);

        handyPencilRenderer.arc(0, 0, rho, rho, 0, PI * 2);

        popMatrix();
        break;
      }

    case 3:  // 2 circles
      {
        float rho = scl / 4;

        pushMatrix();
        translate(scl / 2, scl / 2);
        rotate(PI / 4);
        for (int i = 0; i < 2; i++) {
          pushMatrix();
          rotate(PI * i);
          translate(rho, 0);

          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          handyPencilRenderer.arc(0, 0, rho, rho, 0, PI * 2);

          popMatrix();
        }
        popMatrix();
        break;
      }

    case 4: // two rects (superimposed)
      {
        pushMatrix();

        float width = scl / 2;
        float height = scl;

        for (int i = 0; i < 2; i++) {
          pushMatrix();
          translate(scl / 2, scl / 2);
          rotate(PI / 2 * i);
          translate(-scl / 2, -scl / 2);

          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          handyPencilRenderer.rect(0, 0, width, height);

          popMatrix();
        }

        popMatrix();
        break;
      }

    case 5: // two rects (side by side)
      {
        pushMatrix();

        float width = scl / 2;
        float height = scl;

        for (int i = 0; i < 2; i++) {
          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          handyPencilRenderer.rect(width * i, 0, width, height);
        }

        popMatrix();
        break;
      }


    case 6: // triangle
      {
        pushMatrix();
        float height = scl;

        handyPencilRenderer.triangle(0, 0, height / 2, height, height, 0);

        popMatrix();
        break;
      }


    case 7: // diagonally separated colors
      {
        pushMatrix();

        float height = scl;

        for (int i = 0; i < 2; i++) {
          pushMatrix();
          translate(scl / 2, scl / 2);
          rotate(PI * i);
          translate(-scl / 2, -scl / 2);

          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          handyPencilRenderer.triangle(0, 0, height, height, height, 0);

          popMatrix();
        }
        popMatrix();
        break;
      }

    case 8:         // two arches (superimposed)
      {
        pushMatrix();

        float rho = scl ;// / 2;
        translate(scl / 2, scl / 2);

        for (int i = 0; i < 2; i++) {
          rotate(PI * i / 2);
          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          handyPencilRenderer.arc(-scl / 2, 0, rho, rho, -PI / 2, PI / 2);
        }

        popMatrix();
        break;
      }
    case 9: // alternating lines

      {
        pushMatrix();

        int items = 4;
        float height = scl / (items * 2);
        float width = scl / 2;

        for (int i = 0; i < 2; i++) {
          float dx = width * i;
          float dy = height * i;
          pushMatrix();
          translate(dx, dy);
          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          for (int j = 0; j < items; j++) {
            handyPencilRenderer.rect(0, 0, width, height);
            translate(0, height * 2);
          }
          popMatrix();
        }
        popMatrix();
        break;
      }


    case 10: // circles grid
      {
        pushMatrix();

        int circles = 3;
        float scl = this.scl / circles;
        float rho = scl * 0.50;

        translate(scl / 2, scl / 2);
        for (int x = 0; x < circles; x++) {
          for (int y = 0; y < circles; y++) {
            handyPencilRenderer.arc(x * scl, y * scl, rho, rho, 0, PI * 2);
          }
        }

        popMatrix();
        break;
      }
    case 11: // hollow circle
      {
        pushMatrix();

        float rho = scl / 2;
        float weight = scl / 2 * 0.5;

        translate(scl / 2, scl / 2);

        handyPencilRenderer.arc(0, 0, rho, rho, 0, 2 * PI);
        fill(background_color);
        handyPencilRenderer.arc(0, 0, weight, weight, 0, 2 * PI);

        popMatrix();
        break;
      }
    case 12: // hollow square
      {
        pushMatrix();

        float side = scl;
        float weight = scl / 2 * 0.9;

        translate(scl / 2, scl / 2);

        handyPencilRenderer.rect(-side / 2, -side / 2, side, side);
        fill(background_color);
        handyPencilRenderer.rect(-weight / 2, -weight / 2, weight, weight);

        popMatrix();
        break;
      }

    case 13: // plus sign
      {
        pushMatrix();

        float height = scl;
        float width = scl / 4;

        translate(scl / 2, scl / 2);

        handyPencilRenderer.rect(-width / 2, -height / 2, width, height);

        rotate(PI / 2);
        rect(-width / 2, -height / 2, width, height);

        popMatrix();
        break;
      }
    case 14: // arch on the side
      {
        pushMatrix();

        float rho = scl*1.5;

        handyPencilRenderer.arc(0, 0, rho, rho, 0, PI / 2);

        popMatrix();
        break;
      }
    case 15: // two triangles with touching tops
      {
        pushMatrix();

        float height = scl / 2;

        for (int i = 0; i < 2; i++) {
          pushMatrix();
          translate(scl / 2, scl / 2);
          rotate(PI * i);
          translate(-scl / 2, -scl / 2);

          if ( i == 1) {
            color c = getColor();
            fill(c);
            if (useHandy && roughy > 0) stroke(c);
            handyPencilRenderer.setStrokeColour(c);
          }
          handyPencilRenderer.triangle(0, 0, height, height, height * 2, 0);

          popMatrix();
        }

        popMatrix();
        break;
      }
    default:
    }
    popMatrix();
  }
}

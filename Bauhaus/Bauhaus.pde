import java.text.SimpleDateFormat;
import java.util.Date;


int min_cols = 3;
int max_cols = 12;
float border = 0.15;

int min_fill = 20;
int max_fill = 120;

boolean tilt = true;

int cols = floor(random(min_cols, max_cols));

int fillweight = floor(random(min_fill, max_fill));

int inner_size;
int inner_border;
// size and displacement calculations
int scl;
int dpos;

int[][] figures = {
  {1, 4, 5, 6, 7, 9, 12, 13, 15, 16, 17, 18}, // sqaures
  {0, 2, 3, 8, 10, 11, 14}  // circles
};

int currentSet = 0;

boolean singleFigureOnly = false;
int singleFigure = -1;



//color background_color = #FCFCFC;//A4;
color background_color = #f5e7dc;
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

color tileColors[][]  = {{
    0xFF015EAD, // blue
    0xFF015EAD, // blue
    0xFF015EAD, // blue
    0xFFF3BA30, // yellow
    0xFFF3BA30, // yellow
    0xFFF3BA30, // yellow
    0xFFEE1B27, // red
    0xFFEE1B27, // red
    0xFFEE1B27, // red
    0xFF222222, // black
    0xFFF0F3F7, // white
    0xFFF0F3F7  // white
  }, {
    #3b6c97,
    #ca3f28
  }, {
    #d3633b,
    #3f544b
  }, {
    #f6cc9f,
    #eec180,
    #253944,
    #938a61,
    #649383,
    #619483,
    #eca04e,
    #3d6d71,
    #e8a14f,
    #e36326,
    #cc3627,
    #d15d2c,
    #e5a24b,
    #7ea689,
    #253941,
    #b6c0a5
  }
};

int colorSet=0;

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

  colorSet = floor(random(tileColors.length));

  tiles.clear();

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      tiles.add( new Tile(x * scl + dpos, y * scl + dpos, scl));
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
        saveFrame("frames/####.png");
        break;
      }

    case 'y':
      {
        if (fillweight < max_fill)
          fillweight++;
        redraw();
        break;
      }
    case 'x':
      {
        if (fillweight > min_fill)
          fillweight--;
        redraw();
        break;
      }
    case 'c':
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
    case 'f':
      {
        singleFigureOnly = !singleFigureOnly;
        if (singleFigureOnly)
        {
          currentSet = floor(random(figures.length));
          singleFigure = figures[currentSet][floor(random(figures[currentSet].length))];
        }
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
    color c =  tileColors[colorSet][ floor(random(tileColors[colorSet].length))];

    while ( c == lastColor)
      c =  tileColors[colorSet][ floor(random(tileColors[colorSet].length))];

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
    int figure = floor(random(fillweight));

    if (singleFigureOnly)
      figure = singleFigure;
    else
    {
      // currentSet = floor(random(figures.length));

      // figure = figures[currentSet][floor(random(figures[currentSet].length))];
    }
    fill(fillColor);

    switch (figure) {

    case 0: // 2 arcs
      {
        float rho = scl ; // / 2;

        pushMatrix();
        translate(scl / 2, scl / 2);

        for (int i = 0; i < 2; i++) {
          rotate(PI * i);

          if ( i == 1) fill(getColor());

          arc(-scl / 2, 0, rho, rho, -PI / 2, PI / 2);
        }
        popMatrix();

        break;
      }
    case 1: // Square
      {

        float side = scl * 0.75;

        pushMatrix();
        translate(scl / 2, scl / 2);

        rect(-side / 2, -side / 2, side, side);

        popMatrix();
        break;
      }
    case 2:  // one circle in the middle
      {

        float rho = scl / 1.5;

        pushMatrix();
        translate(scl / 2, scl / 2);

        arc(0, 0, rho, rho, 0, PI * 2);

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

          if ( i == 1) fill(getColor());
          arc(0, 0, rho, rho, 0, PI * 2);

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

          if ( i == 1) fill(getColor());
          rect(0, 0, width, height);

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
          if ( i == 1) fill(getColor());
          rect(width * i, 0, width, height);
        }

        popMatrix();
        break;
      }


    case 6: // triangle
      {
        pushMatrix();
        float height = scl;

        triangle(0, 0, height / 2, height, height, 0);

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

          if ( i == 1) fill(getColor());

          triangle(0, 0, height, height, height, 0);

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
          if ( i == 1) fill(getColor());
          arc(-scl / 2, 0, rho, rho, -PI / 2, PI / 2);
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
          if ( i == 1) fill(getColor());
          for (int j = 0; j < items; j++) {
            rect(0, 0, width, height);
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

        int circles = floor(random(2, 6));
        float scl = this.scl / circles;
        float rho = scl * 0.50;

        translate(scl / 2, scl / 2);
        for (int x = 0; x < circles; x++) {
          for (int y = 0; y < circles; y++) {
            arc(x * scl, y * scl, rho, rho, 0, PI * 2);
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

        arc(0, 0, rho, rho, 0, 2 * PI);
        fill(background_color);
        arc(0, 0, weight, weight, 0, 2 * PI);

        popMatrix();
        break;
      }
    case 12: // hollow square
      {
        pushMatrix();

        float side = scl;
        float weight = scl / 2 * 0.9;

        translate(scl / 2, scl / 2);

        rect(-side / 2, -side / 2, side, side);
        fill(background_color);
        rect(-weight / 2, -weight / 2, weight, weight);

        popMatrix();
        break;
      }

    case 13: // plus sign
      {
        pushMatrix();

        float height = scl;
        float width = scl / 4;

        translate(scl / 2, scl / 2);

        rect(-width / 2, -height / 2, width, height);

        rotate(PI / 2);
        rect(-width / 2, -height / 2, width, height);

        popMatrix();
        break;
      }
    case 14: // arch on the side
      {
        pushMatrix();

        float rho = scl*1.5;

        arc(0, 0, rho, rho, 0, PI / 2);

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

          if ( i == 1) fill(getColor());

          triangle(0, 0, height, height, height * 2, 0);

          popMatrix();
        }

        popMatrix();
        break;
      }
    case 16: // zebra lines H
      {
        pushMatrix();

        int items = 4;
        int stripsets = 3;
        float height = scl / (items * (2+1));
        float width = scl / stripsets;

        for (int i = 0; i < stripsets; i++) {
          float dx = width * i;
          float dy = height * i;
          pushMatrix();
          translate(dx, dy);
          if ( i > 0) fill(getColor());
          for (int j = 0; j < items; j++) {
            rect(0, 0, width, height);
            translate(0, height * 2);
          }
          popMatrix();
        }
        popMatrix();
        break;
      }

    case 17: // zebra lines V
      {
        pushMatrix();

        int items = 4;
        int stripsets = 3;
        float width = scl / (items * (2+1));
        float height = scl / stripsets;

        for (int i = 0; i < stripsets; i++) {
          float dx = width * i;
          float dy = height * i;
          pushMatrix();
          translate(dx, dy);
          if ( i > 0) fill(getColor());
          for (int j = 0; j < items; j++) {
            rect(0, 0, width, height);
            translate(width * 2, 0);
          }
          popMatrix();
        }
        popMatrix();
        break;
      }

    case 18: // square grid
      {
        pushMatrix();
        rectMode(CENTER);
        int squares = floor(random(2, 6));
        float scl = this.scl / squares;
        float rho = scl * 0.50;

        translate(scl / 2, scl / 2);
        for (int x = 0; x < squares; x++) {
          for (int y = 0; y < squares; y++) {
            //arc(x * scl, y * scl, rho, rho, 0, PI * 2);
            rect(  x * scl, y * scl, rho, rho);
          }
        }
        rectMode(CORNER);
        popMatrix();
        break;
      }

    default:
    }
    popMatrix();
  }
}

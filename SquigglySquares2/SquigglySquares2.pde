import com.cage.colorharmony.*;

ColorHarmony colorHarmony = new ColorHarmony(this, 15, 55, 20, 65); 

color[] colors = colorHarmony.Monochromatic();


float x, y;
float angle;
float fillCol;
float diaArc_x, diaArc_y;

int dimension = 800;
float max = dimension/100*90;
float min = dimension/30;

float diaMax_ = dimension/8;
float diaMax = max;
float diaMin = dimension/10;


void settings()
{
  size(dimension, dimension);
}

void setup()
{
  rectMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  stroke(#282828);
  strokeWeight(0.1);

}

void draw()
{
  background(#282828);

  int squareWidth = floor(width);
  int squareHeight = floor(height);

  angle += 5;

  if ( angle%360 == 0)
  {
    if (diaMax < max) diaMax_ +=min;
  }

  diaMax = lerp(diaMax, diaMax_, 0.1);

  x = sin(radians(angle))*squareWidth/2;
  y = cos(radians(angle))*squareHeight/2;

  diaArc_x = map(x, -squareWidth/2, squareWidth/2, 0, squareWidth/2);
  diaArc_y = map(y, -squareHeight/2, squareHeight/2, 0, squareHeight/2);

  translate(width/2, height/2);

  //fill(#282828);
  //rect(0, 0, diaMax+diaMin, diaMax+diaMin, diaArc_x, diaArc_y, squareWidth/2-diaArc_x, squareHeight/2-diaArc_y);

  for (float dia=diaMax; dia>diaMin; dia-=min) {
    fillCol = color(angle%360);//,100,map(dia,diaMax,diaMin,0,100));

    fill(fillCol,80,map(dia,diaMax,diaMin,0,100));
    //rect(0, 0, dia, dia, diaArc_x, diaArc_y, diaArc_x, diaArc_y);
    rect(0,0,dia,dia,diaArc_x,diaArc_y,squareWidth/2-diaArc_x,squareHeight/2-diaArc_y);
  }
}

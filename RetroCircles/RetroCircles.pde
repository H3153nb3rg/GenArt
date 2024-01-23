import java.text.SimpleDateFormat;
import java.util.Date;
import java.time.Instant;
import java.util.Collection;

BorderInfo borderInfo;

float border = 0.09;


color background_color = #FFDFD1BF;


color[] cirleCol1 = { color(253, 229, 240), color(237, 32, 123)};
color[] cirleCol2 = { color(251, 229, 234), color(135, 49, 139)};
color[] cirleCol3 = { color(238, 31, 122), color(249, 148, 27)};
color[] cirleCol4 = { color(171, 73, 158), color(1, 3, 4) };
color[] cirleCol5 = { color(238, 30, 40), color(255, 243, 1)};
color[] cirleCol6 = { color(175, 212, 53), color(244, 151, 32)};
color[] cirleCol7 = { color(89, 52, 144), color(251, 245, 1)};
color[] cirleCol8 = { color(181, 210, 56), color(252, 147, 32)};

color[][] circleColors = {cirleCol1, cirleCol2, cirleCol3, cirleCol4, cirleCol5, cirleCol6, cirleCol7, cirleCol8};

color backColor = color(240, 240, 240);

int nrGenCircles = 10;
int nrColStripes = 5;

boolean refresh = false;
boolean clear = false;
boolean splatter2 = false;
boolean splatter1 = false;

int circleX;
int circleY;
int seed;

ArrayList<Circle2D> circles = new ArrayList<Circle2D>();

Circle2D paintCircle;

void setup()
{
  size(900, 900);
  background(backColor);

  initialize();
}

void initialize() {

  seed = (int)Instant.now().getEpochSecond();
  randomSeed(seed);
  noiseSeed(seed);


  borderInfo = new BorderInfo(width, height, seed, border);
  borderInfo.setShowInnerBorder(true);
  borderInfo.setShowFraming(true);
}

void draw()
{
  if (borderInfo.isShowFraming())
  {
    clip(borderInfo.getDisplacement(), borderInfo.getDisplacement(), borderInfo.getInnerSizeX(), borderInfo.getInnerSizeY());
  }

  if ( refresh )
  {

    refresh = false;
    paint();
  }

  if ( splatter1 )
  {
    splatter1 = false;
    paintSplatter(true);
  }

  if ( splatter2 )
  {
    splatter2 = false;
    paintSplatter(false);
  }

  if (borderInfo.isShowFraming())
  {
    noClip();
    strokeWeight(borderInfo.getDisplacement()*2);
    stroke(backColor);
    noFill();
    rect(0, 0, width, height);
    borderInfo.drawCasing(getGraphics());
  }
}

void paintSplatter(boolean overlapped)
{
  for ( int i=0; i < nrGenCircles; i++)
  {
    Circle2D newCircle = getSomeCircles(overlapped);
    if ( newCircle != null)
    {
      paintCircle = newCircle;
      circles.add(paintCircle );

      paint();
    }
  }
}

Circle2D getSomeCircles(boolean overlapped)
{
  Circle2D circle = new Circle2D();

  int maxIterations = 999;

  do
  {
    circle.x = (int)random(width);
    circle.y = (int)random(height);
    circle.radius = (int)random ( width/8, width/4)/2;

    if ( checkIfAllowed(circle, overlapped))
      break;

    maxIterations--;
  }
  while (maxIterations>0);


  if (maxIterations==0) {
    circle = null;
  }

  return circle;
}

boolean checkIfAllowed(Circle2D circle, boolean overlapped)
{
  boolean invalid = false;

  for (int i = 0; i < circles.size() && !invalid; i++)
  {
    if (overlapped) {
      invalid = circle.overlaps( circles.get(i));
    } else {
      invalid = circles.get(i).inCircle(circle.x, circle.y);
    }
  }

  return !invalid;
}


void paint()
{

  if ( clear )
  {
    clear = false;
    fill(backColor);
    rect(0, 0, width, height);
  }
  if (paintCircle != null) {
    int radius = (int)paintCircle.radius*2;
    int circleX = (int)paintCircle.x;
    int circleY= (int)paintCircle.y;

    color[] circleColor = circleColors[(int)random(circleColors.length)];

    int odd = (int)random(0, circleColor.length);
    int even = abs(odd -1);

    noStroke();
    for ( int i = 0; i < nrColStripes; i++)
    {
      int innerRadius = radius-(radius/5)*i;

      fill(circleColor[i%2==0?odd:even]);
      circle(circleX, circleY, innerRadius);
    }
  }
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
    case 'x':
      {
        clear=true;
        break;
      }
    case 'y':
      {
        splatter1=true;
        break;
      }
    case 'a':
      {
        splatter2=true;
        break;
      }
    case ' ':
      {
        refresh = true;
        break;
      }
    }
  }
}



void mouseClicked()
{
  Circle2D circle = new Circle2D( mouseX, mouseY, (int)random ( width/8, width/4)/2);

  paintCircle = circle;
  circles.add( circle);

  refresh = true;
}

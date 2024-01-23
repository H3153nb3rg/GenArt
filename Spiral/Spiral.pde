
int angle = floor(random(5, 30));
int steps = 500;
int factor = floor(random(1500, 3500));
float rStrokeSize = 0.3;

boolean save = false;

void setup()
{
  size(900, 900);
}

void initialize()
{
  angle = floor(random(5, 30));
  steps = floor(random(200, 700));
  factor = floor(random(1500, 3500));
  rStrokeSize = 0.3;
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
        save = !save;
        break;
      }
    default:

      initialize();
    }
  }
}


void draw() {
  strokeWeight(rStrokeSize);

  background(#282828);

  translate(width/2, height/2);

  float wave = sin(radians(frameCount))*factor;

  for (int i = 0; i < steps; i ++) {

    rotate(angle);
    stroke(128, 128, 240);
    line(width/2, i-wave/2, -width/2, i++);
    stroke(128, 240, 128);
    line(-width/2, -i+wave, width/3, i++);
    stroke(255, 0, 255);
    line(-width/2, i-wave, width/2, i++);
  }

  if (save)
  {
    saveFrame("frames/####.tif");
  }

}

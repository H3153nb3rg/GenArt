import com.cage.colorharmony.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Collection;

ColorHarmony colorHarmony = new ColorHarmony(this, 15, 55, 20, 65);

//color background_color = #FFF3EFE4;
color background_color = 0xFFFAFAFA;
//color background_color = 0x282828;

int maxArcs = 25;
int minArcs = 5;
int n = maxArcs;

float width_rads[] = new float[n];
float seeds[] = new float[n];
color colors[];// = new color[n];

float border = 0.09;
boolean framing = false;      // toggle frame

BorderInfo borderInfo;

int seed;               // = millis();


void setup() {
  size(900, 900);
  frameRate(15);

  stroke(125);
  strokeWeight(0.3);

  init();

  initialize();
}

void init() {
  seed = (int)Instant.now().getEpochSecond();
  randomSeed(seed);
  noiseSeed(seed);

  borderInfo = new BorderInfo(width, height, seed, border);
}

void initialize() {

  n = floor(random(minArcs, maxArcs));

  for (int i=0; i<n; i++) {
    width_rads[i] = random(PI/2, 3*PI/2);
    seeds[i] = random(0, 100000);
  }

  switch (floor(random(0, 5))) {

  case 0:
    colors = colorHarmony.Complementary();
    break;
  case 1:
    colors = colorHarmony.Analogous();
    break;
  case 2:
    colors = colorHarmony.Monochromatic();
    break;
  case 3:
    colors = colorHarmony.Triads();
    break;
  default:
    colors = new color[n];
    for (int i=0; i<n; i++) {
      colors[i] = color(random(255), random(128), random(128));
    }
  }
}


void draw() {
  render();

  if (framing) {
    borderInfo.drawCasing(getGraphics());
  }
}

void render() {

  if (framing) {
    background(255);
    clip(borderInfo.getDisplacement(), borderInfo.getDisplacement(), borderInfo.inner_sizeX, borderInfo.inner_sizeY);
  }

  background(background_color);

  translate(width/2, height/2);

  for (int i=n-1; i>=0; i--) {

    int cIx = i % colors.length;

    fill(( colors[cIx] >> 16) & 0xFF, ( colors[cIx] >> 8) & 0xFF, ( colors[cIx]) & 0xFF, map(n-i, 0, n, 0, 90));
    float rotate_rad = map(noise(seeds[i]), 0, 1, 0, 2*PI);

    rotate(rotate_rad);

    float r = map(i, 0, n, 50, borderInfo.inner_sizeX);
    PVector lower_pos = new PVector(r*cos(0)/2, r*sin(0)/2);
    PVector upper_pos = new PVector(r*cos(width_rads[i])/2, r*sin(width_rads[i])/2);

    arc(0, 0, r, r, 0, width_rads[i]);
    line(0, 0, lower_pos.x, lower_pos.y);
    line(0, 0, upper_pos.x, upper_pos.y);

    seeds[i]+=0.01;

    rotate(-rotate_rad);
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
        saveFrame("frames/####.tif");
        break;
      }
    case 'f':
      {
        framing = !framing;
        break;
      }
    default:
      initialize();
    }
  }
}

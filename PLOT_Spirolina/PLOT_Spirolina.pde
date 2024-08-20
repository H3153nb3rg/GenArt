import processing.svg.*;


float a, b, h, xpos, ypos, oxpos, oypos, t, ot, d, od;
int centerX, centerY;

boolean saveSVG = false;
String baseFilename="";

void setup() {
  size(800, 800);
  colorMode(HSB, 360);
  background(0);
  
  centerX = width/2;
  centerY = height/2;
}

void draw() {
  
  background(0);

  if ( saveSVG) {
    stroke(255);
    beginRecord(SVG, baseFilename+".svg");
  }

  a = mouseX;
  b = 60;
  h = mouseY;

  for (int i=1; i<361; i+=1) {
    t = radians(i);
    ot = radians(i-1);
    d = a*t;
    od = a*ot;

    oxpos = (a-b)*cos(ot)+h*cos(od);
    oypos = (a-b)*sin(ot)+h*sin(od);

    xpos = (a-b)*cos(t)+h*cos(d);
    ypos = (a-b)*sin(t)+h*sin(d);

    if ( !saveSVG) {
      stroke(i-1, 360, 360);
    }

    line(centerX+oxpos, centerY+oypos, centerX+xpos, centerY+ypos);
  }

  if ( saveSVG) {
    saveSVG = false;
    endRecord();
  }
}

void mousePressed() {
  baseFilename = "frames/spirolina_"+a+"_"+b+"_"+h;
  save(baseFilename+".tif");
  saveSVG = true;
}

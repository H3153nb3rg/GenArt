/*
Based on
 Processing + Axidraw — Generative hut tutorial by Julien "v3ga" Gachadoat
 January 2020
 www.generativehut.com
 —
 
 www.instagram.com/julienv3ga
 https://twitter.com/v3ga
 https://github.com/v3ga
 
 */

// --------------------------------------------------
import processing.svg.*;
import java.util.*;
import controlP5.*;

import org.gicentre.handy.*;

HandyRenderer handyPencilRenderer;
int roughness=0;

boolean paintit = true;
boolean showControls = true;
// --------------------------------------------------
boolean bExportSVG = false;
ControlP5 cp5;

// --------------------------------------------------
int nrCorners = 5;

float nrIterations = 62;
float radiusMin = 10;
float radiusMax = 370;
float lineWidthMin = 0.1;
float lineWidthMax = 3.0;
float nbWaves = 2;
float angleRotation = 0.07;

// --------------------------------------------------
void setup()
{
  size(800, 800);
  initControls();

  handyPencilRenderer = HandyPresets.createPencil(this);
  //  handyPencilRenderer.setHachurePerturbationAngle(75);
  //  noLoop();
}

// --------------------------------------------------
void draw()
{
  if (paintit) {
    //  handyPencilRenderer.setIsHandy(useHandy);
    //handyPencilRenderer.setFillColour(c1);
    //handyPencilRenderer.setStrokeColour(c1);
    //handyPencilRenderer.setRoughness(useRoughness ? floor(random(2, 7)) : 1);
    //handyPencilRenderer.setIsAlternating(false);
    //handyPencilRenderer.setSecondaryColour(c2);
    //handyPencilRenderer.setUseSecondaryColour(false);
    //handyPencilRenderer.setFillGap(random(0.4, 0.7));
    //handyPencilRenderer.setFillWeight(0.3);
    //handyPencilRenderer.rect(x, y, xx, yy);


    // White background
    // The function is called before beginRecord
    background(255);

    // Start recording if the flag bExportSVG is set
    // When recording, all Processing drawing commands will be displayed on screen and saved into a file
    // The filename is set with a timestamp

    PGraphics svg=null;

    if (bExportSVG)
    {
      beginRecord(SVG, "data/image_"+timestamp()+".svg");

      handyPencilRenderer.setIsHandy(false);

      //svg = createGraphics(800, 800, SVG, "data/image_"+timestamp()+".svg");
      //svg.beginDraw();
      //handyPencilRenderer.setGraphics(svg);
    }


    // Drawing options : no fill and stroke set to black
    noFill();
    stroke(0);

    // Translate the origin to the center of screen
    pushMatrix();
    translate(width/2, height/2);

    // Start drawing here
    for (int n=0; n<nrIterations; n++)
    {
      pushMatrix();

      rotate( map( sin(nbWaves*n/(nrIterations-1)*TWO_PI), -1, 1, -angleRotation, angleRotation) );

      circle(nrCorners, map(n, 0, nrIterations-1, radiusMax, radiusMin), n);

      popMatrix();
    }
    // End drawing here

    // Reset origin
    popMatrix();

    // If we were exporting, then we stop recording and set the flag to false
    if (bExportSVG)
    {
      //svg.dispose();
      //svg.endDraw();
      handyPencilRenderer.setIsHandy(true);
      endRecord();
      bExportSVG = false;
    }

    paintit = false;
  }
  drawControls();
}

// --------------------------------------------------
void keyPressed()
{
  if (key != ESC)
  {

    switch (key)
    {
    case 's':
      {
        bExportSVG = true;
        paintit = true;
        break;
      }
    case ' ':
      {
        paintit = true;
        break;
      }
    case 'c':
      {
        paintit = true;
        showControls = !showControls;
        break;
      }
    }
  }
}

// --------------------------------------------------
void circle(int nrCorners, float radius, int index)
{
  handyPencilRenderer.setRoughness(roughness);
  strokeWeight(map(index, 1, nrIterations, lineWidthMin, lineWidthMax));

  handyPencilRenderer.beginShape();

  for (int i=0; i<nrCorners; i++)
  {
    float angle = -PI/2+float(i)*TWO_PI/float(nrCorners);
    handyPencilRenderer.vertex( radius*cos(angle), radius*sin(angle) );
  }

  handyPencilRenderer.endShape(CLOSE);
}

// --------------------------------------------------

String timestamp()
{
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

// --------------------------------------------------

void paintIt()
{
  paintit = true;
}

// --------------------------------------------------
void initControls()
{

  int hSlider = 15;
  int wSlider = width/2;
  int x = 5;
  int y = 5;
  int margin = 12;

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.setBroadcast(false);

  cp5.addSlider("nrCorners").setSize(wSlider, hSlider).setPosition(x, y).setLabel("Corners").setRange(3, 10).setNumberOfTickMarks(10-3).setValue(nrCorners);
  y+=hSlider+margin;
  cp5.addSlider("nrIterations").setSize(wSlider, hSlider).setPosition(x, y).setLabel("Iterations").setRange(1, 100).setNumberOfTickMarks(100).setValue(nrIterations);
  y+=hSlider+margin;
  cp5.addRange("radius").setSize(wSlider, hSlider).setWidth(wSlider).setPosition(x, y).setLabel("radius range").setRange(10, 370).setRangeValues(radiusMin, radiusMax);
  y+=hSlider+margin;
  cp5.addSlider("nbWaves").setSize(wSlider, hSlider).setWidth(wSlider).setPosition(x, y).setLabel("Waves").setRange(1, 5).setNumberOfTickMarks(5).setValue(nbWaves);
  y+=hSlider+margin;
  cp5.addSlider("angleRotation").setSize(wSlider, hSlider).setPosition(x, y).setLabel("Rotation").setRange(0, PI/2).setValue(angleRotation);
  y+=hSlider+margin;
  cp5.addSlider("roughness").setSize(wSlider, hSlider).setPosition(x, y).setLabel("Roughness").setRange(0, 7).setNumberOfTickMarks(7).setValue(roughness);
  y+=hSlider+margin;
  cp5.addSlider("lineWidthMin").setSize(wSlider, hSlider).setPosition(x, y).setLabel("LineWidth MIN").setRange(0.1, 4).setNumberOfTickMarks(10).setValue(lineWidthMin);
  y+=hSlider+margin;
  cp5.addSlider("lineWidthMax").setSize(wSlider, hSlider).setPosition(x, y).setLabel("LineWidth MAX").setRange(0.1, 4).setNumberOfTickMarks(10).setValue(lineWidthMax);

  cp5.setBroadcast(true);
}
// --------------------------------------------------
void controlEvent(ControlEvent theControlEvent)
{
  if (theControlEvent.isFrom("radius"))
  {
    radiusMin = int(theControlEvent.getController().getArrayValue(0));
    radiusMax = int(theControlEvent.getController().getArrayValue(1));
  }

  paintit = true;
}

// --------------------------------------------------
void drawControls()
{
  if (showControls) {
    pushStyle();
    noStroke();
    fill(0, 100);
    rect(0, 0, width, 220);
    popStyle();
    cp5.draw();
  }
}

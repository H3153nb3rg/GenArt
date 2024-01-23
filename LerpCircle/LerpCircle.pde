// P_2_2_3_01
//
// Generative Gestaltung – Creative Coding im Web
// ISBN: 978-3-87439-902-9, First Edition, Hermann Schmidt, Mainz, 2018
// Benedikt Groß, Hartmut Bohnacker, Julia Laub, Claudius Lazzeroni
// with contributions by Joey Lee and Niels Poldervaart
// Copyright 2018
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * form mophing process by connected random agents
 *
 * MOUSE
 * click               : start a new circe
 * position x/y        : direction of floating
 *
 * KEYS
 * 1-2                 : fill styles
 * f                   : freeze. loop on/off
 * Delete/Backspace    : clear display
 * s                   : save png
 */
//'use strict';

int formResolution = 15;
int stepSize = 2;
int distortionFactor = 1;
int initRadius = 150;
int centerX;
int centerY;

ArrayList<Point> circle = new ArrayList<Point>();

boolean filled = false;
boolean freeze = false;

void setup() {
  size(900, 900);
  stroke(0, 50);
  strokeWeight(0.75);
  background(255);
  noFill();
  init(width / 2, height / 2);

  // noLoop();
}

void init(int x, int y) {
  // init shape
  centerX = x;
  centerY = y;

  circle.clear();
  // float angle = radians(floor(360 / formResolution));
  for (float angle = 0; angle < 360; angle++) {

    circle.add( new Point( (float)Math.cos(angle * Math.PI / 180) * initRadius, (float)Math.sin(angle * Math.PI / 180) * initRadius));
  }
}

void addRand() {

  circle.forEach( point -> {
    point.setX(point.getX() + random(-stepSize, stepSize));
    point.setY(point.getY() + random(-stepSize, stepSize));
  }
  );
}


void draw() {
  //// floating towards mouse position
  centerX += (mouseX - centerX) * 0.01;
  centerY += (mouseY - centerY) * 0.01;

  background(255);
  addRand();

  beginShape();

  circle.forEach( point -> {
    curveVertex(point.getX() + centerX, point.getY() + centerY);
  }
  );

  endShape(CLOSE);
}

void mousePressed() {

  init(mouseX, mouseY);
}


//void keyReleased() {
//  if (key == 's' || key == 'S') saveCanvas(gd.timestamp(), 'png');
//  if (keyCode == DELETE || keyCode == BACKSPACE) background(255);
//  if (key == '1') filled = false;
//  if (key == '2') filled = true;

//  // pauze/play draw loop
//  if (key == 'f' || key == 'F') freeze = !freeze;
//  if (freeze) {
//    noLoop();
//  } else {
//    loop();
//  }
//}

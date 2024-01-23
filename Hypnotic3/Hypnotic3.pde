import com.cage.colorharmony.*;

ColorHarmony colorHarmony = new ColorHarmony(this, 15, 55, 20, 65); 

color[] colors = colorHarmony.Monochromatic();

float angle=0;

int scaleX = 0;

int[] col={(int)random(255),(int)random(255),(int)random(255)};

void setup()
{
  size (960,1000);
  surface.setLocation(457,0);
  //noStroke();
  //fill(0,15,30);
  //colorMode(HSB, 100.0, 100.0, 360.0);
  
  stroke(0,15,30);
  strokeWeight(25);
  rectMode(CENTER);
  
  frameRate(30);
}

void draw()
{
  
   
  background(0,15,30);
  translate(width/2,height/2);
  
  if (frameCount > 300)
  {
      if (frameCount < 1000)
      {
        scaleX++;
      }
      else
      {
        if (scaleX > 0)
          scaleX--;
      }
  }
  
  
  float scaleVar = map(scaleX,0,width,0.6,5);
  scale(scaleVar);
    
  for (int i=0; i< 90; i++) {
     // fill(i+10,45,90);
     
    fill(i+155,155-i+15,255-i*10);
    
    //fill(col[0],col[1],col[2]);
    
    scale(0.95);
    rotate(radians(angle));
    rect(0,0,600,600);
  }
  angle +=0.1;
  
   // saveFrame("frames/####.tif"); 
  
}

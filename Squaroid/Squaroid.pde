
int num = 30;
float[] y = new float[num];
float sW;

void setup()
{
    size(900,900);
    frameRate(20); 
    blendMode(DIFFERENCE);
    
    for ( int n = 0; n < num; n++) {
      y[n] = height/num*n;
    }
    sW = height/num/2;
}

void drawStripes(int stripeColor)
{
   for ( int n = 0; n < num; n++) {
      float alpha = map(y[n],0,height,0,255);
      stroke(stripeColor,alpha);
      
      //beginShape();      
      //for (int xx=0; xx < width;xx+=20)
      //{
      //  vertex(xx, y[n]+noise(xx)*10);
      //}
      //endShape();
          
      line(0,y[n],width,y[n]);
      
      y[n] += 0.5;
      if (y[n] > height){
        y[n] = 0;
      }
    }


}

int rCol = #f10000;
int gCol = #00d000;

void draw()
{
  background(#eeeeee);
  
    rCol += noise(frameCount)*5;
    gCol += noise(frameCount)*5;
  
  strokeWeight(sW);
  drawStripes(rCol);

  translate(0,height);
  rotate(-HALF_PI); 

  drawStripes(gCol);
 
  stroke(#ffffff);
  strokeWeight(height/3);
  noFill();
  
  ellipse(width/2,height/2,height+height/6,height+height/6);

  
  //rotate(HALF_PI/2+PI); 
  //translate(-width,-height/2);
  //drawStripes(#0000e0);
  
  //stroke(#ffffff);
  //strokeWeight(height/3);
  //noFill();
  
  ////ellipse(width/2,height/2,height+height/6,height+height/6);

  //square(0,0,height);
  
   //for ( int n = 0; n < num; n++) {
   // float alpha = map(y[n],0,height,0,255);
   // stroke(#f10000,alpha);
   // strokeWeight(sW);
    
   // line(0,y[n],width,y[n]);
    
   // y[n] += 0.5;
   // if (y[n] > height) y[n] =0;
    
   // }
    
}

// Jim andango 2023
// https://www.kunstkopie.de/a/robert-delaunay/premier-disque.html


color quarter1[] = { color(96,35,69), color(195,107,44), color(212,198,174), color(129,57,94), color(159,178,200),color(184,99,132), color(222,35,34)};
color quarter2[] = { color(46,79,124), color(88,95,62), color(141,37,38), color(39,44,67), color(242,194,65), color(81,103,144), color(225,65,51) };
color quarter3[] = { color(170,48,37), color(210,186,188), color(61,50,56), color(63,55,56), color(238,168,46), color(110,134,95), color(92,128,178)};
color quarter4[] = { color(148,41,52), color(83,109,166), color(40,40,50), color(193,53,50), color(236,203,194), color(233,142,44), color(60,120,176) };

color circleColors[][] = { quarter1,quarter2,quarter3,quarter4};

color backgroundColor = color(243,238,232);

boolean hasChanged = true;
boolean shuffle = false;

int dimension = 800;

//void settings()
//{
//    size(dimension,dimension);
//}

void setup() {
  
  size(800,800);
  colorMode(HSB, 360.0, 100.0, 100.0, 100.0);
  
  background(backgroundColor);
  
  smooth();
  // noLoop();
}

void draw()
{
  if (hasChanged)
  {
     hasChanged = false;
  
    int centerX = width / 2;
    int centerY = height / 2;
    
    int radius = width-(width/20);
    noStroke();
    
    
    for (int c = 0; c < quarter1.length; c++)
    {
      int col =0;
      for ( float arclen = PI; arclen < TWO_PI+PI; arclen += HALF_PI)
      {
        
        if (shuffle)
        {
           shuffleArray( circleColors[col]);
        }
          
        fill(circleColors[col][c]);    
        arc(centerX, centerY, radius , radius, arclen, arclen+HALF_PI);
        
        col++;
      }
    
      radius -= (width/7);
    }
  }
}

void keyPressed()
{
  if (key != ESC)
  {
    if (key=='s')
      saveFrame();
      
    if (key == ' ')
       shuffle = !shuffle;
       
    hasChanged = true;
  }
}

void shuffleArray(color[] array) {

  for (int i = array.length-1; i > 0; i--) {
    
      int k = (int)random(array.length);  
  
      // Swap array elements.
      color tmp = array[k];
      array[k] = array[i-1];
      array[i-1] = tmp;
    
  }
}

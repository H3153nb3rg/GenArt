class Circle2D {

    float x; //first parameter
    float y; //second parameter
    float radius; //third parameter

    Circle2D() {
    }
    
    public Circle2D(float x, float y, float radius) {
        this.x = x;
        this.y = y;
        this.radius = radius;
    }
    
    public void setX(float x) {
        this.x = x;  //set x
    }
    
    public float getX() {
        return x; //grab x
    }
    
    public void setY(float y) {
        this.y = y; //set y
    }
    public float getY() {
        return y; //grab y
    }
    
    public void setRadius(float radius) {
        this.radius = radius; //set radius
    }
    
    public float getRadius() {
        return radius; //grab radius
    }
    
    public float getArea() {
            float area = (float)(Math.PI*radius*radius); //formula for area
                return area;
    }
    
    public float getPerimeter() {
            float perimeter = (float)(2*Math.PI*radius); //formula for perimeter
                return perimeter;
    }
    
    public boolean inCircle(float x, float y) {
        //Use distance formula to check if a specific point is within our circle. 
        float distance = (float)(Math.sqrt(Math.pow(this.x - x, 2) + (Math.pow(this.y - y, 2))));
        return (distance  <= radius);
            
    }
    public boolean contains(Circle2D circle) {
        //Use distance formula to check if a circle is contained within another circle.
        float distance = (float)(Math.sqrt(Math.pow(circle.getX() - x, 2) + (Math.pow(circle.getY() - y, 2))));
        return (distance <= Math.abs(this.radius - circle.radius));
    }
           
    public boolean overlaps(Circle2D circle, int distance) {
        //Use distance formula to check if a circle overlaps with another circle.

      float centersDistance = (float)(Math.sqrt(Math.pow(circle.getX() - x, 2) + (Math.pow(circle.getY() - y, 2))));

      //boolean contains = radius > centersDistance + circle.radius;
      //boolean contained = circle.radius > centersDistance + radius;
      boolean circlesOverlap = (centersDistance <= radius + circle.radius + distance);
      
      //if ( circlesOverlap )
      //{
      //  System.out.println( "X: " + x + " Y: " + y + " R: "+radius +"   Cx: "+ circle.getX() + " Cy: "+circle.getY() + " Cr: "+circle.getRadius()+"  -> "+(int)centersDistance+" : "+ (radius + circle.radius));
      //}
      
//      return contains || contained || circlesOverlap;
  
      return circlesOverlap;
            
    }

}

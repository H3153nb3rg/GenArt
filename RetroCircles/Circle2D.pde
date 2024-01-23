class Circle2D {

    double x; //first parameter
    double y; //second parameter
    double radius; //third parameter

    Circle2D() {
    }
    
    public Circle2D(double x, double y, double radius) {
        this.x = x;
        this.y = y;
        this.radius = radius;
    }
    
    public void setX(double x) {
        this.x = x;  //set x
    }
    
    public double getX() {
        return x; //grab x
    }
    
    public void setY(double y) {
        this.y = y; //set y
    }
    public double getY() {
        return y; //grab y
    }
    
    public void setRadius(double radius) {
        this.radius = radius; //set radius
    }
    
    public double getRadius() {
        return radius; //grab radius
    }
    
    public double getArea() {
            double area = Math.PI*radius*radius; //formula for area
                return area;
    }
    
    public double getPerimeter() {
            double perimeter = 2*Math.PI*radius; //formula for perimeter
                return perimeter;
    }
    
    public boolean inCircle(double x, double y) {
        //Use distance formula to check if a specific point is within our circle. 
        double distance = Math.sqrt(Math.pow(this.x - x, 2) + (Math.pow(this.y - y, 2)));
        return (distance  <= radius);
            
    }
    public boolean contains(Circle2D circle) {
        //Use distance formula to check if a circle is contained within another circle.
        double distance = Math.sqrt(Math.pow(circle.getX() - x, 2) + (Math.pow(circle.getY() - y, 2)));
        return (distance <= Math.abs(this.radius - circle.radius));
    }
           
    public boolean overlaps(Circle2D circle) {
        //Use distance formula to check if a circle overlaps with another circle.

      double centersDistance = Math.sqrt(Math.pow(circle.getX() - x, 2) + (Math.pow(circle.getY() - y, 2)));

      //boolean contains = radius > centersDistance + circle.radius;
      //boolean contained = circle.radius > centersDistance + radius;
      boolean circlesOverlap = (centersDistance <= radius + circle.radius);
      
      //if ( circlesOverlap )
      //{
      //  System.out.println( "X: " + x + " Y: " + y + " R: "+radius +"   Cx: "+ circle.getX() + " Cy: "+circle.getY() + " Cr: "+circle.getRadius()+"  -> "+(int)centersDistance+" : "+ (radius + circle.radius));
      //}
      
//      return contains || contained || circlesOverlap;
  
      return circlesOverlap;
            
    }

}

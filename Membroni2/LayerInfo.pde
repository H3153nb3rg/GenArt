class LayerInfo {

  ArrayList<Circle2D> circles;
  color fillColor;

  PShape shapeGroup;

  public LayerInfo() {
    circles = new ArrayList<Circle2D>();
  }
  public void setColor(color c) {
    fillColor = c;
  }
  public color getColor() {
    return fillColor;
  }
  public void setCircles(ArrayList<Circle2D> circles) {
    this.circles = circles;
  }
  public ArrayList<Circle2D> getCircles() {
    return circles;
  }
  
  PShape getShapes() {
    return shapeGroup;
  }
  
  void setShapes(PShape shape) {
    shapeGroup = shape;
  }
  
}

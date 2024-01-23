public class Point {

    private float x;
    private float y;

    // Default constructor that sets the Point coordinates to (0, 0)
    public Point() {
        this.x = 0;
        this.y = 0;
    }

    // Constructor that takes x and y coordinates of the Point
    public Point(float x, float y) {
        this.x = x;
        this.y = y;
    }

    // Getter method for x coordinate
    public float getX() {
        return x;
    }

    // Setter method for x coordinate
    public void setX(float x) {
        this.x = x;
    }

    // Getter method for y coordinate
    public float getY() {
        return y;
    }

    // Setter method for y coordinate
    public void setY(float y) {
        this.y = y;
    }

    // Method to calculate the distance between two Points
    public double distance(Point otherPoint) {
        double distanceX = Math.pow(this.x - otherPoint.x, 2);
        double distanceY = Math.pow(this.y - otherPoint.y, 2);
        return Math.sqrt(distanceX + distanceY);
    }

    // Method to check if two Points have the same coordinates
    public boolean equals(Point otherPoint) {
        return this.x == otherPoint.x && this.y == otherPoint.y;
    }

    // Method to prfloat the coordinates of the Point
    public String toString() {
        return "(" + x + ", " + y + ")";
    }
};

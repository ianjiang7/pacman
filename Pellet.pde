class Pellet{
  int x;
  int y;
  int diameter;
  
  Pellet(int ax, int ay, int adiameter) {
    x = ax;
    y = ay;
    diameter = adiameter;
  }
  
  void display() {
    fill(255);
    stroke(255);
    circle(x,y,diameter); 
  }
}

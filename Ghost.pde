class Ghost {
  int x, y;
  color c;
  int size;
  //size just needs to be switched to width and height when we replace the circle with PImage

  Ghost(int row, int col, int asize, color ac) {
    x = col*BWidth + BWidth/2;
    y = row*BHeight + BHeight/2;
    c = ac;
    size = asize;
  }
  
  void display() {
    fill(c);
    circle(x, y, size);
  }
  
  void move() {
    
  }
}

class Pellet{
  int x;
  int y;
  int diameter;
  boolean eaten;
  Pellet(int ax, int ay, int adiameter) {
    x = ax;
    y = ay;
    diameter = adiameter;
    eaten = false;
  }
  
  void display() {
    if(inPacMan() && !eaten){
      eaten = true;
      eatenPellets++;
      score += 100;
      eatP.play();
    }
    if(!eaten){
      fill(255);
      stroke(255);
      circle(x,y,diameter);
    }
    
  }
  
  boolean inPacMan() {
    return dist(pac.pos.x,pac.pos.y, x, y) < diameter/2.0 + BWidth/2; 
  }
  
  
}

class LightBlueGhost extends Ghost {
  //scatter: target is bottom right
  //chase: target is two units in front of Pac-Man and then the vector from this tile to red's is rotated 180 degrees and resulting pos is blue's target
  LightBlueGhost(int row, int col, int asize) {
    super(row, col, asize,LB);
    nextPos.y -= BHeight;
    scatterTarget = new PVector(600, 600);
  }
  
  void setChaseTarget() {
    PVector vec;
    PVector pacVel = new PVector(pac.xVel, pac.yVel);
    vec = PVector.add(pac.pos.copy(), PVector.mult(pacVel, 2*BWidth));
    //vec = PVector.add(vec, redG.pos);
    chaseTarget = vec.copy();
    chaseTarget.setMag(2*PVector.dist(vec, redG.pos));
  }
}

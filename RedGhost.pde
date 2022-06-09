class RedGhost extends Ghost {
  //scatter: target is upper right hand corner
  //chase: target is Pac-Man
  RedGhost(int row, int col, int asize) {
    super(row, col, asize,R);
    scatterTarget = new PVector(600, 0);
  }
  
  void setChaseTarget() {
    chaseTarget = pac.pos.copy();
  }
}

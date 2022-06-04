class OrangeGhost extends Ghost {
  //scatter: target is bottom left
  //chase: when 8 or more units from Pac-Man, target is Pac-Man
  //chase: if less than 8, target is scatter target
  int target;
  float distToPac;
  OrangeGhost(int row, int col, int asize) {
    super(row, col, asize,color(255,140,0));
    scatterTarget = new PVector(0, 600);
    nextPos = new PVector(col*BWidth + BWidth/2 - BWidth, row*BHeight + BHeight/2 - 2*BHeight);
    vel = new PVector (-1, 0);
    target = col*BWidth + BWidth/2 - BWidth;
  }
  
  void spawnMove() {
    vel.x = -1;
    vel.y = 0;
    if(pos.x != target) {
      prevVel = vel;
      prevPos = pos;
      pos.add(vel);
      setPos(findRow(int(pos.y)), findCol(int(pos.x)));
    }
    
    else{
      super.spawnMove();
    }  
  }
  
  void setChaseTarget() {
    println("o");
    distToPac = PVector.dist(pac.pos, pos);
    if (distToPac >= 8*BWidth) {
      chaseTarget = pac.pos.copy();
    }
    else {
      chaseTarget = scatterTarget.copy();
    }
  }
}

class PowerPellet extends Pellet{
   PowerPellet(int ax, int ay, int adiameter) {
     super(ax,ay,adiameter*2);
   }
   
   void display() {
    if(inPacMan() && !eaten){
       mode = BLUE;
       blueStartFrameCount = frameCount;
       for(int i = 0;i<ghosts.length;i++) {
         if (!ghosts[i].eaten) {
           ghosts[i].blue = true;
         }
       }
      eaten = true;
      eatenPellets++;
      score += 100;
      eatPow.play();
    }
    if(!eaten){
      stroke(255);
      if(frameCount % 2 == 0)
        circle(x,y,diameter);
    }
    
  }
   boolean inPacMan() {
     if( dist(pac.pos.x,pac.pos.y, x, y) < diameter/2.0 + BWidth/2) {

       println(mode);
       return true;
     }
     return false;
   }
   
}

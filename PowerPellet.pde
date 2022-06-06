class PowerPellet extends Pellet{
   PowerPellet(int ax, int ay, int adiameter) {
     super(ax,ay,adiameter*2);
   }
   
   boolean inPacMan() {
     if( dist(pac.pos.x,pac.pos.y, x, y) < diameter/2.0 + BWidth/2) {
       mode = BLUE;
       for(int i = 0;i<ghosts.length;i++) {
         ghosts[i].blue = true; 
       }
       println(mode);
       return true;
     }
     return false;
   }
   
}

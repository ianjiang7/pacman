class SpriteSheet {
  PImage ss;
  
  SpriteSheet(String s) {
    ss = loadImage(s);
  }
  
  PImage get(int c,int r) {
     return ss.get( c*16 + 1,r*16,15,15);
  }
  PImage getMaze() {
    return ss.get(ss.width/3,0,227,248); 
  }
}

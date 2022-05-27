int EMPTY = 0;
int WALL = 1;
int SPAWN = 2;
int DOOR = 3;

color blue = color(0,0,255);
color black = color(0);
color red = color(255,0,0);

int diameter = 5;

Map m;
Pellets p;
void setup() {
  size(600,600);
  background(0);
  m = new Map("map.txt");
  m.ReadMap();
  for(int irow = 0; irow < m.rows; irow+=1) {
    for(int icol = 0; icol < m.cols; icol += 1) {
      m.blocks[irow][icol].display();
    }
  }
  p = new Pellets("map.txt");
    p.ReadFile();

  p.display();
}

void draw() {
  
}

import processing.sound.*;
PImage bitmap, background, map, open, zombie;
boolean[] keys;
String[] stuff;
int[] doors, door;
SoundFile gunSounds[];
playerClass player;

void setup() {

  fullScreen(P2D);
  background(0);
  frameRate(60);
  bitmap = loadImage("bunker-bitmap.png");
  background = loadImage("bunker-map.png");
  map = loadImage("bunker-startmap.png");
  open = loadImage("bunker-openmap.png");
  zombie = loadImage("zombie-temp.png");

  image(background, 0, 0);

  gunSounds = new SoundFile[18];
  player = new playerClass();
  keys = new boolean[8];
  door = new int[4];
  stuff = loadStrings("Resources/bunker-rooms.dat");
  doors = int(split(stuff[0], ','));
  for (int i = 0; i < 8; i++ ) {
    keys[i] = false; //clears the key buffer
  }
}

void draw() {
  player.collision();
  if (player.doorx != -1) {
    player.doors();
  }
  player.display();
}

void keyPressed() {
  keys[0] = (key == 'A' || key == 'a') ? true : keys[0]; //checks the A key, which controls movement to the left 
  keys[1] = (key == 'D' || key == 'd') ? true : keys[1]; //checks the D key, which controls movement to the right
  keys[2] = (key == 'W' || key == 'w') ? true : keys[2]; //checks the W key, which controls climbing and jumping
  keys[3] = (key == 'S' || key == 's') ? true : keys[3]; //checks the S key, an arbitrary check at the moment
  keys[4] = (key == 'E' || key == 'e') ? true : keys[4]; //checks the E key, which controls interaction with environment
}
void keyReleased() {
  keys[0] = (key == 'A' || key == 'a') ? false : keys[0]; //checks the A key, which controls movement to the left 
  keys[1] = (key == 'D' || key == 'd') ? false : keys[1]; //checks the D key, which controls movement to the right
  keys[2] = (key == 'W' || key == 'w') ? false : keys[2]; //checks the W key, which controls climbing and jumping
  keys[3] = (key == 'S' || key == 's') ? false : keys[3]; //checks the S key, an arbitrary check at the moment
  keys[4] = (key == 'E' || key == 'e') ? false : keys[4]; //checks the E key, which controls interaction with environment
}
import processing.sound.*;
PImage bitmap, map, background, open, zombie;
boolean[] keys;
String[] stuff;
int[] doors, rooms, door;
SoundFile gunSounds[];

playerClass player;

void setup() {
  noCursor();
  fullScreen(P2D);
  background(0);
  frameRate(60);
  bitmap = loadImage("bunker-bitmap.png");
  background = loadImage("bunker-map.png");
  open = loadImage("bunker-openmap.png");
  zombie = loadImage("zombie-temp.png");

  image(background, 0, 0);

  gunSounds = new SoundFile[18];
  player = new playerClass();
  keys = new boolean[8];
  door = new int[2];
  stuff = loadStrings("Resources/doors.dat"); 
  doors = int(split(stuff[0], ','));
  stuff = loadStrings("Resources/rooms.dat"); 
  rooms = int(split(stuff[0], ','));
  for (int i = 0; i < 8; i++ ) {
    keys[i] = false; //clears the key buffer
  }
}

void draw() {
  image(background, 0, 0);
  player.collision();
  if (player.door[0] != -1) {
    player.doors();
  }
  player.movement();
}

void keyPressed() { //checks key press events and sets keys to true
  keys[0] = (key == 'A' || key == 'a') ? true : keys[0]; //checks the A key
  keys[1] = (key == 'D' || key == 'd') ? true : keys[1]; //checks the D key
  keys[2] = (key == 'W' || key == 'w') ? true : keys[2]; //checks the W key
  keys[3] = (key == 'S' || key == 's') ? true : keys[3]; //checks the S key
  keys[4] = (key == 'E' || key == 'e') ? true : keys[4]; //checks the E key
}
void keyReleased() { //checks key release events and sets keys to false
  keys[0] = (key == 'A' || key == 'a') ? false : keys[0]; //checks the A key
  keys[1] = (key == 'D' || key == 'd') ? false : keys[1]; //checks the D key
  keys[2] = (key == 'W' || key == 'w') ? false : keys[2]; //checks the W key
  keys[3] = (key == 'S' || key == 's') ? false : keys[3]; //checks the S key
  keys[4] = (key == 'E' || key == 'e') ? false : keys[4]; //checks the E key
}
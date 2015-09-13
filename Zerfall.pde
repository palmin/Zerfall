import processing.video.*;
import processing.sound.*;
PImage bitmap, map, background, open, zombie;
boolean[] keys;
String[] stuff;
int[] doors, rooms, door;
SoundFile gunShot[], gunReload[];

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

  gunShot = new SoundFile[18];
  gunReload= new SoundFile[18];
  player = new playerClass();
  keys = new boolean[8];
  door = new int[2];
  stuff = loadStrings("Resources/doors.dat"); 
  doors = int(split(stuff[0], ','));
  stuff = loadStrings("Resources/rooms.dat"); 
  rooms = int(split(stuff[0], ','));

  gunShot[0] = new SoundFile(this, "Sounds/1.ogg"); //AK-47 Gunshot
  gunReload[0] = new SoundFile(this, "Sounds/1-reload.ogg"); //AK-47 Reload
  gunShot[1] = new SoundFile(this, "Sounds/2.ogg"); //AUG Gunshot
  gunReload[1] = new SoundFile(this, "Sounds/2-reload.ogg"); //AUG Reload
  gunShot[2] = new SoundFile(this, "Sounds/3.ogg"); //M9 Gunshot
  gunShot[3] = new SoundFile(this, "Sounds/4.ogg"); 
  gunReload[3] = new SoundFile(this, "Sounds/4-reload.ogg");
  gunShot[4] = new SoundFile(this, "Sounds/5.ogg");
  gunShot[5] = new SoundFile(this, "Sounds/6.ogg");
  gunReload[5] = new SoundFile(this, "Sounds/6-reload.ogg");
  gunShot[6] = new SoundFile(this, "Sounds/7.ogg"); 
  gunReload[6] = new SoundFile(this, "Sounds/7-reload.ogg");
  gunShot[8] = new SoundFile(this, "Sounds/9.ogg");
  gunReload[8] = new SoundFile(this, "Sounds/9-reload.ogg");
  gunShot[9] = new SoundFile(this, "Sounds/10.ogg"); 
  gunReload[9] = new SoundFile(this, "Sounds/10-reload.ogg");
  gunShot[11] = new SoundFile(this, "Sounds/12.ogg"); 
  gunReload[11] = new SoundFile(this, "Sounds/12-reload.ogg");
  gunShot[12] = new SoundFile(this, "Sounds/13.ogg"); 
  gunReload[12] = new SoundFile(this, "Sounds/13-reload.ogg");
  gunShot[13] = new SoundFile(this, "Sounds/14.ogg"); 
  gunReload[13] = new SoundFile(this, "Sounds/14-reload.ogg");
  gunShot[14] = new SoundFile(this, "Sounds/15.ogg"); 
  gunReload[14] = new SoundFile(this, "Sounds/15-reload.ogg");
  gunShot[16] = new SoundFile(this, "Sounds/17.ogg"); 
  gunReload[16] = new SoundFile(this, "Sounds/17-reload.ogg");

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
  keys[5] = (key == 'R' || key == 'r') ? true : keys[5]; //checks the R key
}
void keyReleased() { //checks key release events and sets keys to false
  keys[0] = (key == 'A' || key == 'a') ? false : keys[0]; //checks the A key
  keys[1] = (key == 'D' || key == 'd') ? false : keys[1]; //checks the D key
  keys[2] = (key == 'W' || key == 'w') ? false : keys[2]; //checks the W key
  keys[3] = (key == 'S' || key == 's') ? false : keys[3]; //checks the S key
  keys[4] = (key == 'E' || key == 'e') ? false : keys[4]; //checks the E key
  keys[5] = (key == 'R' || key == 'r') ? false : keys[5]; //checks the R key
}
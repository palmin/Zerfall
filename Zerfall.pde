import pathfinder.*;
import processing.sound.*;
PImage bitmap, map, background, foreground, loading;
boolean keys[], r[], gunFlare;
String stuff[];
int doors[], rooms[], door[], time, start;
float duration;
SoundFile gunshot[], reload[];

playerClass player;
zombieClass[] zombieList;

void setup() {
  noCursor();
  fullScreen(P3D);
  colorMode(RGB, 255);
  smooth(2);
  loading = loadImage("Images/loading.png");
  image(loading, 0, 0);
  r = new boolean[100];
  frameRate(60);
  bitmap = loadImage("Maps/bitmap.png");
  background = loadImage("Maps/map.png");
  foreground = loadImage("Maps/foreground.png");

  gunshot = new SoundFile[18];
  reload = new SoundFile[18];
  player = new playerClass();
  zombieList = new zombieClass[8];
  keys = new boolean[8];
  door = new int[2];
  stuff = loadStrings("Resources/doors.dat");
  doors = int(split(stuff[0], ','));
  stuff = loadStrings("Resources/rooms.dat");
  rooms = int(split(stuff[0], ','));
  for (int i = 0; i < 18; i++) {
    gunshot[i] = new SoundFile(this, "Sounds/Dry-Fire.ogg");        
    reload[i] = new SoundFile(this, "Sounds/Dry-Fire.ogg");
    gunshot[i] = new SoundFile(this, "Sounds/Guns/" + player.gunID[i] + " Gunshot.ogg");
    reload[i] = new SoundFile(this, "Sounds/Guns/" + player.gunID[i] + " Reload.ogg");
  }
  for (int i = 0; i < 8; i++ ) {
    keys[i] = false; //clears the key buffer
  }
  int index = 0;
  for (int i = 0; i < 8; i++) {
    zombieList[index++] = new zombieClass(int(random(1, 4)));
  }
}
void draw() {
  lighting();
  image(background, 0, 0);
  player.movement();
  if (player.door[0] != -1) {
    player.doors();
  }
  player.weapon();
  for (zombieClass zombie : zombieList) {
    zombie.movement();
  }
}

void keyPressed() { //checks key press events
  keys[0] = (key == 'A' || key == 'a') ? true : keys[0];       //checks the A key
  keys[1] = (key == 'D' || key == 'd') ? true : keys[1];       //checks the D key
  keys[2] = (key == 'W' || key == 'w') ? true : keys[2];       //checks the W key
  keys[3] = (key == 'S' || key == 's') ? true : keys[3];       //checks the S key
  keys[4] = (key == 'E' || key == 'e') ? true : keys[4];       //checks the E key
  keys[5] = (key == 'R' || key == 'r') ? true : keys[5];       //checks the R key
  keys[6] = (key == ' ') ? true : keys[6];                     //checks the spacebar
  keys[7] = (key == RETURN || key == ENTER) ? true : keys[7];  //checks the enter key
}
void keyReleased() { //checks key release events
  keys[0] = (key == 'A' || key == 'a') ? false : keys[0];      //checks the A key
  keys[1] = (key == 'D' || key == 'd') ? false : keys[1];      //checks the D key
  keys[2] = (key == 'W' || key == 'w') ? false : keys[2];      //checks the W key
  keys[3] = (key == 'S' || key == 's') ? false : keys[3];      //checks the S key
  keys[4] = (key == 'E' || key == 'e') ? false : keys[4];      //checks the E key
  keys[5] = (key == 'R' || key == 'r') ? false : keys[5];      //checks the R key
  keys[6] = (key == ' ') ? false : keys[6];                    //checks the spacebar
  keys[7] = (key == RETURN || key == ENTER) ? false : keys[7]; //checks the enter key
}

void roundEnd() {
}
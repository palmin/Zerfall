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
class playerClass {
  PImage sheet;
  int sprite, xpos, ypos, yspeed, doorx, doory, l;
  boolean[] collision;
  color c = color(0, 0, 0);
  playerClass() {
    sheet = loadImage("player-sheet.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    doorx = -1;
    doory = -1;
    yspeed = 1;
    collision = new boolean[5];
  }
  void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    doorx = doory = -1;
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1];
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1];
      }
    }
    if (keys[0] == true) {
      for (int x = xpos + 20; x <= xpos + 25; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3];
          if (c == color(255, 0, 0) && keys[4] == true) {
            doorx = x;
            doory = y;
          }
        }
      }
    }
    if (keys[1] == true) {
      for (int x = xpos + 150; x <= xpos + 155; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4];
          if (c == color(255, 0, 0) && keys[4] == true) {
            doorx = x;
            doory = y;
          }
        }
      }
    }
  }
  void doors() {
    for (int i = 0; i <=20; i += 4) {
      if (doorx >= doors[i] && doorx <= doors[i + 2] && doory >= doors[i + 1] && doory <= doors[i + 3]) {
        l = i;
        break;
      }
    }
    for (int x = doors[l]; x <= doors[l + 2]; x ++) {
      for (int y = doors[l + 1]; y <= doors[l + 3]; y++) {
        bitmap.set(x, y, color(255));
      }
    }
  }
  void display() {
    image(bitmap.get(xpos, ypos, 175, 161), xpos, ypos);
    if (keys[0] == true && collision[3] == false) {
      xpos -= 5;
      sprite = (collision[1] == true) ? 0 : sprite;
    }
    if (keys[1] == true && collision[4] == false) {
      xpos += 5;
      sprite = (collision[1] == true) ? 2 : sprite;
    }
    if (keys[2] == true && collision[1] == true) {
      yspeed = -10;
      collision[1] = false;
      sprite += (sprite % 2 == 0) ? 1 : 0;
    }
    if (collision[1] == false) {
      ypos += yspeed;
      yspeed ++;
    }
    if (collision[0] == true && keys[2] == true) {
      yspeed = -4;
      ypos -= 7;
    }
    yspeed = (collision[1] == true) ? 1 : yspeed;
    image(sheet.get(sprite * 175, 0, 175, 161), xpos, ypos);
  }
}
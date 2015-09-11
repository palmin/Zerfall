import processing.sound.*;
PImage bitmap, background, start, open, zombie;
boolean[] keys;
String[] stuff;
int[] doors;
SoundFile gunSounds[];
playerClass player;

void setup() {
  fullScreen();
  background(0);
  frameRate(60);

  bitmap = loadImage("bunker-bitmap.png");
  background = loadImage("bunker-map.png");
  map = loadImage("bunker-startmap.png");
  open = loadImage("bunker-openmap.png");
  zombie = loadImage("zombie-temp.png");

  image(background, 0, 0, width, height);

  gunSounds = new SoundFile[18];
  player = new playerClass();
  keys = new boolean[8];
  stuff = loadStrings("Resources/bunker-rooms.dat");
  doors = int(split(stuff[0], ','));
  for (int i = 0; i < 8; i++ ) {
    keys[i] = false;
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
  if (key == 'A' || key == 'a') {
    keys[0] = true; //checks the A key, which controls movement to the left
  }
  if (key == 'D' || key == 'd') {
    keys[1] = true; //checks the D key, which controls movement to the right
  }
  if (key == 'W' || key == 'w') {
    keys[2] = true; //checks the W key, which controls climbing and jumping
  }
  if (key == 'S' || key == 's') {
    keys[3] = true; //checks the S key, an arbitrary check at the moment
  }
  if (key == 'E' || key == 'e') {
    keys[4] = true; //checks the E key, which controls interaction with environment
  }
}

void keyReleased() {
  if (key == 'A' || key == 'a') {
    keys[0] = false;
  }
  if (key == 'D' || key == 'd') {
    keys[1] = false;
  }
  if (key == 'W' || key == 'w') {
    keys[2] = false;
  }
  if (key == 'E' || key == 'e') {
    keys[4] = false;
  }
}
class playerClass {
  PImage sheet;
  int sprite;
  int xpos;
  int ypos;
  int yspeed;
  int doorx;
  int doory;
  int l;
  boolean[] collision;
  color c = color(0, 0, 0);

  playerClass() {
    sheet = loadImage("player-sheet.png");
    xpos = int(1136);
    ypos = int(470);
    println(xpos);
    println(ypos);
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
    for (int x = xpos + 25; x <= xpos + 145; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        if (c == color(255, 0, 0) || c == color(0, 0, 0)) {
          collision[1] = true;
          if (c == color(0, 0, 255)) {
            collision[0] = true;
          }
        }
      }
    }
    for (int x = xpos + 25; x <= xpos + 145; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y++) {
        c = bitmap.get(x, y);
        if (c == color(255, 0, 0) || c == color(0, 0, 0)) {
          collision[1] = true;
        }
      }
    }
    for (int x = xpos + 20; x <= xpos + 25; x++) {
      for (int y = ypos; y<= ypos + 161; y++) {   
        color c = bitmap.get(x, y); 
        if (c == color(255, 0, 0) || c == color(0, 0, 0)) {
          collision[3] = true;
        }
        if (c == color(255, 0, 0) && keys[4] == true) {
          doorx = x;
          doory = y;
        }
      }
    }

    for (int x = xpos + 145; x <= xpos + 150; x++) {
      for (int y = ypos; y<= ypos + 161; y++) {   
        color c = bitmap.get(x, y); 
        if (c == color(255, 0, 0) || c == color(0, 0, 0)) {
          collision[4] = true;
        }
        if (c == color(255, 0, 0) && keys[4] == true) {
          doorx = x;
          doory = y;
        }
      }
    }


    //println(collision);
  }

  void doors() {
    for (int i = 0; i <=20; i += 4) {
      if (doorx >= doors[i] && doorx <= doors[i + 3] && doory >= doors[i + 2] && doory <= doors[i + 4]) {
        l = i;
        break;
      }
    }
    image(open.get(doors[2 * l] - 2, doors[2 * l + 1], 7, doors[2 * l + 3] - doors[2 * l + 1]), doors[2 * l] - 2, doors[2 * l + 1]);
    for (int x = doors[1]; x <= doors[l + 2]; x ++) {
      for (int y = doors[l + 1]; y <= doors[l + 3]; y++) {
        bitmap.set(x, y, color(255));
      }
    }
  }

  void display() {
    image(background.get(xpos, ypos, 175, 161), xpos, ypos);

    if (keys[0] == true && collision[3] == false) {
      xpos -= 5;
      if (collision[1] == true) {
        sprite = 0;
      }
    }

    if (keys[1] == true && collision[4] == false) {
      xpos += 5;
      if (collision[1] == true) {
        sprite = 2;
      }
    }

    if (keys[2] == true && collision[1] == true) {
      yspeed = -10;
      collision[1] = false;
      if (sprite % 2 == 0) {
        sprite += 1;
      }
    }

    if (collision[1] == false) {
      ypos += yspeed;
      yspeed ++;
    }
    if (collision[0] == true) {
      yspeed = -4;
      ypos -= 7;
    } else if (collision[1] == true && collision[0] == false) {
      yspeed = 1;
    }


    image(sheet.get(sprite * 175, 0, 175, 161), xpos, ypos);
  }
}

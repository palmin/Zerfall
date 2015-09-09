import processing.sound.*;
PImage bitmap, background, start, open, zombie;
boolean[] keys;
SoundFile gunSounds[];
playerClass player;
int[] doors;

void setup() {
  fullScreen();
  background(0);
  frameRate(60);

  bitmap = loadImage("bunker-bitmap.png");
  background = loadImage("bunker-map.png");
  start = loadImage("bunker-startmap.png");
  open = loadImage("bunker-openmap.png");
  zombie = loadImage("zombie-temp.png");

  image(background, 0, 0);

  gunSounds = new SoundFile[18];
  player = new playerClass();
  keys = new boolean[8];
  doors[] stuff = loadStrings("Resources/bunker-rooms.dat");
  doors = int(split(stuff[0],','));

  for ( int i = 0; i < 8; i++ ) {
    keys[i] = false;
  }
}

void draw() {
  player.collision();
  player.display();
}



void keyPressed() {
  if (key == 'A' || key == 'a') {
    keys[0] = true;
  }
  if (key == 'D' || key == 'd') {
    keys[1] = true;
  }
  if (key == 'W' || key == 'w') {
    keys[2] = true;
  }
  if (key == 'E' || key == 'e') {
    keys[4] = true;
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
  boolean[] collision;
  color c = color(0, 0, 0);

  playerClass() {
    sheet = loadImage("player-sheet.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    yspeed = 1;
    collision = new boolean[5];
  }

  void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
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


    println(collision);
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

void doors() {
  for (i = 0; i <=20; i += 4) {
    if (doorx >= doors(i) AND doorx <= doors(i + 3) AND doory >= doors(i + 2) AND doory <= doors(i + 4)) {
        l = i;
        break;
    }
  }
  image(open.get(doors(l) - 2, doors(l + 1), 7, doors(l + 3) - doors(l + 1)), doors(l) - 2, doors(l + 1))
}


    image(sheet.get(sprite * 175, 0, 175, 161), xpos, ypos);
  }
}

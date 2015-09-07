
PImage bitmap, background, start, open, zombie;
boolean[] keys;

playerClass player;

void setup() {
  fullScreen();
  background(0);
  frameRate(60);

  bitmap = loadImage("bunker-bitmap.png");
  background = loadImage("bunker-map.png");
  start = loadImage("bunker-startmap.png");
  open = loadImage("bunker-openmap.png");

  image(background, 0, 0);

  player = new playerClass();
  keys = new boolean[8];
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
}

class playerClass {
  PImage sheet;
  int sprite;
  int xpos;
  int ypos;
  int yspeed;
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
    for (int x = xpos; x <= xpos + 175; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        if (c == color(255, 0, 0) || c == color(0, 0, 0)) {
          collision[0] = true;
        }
      }
    }
    println(collision);
  }


  void display() {
    image(background.get(xpos, ypos, 175, 161), xpos, ypos);
    
    if (keys[0] == true && collision[2] == false) {
      xpos -= 5;
      if (collision[0] == true) {
        sprite = 0;
      }
    }
    
    if (keys[1] == true && collision[3] == false) {
      xpos += 5;
      if (collision[0] == true) {
        sprite = 2;
      }
    }
    
    if (keys[2] == true && collision[0] == true) {
      yspeed = -10;
      collision[0] = false;
      if (sprite % 2 == 0) {
        sprite += 1;
      }
    }
    
    if (collision[0] == false) {
      ypos += yspeed;
      yspeed ++;
    } else {
      yspeed = 1;
    }
    
    image(sheet.get(sprite * 175, 0, 175, 161), xpos, ypos);
  }
}
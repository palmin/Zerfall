class player {
  PImage temp, sheet[];
  String gunID[] = { "AK47", "AUG", "Dragunov", "FAL", "FAMAS", "G3", "L2A3", "M1911", "M1918", 
    "M1928", "M60", "M9", "MP40", "PPK", "RPK", "Stoner63", "Uzi" };
  int sprite, xpos, ypos, yspeed, weapon, gunClip, 
    gunRPM[] = { 6, 5, 120, 48, 3, 6, 600, 144, 6, 5, 6, 90, 7, 240, 6, 4, 6 }, 
    clipSize[] = { 30, 30, 10, 30, 25, 20, 5, 7, 20, 50, 100, 10, 32, 8, 75, 150, 32 }, 
    boltPosition = 0;
  boolean collision[] = new boolean[5];
  SoundFile gunAudio[][] = new SoundFile[2][18], dryfire;
  timer swap, reload;
  player() {
    for (int i = 0; i < gunID.length; i++) {
      gunAudio[0][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + gunID[i] + " Gunshot.ogg");
      gunAudio[1][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + gunID[i] + " Reload.ogg");
    }
    temp = loadImage("Sprites/player.png");
    sheet = new PImage[8];
    for (int i = 0; i < 8; i++) {
      sheet[i] = temp.get(i * 175, 0, 175, 161);
    }
    temp = new PImage();
    xpos = 2272;
    ypos = 940;
    sprite = 0;
    yspeed = 1;
    weapon = 0;
    gunClip = 30;
    swap = new timer(1);
    reload = new timer(1);
    dryfire = new SoundFile(Zerfall.this, "Sounds/Dry-Fire.ogg");
  }
  void movement() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        color c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1]; //This checks the lower bound
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y--) {
        color c = bitmap.get(x, y);
        collision[2] = (c == color(0, 0, 0)) ? true : collision[2]; //This checks the upper bound
      }
    }
    if (keys[65] == true || keys[69] == true) {
      for (int x = xpos + 20; x <= xpos + 25; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y);
          if (collision[3] == true) {
            collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
            xpos += (collision[3] == false) ? x - (xpos + 20) : 0;
          }
          if (c == color(255, 0, 0) && keys[69] == true)
            doors(x, y);
        }
      }
    }
    if (keys[68] == true || keys[69] == true) {
      for (int x = xpos + 150; x <= xpos + 155; x++) { 
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
          if (c == color(255, 0, 0) && keys[69] == true)
            doors(x, y);
        }
      }
    }

    if (keys[65] == true && collision[3] == false) {
      xpos -= 5;
      sprite = (collision[1] == true && keys[' '] == false) ? 0 : sprite;
    }

    xpos += (keys[68] == true && collision[4] == false) ? 5 : 0;
    sprite = (collision[1] == true && keys[' '] == false && keys[68] == true && collision[4] == false) ? 2 : sprite;
    if (keys[87] == true && collision[2] == false) {
      if (collision[1] == true) {
        yspeed = -10;
        collision[1] = false;
        sprite += (sprite % 2 == 0) ? 1 : 0;
      }
      if (collision[0] == true) {
        yspeed = -4;
        collision[1] = false;
      }
    }
    yspeed = (collision[1] == true || collision[2] == true) ? 1 : yspeed + 1;
    ypos += (collision[1] == false) ? yspeed : 0;
    if (sprite > 3 && boltPosition != 2) {
      sprite -= 4;
    } else if (keys[32] == true && gunClip > 0 && sprite <= 3) {
      sprite += 4;
    }
  }
  void doors(int xpos, int ypos) {
    for (int i = 0; i < doors[0].length; i++) {
      if (xpos >= doors[0][i] && xpos <= doors[2][i] + 2 && ypos >= doors[1][i] && ypos <= doors[3][i]) {
        for (int x = doors[0][i]; x <= doors[2][i]; x++) { 
          for (int y = doors[1][i]; y < doors[3][i]; y++) {
            bitmap.set(x, y, color(255));
          }
        }
        break;
      }
    }
  }
  void weapon() {
    if (reload.active == true) {
      reload.check();
      if (reload.active == false)
        gunClip = clipSize[weapon];
    }
    if (swap.active == true) {
      swap.check();
    }

    if (keys[70] == true && swap.active == false) {
      weapon = (weapon < 17) ? weapon + 1 : 0;
      gunClip = clipSize[weapon];
      swap = new timer(.2);
    }
    if (keys[32] == true && reload.active == false) { //If the spacebar is pressed
      if (boltPosition == 1 && gunClip > 0) { 
        gunAudio[0][weapon].play(); //Plays the weapon gunshot sound
        gunClip = gunClip - 1;
      } else if (boltPosition == 1 && gunClip == 0 ) {
        dryfire.play();
      }
    }
    if (keys[32] == true && boltPosition <= gunRPM[weapon]) {
      boltPosition += 1;
    } else {
      boltPosition = 1;
    }
    if (keys[82] == true && reload.active == false) { //If the R key is pressed
      reload = new timer(gunAudio[1][weapon].duration());
      gunAudio[1][weapon].play();
    }
  }
}
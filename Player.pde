class player {
  PImage sheet;
  String gunID[] = { "AK47", "AUG", "Dragunov", "FAL", "FAMAS", "G3", "L2A3", "M1911", "M1918", 
    "M1928", "MP40", "M60", "M9", "P08", "PPK", "RPK", "Stoner63", "Uzi" };
  int sprite, xpos, ypos, yspeed, currentWeapon, gunClip, 
    gunRPM[] = { 6, 5, 120, 48, 3, 6, 144, 6, 5, 600, 6, 90, 7, 180, 240, 6, 4, 6 }, 
    clipSize[] = { 30, 30, 10, 30, 25, 20, 5, 7, 20, 30, 100, 10, 32, 8, 8, 75, 150, 32 }, 
    boltPosition;
  boolean collision[] = new boolean[5];
  SoundFile gunAudio[][] = new SoundFile[2][18], dryfire;
  timer swap, reload;
  player() {
    sheet = loadImage("Sprites/player.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    yspeed = 1;
    currentWeapon = 0;
    gunClip = 30;
    boltPosition = 1;
    swap = new timer(1);
    reload = new timer(gunAudio[1][currentWeapon].duration());
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
          collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
          if (c == color(255, 0, 0) && keys[69] == true) {
            doors(x, y);
          }
        }
      }
    }
    if (keys[68] == true || keys[69] == true) {
      for (int x = xpos + 150; x <= xpos + 155; x++) { 
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
          if (c == color(255, 0, 0) && keys[69] == true) {
            doors(x, y);
          }
        }
      }
    }
    if (keys[65] == true && collision[3] == false) {
      xpos -= 5;
      sprite = (collision[1] == true && keys[' '] == false) ? 0 : sprite;
    }
    if (keys[68] == true && collision[4] == false) {
      xpos += 5;
      sprite = (collision[1] == true && keys[' '] == false) ? 2 : sprite;
    }
    if (keys[87] == true && collision[1] == true && collision[2] == false) {
      yspeed = -10;
      collision[1] = false;
      sprite += (sprite % 2 == 0) ? 1 : 0;
    }
    if (keys[87] == true && collision[0] == true && collision[2] == false) {
      yspeed = -4;
      collision[1] = false;
    }
    if (collision[2] == true) {
      yspeed = 1;
    }
    yspeed = (collision[1] == true || collision[2] == true) ? 1 : yspeed + 1;
    if (collision[1] == false) {
      ypos += yspeed;
    }
    if (sprite > 3 && boltPosition != 2) {
      sprite -= 4;
    } else if (boltPosition == 2 && sprite < 4 && keys[32] == true && gunClip > 0) {
      sprite += 4;
    }
  }
  void doors(int xpos, int ypos) {
    for (int i = 0; i <= 20; i += 4) {
      if (xpos >= doors[i] - 2 && xpos <= doors[i + 2] + 2 && ypos >= doors[i + 1] + 2 && ypos <= doors[i + 3] - 2) {
        for (int x = doors[i] - 2; x <= doors[i + 2] + 2; x++) { 
          for (int y = doors[i + 1] + 2; y < doors[i + 3] - 2; y++) {
            bitmap.set(x, y, color(255));
          }
        }
        break;
      }
    }
  }
  void weapon() {
    if (keys[13] == true && swap.active == false) { //If the enter key is pressed
      currentWeapon = (currentWeapon < 17) ? currentWeapon + 1 : 0;
      gunClip = clipSize[currentWeapon];
      swap = new timer(1);
    }
    if (keys[32] == true && reload.active == false) { //If the spacebar is pressed
      if (gunAudio[0][currentWeapon] != null && boltPosition == 1 && gunClip > 0) { 
        gunAudio[0][currentWeapon].play(); //Plays the weapon sound
        gunClip = gunClip - 1;
        pushMatrix();
        int xpos = player.xpos + 75;
        int ypos = player.ypos + 75;
        int step = (player.sprite == 0 || player.sprite == 1) ? -1 : 1;
        int max = (step == -1) ? 0 : width;
        boolean condition = false;
        for (int x = xpos; x != max; x += step) {
          color c = bitmap.get(x, ypos);
          if (condition == false) {
            for (zombieClass zombie : zombies) {
              if (x > zombie.xpos && x < zombie.xpos + 100 && ypos > zombie.ypos && ypos < zombie.ypos + 162) {
                zombie.health -= 10;
                if (zombie.health <= 0) {
                  zombie = new zombieClass(int(random(1,3)));
                }
                condition = true;
                break;
              }
            }
          }
          if (c == (color(255, 0, 0) | color(0))) {
            break;
          }
        }
      } else if (boltPosition == 1 && gunClip == 0 ) {
        dryfire.play();
      }
      boltPosition = (boltPosition < gunRPM[currentWeapon]) ? (boltPosition + 1) : 1;
    }
    if (keys[82] == true && reload.active == false) { //If the R key is pressed
      reload = new timer(gunAudio[1][currentWeapon].duration());
      gunAudio[1][currentWeapon].play();
    }
    if (reload.active == true) {
      reload.check();
      gunClip = (reload.active == false) ? clipSize[currentWeapon] : gunClip;
    }
    if (swap.active == true) {
      swap.check();
    }
  }
}

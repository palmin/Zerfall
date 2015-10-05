class Player {
  PImage sheet;
  String gunID[], gunInfo[];
  int sprite, xpos, ypos, yspeed, 
    l, t, doorx, doory, currentWeapon, gunClip,
    gunRPM[], clipSize[], boltPosition;
  boolean collision[];
  SoundFile gunAudio[][], dryfire;
  Player() {
    sheet = loadImage("Sprites/player.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    yspeed = 1;
    currentWeapon = 0;
    collision = new boolean[5];
    orbitron = createFont("Fonts/Orbitron.ttf", 72, true);

    gunClip = 30;
    boltPosition = 1;
    gunAudio = new SoundFile[2][18];
    stuff = loadStrings("Resources/gunID.dat");
    gunID = split(stuff[0], ',');
    stuff = loadStrings("Resources/gunRPM.dat");
    gunRPM = int(split(stuff[0], ','));
    dryfire = new SoundFile(Zerfall.this, "Sounds/Dry-Fire.ogg");
    for (int i = 0; i < 18; i++) {
      gunRPM[i] = (gunRPM[i] != 0) ? 60 * 60 / gunRPM[i] : 1;
      println(gunRPM[i]);
    }
    stuff = loadStrings("Resources/gunClip.dat");
    clipSize = int(split(stuff[0], ','));
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
    if (keys[0] == true || keys[4] == true) {
      for (int x = xpos + 20; x <= xpos + 25; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
          if (c == color(255, 0, 0) && keys[4] == true) {
            doors(x,y);
          }
        }
      }
    }
    if (keys[1] == true || keys[4] == true) {
      for (int x = xpos + 150; x <= xpos + 155; x++) { 
        for (int y = ypos; y<= ypos + 161; y++) {   
          color c = bitmap.get(x, y); 
          collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
          if (c == color(255, 0, 0) && keys[4] == true) {
            doors(x,y);
          }
        }
      }
    }
    if (keys[0] == true && collision[3] == false) {
      xpos -= 5;
      sprite = (collision[1] == true) ? 0 : sprite;
    }
    if (keys[1] == true && collision[4] == false) {
      xpos += 5;
      sprite = (collision[1] == true) ? 2 : sprite;
    }
    if (keys[2] == true && collision[1] == true && collision[2] == false) {
      yspeed = -10;
      collision[1] = false;
      sprite += (sprite % 2 == 0) ? 1 : 0;
    }
    if (keys[2] == true && collision[0] == true && collision[2] == false) {
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
    } else if (boltPosition == 2 && sprite < 4 && keys[6] == true && gunClip > 0) {
      sprite += 4;
    }
  }
  void doors(int xpos, int ypos) {
    doorx = xpos;
    doory = ypos;
    l = -1;
    for (int i = 0; i <= 20; i += 4) {
      if (xpos >= doors[i] && xpos <= doors[i + 2] && ypos >= doors[i + 1] && ypos <= doors[i + 3]) {
        l = i;
        break;
      }
    }
    for (int x = doors[l]; x <= doors[l + 2]; x++) { 
      for (int y = doors[l + 1]; y < doors[l + 3]; y++) {
        bitmap.set(x, y, color(255));
      }
    }
  }
  void weapon() {
    if (keys[7] == true && timer[2] == false) { //If the enter key is pressed
      currentWeapon = (currentWeapon < 17) ? currentWeapon + 1 : 0;
      gunClip = clipSize[currentWeapon];
      timerInit(1, 2);
    }
    if (keys[6] == true && timer[1] == false) { //If the spacebar is pressed
      if (gunAudio[0][currentWeapon] != null && boltPosition == 1 && gunClip > 0) { 
        gunAudio[0][currentWeapon].play(); //Plays the weapon sound
        gunClip = gunClip - 1;
        gunFlare = true;
      } else if (boltPosition == 1 && gunClip == 0 ) {
        dryfire.play();
      }
      boltPosition = (boltPosition < gunRPM[currentWeapon]) ? (boltPosition + 1) : 1;
    }
    if (keys[5] == true && timer[1] == false) { //If the R key is pressed
        timerInit(gunAudio[1][currentWeapon].duration(), 1);
        gunAudio[1][currentWeapon].play();
    }
    if (timer[1] == true) {
      timer(1);
      gunClip = (timer[1] == false) ? clipSize[currentWeapon] : gunClip;
    }
    if (timer[2] == true) {
      timer(2);
    }
  }
}
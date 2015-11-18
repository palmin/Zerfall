static class player {
  PImage 
    sheet[] = new PImage[8];
  String
    gunID[] = { "AK47", "AUG", "Dragunov", "FAL", "FAMAS", "G3", "L2A3", "M1911", "M1918", "M1928", "M60", "M9", "MP40", "PPK", "RPK", "Stoner63", "Uzi" };
  int
    sprite = 0, 
    xpos = 2270, 
    ypos = 940, 
    yspeed = 1, 
    weapon = 0, 
    gunClip = 30, 
    gunRPM[] = { 6, 5, 120, 48, 3, 6, 600, 144, 6, 5, 6, 90, 7, 240, 6, 4, 6 }, 
    clipSize[] = { 30, 30, 10, 30, 25, 20, 5, 7, 20, 50, 100, 10, 32, 8, 75, 150, 32 }, 
    boltPosition = 0;
  boolean
    collision[] = new boolean[5];
  SoundFile
    gunAudio[][] = new SoundFile[2][18], 
    dryfire = new SoundFile();
  timer 
    swap = new timer(), 
    reload = new timer();
  player() {
    for (int i = 0; i < gunID.length; i++) {
      gunAudio[0][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + gunID[i] + " Gunshot.ogg");
      gunAudio[1][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + gunID[i] + " Reload.ogg");
    }
    PImage temp = loadImage("Sprites/player.png");
    for (int i = 0; i < 8; i++)
      sheet[i] = temp.get(i * 175, 0, 175, 161);
    temp = new PImage();
    dryfire = new SoundFile(Zerfall.this, "Sounds/Dry-Fire.ogg");
  }
  void movement() {
    for (int i = 0; i < 5; i++)
      collision[i] = false;
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        color c = bitmap.get(x, y);
        if (c == color(255, 0, 0) || c == color(0)) {
          collision[1] = true; //Lower bound
          continue;
        }
        if (c == color(0, 0, 255)) {
          collision[0] = true;
          continue;
        }
      }
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y--) {
        color c = bitmap.get(x, y);
        if (c == color(0))
          collision[2] = true; //Upper bound
      }
    }
    for (int x = xpos + 20; x <= xpos + 25; x++) {
      for (int y = ypos; y<= ypos + 161; y++) {   
        color c = bitmap.get(x, y);
        if (c == color(255, 0, 0) || c == color(0))
          collision[3] = true; //Left bound
        if (c == color(255, 0, 0) && keys[69] == true)
          println(c);
        doors(x, y);
      }
    }
    if (keys[68] == true && collision[4] == false)
      xpos += 5;
    if (keys[68] == true && collision[1] == true && keys[' '] == false) 
      sprite = 2;
    for (int x = xpos + 150; x <= xpos + 155; x++) { 
      for (int y = ypos; y<= ypos + 161; y++) {   
        color c = bitmap.get(x, y); 
        if (collision[4] == false && (c == color(255, 0, 0) || c == color(0)))
          collision[4] = true; //Right bound
        if (c == color(255, 0, 0) && keys[69] == true)
          doors(x, y);
      }
    }
    if (keys[65] == true && collision[3] == false)
      xpos -= 5;
    if (keys[65] == true && collision[1] == true && keys[' '] == false) 
      sprite = 0;
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
  void doors(int x, int y) {
    color doorColor = color(255, 0, 0);
    while (bitmap.get(x - 1, y) == doorColor)
      x--;
    while (bitmap.get(x, y - 1) == doorColor)
      y--;
    while (bitmap.get(x, y + 1) == doorColor) {
      while (bitmap.get(x + 1, y) == doorColor) {
        bitmap.set(x, y, color(255));
        x++;
      }
      y++;
    }
  }
  void weapon() {
    if (reload.active == true) {
      reload.check();
      if (reload.active == false)
        gunClip = clipSize[weapon];
    }
    if (swap.active == true)
      swap.check();

    if (keys[70] == true && swap.active == false) {
      weapon = (weapon < 17) ? weapon + 1 : 0;
      gunClip = clipSize[weapon];
      swap.activate();
      reload.set(gunAudio[1][weapon].duration());
    }
    if (keys[32] == true && reload.active == false) { //If the spacebar is pressed
      if (boltPosition == 1 && gunClip > 0) { 
        gunAudio[0][weapon].play(); //Plays the weapon gunshot sound
        gunClip--;
      } else if (boltPosition == 1 && gunClip == 0) {
        dryfire.play();
      }
    }
    boltPosition = (keys[32] == true && boltPosition <= gunRPM[weapon]) ? boltPosition + 1 : 1;
    if (keys[82] == true && reload.active == false) { //If the R key is pressed
      reload.activate();
      gunAudio[1][weapon].play();
    }
  }
}

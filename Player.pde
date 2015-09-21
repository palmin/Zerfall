class playerClass {
  PImage sheet;
  PFont orbitron;
  int sprite, xpos, ypos, yspeed, door[], i, l, t, currentWeapon, gunClip;
  boolean[] collision;
  float len;
  color c = color(0);
  playerClass() {
    sheet = loadImage("Sprites/player.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    yspeed = 1;
    currentWeapon = 0;
    collision = new boolean[5];
    door = new int[2];
    orbitron = createFont("Fonts/Orbitron.ttf", 72, true);
    gunClip = 30;
  }
  void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    door[0] = door[1] = -1;
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 161; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1]; //This checks the lower bound
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y--) {
        c = bitmap.get(x, y);
        collision[2] = (c == color(0, 0, 0)) ? true : collision[2]; //This checks the upper bound
      }
    }
    if (keys[0] == true || keys[4] == true) {
      for (int x = xpos + 20; x <= xpos + 25; x++) {
        for (int y = ypos; y<= ypos + 161; y++) {   
          c = bitmap.get(x, y); 
          collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
          if (c == color(255, 0, 0) && keys[4] == true) {
            door[0] = x;
            door[1] = y;
          }
        }
      }
    }
    if (keys[1] == true || keys[4] == true) {
      for (int x = xpos + 150; x <= xpos + 155; x++) { 
        for (int y = ypos; y<= ypos + 161; y++) {   
          c = bitmap.get(x, y); 
          collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
          if (c == color(255, 0, 0) && keys[4] == true) {
            door[0] = x;
            door[1] = y;
          }
        }
      }
    }
  }
  void doors() {
    l = -1;
    for (i = 0; i <= 20; i += 4) {
      if (door[0] >= doors[i] && door[0] <= doors[i + 2] && door[1] >= doors[i + 1] && door[1] <= doors[i + 3]) {
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
  void movement() {
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
    if (collision[0] == true && keys[2] == true && collision[2] == false) {
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
    image(sheet.get(sprite * 175, 0, 175, 161), xpos, ypos);
  }
  //IF _KEYHIT = 13 THEN
  //    pGunshot& = _SNDCOPY(gunSound(pGun, Shot))
  //    pReload& = _SNDCOPY(gunSound(pGun, Reload))
  //    ELSEIF pClip = -1 AND _SNDPLAYING(pReload&) = 0 THEN pClip = gunList(pGun, 1)
  //END IF
  //IF LPR < gunList(pGun, 2) AND keySPC = -1 THEN LPR = LPR + 1 ELSE IF LPR >= gunList(pGun, 2) THEN LPR = 1
  //IF keySPC = -1 AND (gunList(pGun, 0) = -1 OR lastkeySPC = 0 AND gunList(pGun, 0) = 0) AND LPR = 1 AND pClip > 0 AND _SNDPLAYING(pReload&) = 0 THEN
  //    pClip = pClip - 1
  //    IF pSprite < 4 THEN pSprite = pSprite + 4
  //    _SNDPLAYCOPY pGunshot&
  //    _SOURCE bitmap&
  //    IF pSprite = (0 OR 1 OR 4 OR 5) THEN
  //        FOR x = posi(0, 0) TO 0 STEP -1
  //            IF POINT(x, posi(1, 0) + 75) = _RGB32(0, 0, 0) OR POINT(x, posi(1, 0) + 75) = _RGB32(255, 0, 0) THEN EXIT FOR
  //        NEXT
  //    ELSE
  //        FOR x = posi(0, 0) TO 1920 STEP 1
  //            IF POINT(x, posi(1, 0) + 75) = _RGB32(0, 0, 0) OR POINT(x, posi(1, 0) + 75) = _RGB32(255, 0, 0) THEN EXIT FOR
  //        NEXT
  //    END IF
  //END IF
  //IF keyR AND _SNDPLAYING(pReload&) = 0 THEN _SNDPLAY pReload&: pClip = -1
  //IF keySPC = -1 AND lastkeySPC = 0 AND pClip = 0 AND LPR = 1 THEN _SNDPLAY dFire&
  void weapon() {
    if (keys[7] == true) { //If the enter key is pressed
      if (currentWeapon == 17) { 
        currentWeapon = 0;
      } else if (currentWeapon < 17) { 
        currentWeapon++;
      }
      gunClip = clipSize[currentWeapon];
    }
    if (keys[6] == true) { //If the spacebar is pressed
      if (gunshot[currentWeapon] != null) { 
        gunshot[currentWeapon].play(); //Plays the weapon sound
        gunClip = gunClip - 1;
      }
    }
    println(r);
    if (r != -1) {
      timer();
      if (r == -1) { 
        gunClip = clipSize[currentWeapon];
      }
    }
      if (keys[5] == true && r == -1) { //If the R key is pressed
        if (reload[currentWeapon] != null && r == -1) {
          timer();
          reload[currentWeapon].play();
          d = reload[currentWeapon].duration();
          len = reload[currentWeapon].duration();
          t = second();
          r = int(reload[currentWeapon].duration());
        }
      }
      printText(str(gunClip) + "/" + str(clipSize[currentWeapon]), 2500, 1280, orbitron, 72, #FF0000, RIGHT);
    }
  }
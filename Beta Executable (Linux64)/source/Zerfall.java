import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Zerfall extends PApplet {


PImage bitmap, map, background, foreground, loading;
boolean[] keys;
String[] stuff;
String gunID[];
int[] doors, rooms, door, gunRPM, gunClip;
SoundFile gunshot[], reload[];

playerClass player;
zombieClass[] zombieList;

public void setup() {
  noCursor();
  
  loading = loadImage("Images/loading.png");
  image(loading, 0, 0);
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
  doors = PApplet.parseInt(split(stuff[0], ','));
  stuff = loadStrings("Resources/rooms.dat");
  rooms = PApplet.parseInt(split(stuff[0], ','));
  stuff = loadStrings("Resources/gunID.dat");
  gunID = split(stuff[0], ',');
  stuff = loadStrings("Resources/gunRPM.dat");
  gunRPM = PApplet.parseInt(split(stuff[0], ','));
  stuff = loadStrings("Resources/gunClip.dat");
  gunClip = PApplet.parseInt(split(stuff[0], ','));
  for (int i = 0; i < 18; i++) {
    gunshot[i] = new SoundFile(this, "Sounds/Guns/" + gunID[i] + " Gunshot.ogg");
    reload[i] = new SoundFile(this, "Sounds/Guns/" + gunID[i] + " Reload.ogg");
  }
  for (int i = 0; i < 8; i++ ) {
    keys[i] = false; //clears the key buffer
  }
  int index = 0;
  for (int i = 0; i < 8; i++) {
    zombieList[index++] = new zombieClass(PApplet.parseInt(random(1, 4)));
  }
}
public void draw() {
  image(background, 0, 0);
  player.collision();
  if (player.door[0] != -1) {
    player.doors();
  }
  player.weapon();
  for (zombieClass zombie : zombieList) {
    zombie.collision();
    zombie.movement();
  }
  player.movement();
}

public void keyPressed() { //checks key press events and sets keys to true
  keys[0] = (key == 'A' || key == 'a') ? true : keys[0]; //checks the A key
  keys[1] = (key == 'D' || key == 'd') ? true : keys[1]; //checks the D key
  keys[2] = (key == 'W' || key == 'w') ? true : keys[2]; //checks the W key
  keys[3] = (key == 'S' || key == 's') ? true : keys[3]; //checks the S key
  keys[4] = (key == 'E' || key == 'e') ? true : keys[4]; //checks the E key
  keys[5] = (key == 'R' || key == 'r') ? true : keys[5]; //checks the R key
  keys[6] = (key == ' ') ? true : keys[6]; //checks the spacebar
  keys[7] = (key == RETURN || key == ENTER) ? true : keys[7]; //checks the enter key
}
public void keyReleased() { //checks key release events and sets keys to false
  keys[0] = (key == 'A' || key == 'a') ? false : keys[0]; //checks the A key
  keys[1] = (key == 'D' || key == 'd') ? false : keys[1]; //checks the D key
  keys[2] = (key == 'W' || key == 'w') ? false : keys[2]; //checks the W key
  keys[3] = (key == 'S' || key == 's') ? false : keys[3]; //checks the S key
  keys[4] = (key == 'E' || key == 'e') ? false : keys[4]; //checks the E key
  keys[5] = (key == 'R' || key == 'r') ? false : keys[5]; //checks the R key
  keys[6] = (key == ' ') ? false : keys[6]; //checks the spacebar
  keys[7] = (key == RETURN || key == ENTER) ? false : keys[7]; //checks the enter key
}

public void roundEnd() {
}
class playerClass {
  PImage sheet;
  int spriteDim, sprite, xpos, ypos, yspeed, door[], i, l, currentWeapon;
  boolean[] collision;
  int c = color(0);
  playerClass() {
    sheet = loadImage("Sprites/player.png");
    xpos = 1136;
    ypos = 470;
    sprite = 0;
    yspeed = 1;
    currentWeapon = 0;
    collision = new boolean[5];
    door = new int[2];
  }
  public void collision() {
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
  public void doors() {
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
  public void movement() {
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
  //    IF pGun = 18 THEN pGun = 1 ELSE pGun = pGun + 1
  //    pGunshot& = _SNDCOPY(gunSound(pGun, Shot))
  //    pReload& = _SNDCOPY(gunSound(pGun, Reload))
  //    pClip = gunList(pGun, 1)
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
  public void weapon() {
    if (keys[7] == true) { //If the enter key is pressed
      currentWeapon = (currentWeapon < 17) ? currentWeapon++ : 0; //Switch weapons
    }
    if (keys[6] == true) { //If the spacebar is pressed
      gunshot[currentWeapon].play(); //Plays the weapon sound
    }
  }
}
class zombieClass {
  PImage sheet;
  int sprite, xpos, ypos, health, yspeed, xspeed, zombieCache;
  SoundFile groan, attack;
  boolean[] collision;
  int c = color(0);
  zombieClass(int speed) {
    sheet = loadImage("Sprites/zombie-temp.png");
    xpos = player.xpos;
    ypos = player.ypos;
    sprite = 0;
    yspeed = 1;
    xspeed = speed;
    collision = new boolean[5];
  }
  public void collision() {
    for (int i = 0; i < 5; i++) {
      collision[i] = false;
    }
    for (int x = xpos + 25; x <= xpos + 150; x++) {
      for (int y = ypos + 162; y <= ypos + 162 + abs(yspeed); y++) {
        c = bitmap.get(x, y);
        collision[1] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[1]; //This checks the lower bound
        collision[0] = (c == color(0, 0, 255)) ? true : collision[0];
      }
    }
    for (int x = xpos; x <= xpos + 84; x++) {
      for (int y = ypos; y <= ypos - 1 - abs(yspeed); y--) {
        c = bitmap.get(x, y);
        collision[2] = (c == color(0, 0, 0)) ? true : collision[2]; //This checks the upper bound
      }
    }
    for (int x = xpos; x <= xpos - xspeed; x--) {
      for (int y = ypos; y<= ypos + 162; y++) {   
        c = bitmap.get(x, y); 
        collision[3] = (c == color(255, 0, 0) || c == color(0, 0, 0)) ? true : collision[3]; //This checks the left bound
      }
    }
    for (int x = xpos + 84; x <= xpos + 84 + xspeed; x++) { 
      for (int y = ypos; y<= ypos + 162; y++) {   
        c = bitmap.get(x, y); 
        collision[4] = (c == color(0, 0, 0) || c == color(255, 0, 0)) ? true : collision[4]; //This checks the right bound
      }
    }
  }
  public void movement() {
    yspeed = (collision[1] == true || collision[2] == true) ? 1 : yspeed + 1;
    if (collision[1] == false) {
      ypos += yspeed;
    }
    if (player.xpos + 50 > xpos) {
      xpos = xpos + xspeed;
    }
    if (player.xpos + 50 < xpos) {
      xpos = xpos - xspeed;
    }
    image(sheet.get(sprite * 84, 0, 84, 162), xpos, ypos);
  }
  public void spawn() {
    if (zombieList.length < 8 && zombieCache > 0) {
      zombieCache--;
      append(zombieList, new zombieClass(PApplet.parseInt(random(1,4))));
    }
  }
}
  public void settings() {  fullScreen(P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Zerfall" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

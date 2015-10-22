import processing.sound.*;
PImage bitmap, loading, map, foreground;
PShape background;
boolean keys[] = new boolean[128];
int doors[] = { 800, 445, 805, 725, 
  1505, 445, 1510, 725, 
  2340, 445, 2345, 725, 
  1280, 730, 1285, 1020, 
  2340, 730, 2345, 1020, 
  2340, 1025, 2345, 1300 };
int rooms[] = { 0, 330, 600, 548, 
  1134, 330, 1756, 548, 
  2340, 330, 1920, 980, 
  0, 545, 961, 768, 
  961, 545, 2340, 768, 
  0, 765, 2340, 980 };
PFont orbitron;
player player;
zombieClass zombies[];

void setup() {
  fullScreen(P3D);
  int d = displayDensity();
  pixelDensity(d);
  noCursor();
  smooth(2);
  noStroke();
  bitmap = requestImage("Maps/bitmap.png");
  loading = loadImage("Images/loading.png");
  map = requestImage("Maps/map.png");
  foreground = requestImage("Maps/foreground.png");
  image(loading, 0, 0);
  player = new player();
  zombies = new zombieClass[8];
  for (int i = 0; i < 18; i++) {
    player.gunAudio[0][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + player.gunID[i] + " Gunshot.ogg");
    player.gunAudio[1][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + player.gunID[i] + " Reload.ogg");
  }
  int index = 0;
  for (int i = 0; i < 8; i++) {
    zombies[index++] = new zombieClass(int(random(1, 3)));
  }
  background = createShape();
  background.beginShape();
  background.texture(map);
  background.vertex(0, 0, 0, 0, 0);
  background.vertex(2560, 0, 0, map.width, 0);
  background.vertex(2560, 1440, 0, map.width, map.height);
  background.vertex(0, 1440, 0, 0, map.height);
  background.endShape(CLOSE);
  orbitron = createFont("Fonts/Orbitron.ttf", int(map(72, 0, 2560, 0, width)), true);
}

void draw() {
  player.weapon();
  player.movement();
  for (zombieClass zombie : zombies) {
    zombie.movement();
  }
  display();
}

void display() {
  background(0);
  fill(200, 190, 180);
  camera(player.xpos + 87, player.ypos + 81, 623.5, player.xpos + 87, player.ypos + 81, 0, 0, 1, 0);
  ambientLight(127, 127, 127);
  if (player.sprite > 3) {
    float xpos = (player.sprite == (2 | 3 | 6 | 7)) ? player.xpos : player.xpos + 175;
    float ypos = player.ypos + 75;
    fill(255, 255, 127);
    pointLight(255, 127, 0, xpos, ypos, 40);
  }
  translate(0, 0, -1);
  shape(background);
  translate(0, 0, 1);
  image(player.sheet[player.sprite], player.xpos, player.ypos);
  for (zombieClass zombie : zombies) {
    image(zombie.sheet.get(zombie.sprite * 100, 0, 100, 162), zombie.xpos, zombie.ypos);
  }
  image(foreground, 0, 0);
  fill(255);
  pushMatrix();
  lights();
  hint(DISABLE_DEPTH_TEST);
  camera();
  int x = int(map(2500, 0, 2560, 0, width));
  int y = int(map(1400, 0, 1440, 0, height));
  printText(str(player.gunClip) + "/" + str(player.clipSize[player.currentWeapon]), x, y, 10, orbitron, 144, #888888, RIGHT);
  popMatrix();
}

void keyPressed() { 
  for (int i = 0; i < 128; i++) {
    if (i >= 65 && i < 90) {
      keys[i] = (key == (char(i) | char(i + 32))) ? true : keys[i];
    } else {
      keys[i] = (key == char(i)) ? true : keys[i];
    }
  }
}
void keyReleased() {
  for (int i = 0; i < 128; i++) {
    if (i >= 65 && i < 90) {
      keys[i] = (key == (char(i) | char(i + 32))) ? false : keys[i];
    } else {
      keys[i] = (key == char(i)) ? false : keys[i];
    }
  }
}

void roundEnd() {
}

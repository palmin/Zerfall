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
float timerInfo[][];
boolean timer[];
PFont orbitron;
player player;
zombieClass zombies[];

void setup() {
  fullScreen(P3D);
  noCursor();
  smooth(2);
  bitmap = loadImage("Maps/bitmap.png");
  loading = loadImage("Images/loading.png");
  map = loadImage("Maps/map.png");
  foreground = loadImage("Maps/foreground.png");
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
  orbitron = createFont("Fonts/Orbitron.ttf", int(map(72, 0, 2560, 0, displayWidth)), true);
  timerInfo = new float[3][64];
  timer = new boolean[64];
}

void draw() {
  player.weapon();
  player.movement();
  for (zombieClass zombie : zombies) {
    zombie.movement();
  }
  display();
}

void keyPressed() {                                       //checks key press events
  for (int i = 0; i < 128; i++) {
    if (i >= 65 && i < 90) {
      keys[i] = (key == (char(i) | char(i + 32))) ? true : keys[i];  //checks the letter keys
    } else {
      keys[i] = (key == char(i)) ? true : keys[i];
    }
  }
}
void keyReleased() { //checks key release events
  for (int i = 0; i < 128; i++) {
    if (i >= 65 && i < 90) {
      keys[i] = (key == (char(i) | char(i + 32))) ? false : keys[i];  //checks the letter keys
    } else {
      keys[i] = (key == char(i)) ? false : keys[i];
    }
  }
}

void roundEnd() {
}
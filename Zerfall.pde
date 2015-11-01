import processing.sound.*;
PImage bitmap, loading, map, foreground;
PShape background;
boolean keys[] = new boolean[128];
int doors[][], smoothing = 2;
IntList doorx, doory, doorx2, doory2;
PFont orbitron;
player player;
zombieClass zombies[];

void settings() {
  fullScreen(P3D);
  //size(1280, 720, P3D);
  if (smoothing == 0) {
    noSmooth();
  } else if (smoothing <= 8 && smoothing % 2 != 0) {
    smooth(smoothing);
  }
}


void setup() {
  noCursor();
  noStroke();
  ortho();
  textMode(SHAPE);
  frameRate(60);
  bitmap = loadImage("Maps/bitmap.png");
  loading = loadImage("Images/loading.png");
  map = loadImage("Maps/map.png");
  foreground = loadImage("Maps/foreground.png");
  image(loading, 0, 0);
  loading = new PImage();
  parseBitmap(bitmap, color(255, 0, 0));
  player = new player();
  zombies = new zombieClass[8];
  for (int i = 0; i < player.gunID.length; i++) {
    player.gunAudio[0][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + player.gunID[i] + " Gunshot.ogg");
    player.gunAudio[1][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + player.gunID[i] + " Reload.ogg");
  }
  int index = 0;
  for (int i = 0; i < 8; i++)
    zombies[index++] = new zombieClass(int(random(1, 3)));
  background = createShape();
  background.beginShape();
  background.texture(map);
  background.vertex(0, 0, 0, 0, 0);
  background.vertex(width * 2, 0, 0, map.width, 0);
  background.vertex(width * 2, height * 2, 0, map.width, map.height);
  background.vertex(0, height * 2, 0, 0, map.height);
  background.endShape(CLOSE);
  orbitron = createFont("Fonts/Orbitron.ttf", int(map(72, 0, 2560, 0, width)), true);
  loading = new PImage();
}

void draw() {
  player.weapon();
  player.movement();
  //for (zombieClass zombie : zombies) {
  //    zombie.movement();
  //}
  display();
}

void keyPressed() { 
  keys[keyCode] = true;
}
void keyReleased() {
  keys[keyCode] = false;
}

void roundEnd() {
}
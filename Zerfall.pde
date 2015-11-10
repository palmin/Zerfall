import processing.sound.*;
PImage bitmap, map, foreground;
boolean keys[] = new boolean[128];
int doors[][];
PFont orbitron;
player player;
ArrayList<zombieClass> zombies;

void settings() {
  size(1280, 720, P3D);
}

void setup() {
  noCursor();
  noStroke();
  ortho();
  textMode(SHAPE);
  frameRate(60);
  bitmap = loadImage("Maps/bitmap.png");
  PImage loading = loadImage("Images/loading.png");
  map = loadImage("Maps/map.png");
  foreground = loadImage("Maps/foreground.png");
  image(loading, 0, 0);
  loading = new PImage();
  parseBitmap(bitmap, color(255, 0, 0));
  player = new player();
  zombies = new ArrayList<zombieClass>();
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

void keyPressed() { 
  keys[keyCode] = true;
}
void keyReleased() {
  keys[keyCode] = false;
}

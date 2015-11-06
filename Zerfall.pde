import processing.sound.*;
PImage bitmap, loading, map, foreground;
boolean keys[] = new boolean[256];
int doors[][], smoothing = 2;
PFont orbitron;
player player;
ArrayList<zombieClass> zombies;

void settings() {
  //fullScreen(P3D);
  size(1280, 720, P3D);
  //The following code allows the user to set the smoothing level.
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
  zombies = new ArrayList<zombieClass>();
  zombies.add(new zombieClass(int(random(3))));
  orbitron = createFont("Fonts/Orbitron.ttf", int(map(72, 0, 2560, 0, width)), true);
  loading = new PImage();
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

void roundEnd() {
}
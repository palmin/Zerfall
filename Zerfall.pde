import
  processing.sound.*;
PImage
  bitmap = new PImage(), 
  map = new PImage(), 
  foreground = new PImage();
boolean 
  keys[] = new boolean[256];
PFont
  orbitron;
ArrayList<zombieClass>
  zombies = new ArrayList<zombieClass>();
player
  player;

void settings() {
  size(1280, 720, P2D);
}

void setup() {
  PImage loading = loadImage("Images/loading.png");
  image(loading, 0, 0, width, height);
  loading = new PImage();
  noCursor();
  orbitron = createFont("Fonts/Orbitron.ttf", int(map(72, 0, 2560, 0, width)), true);
  textMode(SHAPE);
  frameRate(60);
  bitmap = loadImage("Maps/bitmap.png");
  map = loadImage("Maps/map.png");
  foreground = loadImage("Maps/foreground.png");
  textFont(orbitron);
  player = new player();
}

void draw() {
  player.weapon();
  player.movement();
  for (zombieClass zombie : zombies)
    zombie.movement();
  display();
}

void keyPressed() { 
  keys[keyCode] = true;
}
void keyReleased() {
  keys[keyCode] = false;
}
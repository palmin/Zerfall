import
  processing.sound.*;
PImage
  bitmap = new PImage(), 
  map = new PImage(), 
  foreground = new PImage();
boolean 
  keys[], 
  itemsLoaded;
PFont
  orbitron;
ArrayList<zombieClass>
  zombies;
player
  player;
XML
  guns;

void settings() {
  fullScreen(P2D);
}

void setup() {
  PImage loading = loadImage("Images/loading.png");
  image(loading, 0, 0, width, height);
  loading = new PImage();
  textMode(SHAPE);
  noCursor();
  frameRate(60);
  player = new player();
  zombies = new ArrayList<zombieClass>();
  thread("loadItems");
}

void draw() {
  if (itemsLoaded == true) {
    player.weapon();
    player.movement();
    for (zombieClass zombie : zombies)
      zombie.movement();
    display();
  }
}

void keyPressed() { 
  keys[keyCode] = true;
}
void keyReleased() {
  keys[keyCode] = false;
}

void loadItems() {
  orbitron = createFont("Fonts/Orbitron.ttf", int(map(72, 0, 2560, 0, width)), true);
  bitmap = loadImage("Maps/bitmap.png");
  map = loadImage("Maps/map.png");
  foreground = loadImage("Maps/foreground.png");
  textFont(orbitron);
  keys = new boolean[256];
  guns = loadXML("Resources/Gun Information.xml");
  itemsLoaded = true;
}
import processing.sound.*;
PImage bitmap, loading, map, foreground;
PShape background;
boolean keys[];
String stuff[];
int doors[], rooms[];
float timerInfo[][];
boolean timer[];
PShader shader;
PFont orbitron;
player player;
zombieClass zombies[];

void setup() {
  fullScreen(P3D);
  noCursor();
  smooth(2);
  loading = loadImage("Images/loading.png");
  image(loading, 0, 0);
  bitmap = loadImage("Maps/bitmap.png");
  map = loadImage("Maps/map.png");
  foreground = loadImage("Maps/foreground.png");
  stuff = loadStrings("Resources/doors.dat");
  doors = int(split(stuff[0], ','));
  stuff = loadStrings("Resources/rooms.dat");
  rooms = int(split(stuff[0], ','));
  keys = new boolean[128];
  player = new player();
  zombies = new zombieClass[8];
  screenWidth = 1280;
  screenHeight = 720;
  for (int i = 65; i < 128; i++) {
    println(i);
    keyCodes[i] = char(i);
  }
  for (int i = 0; i < 18; i++) {
    player.gunAudio[0][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + player.gunID[i] + " Gunshot.ogg");
    player.gunAudio[1][i] = new SoundFile(Zerfall.this, "Sounds/Guns/" + player.gunID[i] + " Reload.ogg");
  }
  for (int i = 0; i < 8; i++ ) {
    keys[i] = false; //clears the key buffer
  }
  int index = 0;
  for (int i = 0; i < 8; i++) {
    zombies[index++] = new zombieClass(int(random(1, 5)));
  }
  background = createShape();
  background.beginShape();
  background.texture(map);
  background.vertex(0, 0, 0, 0, 0);
  background.vertex(2560, 0, 0, map.width, 0);
  background.vertex(2560, 1440, 0, map.width, map.height);
  background.vertex(0, 1440, 0, 0, map.height);
  background.endShape(CLOSE);
  shader = loadShader("Shaders/pixlightxfrag.glsl", "Shaders/pixlightxvert.glsl");
  orbitron = createFont("Fonts/Orbitron.ttf", 72, true);
  timerInfo = new float[3][64];
  timer = new boolean[64];
}

void draw() {
  player.weapon();
  player.movement();
  display();
  for (zombieClass zombie : zombies) {
    zombie.movement();
  }
  HUD();
}

void keyPressed() {                                       //checks key press events
    for (int i = 0; i < 128; i++) {
    if (i >= 65 && i < 90) {
      keys[i] = (key == (char[i] | char[i + 32])) ? true : keys[i];  //checks the letter keys
    } else {
      keys[i] = (key == char[i]) ? true : keys[i];
  }
}
void keyReleased() { //checks key release events
  for (int i = 0; i < 128; i++) {
    if (i >= 65 && i < 90) {
      keys[i] = (key == (char[i] | char[i + 32])) ? false : keys[i];  //checks the letter keys
    } else {
      keys[i] = (key == char[i]) ? false : keys[i];
  }
}

void roundEnd() {
}

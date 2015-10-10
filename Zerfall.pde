import processing.sound.*;
PImage bitmap, loading, map, foreground, playerSprite;
PShape background;
boolean keys[], fullscreen;
char keyCodes[];
String stuff[];
int doors[], rooms[], screenWidth, screenHeight;
float timerInfo[][];
boolean timer[];
PShader shader;
PFont orbitron;
player player;
zombieClass zombies[];

void setup() {
  fullScreen(P3D);
  textMode(SCREEN);
  noCursor();
  colorMode(RGB, 255);
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
  keyCodes = new char[128];
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

void settings() {
  if (fullscreen == false) {
    size(1280, 720, P3D);
  } else {
    fullScreen(P3D);
  }
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
  keys[65] = (key == ('A' | 'a')) ? true : keys[65];        //checks the A key
  keys[68] = (key == ('D' | 'd')) ? true : keys[68];        //checks the D key
  keys[87] = (key == ('W' | 'w')) ? true : keys[87];        //checks the W key
  keys[83] = (key == ('S' | 's')) ? true : keys[83];        //checks the S key
  keys[69] = (key == ('E' | 'e')) ? true : keys[69];        //checks the E key
  keys[82] = (key == ('R' | 'r')) ? true : keys[82];        //checks the R key
  keys[32] = (key == (' ' | ' ')) ? true : keys[32];        //checks the spacebar
  keys[13] = (key == (RETURN | ENTER)) ? true : keys[13];   //checks the enter key
  keys[70] = (key == ('F' | 'f')) ? true : keys[70];        //checks the F key
}
void keyReleased() { //checks key release events
  for (int i = 65; i < 90; i++) {
    keys[i] = (key == (keyCodes[i] | keyCodes[i + 32])) ? false : keys[i];  //checks the A key
  }
  keys[32] = (key == (' ' | ' ')) ? false : keys[32];                       //checks the spacebar
  keys[13] = (key == (RETURN | ENTER)) ? false : keys[13];                  //checks the enter key
}

void roundEnd() {
}
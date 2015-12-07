class gun {
  SoundFile
    gunshot, 
    reload;
  int
    clip, 
    damage, 
    rate;
  String
    name;
  gun(String n, int r, int e, int c) {
    name = n;
    rate = r;
    damage = e;
    clip = c;
    gunshot = new SoundFile(Zerfall.this, "Sounds/Guns/" + identifier + " Gunshot.ogg");
    reload = new SoundFile(Zerfall.this, "Sounds/Guns/" + identifier + " Reloadt.ogg");
  }
}

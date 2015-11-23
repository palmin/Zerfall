class gun {
  SoundFile
    gunshot, 
    reload;
  int
    clip, 
    damage, 
    rate;
  String
    identifier;
  gun(String id) {
    identifier = id;
    gunshot = new SoundFile(Zerfall.this, "Sounds/Guns/" + identifier + " Gunshot.ogg");
    reload = new SoundFile(Zerfall.this, "Sounds/Guns/" + identifier + " Gunshot.ogg");
  }
}
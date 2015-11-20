class gun {
  SoundFile
    gunshot = new SoundFile(),
    reload = new SoundFile();
  int
    clip = new int(),
    damage = new int(),
    rate = new int();
  String
    identifier = new String();
  gun(String id) {
    identifier = id;
    gunshot = new SoundFile(Zerfall.this, "Sounds/Guns/" + identifier + " Gunshot.ogg");
    reload = new SoundFile(Zerfall.this, "Sounds/Guns/" + identifier + " Gunshot.ogg");
  }
}

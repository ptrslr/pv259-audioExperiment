Minim minim;
AudioPlayer player;
AudioInput input;
 
void setup()
{
  size(100, 100);
 
  minim = new Minim(this);
  player = minim.loadFile("song.mp3");
  input = minim.getLineIn();
}
 
void draw()
{
  // do what you do
}
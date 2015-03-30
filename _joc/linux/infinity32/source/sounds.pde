Minim minim = new Minim(this);
AudioPlayer audioPlayer;

boolean playing = false;
boolean closeSound = false;

void gameSound()
{
    if(!playing && closeSound == false)
    {
       audioPlayer = minim.loadFile("sounds/gameSoundTrack/SoundTrack.mp3");
       audioPlayer.loop();
       audioPlayer.rewind();
       playing = true;
    }    
    
    if(closeSound)
    {
       audioPlayer.close();
       minim.stop(); 
    }
}

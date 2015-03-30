PImage bg;
PImage cloud;
PImage[] players;
PImage[] players2;
int nrPlayers = 6;
IntList cloudX = new IntList();
IntList cloudY = new IntList();
int maxClouds = 10;
int cloudAlpha = 70;
int cloudsNumber = 0;
int cloudsDelay = 0;

void loadImages()
{
   //background
    background(0);        
    bg = loadImage("images/background/background.png");
    menuBg = loadImage("images/background/menu.png");
    missionsBg = loadImage("images/background/missions.png");
    optionsBg = loadImage("images/background/options.png");
    selectStoryBg = loadImage("images/background/selectStory.png");
    cloud = loadImage("images/background/cloud.png");
    players = new  PImage[nrPlayers];
    players2 = new  PImage[nrPlayers];
    for(int i = 0; i < nrPlayers; i++)
    {
      players[i] = loadImage("images/player/menu/player" + ( i + 1) + ".png");
      players2[i] = loadImage("images/player/player" + ( i + 1) + ".png");
    }    
}

void drawBackground()
{
   background(255);
   //stars
   int onWidth = 0;
   int onHeight = 0;
   if(width % bg.width == 0)
    onWidth = width / bg.width;
   else
    onWidth = width / bg.width + 1;
    
   if(height % bg.height == 0)
    onHeight = width / bg.height;
   else
    onHeight = width / bg.height + 1;
    
   for(int i = 0; i <= onWidth; i++)
    for(int j = 0; j <= onHeight; j++)
    {
        image(bg, i*bg.width, j*bg.height);
    }
}



int fireRate = 0;
boolean sFx = true;

class Player
{
   AudioPlayer fireSound;
   AudioPlayer deathSound;
   
   int playerX;
   int playerY;
   int damage = 0;
   String name = "Player";
   PImage playerImage;
   PImage bulletImage;
   int bulletSpeed = 3;
   int life = 3;
   //bullet Properties
   IntList bulletX;
   IntList bulletY; 
   int numBullets = 0;
   int newWidth;
   int newHeight;
   int playerScore = 0;
   
   Player(String name1, PImage img, PImage bullet, int fr, int dmg, String sp/*laser.mp3*/, String pD/*playerDeath.mp3*/)
   {
     name = name1;
     playerImage = img;
     bulletImage = bullet;
     bulletX = new IntList();
     bulletY = new IntList();
     fireRate = fr;
     damage = dmg;
     fireSound = minim.loadFile(sp);// variabila minim se afla in sounds
     deathSound = minim.loadFile(pD);
   }
  
  void drawPlayer()
  {
     if(life <= 0)
     {
        CurrentMenu = "over";
        return; 
     }
     
     textSize(24);
     fill(255,0,0);
     text("Score: " + playerScore, 0,25);
     text("life: " + life, 0, 50);
     text("level: " + (currentLevel + 1),0, 75);
     noFill();
     
     imageMode(CENTER);
     image(playerImage, mouseX, playerY);    
  }
  
  void updatePosition()
  {    
    playerX = mouseX;    
    playerY = mouseY;
  }
  
  void playSound()
  {
     if(!sFx)
       return;
     fireSound.play();
     fireSound.rewind(); 
  }
  
  void death()
  {
     if(!sFx)
       return;
     deathSound.play();
     deathSound.rewind(); 
  }
  
  void shoot()
  {
    if(numBullets > 0)
      if(fireRate > 0)
         return;
    playSound();
    bulletX.append(mouseX);
    bulletY.append(playerY);
    numBullets++;
  }
  
  void fire()
  {
    for(int i = 0; i < numBullets; i++)
    {
       bulletY.set(i, bulletY.get(i) - bulletSpeed);
       imageMode(CENTER);
       image(bulletImage, bulletX.get(i), bulletY.get(i));          
    }
  }
  
  void deleteBullet()
  {
    for(int i = 0; i < numBullets; i++)
      if(bulletY.get(i) < 0)
        {
           bulletX.remove(i);
           bulletY.remove(i); 
           numBullets--;
        }
  }
  
  void deleteBulletOnContact(int index)
  {
     bulletX.remove(index);
     bulletY.remove(index); 
     numBullets--;
  }
  
  void clearAllBullets()
  {
     for(int i = 0; i < numBullets; i++)
        deleteBulletOnContact(i); 
  }
   
}

void showPlayerImage(int nr,int x, int y)
{
  player.playerImage = players2[nr];
  image(players[nr],x,y);
}

void alocatePlayer()
{
   PImage playerImg;
   PImage bulletImg;   
   playerImg = loadImage("images/player/player1.png");
   bulletImg = loadImage("images/player/bullet2.png");
   player = new Player("Stefan", playerImg, bulletImg, 50,5,"sounds/gun/laser.mp3","sounds/player/playerDeath.mp3"); 
}

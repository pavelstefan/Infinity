import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import java.awt.AWTException; 
import java.awt.Robot; 
import java.io.DataInputStream; 
import java.io.FileInputStream; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class infinity extends PApplet {







public void setup()
{
  //rezolutia se seteaza automat in fisierul setResolution
  loadImages();
  loadGame();
  createLevels();
  alocatePlayer();  
  alocateEnemy();
  alocateMenu();    
  gameSound();
  frame.setTitle("Infinity");
  changeAppIcon(loadImage("images/app/icon.png"));
  
  try { 
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }
  
  //CurrentMenu = "story";
}

public void draw()
{  
  getResolution();  
  findMenu();
}

public void findMenu()
{
    if(player.life <= 0 && CurrentMenu == "story")
    {
      CurrentMenu = "over";
      enemyDeath = enemyNumber;
      enemyNumber = PApplet.parseInt(random(1,16));
      prepareNewLevel();
    }
    
    if(CurrentMenu == "story")
    {       
       noCursor();
       story();// in story se deseneaza si fundalul             
       return; 
    }
    
    if(CurrentMenu == "over")
    {
       drawStoryBackground();
       gui("GAME OVER",48,true);
       //resetGame();
       return; 
    }
    
    if(CurrentMenu == "PrincipalMenu")
    {
       //acest meniu va fi afisat la inceputul jocului
       cursor();
       storyStarted = false;       
       drawStoryBackground();
       imageMode(NORMAL);
       image(menuBg,0,0);
       showPlayerImage(currentPlayer,700,100);
       showPrincipalMenu();
       time();
       //gui("Press ENETER to start", 48,true);
        
       return; 
    }
        
    if(CurrentMenu == "selectStory")
    {
      drawStoryBackground();
      imageMode(NORMAL);
      image(selectStoryBg,0,0);
      if(time() < 4)
      {
        textSize(48);
        fill(255,0,0);
        text(storyMessage, 560,260);
      }
      else
      {
         lastMin = minute();
         lastSec = second();
         storyMessage = "";
      } 
      return;
    }
    
    if(CurrentMenu == "NewChapter")
    {     
      drawStoryBackground();
      if(textSize >= 48)
      {
         gui(message,textSize,false);         
      }
      else
        gui(message,48,false);
      if(textSize == 15)
        {          
          CurrentMenu = "story";
          chapter = false;
          textSize = 128;
          if(currentLevel == nrLevels)
            CurrentMenu = "gameFinished";
        }
      textSize--;            
      return;
    }
    
    if(CurrentMenu == "gameFinished")
    {
       drawStoryBackground();
       gui("you finished the game!",48,true);
       return; 
    }
    
    if(CurrentMenu == "options")
    {
        drawStoryBackground();
        imageMode(NORMAL);
        image(optionsBg,0,0);
        showOptions();
        return;
    }
    
    if(CurrentMenu == "missions")
    {
        drawStoryBackground();
        imageMode(NORMAL);
        image(missionsBg,0,0);
        return;
    }
    
    println("meniul " + CurrentMenu + " nu exista");
}

int opacity = 256;
boolean show = false;

public void gui(String name, int dim,boolean p)
{
    if(p)
      pulsate();
    textSize(dim);
    int tw = PApplet.parseInt(textWidth(name));
    fill(250,0,0, opacity);
    tint(255, 25);
    text(name, width/2 - tw / 2, height/2);
    noTint();
    noFill();
}

public void pulsate()
{
   if(show)
   {
      if(opacity < 256)
        opacity += 5;
      else
        show = false;
   }
   else
   {
      if(opacity > 0)
        opacity -= 5;
      else
        show = true;
   } 
}

public void mouseClicked()
{
   if(CurrentMenu == "PrincipalMenu")
   {
     if(play.over())
     {
       CurrentMenu = "selectStory";
       //noCursor();
      // robot.mouseMove(width/2, height - player.playerImage.height/4);
     }
   
     if(options.over())
     {
       CurrentMenu = "options";
     }
     
     if(missions.over())
     {
       CurrentMenu = "missions";
     }
   
     if(left.over())
     {
        if(currentPlayer > 0)
          currentPlayer--;
     }
     
     if(right.over())
     {
       if(currentPlayer < nrPlayers - 1)
         currentPlayer++;
     }
   
     if(exit.over())
     {
       exit();
     } 
     return; 
   }
  
   if(CurrentMenu == "selectStory")
   {
       
       if(newGame.over())
       {
          currentLevel = 0;
          CurrentMenu = "story"; 
       }
       
       if(loadGame.over() && currentLevel > 0)
       {
          CurrentMenu = "story"; 
          storyMessage = "";
       }
       else
       {
          storyMessage = "Nothing to load!";          
       }
       
       if(back[0].over())
       {
          CurrentMenu = "PrincipalMenu"; 
       }
       return;
   }
  
   if(CurrentMenu == "options")
   {
       if(music.over())
       {
         closeSound = !closeSound;
         if(closeSound)
         {
           audioPlayer.pause();
         }
         else
         {
            audioPlayer.loop();
            audioPlayer.rewind();
         } 
       }
       
       if(soundFx.over())
       {
         sFx = !sFx;
       }
       
       if(back[0].over())
       {
          CurrentMenu = "PrincipalMenu"; 
       }
       return;
   }
  
   if(CurrentMenu == "missions")
   {
      if(back[0].over())
      {
         CurrentMenu = "PrincipalMenu"; 
      }
      return;
   } 
}
//universal
int nrBack = 1;
Button[] back;

//principalMenu
Button play;
Button options;
Button missions;
Button exit;
Button left;
Button right;

//selectStory
Button newGame;
Button loadGame;

//options
Button music;
Button soundFx;

class Button
{
  int x;
  int y;
  int w;
  int h;
  PImage img;
  
  Button(int x1,int y1,int w1, int h1)
  {
    x = x1;
    y = y1;
    w = w1;
    h = h1;
  }
  
  Button(int x1,int y1,int w1, int h1, PImage img1)
  {
    x = x1;
    y = y1;
    w = w1;
    h = h1;
    img = img1;
  }
  
  public void show()
  {
     stroke(255,0,0);
     noFill();
     rect(x,y,w,h); 
  }

  public void drawBtn()
  {
     image(img,x,y); 
  }
  
  public boolean over()
  {
     if(mouseX < x || mouseX > x + w)
       return false;
       
     if(mouseY < y || mouseY > y + h)
       return false;   
     
     return true;
  }
  
}

public void alocateMenu()
{ 
  //universal
  back = new Button[nrBack];
  back[0] = new Button(500,510,200,60);
  
  //principalMenu
  play = new Button(100,115,200,80);
  options = new Button(100,240,350,80);
  missions = new Button(100,360,410,70);
  exit = new Button(100,480,200,70);
  left = new Button(700,500,40,40,loadImage("images/player/menu/left.png"));
  right = new Button(1030,500,40,40,loadImage("images/player/menu/right.png"));
  
  //selectStory
  newGame = new Button(85,125,410,63);
  loadGame = new Button(90,205,453,80);
  
  //options
  music = new Button(546,116,62,51,loadImage("images/background/off_button.png"));
  soundFx = new Button(546,212,62,51,loadImage("images/background/off_button.png"));  
}

public void showPrincipalMenu()
{
  /*
   play.show();
   options.show(); 
   missions.show();
   exit.show();   
   */
   right.drawBtn();
   left.drawBtn();
        
}

public void showSelectStory()
{
  newGame.show();
  loadGame.show();
  back[0].show();
}

public void showOptions()
{
   /*     
     music.show();
     soundFx.show();
     back[0].show();
   */
   
   if(!closeSound)
   {
     music.drawBtn();
   }
  
   if(sFx)
   {
     soundFx.drawBtn(); 
   }        
}
int nrEnemyBullets = 0;

class Enemy
{
   PImage enemyImg;
   PImage bulletImg;
   int bulletX;
   int bulletY;
   boolean bullet = true;
   int nrLoop = 0;
   int enemyX = 0;
   int enemyY = 0;
   int enemyReward = 0;
   int enemyHealth = 0;
   int enemyHealthCopy = 0;
   boolean alive = true;
   int enemyInitialX = 0;
   int enemyInitialY = 0;
   int state = 1;
   
   
   Enemy(int eX, int eY, int eR, int eH, PImage eI,PImage bI)
   {
      state = PApplet.parseInt(random(1,4));
      enemyImg = eI;
      bulletImg = bI;
      enemyX = eX;
      enemyY = eY;
      enemyReward = eR;
      enemyHealth = eH;
      enemyHealthCopy = eH;
      enemyInitialX = eX;
      enemyInitialY = eY;
      bulletX = enemyX;
      bulletY = enemyY;
      nrLoop = PApplet.parseInt(random(30,50));
   }
   
   public void drawEnemy()
   {
      if(!bullet)
      {
         shootToPlayer(); 
      }
      else
      {
       bulletY = enemyY;
       bulletX = enemyX; 
      }
     
      if(!alive)
         return;
      imageMode(NORMAL);
      image(enemyImg, enemyX, enemyY);
      
      //ma pregatesc sa trag catre player

      if(numSec() || glont)
      {
         if(random(1) >= 0.3f && bullet)
         {
          nrEnemyBullets++;
          bullet = false;
          glont = false;
          prevMin = minute();
          prevSec = second();
          totalSec = 0;
         } 
      }
   }
   
   public void shootToPlayer()
   {
       if(bulletY > 720 || (!alive && enemyX == bulletX && enemyY == bulletY))
       {
          nrEnemyBullets--;
          bulletX = enemyX;
          bulletY = enemyY;
          bullet = true;
          return; 
       }
       imageMode(NORMAL);
       image(bulletImg,bulletX,bulletY);
       bulletY++;
   }
   
   public void takeDamage(int amount)
   {
       if(alive)
       {
         enemyHealth -= amount;
         if(enemyHealth <= 0)
         {
           enemyHealth = 0;
           player.playerScore += enemyReward;
           alive = false;           
           enemyDeath++; 
         }
       }
   }     
   
   public void animEnemy()
   {
       switch(state)
       {
         case 1:
           
           if(enemyY < enemyInitialY + 40)
             enemyY++;
           else
             state++;           
           break;
          
          case 2:
            if(enemyX < enemyInitialX + 40)
              enemyX++;
            else
              state++; 
           break;
          
          case 3:
            if(enemyY > enemyInitialY)
              enemyY--;
            else
              state++;
           break;
          
          case 4:
           if(enemyX > enemyInitialX)
             enemyX--;
           else
             state = 1;
           break;
           
          default:
            println("mutare incorecta");
       }
   }
   
   public void reset()
   {
      enemyHealth = enemyHealthCopy;
      alive = true; 
   }     
}

public void alocateEnemy()
{
    PImage eI = loadImage("images/enemy/enemy1.png");
    PImage bI = loadImage("images/enemy/enemyBullet.png");
    enemyNumber = PApplet.parseInt(random(1, 16));
    enemyNumber = level[currentLevel].getMonsters();
    enemy = new Enemy[16];
    for(int i = 0; i < enemyNumber; i++)
     {
       if(i < 8)
         enemy[i] = new Enemy(190 + i * 120, 30, 10, 10,eI,bI);
       else
         enemy[i] = new Enemy(190 + (i - 8) * 120, 150, 10, 10,eI,bI);
     }
}

public void animateEnemy()
{
  for(int i = 0; i < enemyNumber; i++)
    enemy[i].animEnemy();
}
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

public void loadImages()
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

public void drawBackground()
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


public void keyPressed()
{ 
  if(key == '\n' && (CurrentMenu != "story" && CurrentMenu != "NewChapter"))
  {
    robot.mouseMove(width/2, height - player.playerImage.height/4);
    CurrentMenu = "story";    
    resetGame();
    return;
  }
    
   if(key == 'm')
   {
     closeSound = !closeSound;
     if(closeSound)
     {
       audioPlayer.pause();
     }
     else
     {
        audioPlayer.loop();
        audioPlayer.rewind();
     }     
   } 
  
  if(key == 27)// aici se opreste folosirea tastei esc pentru a iesi din joc
   {
     key = 0;

     if(CurrentMenu == "over" || CurrentMenu == "story" || CurrentMenu == "gameFinished" || CurrentMenu == "selectStory")
     {
        CurrentMenu = "PrincipalMenu";
        return;
     }
         
     if(CurrentMenu == "PrincipalMenu")
     {       
       exit();
       return;
     }
     
   }  
}

public void resetGame()
{
    Player auxP = new Player("Stefan", player.playerImage, player.bulletImage, 50,5,"sounds/gun/laser.mp3","sounds/player/playerDeath.mp3");
    player = auxP;    
    enemyDeath = 0;
    println("enemyNumber= " + enemyNumber);
    for(int i = 0; i < enemyNumber; i++)
     {
       Enemy auxE;
       if(i < 8)
         auxE = new Enemy(190 + i * 120, 30, 10, 10,enemy[0].enemyImg,enemy[0].bulletImg);
       else
         auxE = new Enemy(190 + (i - 8) * 120, 150, 10, 10,enemy[0].enemyImg,enemy[0].bulletImg);
       println("i= " + i);
       enemy[i] = auxE;       
     }  
    nrEnemyBullets = 0; 
}
int currentLevel = 0;
int nrLevels = 20;
Level[] level;
String message = "";

class Level
{
   int nrWave = 0;
   int nrMonsters = 0;
   int currentWave = 0;
   
   Level(int nrWave1, int nrMonsters1)
   {
       nrWave = nrWave1;
       nrMonsters = nrMonsters1;
   }
   
   public boolean complete()
   {
      return (nrWave == currentWave); 
   }
   
   public int getMonsters()
   {      
     return nrMonsters; 
   }
}

public void createLevels()
{
   level = new Level[nrLevels];
   
   //incalzire
   level[0] = new Level(1,2);
   
   //usor
   level[1] = new Level(1,4);
   level[2] = new Level(2,4);
   level[3] = new Level(2,6);
   level[4] = new Level(3,6);
   level[5] = new Level(3,8);
   
   //mediu
   level[6] = new Level(2,8);
   level[7] = new Level(4,8);
   level[8] = new Level(3,10);
   level[9] = new Level(2,12);
   level[10] = new Level(3,12);
   
   //greu
   level[11] = new Level(4,12);
   level[12] = new Level(5,12);
   level[13] = new Level(4,14);
   level[14] = new Level(6,14);
   level[15] = new Level(5,16);
   
   //foarte greu
   level[16] = new Level(7,10);
   level[17] = new Level(8,12);
   level[18] = new Level(9,14);
   level[19] = new Level(10,16); 
      
}
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
  
  public void drawPlayer()
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
  
  public void updatePosition()
  {    
    playerX = mouseX;    
    playerY = mouseY;
  }
  
  public void playSound()
  {
     if(!sFx)
       return;
     fireSound.play();
     fireSound.rewind(); 
  }
  
  public void death()
  {
     if(!sFx)
       return;
     deathSound.play();
     deathSound.rewind(); 
  }
  
  public void shoot()
  {
    if(numBullets > 0)
      if(fireRate > 0)
         return;
    playSound();
    bulletX.append(mouseX);
    bulletY.append(playerY);
    numBullets++;
  }
  
  public void fire()
  {
    for(int i = 0; i < numBullets; i++)
    {
       bulletY.set(i, bulletY.get(i) - bulletSpeed);
       imageMode(CENTER);
       image(bulletImage, bulletX.get(i), bulletY.get(i));          
    }
  }
  
  public void deleteBullet()
  {
    for(int i = 0; i < numBullets; i++)
      if(bulletY.get(i) < 0)
        {
           bulletX.remove(i);
           bulletY.remove(i); 
           numBullets--;
        }
  }
  
  public void deleteBulletOnContact(int index)
  {
     bulletX.remove(index);
     bulletY.remove(index); 
     numBullets--;
  }
  
  public void clearAllBullets()
  {
     for(int i = 0; i < numBullets; i++)
        deleteBulletOnContact(i); 
  }
   
}

public void showPlayerImage(int nr,int x, int y)
{
  player.playerImage = players2[nr];
  image(players[nr],x,y);
}

public void alocatePlayer()
{
   PImage playerImg;
   PImage bulletImg;   
   playerImg = loadImage("images/player/player1.png");
   bulletImg = loadImage("images/player/bullet2.png");
   player = new Player("Stefan", playerImg, bulletImg, 50,5,"sounds/gun/laser.mp3","sounds/player/playerDeath.mp3"); 
}
public int sketchWidth() {
  return 1200;
}
 
public int sketchHeight() {
  return 720;
}

public void getResolution()
{
   ScreenWidth = width;
   ScreenHeight = height; 
}

public void changeAppIcon(PImage img) {
  final PGraphics pg = createGraphics(16, 16, JAVA2D);

  pg.beginDraw();
  pg.image(img, 0, 0, 16, 16);
  pg.endDraw();

  frame.setIconImage(pg.image);
}
Minim minim = new Minim(this);
AudioPlayer audioPlayer;

boolean playing = false;
boolean closeSound = false;

public void gameSound()
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
Robot robot;
boolean storyStarted = false;
boolean chapter = false;

public void story()
{ 
  //set mouse position to bottom    
  if(!storyStarted)
  {   
      //println("story started");
      robot.mouseMove(width/2, height - player.playerImage.height/4);
      
  }
 // println("nrEnemyBullets: " + nrEnemyBullets);
  
  drawStoryBackground();
  newLevel();
  
  if(chapter)
    {
      player.clearAllBullets();      
      CurrentMenu = "NewChapter";
      robot.mouseMove(width/2, height - player.playerImage.height/4);
      return;
    }
   
  fireRate++;
  
  if(fireRate > 15)
  {
   fireRate = 0; 
  }
  
  //fireRate %= 15;
  if(mousePressed)
  {
    player.updatePosition();
    player.shoot();
  }
  player.updatePosition();
  player.deleteBullet();
  player.fire();
  drawStoryEnemy();
  player.drawPlayer();
  enemyColision();
  storyStarted = true;
}

public void newLevel()
{  
   if(enemyDeath != enemyNumber)
     return; 
     
   chapter = true;  
   
   nrEnemyBullets = 0;
   
   level[currentLevel].currentWave++;
   message = "finished wave " + level[currentLevel].currentWave + " on level " + (currentLevel + 1); 
   if(level[currentLevel].complete())
   {
     currentLevel++;
     saveGame();
     message = "finished level " + currentLevel;         
   }
   
   enemyNumber = level[currentLevel].getMonsters();
   enemyDeath = 0;
   prepareNewLevel();  
}

public void prepareNewLevel()
{
    Enemy []auxVct = new Enemy[enemyNumber];
    for(int i = 0; i < enemyNumber; i++)
     {
       Enemy auxE;
       if(i < 8)
         auxE = new Enemy(190 + i * 120, 30, 10, 10,enemy[0].enemyImg,enemy[0].bulletImg);
       else
         auxE = new Enemy(190 + (i - 8) * 120, 150, 10, 10,enemy[0].enemyImg,enemy[0].bulletImg);
       auxVct[i] = auxE;
     } 
   enemy = auxVct;  
}

public void drawStoryEnemy()
{
  for(int i = 0; i < enemyNumber; i++)
    enemy[i].drawEnemy();
  animateEnemy();
}

public void enemyColision()
{
   int i;
   int bulletVfX = 0;
   int bulletVfY = 0;   
   for(i = 0; i < player.numBullets; i++)
   {
      bulletVfY = player.bulletY.get(i) - player.bulletImage.width / 2;//pozitia pe axa OY
      bulletVfX = player.bulletX.get(i) - player.bulletImage.width / 2;//pozitia pe axa OX 
      for(int j = 0; j < enemyNumber; j++)
      {
          if(bulletVfY <= enemy[j].enemyY + 80 && bulletVfY >= enemy[j].enemyY)
          {     
            if(bulletVfX >= enemy[j].enemyX && bulletVfX <= enemy[j].enemyX + 80)
            {
               if(enemy[j].alive)
               {
                 enemy[j].takeDamage(player.damage);
                 player.deleteBulletOnContact(i);
               }           
            }  
          }
      }                
   }
   
   //verific daca player-ul s-a lovit un inamic
   for(int j = 0; j < enemyNumber; j++)
   {
      if( (mouseY - 44 <= enemy[j].enemyY + 80 && mouseY - 44 >= enemy[j].enemyY) || (mouseY + 44 <= enemy[j].enemyY + 80 && mouseY + 44 >= enemy[j].enemyY) )
      {     
        if( (mouseX - 49 >= enemy[j].enemyX && mouseX - 49 <= enemy[j].enemyX + 80) || (mouseX + 49 >= enemy[j].enemyX && mouseX + 49 <= enemy[j].enemyX + 80) )
        {
            //inacmicul a fost lovit si trebuie sa moara
            if(enemy[j].alive && storyStarted)
            {
              player.playerScore -= enemy[j].enemyReward;
              enemy[j].takeDamage(enemy[j].enemyHealth);
              player.life--; 
              player.death();              
              robot.mouseMove(600, 720);              
            }   
        }  
      } 
   }
   
   //verific daca player-ul a fost lovit de un inamic
   for(i = 0; i < enemyNumber; i++)
   {
     if(!enemy[i].bullet)
     {
         if(enemy[i].bulletX >= player.playerX - 49 && enemy[i].bulletX <= player.playerX + 49)
         {
            if(enemy[i].bulletY + 38 >= player.playerY - 44 && enemy[i].bulletY <= player.playerY + 44)
            {
               //inamicul a lovit player-ul
               if(storyStarted)
               {
                 player.life--;
                 player.death();
                 enemy[i].bullet = true;
                 enemy[i].bulletY = 720;
                 robot.mouseMove(600, 720);
               }               
            } 
         }
     }
   }
}

public void drawStoryBackground()
{
  background(255);
  imageMode(NORMAL);
  int onWidth = 0;
  int onHeight = 0;
  
  //stars
  
  if(width % bg.width == 0)
    onWidth = width / bg.width;
  else
    onWidth = width / bg.width + 1;
    
  if(height % bg.height == 0)
    onHeight = width / bg.height;
  else
    onHeight = width / bg.height + 1;
    
  for(int i = 0; i < onWidth; i++)
    for(int j = 0; j < onHeight; j++)
    {
        image(bg, i*bg.width, j*bg.height);
    } 
   
   //clouds 
   
   if(cloudsDelay % 100 == 0)
   {
     addClouds();
     cloudsDelay = 0;
   }
   cloudsDelay++; 
   drawClouds();
   moveClouds();
   deleteClouds();
}

public void addClouds()
{
    if(cloudsNumber < maxClouds)
    {
       int cx = PApplet.parseInt(random(width));
       int cy;
       if(cloudsNumber == 0 || cloudsNumber > 0 && cloudY.min() > 600)
         cy = 0 - cloud.height/2 - 1;
       else
         cy = cloudY.min() - 250;
       cloudX.append(cx);
       cloudY.append(cy);
       cloudsNumber++; 
    }
}

public void deleteClouds()
{
   for(int i = 0; i < cloudsNumber; i++)
   {
     if(cloudY.get(i) - cloud.height / 2 + 1 > height)
     {
      cloudY.remove(i);
      cloudX.remove(i);
      cloudsNumber--; 
     }
   } 
}

public void drawClouds()
{
   imageMode(CENTER);
   for(int i = 0; i < cloudsNumber; i++)
   {
     tint(128, 50);
     image(cloud, cloudX.get(i), cloudY.get(i));
   } 
   noTint();
}

public void moveClouds()
{
   for(int i = 0; i < cloudsNumber; i++)
      cloudY.increment(i); 
}

public void saveGame()
{
    PrintWriter out = createWriter(filePath);
    out.println(currentLevel);
    out.close();
}

public void loadGame()
{
  File file = new File(sketchPath(filePath));
  InputStream in = createInput(filePath);
  if(file.exists())
  {       
    try
    {      
      int data =in.read();
      
      currentLevel = data - '0'; 
      while(data != -1)
      {
        data = in.read();
        if(data >= 48 && data <= 57)
        {
          currentLevel *= 10;
          currentLevel += data - '0';
        } 
      }
    }catch (IOException e)
    {
      e.printStackTrace();
    }
    
    finally 
    {
      try 
      {
        in.close();
      } 
      catch (IOException e) 
      {
        e.printStackTrace();
      }
    }
  }
  else
  {
    //nu am gasit fisierul cu salvariel jocului
    currentLevel = 0;    
  }  
}

int prevMin = -1;
int prevSec = -1;
int totalSec = 0;

int lastMin = -1;
int lastSec = -1;

boolean glont = false;

public boolean numSec()
{
   int min = minute();
   int sec = second();
   if(prevMin == -1)
   {
      prevMin = min;
      prevSec = sec;
      //println("nu: 0");
      return false;
   }
  
   totalSec = (min - prevMin) * 60 + sec - prevSec;
   glont = totalSec > 3;
   
   if(totalSec > 7)
    {
      prevMin = min;
      prevSec = sec;
     // println("da");
      return true;      
    }
    //println("nu: " + totalSec);
   return false; 
}

public int time()
{
   int min = minute();
   int sec = second();
   if(lastMin == -1)
   {
      lastMin = min;
      lastSec = sec;
      return 0; 
   }
   int total = (min - lastMin) * 60 + sec - lastSec; 
   return total;
}
int ScreenWidth = displayWidth;
int ScreenHeight = displayHeight;

String CurrentMenu = "PrincipalMenu";
String storyMessage = "";

int currentPlayer = 0;

Player player;
Enemy []enemy;

int enemyNumber = 0;
int enemyDeath = 0;
int textSize = 128;

//save game
String filePath = "save/save.txt";

//meniu
PImage menuBg;
PImage optionsBg;
PImage missionsBg;
PImage selectStoryBg;
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "infinity" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

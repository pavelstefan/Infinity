import ddf.minim.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.io.DataInputStream;
import java.io.FileInputStream;

void setup()
{
  //rezolutia se seteaza automat in fisierul setResolution
  loadImages();
  loadGame();
  createLevels();
  alocatePlayer();  
  alocateEnemy();
  alocateMenu(); 
  alocateBonus();  
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

void draw()
{  
  getResolution();  
  findMenu();
}

void findMenu()
{
    if(player.life <= 0 && CurrentMenu == "story")
    {
      CurrentMenu = "over";
      enemyDeath = enemyNumber;
      enemyNumber = int(random(1,16));
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
    
    println("meniul " + CurrentMenu + " nu exista");
}


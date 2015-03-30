int opacity = 256;
boolean show = false;

void gui(String name, int dim,boolean p)
{
    if(p)
      pulsate();
    textSize(dim);
    int tw = int(textWidth(name));
    fill(250,0,0, opacity);
    tint(255, 25);
    text(name, width/2 - tw / 2, height/2);
    noTint();
    noFill();
}

void pulsate()
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

void mouseReleased()
{
   liber = false; 
}

void mouseClicked()
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
          enemyNumber = level[currentLevel].getMonsters();
          CurrentMenu = "story"; 
          player.life = 3;//resetez viata jucatorului la 3 daca incepe un joc nou
       }
       
       if(loadGame.over() && currentLevel >= 0)
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

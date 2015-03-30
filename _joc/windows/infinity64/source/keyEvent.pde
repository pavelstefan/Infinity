void keyPressed()
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

void resetGame()
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

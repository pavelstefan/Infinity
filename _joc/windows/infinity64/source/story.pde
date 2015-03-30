Robot robot;
boolean storyStarted = false;
boolean chapter = false;

void story()
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

void newLevel()
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

void prepareNewLevel()
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

void drawStoryEnemy()
{
  for(int i = 0; i < enemyNumber; i++)
    enemy[i].drawEnemy();
  animateEnemy();
}

void enemyColision()
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

void drawStoryBackground()
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

void addClouds()
{
    if(cloudsNumber < maxClouds)
    {
       int cx = int(random(width));
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

void deleteClouds()
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

void drawClouds()
{
   imageMode(CENTER);
   for(int i = 0; i < cloudsNumber; i++)
   {
     tint(128, 50);
     image(cloud, cloudX.get(i), cloudY.get(i));
   } 
   noTint();
}

void moveClouds()
{
   for(int i = 0; i < cloudsNumber; i++)
      cloudY.increment(i); 
}

void saveGame()
{
    PrintWriter out = createWriter(filePath);
    out.println(currentLevel);
    out.close();
}

void loadGame()
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


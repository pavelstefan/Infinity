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
      state = int(random(1,4));
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
      nrLoop = int(random(30,50));
   }
   
   void drawEnemy()
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
         if(random(1) >= 0.3 && bullet)
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
   
   void shootToPlayer()
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
   
   void takeDamage(int amount)
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
   
   void animEnemy()
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
   
   void reset()
   {
      enemyHealth = enemyHealthCopy;
      alive = true; 
   }     
}

void alocateEnemy()
{
    PImage eI = loadImage("images/enemy/enemy1.png");
    PImage bI = loadImage("images/enemy/enemyBullet.png");
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

void animateEnemy()
{
  for(int i = 0; i < enemyNumber; i++)
    enemy[i].animEnemy();
}

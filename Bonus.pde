int auxMin = -1;
int auxSec = -1;
boolean bonus = false;

class Bonus
{
  int x = 0,y = 0;
  int amount = 0;
  PImage img;
  boolean used = false;
  int lastPlayerScore = 0;
  
  Bonus(int val, PImage img1)
  {      
      amount = val;
      img = img1;
      used = false;
  }  
  
  void drawBonusImg()
  {
     if(used || player.playerScore == 0)
       return;
     imageMode(NORMAL);
     image(img, x, y);
     
     if(touched())
     {
        used = true;
        bonus = false;
        player.life++; 
     }
     
     y += 2; 
  
    if(y > 750)
    {
      used = true;
      bonus = false;
    }
    
  }
  
  void generateX()
  {
     x = int(random(100, 1100)); 
  }
  
  boolean touched()
  {
    if(x + 32 < player.playerX - 49 || x > player.playerX + 49)
      return false;
    
    if(y + 32 < player.playerY - 44 || y > player.playerY + 44)
      return false;
     
    return true;
  }
  
}

void alocateBonus()
{
  bonusLife = new Bonus(1, bonusLifeImg); 
}

void bonusController()
{
    if(auxMin == -1)
    {
      auxMin = minute();
      auxSec = second();     
    } 
    
    if(!bonus)
    {
       if(time2(auxMin, auxSec) >= 5 && (player.playerScore > bonusLife.lastPlayerScore && player.playerScore % 35 == 0))
       {   
          Bonus auxLife = new Bonus(1, bonusLifeImg);
          bonusLife = auxLife;
          auxMin = minute();
          auxSec = second();
          bonus = true;
          bonusLife.generateX();
          bonusLife.lastPlayerScore = player.playerScore;
       }  
    }
    else
      bonusLife.drawBonusImg();
}

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
  
  void show()
  {
     stroke(255,0,0);
     noFill();
     rect(x,y,w,h); 
  }

  void drawBtn()
  {
     image(img,x,y); 
  }
  
  boolean over()
  {
     if(mouseX < x || mouseX > x + w)
       return false;
       
     if(mouseY < y || mouseY > y + h)
       return false;   
     
     return true;
  }
  
}

void alocateMenu()
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

void showPrincipalMenu()
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

void showSelectStory()
{
  newGame.show();
  loadGame.show();
  back[0].show();
}

void showOptions()
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

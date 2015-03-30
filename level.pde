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
   
   boolean complete()
   {
      return (nrWave == currentWave); 
   }
   
   int getMonsters()
   {      
     return nrMonsters; 
   }
}

void createLevels()
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

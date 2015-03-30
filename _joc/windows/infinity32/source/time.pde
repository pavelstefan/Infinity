int prevMin = -1;
int prevSec = -1;
int totalSec = 0;

int lastMin = -1;
int lastSec = -1;

boolean glont = false;

boolean numSec()
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

int time()
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

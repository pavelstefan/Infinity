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

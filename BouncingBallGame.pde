//woking latest 09/11/11
Ball[] Balls;
final int BALL_RADIUS = 25;
final float ACCRELATION = 0.63;
final float FRICTION = 0.80;

boolean GameOver, MouseIsPressed;

float PercentOfBallsPoped, BallsPoppedCounter;
int PopperPosition, Score, Level;
int NumberOfLevels = 10;//please change this is you wish to test for more levels

class Ball {
  int X; //x location of ball
  float  Y; //y location of ball
  float Speed;
  color BallColor;
  int PointValue;
  int TempPointValue; // this will keep a copy on point value 
  int Bounces;

  boolean BallState; // if its true the ball is alive, otherwize its dead

  Ball(int locX, float locY, color pColor, int pPoint) {
    X = locX; 
    Y = locY;
    Speed = 0;
    BallColor = pColor;
    PointValue = pPoint;
    Bounces = 0;
    BallState = true;
  }
}

void checkBounce(Ball b) {
  // deals with when the ball touches the floor
  if (b.Y + BALL_RADIUS>= height)
  {
    b.Y = height - BALL_RADIUS ;// this will make sure the ball touches the floor
    b.Speed = -b.Speed * FRICTION; //use the friction to slow the ball after each bounce

    b.Bounces++;//increase the # of bounce
  }
}

void advance(Ball b) {
  //advance the location of Ball b based on it's current speed and direction

  //increses velocity
  b.Speed += ACCRELATION;

  //increases the position of the ball.
  b.Y += b.Speed;
}

void drawBall(Ball b) {

  stroke(b.BallColor);
  fill(b.BallColor);
  ellipse(b.X, b.Y, 2*BALL_RADIUS, 2*BALL_RADIUS);
}

//draws the popper at the given mouse position
void DrawPopper(int X)
{
  fill (0);//black
  stroke (0);//black
  triangle (X, height-20, X+10, height-10, X-10, height-10);
  rect (X-20, height, 40, -10);
}

void BallToText (Ball b)
{
  //converts ball to text displaying its value
  fill(b.BallColor);
  b.Y = b.Y - 5;
  textAlign(CENTER, CENTER);
  text(b.PointValue + " PTS.", b.X, b.Y);
}

boolean BallPoped(Ball b)
{
  boolean returnValue = false;

  //only return true if the poper is touching a live ball, the poper can not touch a dead ball.
  if ((dist(b.X, b.Y, mouseX, height-20) < BALL_RADIUS) && (b.BallState))
  {
    returnValue = true;
    BallsPoppedCounter ++;//counts the balls popped
    //b.BallState = false;//kill the ball after
  }
  return returnValue;
}

//starts the gmae based on the level#
void TheGame()
{
  int AmountOfBalls = 2*(int)Level;

  for (int i=0; i<AmountOfBalls; i++) {
    //if ball is alive (not poped)continue as normal
    if ((Balls[i].BallState)&&(!(BallPoped(Balls[i]))))
    {
      //this swith statment changes the colors, point value, and ball state accordingly based on the bounce
      switch (Balls[i].Bounces)
      {
      case 1:
        Balls[i].BallColor = color(255, 255, 000);//yelow
        Balls[i].PointValue = 40;
        break;
      case 2:
        Balls[i].BallColor = color(255, 165, 000);//orange
        Balls[i].PointValue = 30;
        break;   
      case 3:
        Balls[i].BallColor = color(255, 000, 000);//red
        Balls[i].PointValue = 20;
        break;
      case 4:
        Balls[i].BallColor = color(190, 190, 190 );//grey
        Balls[i].PointValue = 10;
        break;
      case 5:
        Balls[i].PointValue = 0;
        Balls[i].BallState = false; // the ball is dead.
        break;
      }

      //drawBall
      drawBall(Balls[i]);

      //check for bouncing.
      checkBounce(Balls[i]);

      //advance ball
      advance(Balls[i]);
    }
    else// the ball is dead otherwize.
    {//if the ball just poped and was not dead already then only ad point to the score, we dont want to add point for a dead ball.
      if ((Balls[i].BallState)&&(BallPoped(Balls[i])))
      {
        Score += Balls[i].PointValue;
      }           
      Balls[i].BallState = false; // after adding the score make the ball dead

      if (Balls[i].PointValue>0)//only displays positive non zero scores
        BallToText(Balls[i]);
    }
  }
}

boolean AllBallsDead()
{
  boolean returnValue = false;
  int AmountOfBalls = 2*(int)Level;
  int AllBallsCumulativeValue = 0; 

  for (int i=0; i<AmountOfBalls; i++)
  {// we will only alter the TempPointValue variable because we are already using the PointValue Variable elsewhere
    if ((!Balls[i].BallState)&&(Balls[i].Y <0))//this will make sure the text is always displayed until its of the window // if the ball is dead
    {
      Balls[i].TempPointValue = 0;
    }
    else
    {
      Balls[i].TempPointValue = Balls[i].PointValue;
    }
    //if not all the baklls are dead this will !=0, otherwise it will be zero and the level is over
    AllBallsCumulativeValue +=Balls[i].TempPointValue;
    
  }
  if (AllBallsCumulativeValue == 0)
  {
    returnValue = true;
  }

  return returnValue;
}

void mousePressed()
{
  MouseIsPressed = true;
}
void mouseReleased()
{
  MouseIsPressed = false;
}

void setup() {

  size(1024, 600);

  PFont font = loadFont("ComicSansMS-Bold-32.vlw");
  textFont(font);

  GameOver = false;
  MouseIsPressed = false;

  BallsPoppedCounter = 0;

  Score = 0;
  Level = 1;

  Balls = new Ball[2*NumberOfLevels]; // assuming there are x numer of levels the balls should be twice as much

  for (int i=0; i<Balls.length; i++)
    Balls[i] = null; // we will will these up later;

  //start the ball above the screen, at a random x & y position.
  //origanally the ball in green, with a point value of 50.
  //this is for level one
  for (int i=0; i<2*Level; i++)
  {
    Balls[i] = null; // get rid of the values assigned by the previous level
    Balls[i] = new Ball((int)(random(width - 2*BALL_RADIUS + 1) + BALL_RADIUS), -(random(height - 2*BALL_RADIUS + 1) + BALL_RADIUS), color(0, 255, 0), 50);
  }
}

void draw() {

  background(255);//white color

  PopperPosition = mouseX;

  boolean LevelIsOver = AllBallsDead ();
  PercentOfBallsPoped = (BallsPoppedCounter/2) / (float)(2*Level)*100;
  println("BallsPoppedCounter: " + BallsPoppedCounter/2 + " Total Balls: " + (2*Level) + "Pecent popped: " + PercentOfBallsPoped);

  if ((!LevelIsOver)&&(!GameOver))
  {
    TheGame ();
  }
  else
  {
    if (Level > NumberOfLevels-1)
    {
      GameOver = true;
    }
    else
    {
      if ((LevelIsOver)&&(PercentOfBallsPoped < 50))
      {
        GameOver = true;
      }
      else
      {
        GameOver = false;
      }
    }

    if (GameOver)
    {
      background(0);//black
      fill (255); //white
      textAlign(CENTER, CENTER);
      text("GAME OVER!", width/2, height/2 - 64);
      text("Final Score: " + Score, width/2, height/2);
      text("(click to start new game)", width/2, height/2 + 64);
      textAlign(LEFT, LEFT);
      if (MouseIsPressed)
      { //restart the game
        Level = 1;
        Score = 0;
        BallsPoppedCounter = 0;
        GameOver = false;
        for (int i=0; i<2*Level; i++)
        {
          Balls[i] = null; // get rid of the values assigned by the previous level
          Balls[i] = new Ball((int)(random(width - 2*BALL_RADIUS + 1) + BALL_RADIUS), -(random(height - 2*BALL_RADIUS + 1) + BALL_RADIUS), color(0, 255, 0), 50);
        }
      }
    }
    else
    {
      if (PercentOfBallsPoped >= 50)
      {
        fill (0); //black
        textAlign(CENTER, CENTER);
        text("LEVEL FINISHED!", width/2, height/2 - 64);
        text(PercentOfBallsPoped + "% Popped", width/2, height/2);
        text("(click to start next level)", width/2, height/2 + 64);
        textAlign(LEFT, LEFT);
        if (MouseIsPressed)
        {          
          Level++;
          BallsPoppedCounter = 0; 
          //start the ball above the screen, at a random x & y position.
          //origanally the ball in green, with a point value of 50.
          //this is for level one
          for (int i=0; i<2*Level; i++)
          {
            Balls[i] = null; // get rid of the values assigned by the previous level
            Balls[i] = new Ball((int)(random(width - 2*BALL_RADIUS + 1) + BALL_RADIUS), -(random(height - 2*BALL_RADIUS + 1) + BALL_RADIUS), color(0, 255, 0), 50);
          }
        }
      }
    }
  }

  DrawPopper (PopperPosition); // draws popper based on mouse

  //updates score after collision occurs
  fill(0);
  textAlign(LEFT, CENTER);
  text("Score: " + Score, 32, 32);

  //level
  fill(0);
  textAlign(RIGHT, CENTER);
  text("Level: " + Level, width - 32, 32);
}


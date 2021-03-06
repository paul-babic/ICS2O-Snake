/** SNAKE – an iteration of the simple game made by Nokia (1998)
 * @author Pauly B
 * @since 2016-06-08
 * @version 1.0
 */
 
import java.util.LinkedList;
import java.util.Random;
import processing.sound.SoundFile;
 
// game constants, used to make sizing dynamic... WORK IN PROGRESS
final int BOX_SIZE = 20;
final int GRID_SIZE = 20;
final int SIDE_SPACE = 20;
final int FRAME_RATE = 10;

// Media files
SoundFile dead; // http://soundbible.com/1570-Death.html
SoundFile fruitEaten; // http://soundbible.com/1968-Apple-Bite.html
SoundFile musicLoopStart; // http://www.playonloop.com/2016-music-loops/dolphin-ride/
PImage doge; // http://static.memecdn.com/images/avatars/s_1138629_527bd33a08cd9.jpg

boolean musicStarted; // used so music file does not start every frame

int gameState;
LinkedList<Point> snake = new LinkedList(); // contains points found in the snake
Point fruit = new Point(1,1); // the x/y coordinates of the fruit
int previousDirection = Directions.NO_DIRECTION;
int direction = Directions.EAST;
int score;
Random n = new Random();
int randomX; int randomY; // to be used as determining points for fruit

void setup() {
  frameRate(FRAME_RATE);
  gameState=GameStates.START;
  surface.setResizable(false); // size is NOT dynamic
  surface.setSize(BOX_SIZE*GRID_SIZE+2*SIDE_SPACE, BOX_SIZE*GRID_SIZE+2*SIDE_SPACE); // set height and width to 440 x 440 pixels
  dead = new SoundFile(this, "dead.mp3");
  fruitEaten = new SoundFile(this, "fruit.mp3");
  musicLoopStart = new SoundFile(this, "start.mp3");
  musicStarted = false; // startup music has not started
  doge = loadImage("doge.jpg");
}

void init(){
  snake.add(new Point(10, 10)); // make snake one box long to start, x:10 y:10
  score = 0;
  fruit.setX(n.nextInt(20)+1); // random number, max: GRID_SIZE min: 1
  fruit.setY(n.nextInt(20)+1);
}

void reset(){
  snake = new LinkedList(); // remove all points found on previous snake
}

void start1(){ // start is reserved word
  fill(255,0,0);
  textSize(64);
  text("SNAKE",10,60);
  textSize(18);
  text("V1.0 by Pauly B",50,120);
  text("Use the arrow keys (↑ ↓ ← →) to move",100,200);
  textSize(10);
  text("\"very snake\"",225,350);
  image(doge,300,300);
  delay(1500);
  textSize(12);
  text("Press the space bar to continue...",160,280);
  if(!musicStarted){
    musicLoopStart.loop();
    musicStarted=true;
  }
}

/* Main game loop */
void play(){
  musicLoopStart.stop();musicStarted=false; // stop music from start screen completely, reset music started variable
  if((checkCollision()||checkOOB())){
    dead.play();
    image(doge,300,300);
    textAlign(CENTER);
    text("has died.",200,200);
    textAlign(LEFT);
    delay(1500); // delay before end screen
    gameState = GameStates.END;
  }
  if(checkFruitCollected()){
    fruitEaten.play();
    score+=10;
    switch(direction){
      case Directions.NORTH:
      snake.add(new Point(snake.getLast().getX(),snake.getLast().getY()-1));break;
      case Directions.SOUTH:
      snake.add(new Point(snake.getLast().getX(),snake.getLast().getY()+1));break;
      case Directions.EAST:
      snake.add(new Point(snake.getLast().getX()+1,snake.getLast().getY()));break;
      case Directions.WEST:
      snake.add(new Point(snake.getLast().getX()-1,snake.getLast().getY()));break;
    }
    // println(score); // used for debugging only
    randomX = n.nextInt(20)+1; // random x coordinate used for fruit
    randomY = n.nextInt(20)+1; // random y coordainte used for fruit
    for(int i=0;i<snake.size();i++){
      if(snake.get(i).getX()==randomX&&snake.get(i).getY()==randomY){ // Make sure fruit will not be placed on a point already occupied by snake
        randomX = n.nextInt(20)+1;
        randomY = n.nextInt(20)+1;
      }
    }
    fruit.setX(randomX);
    fruit.setY(randomY);
  }
  // debugGrid(); // Used for debugging only
  drawBoundaries();
  drawSnake();
  drawFruit();
  move();
  text("Score: "+score,10,10);
}

/* Game over screen */
void end(){
  // STOP ALL SOUNDS
  dead.stop();
  fruitEaten.stop();
  musicLoopStart.stop();
  textSize(64);
  text("GAME OVER",10,60);
  textSize(18);
  text("Score: "+score,50,120);
  textSize(12);
  delay(1500);
  text("Press the space bar to continue...",160,280);
  
}

void draw() {
  background(0, 0, 0); // set the background to black
  switch(gameState){
    case GameStates.PLAY:
    play();break;
    case GameStates.START:
    start1();break;
    case GameStates.END:
    end();break;
  }
}

void keyPressed(){
  switch(gameState){
    case GameStates.START:
    if(key==' '){gameState = GameStates.PLAY;init();}break;
    case GameStates.PLAY:
    previousDirection=direction;
    if(keyCode==UP&&previousDirection!=Directions.SOUTH){direction=Directions.NORTH;}
    else if(keyCode==DOWN&&previousDirection!=Directions.NORTH){direction=Directions.SOUTH;}
    else if(keyCode==LEFT&&previousDirection!=Directions.EAST){direction=Directions.WEST;}
    else if(keyCode==RIGHT&&previousDirection!=Directions.WEST){direction=Directions.EAST;}break;
    case GameStates.END:
    if(key==' '){gameState = GameStates.START;reset();}break;
  }
}

/* Moves the snake one point in 'direction' direction */
void move(){
  switch(direction){
    case Directions.NORTH:
    if(direction!=Directions.SOUTH){snake.addFirst(new Point(snake.getFirst().getX(),snake.getFirst().getY()-1));}break; // move up, if not moving down
    case Directions.SOUTH:
    if(direction!=Directions.NORTH){snake.addFirst(new Point(snake.getFirst().getX(),snake.getFirst().getY()+1));}break; // move down, if not moving up
    case Directions.EAST:
    if(direction!=Directions.WEST){snake.addFirst(new Point(snake.getFirst().getX()+1,snake.getFirst().getY()));}break; // move x to the right, if not moving left
    case Directions.WEST:
    if(direction!=Directions.EAST){snake.addFirst(new Point(snake.getFirst().getX()-1,snake.getFirst().getY()));}break; // move x to the left, if not moving right
  }
  snake.removeLast(); // remove last node in snake
}

/* Checks to see if the snake has collected the fruit */
boolean checkFruitCollected(){
  for(int i=0;i<snake.size(); i++){
    if(snake.get(i).getX()==fruit.getX()&&snake.get(i).getY()==fruit.getY()){return true;} // return true if x and y values are the same
  }
  return false;
}

/* Checks to see if the snake has collided with itself */
boolean checkCollision(){ // check to see if the snake has collided with itself using nested for-loop
  for(int i=0; i<snake.size();i++){
    for(int j=0; j<snake.size(); j++){
      if(i!=j&&(snake.get(i).getX()==snake.get(j).getX()&&snake.get(i).getY()==snake.get(j).getY())){return true;} // i cannot equal j, will always return true
    }
  }
  return false;
}

/* Checks if the snake has exited the boundaries */
boolean checkOOB(){ // OOB = out of bounds
  for(int i=0;i<snake.size(); i++){
    if(snake.get(i).getX()>GRID_SIZE||snake.get(i).getX()<1||snake.get(i).getY()>GRID_SIZE||snake.get(i).getY()<1){return true;}
  }
  return false;
}

/* Iterates through each element of 'snake' and draws a square at each point on the screen */
void drawSnake() {
  stroke(255,255,255);
  fill(0,255,0);
  for(int i=0; i<snake.size();i++){ // iterate through points on snake
    rect(snake.get(i).getX()*BOX_SIZE,snake.get(i).getY()*BOX_SIZE,BOX_SIZE,BOX_SIZE); // args 1&2- place at intervals of 20px, args 3&4- width: 20px height: 20px
  }
}

/* Draws the fruit ellipse at the x/y coordinates specified in 'fruit' */
void drawFruit(){
  stroke(255,255,255);
  fill(255,0,0);
  ellipse(fruit.getX()*BOX_SIZE+BOX_SIZE/2,fruit.getY()*BOX_SIZE+BOX_SIZE/2,BOX_SIZE,BOX_SIZE);
};

/* Draws the red boundaries enclosing the snake */
void drawBoundaries() {
  stroke(255, 0, 0); // set color to red
  line(SIDE_SPACE, SIDE_SPACE, SIDE_SPACE, GRID_SIZE*BOX_SIZE+BOX_SIZE); // west
  line(SIDE_SPACE, SIDE_SPACE, GRID_SIZE*BOX_SIZE+BOX_SIZE, SIDE_SPACE); // north
  line(SIDE_SPACE, GRID_SIZE*BOX_SIZE+BOX_SIZE, GRID_SIZE*BOX_SIZE+BOX_SIZE, GRID_SIZE*BOX_SIZE+BOX_SIZE); // south
  line(GRID_SIZE*BOX_SIZE+BOX_SIZE, SIDE_SPACE, GRID_SIZE*BOX_SIZE+BOX_SIZE, GRID_SIZE*BOX_SIZE+BOX_SIZE); // east
}

/* Draws a grid within the red boundaries, used for debugging only */
void debugGrid() {
  stroke(255, 255, 255); // set color to white
  for (int i=0; i<=BOX_SIZE*GRID_SIZE; i+=BOX_SIZE) {
    line(i+BOX_SIZE, SIDE_SPACE, i+BOX_SIZE, BOX_SIZE*GRID_SIZE+SIDE_SPACE);
    line(SIDE_SPACE, i+BOX_SIZE, BOX_SIZE*GRID_SIZE+SIDE_SPACE, i+BOX_SIZE);
  }
}
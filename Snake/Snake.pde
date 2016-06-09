import java.util.LinkedList;

/** SNAKE – an iteration of the simple game made by Nokia (1998)
 * @author Pauly B
 * @since 2016-06-08
 * @version 1.0
 */

int gameState;
LinkedList<Point> snake = new LinkedList(); // contains points found in the snake

void setup() {
  gameState=GameStates.PLAY;
  surface.setResizable(false); // size is NOT dynamic
  surface.setSize(440, 440); // set height and width to 440 x 440 pixels
  snake.add(new Point(10, 10)); // make snake one box long to start, x:10 y:10
}

void start(){
  fill(255,255,255);
}

void play(){
  debugGrid();
  drawBoundaries();
  drawSnake();
}

void end(){
  
}

void draw() {
  background(0, 0, 0); // set the background to black
  switch(gameState){
    case GameStates.PLAY:
    play();break;
    case GameStates.START:
    start();break;
    case GameStates.END:
    end();break;
  }
}

void drawSnake() {
  stroke(255,255,255);
  fill(255,0,0);
  for(int i=0; i<snake.size();i++){ // iterate through points on snake
    rect(snake.get(i).getX()*20,snake.get(i).getY()*20,20,20); // args 1&2- place at intervals of 20px, args 3&4- width: 20px height: 20px
  }
};

void drawBoundaries() {
  stroke(255, 0, 0); // set color to red
  line(20, 20, 20, 420); // west
  line(20, 20, 420, 20); // north
  line(20, 420, 420, 420); // south
  line(420, 20, 420, 420); // east
}

void debugGrid() {
  stroke(255, 255, 255); // set color to white
  for (int i=0; i<=400; i+=20) {
    line(i+20, 20, i+20, 420);
    line(20, i+20, 420, i+20);
  }
}
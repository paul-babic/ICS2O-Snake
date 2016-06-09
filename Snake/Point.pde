class Point{
  private int xPos;
  private int yPos;
  
  public Point(int x, int y){
    xPos=x;
    yPos=y;
  }
  
  public void setX(int x){
    xPos=x;
  }
  
  public void setY(int y){
    yPos=y;
  }
  
  public int getX(){
    return xPos;
  }
  
  public int getY(){
    return yPos;
  }
}
class Person {
  int id;
  PVector lastPosition;
  PVector positionDelta;
  PVector[] lastPositions;
  boolean isAttentive;
  
  Person(int i, float x, float y){
    id = i;
    lastPosition = new PVector(x, y); 
    positionDelta = new PVector(x, y);
    lastPositions = new PVector[10];
  }
  
  int getId(){
    return id;
  }
  
  
  
}
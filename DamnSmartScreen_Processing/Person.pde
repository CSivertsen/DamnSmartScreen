class Person {
  int id;
  int posListSize = 10;
  PVector position;
  PVector lastPosition;
  PVector positionDelta;
  PVector[] lastPositions;
  boolean isAttentive;
  
  Person(int i, PVector p){
    id = i;
    position = p;
    lastPosition = position;
    positionDelta = PVector.sub(position,lastPosition);
    lastPositions = new PVector[posListSize];
    // initializing all the last positions to (0,0)
    for(int j = 0; j < posListSize; j++){
        lastPositions[j] = new PVector(0,0);
    }
  }
  
  int getId(){
    return id;
  }
  
  // updates position values of person object
  void setPosition(PVector p){
    position = p;
    positionDelta = PVector.sub(position,lastPosition);
    setLastPositions(p);
    lastPosition = position;
  }
  
  // adds new position to lastPositions array
  // and deletes oldest saved position
  void setLastPositions(PVector p){
    PVector[] newPositions = new PVector[posListSize];
    for(int i = 0; i < posListSize - 1; i++){
      if (i == 0) {
        newPositions[i] = p;
      } else {
      newPositions[i + 1] = lastPositions[i];
      }
    }
    lastPositions = newPositions;
  }
  
  PVector getPositionDelta(){
    return positionDelta;
  }
  
  PVector getLastPosition(){
    return lastPosition;
  }
  
  PVector[] getLastPositions(){
    return lastPositions;
  }
  
  void setAttention(boolean b){
    isAttentive = b;
  }
  
  boolean isAttentive(){
    return isAttentive;
  }
  
  void printInfo(){
    println("id: " + id);
    println("position:");
    printArray(position.array());
    println("lastPos:");
    printArray(lastPosition.array());
    println("posDelta:");
    printArray(positionDelta.array());
    for(int i = 0; i < posListSize; i++){
      println("lastPositions[" + i + "]");  
      println(lastPositions[i].array());
    }
  }
}
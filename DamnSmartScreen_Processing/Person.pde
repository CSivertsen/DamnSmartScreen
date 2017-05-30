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
    lastPositions = new PVector[posListSize];
  }
  
  int getId(){
    return id;
  }
  
  void setPosition(PVector p){
    position = p;
    positionDelta = PVector.sub(position,lastPosition);
    setLastPositions(p);
    lastPosition = position;
  }
  
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
}
class Person {
  int id;
  int posListSize = 100; // amount of lastPositions that are being stored
  PVector avPosition;
  boolean isAttentive;
  ArrayList<PVector> lastPositions = new ArrayList<PVector>();

  Person(int i, PVector p) {
    id = i;
    addPosition(p);
  }

  int getId() {
    return id;
  }
  
  void averagePosition(int avListSize) {
   float x = 0;
   float y = 0;
   if (avListSize < lastPositions.size()){
     avListSize = lastPositions.size();
   }
    for (int i = 0; i < avListSize; i++){
       PVector pos = lastPositions.get(i);
       x += pos.x;
       y += pos.y;
   }
   x /= lastPositions.size();
   y /= lastPositions.size();
   avPosition = new PVector(x,y);
  }

  // adds new position to lastPositions array
  // and deletes oldest saved position
  void addPosition(PVector p) {
    if (lastPositions.size() == 0) {
      lastPositions.add(p);
    } else if (lastPositions.size() > 0 && lastPositions.size() <= posListSize) {
      if (lastPositions.size() == posListSize) {
        lastPositions.remove(posListSize + 1);
      }
      lastPositions.add(0, p);
    }
  }

  PVector getAveragePosition() {
    return avPosition;
  }

  ArrayList getLastPositions() {
    return lastPositions;
  }

  void setAttention(boolean b) {
    isAttentive = b;
  }

  boolean isAttentive() {
    return isAttentive;
  }

  void printInfo() {
    println("id: " + id);
    println("avPosition:");
    println(avPosition.array()); 
    println("lastPositions:");
    println(lastPositions);
  }
}
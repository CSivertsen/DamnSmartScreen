class Person {
  int id;
  int posListSize = 10;
  PVector position;
  PVector lastPosition;
  PVector positionDelta;
  boolean isAttentive;
  ArrayList<PVector> lastPositions = new ArrayList<PVector>();

  Person(int i, PVector p) {
    id = i;
    position = p;
    lastPosition = position;
    positionDelta = PVector.sub(position, lastPosition);
    setLastPositions(p);
  }

  int getId() {
    return id;
  }

  // updates position values of person object
  void setPosition(PVector p) {
    lastPosition = position;
    position = p;
    positionDelta = PVector.sub(position, lastPosition);
    setLastPositions(p);
    //lastPosition = position;
  }

  // adds new position to lastPositions array
  // and deletes oldest saved position
  private void setLastPositions(PVector p) {
    if (lastPositions.size() == 0) {
      lastPositions.add(p);
    } else if (lastPositions.size() > 0 && lastPositions.size() < posListSize) {
      if (lastPositions.size() == posListSize) {
        lastPositions.remove(posListSize);
      }
      lastPositions.add(0, p);
    }
  }

  PVector getPositionDelta() {
    return positionDelta;
  }

  PVector getLastPosition() {
    return lastPosition;
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
    println("position:");
    println(position.array());
    println("lastPos:");
    println(lastPosition.array());
    println("posDelta:");
    println(positionDelta.array()); 
    println("lastPositions:");
    println(lastPositions);
  }
}
class Person {
  int id;
  int posListSize = 100; // amount of lastPositions that are being stored
  PVector avPosition;
  boolean isAttentive = true;
  ArrayList<PVector> lastPositions = new ArrayList<PVector>();
  boolean taken = false;
  int averageOver = 10;

  Person(int i, PVector p) {
    id = i;
    addPosition(p);
    println("New person created");
  }

  int getId() {
    return id;
  }

  void averagePosition(int avListSize) {
    float x = 0;
    float y = 0;
    if (avListSize < lastPositions.size()) {
      avListSize = lastPositions.size();
    }
    for (int i = 0; i < avListSize; i++) {
      PVector pos = lastPositions.get(i);
      x += pos.x;
      y += pos.y;
    
    x /= lastPositions.size();
    y /= lastPositions.size();
    avPosition = new PVector(x, y);
  }

  // adds new position to lastPositions array
  // and deletes oldest saved position
  void addPosition(PVector p) {
    if (lastPositions.size() == 0) {
      lastPositions.add(p);
    } else if (lastPositions.size() > 0 && lastPositions.size() <= posListSize) {
      if (lastPositions.size() == posListSize) {
        lastPositions.remove(posListSize - 1);
      }
      lastPositions.add(0, p);
    }
    averagePosition(averageOver);
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

  void show() {  // ADDED BY TEUN AND DAAN
  PVector pos = (PVector) getLastPositions().get(0);
    textAlign(CENTER);
    textSize(64);
    fill(0);
    text(id,pos.x,pos.y);
  }

  void become(Blob other) {
    PVector otherPos = new PVector((other.minx+other.maxx)/2,(other.miny+other.maxy)/2);
    addPosition(otherPos);
    //minx = other.minx;
    //maxx = other.maxx;
    //miny = other.miny;
    //maxy = other.maxy;
    //myPerson = other.myPerson; 
  }
  
  //Simple comparison based on ID
  boolean equals(Person other){
    if ( id == other.getId()){
      return true;
    } else {
      return false;
    }
  }
 
}
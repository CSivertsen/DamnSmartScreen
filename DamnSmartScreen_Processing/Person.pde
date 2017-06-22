class Person {
  int id;
  int posListSize = 100; // amount of lastPositions that are being stored
  PVector avPosition;
  int angle;
  boolean isAttentive = true;
  ArrayList<PVector> lastPositions = new ArrayList<PVector>();
  boolean taken = false;
  int averageOver = 30;
  StateManager sm;

  Person(int i, PVector p, StateManager _sm) {
    sm = _sm;
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
    if (avListSize > lastPositions.size()) {
      avListSize = lastPositions.size();
    }
    for (int i = 0; i < avListSize; i++) {
      PVector pos = lastPositions.get(i);
      x += pos.x;
      y += pos.y;
    }
    x /= avListSize;
    y /= avListSize;
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
    sm.setPoiAngle(getAngle(),this);
  }
  
  float getAngle() {
    float degMapped;
    
    PVector lastPos = (PVector) getLastPositions().get(0);
    //float transX = lastPos.x + (width/2);
    //float transY = lastPos.y + (height/2);
    PVector topPoint = new PVector (width/2, 0);
    PVector center = new PVector(width/2,height/2);
    PVector axis = PVector.sub(center, topPoint);
    PVector posFromCenter = PVector.sub(center, lastPos);
    
    //float rad = PVector.angleBetween(axis, posFromCenter);
    float rad = posFromCenter.heading();
    
    float deg = degrees(rad);
    
    if(deg < 0) {
      degMapped = map(deg, 0, -180, 359.999, 180.0001); 
    } else {
      degMapped = deg; 
    }
        
    //double deg = Math.atan2(transX, transY) * 180 / Math.PI;
    return degMapped;
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
    text(id, pos.x, pos.y);
  }

  void become(Blob other) {
    PVector otherPos = new PVector((other.minx+other.maxx)/2, (other.miny+other.maxy)/2);
    addPosition(otherPos);
    //minx = other.minx;
    //maxx = other.maxx;
    //miny = other.miny;
    //maxy = other.maxy;
    //myPerson = other.myPerson;
  }

  //Simple comparison based on ID
  boolean equals(Person other) {
    if (other != null) {
      if ( id == other.getId()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
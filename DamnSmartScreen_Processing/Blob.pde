// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/r0lvsMPGEoY

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

  int id = 0;
  int distThreshold = 180;

  boolean taken = false;
  
  //Person myPerson;

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    
    //myPerson = new Person(id, getCenter());
    //persons.add(myPerson);
  }

  void show() {
    stroke(0);
    fill(255, 100);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
    ellipseMode(CENTER);
    fill(0, 255, 0);
    ellipse((minx+maxx)/2, (miny+maxy)/2, 30, 30);

    //textAlign(CENTER);
    //textSize(64);
    //fill(0);
    //text(id, minx + (maxx-minx)*0.5, maxy - 10);
  }


  void setPos(float x, float y) {
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  void become(Blob other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
    //myPerson = other.myPerson; 
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  PVector getCenter() {
    float x = (maxx - minx)* 0.5 + minx;
    float y = (maxy - miny)* 0.5 + miny;    
    return new PVector(x, y);
  }

  int getId() {
    return id;
  }
  
  void setId(int _id) {
  id = _id;
  //myPerson.setId(id);
  }

  boolean isNear(float x, float y) {

    float cx = max(min(x, maxx), minx);
    float cy = max(min(y, maxy), miny);
    float d = distSq(cx, cy, x, y);

    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
  float distSq(float x1, float y1, float x2, float y2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
    return d;
  }


  float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
    return d;
  }
}
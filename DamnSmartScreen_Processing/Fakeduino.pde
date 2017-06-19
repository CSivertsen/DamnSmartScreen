//This class is solely used testing purposes, to emulate the behavior of the Arduino.  
class Fakeduino {
  long lastMove;
  float moveTime;
  QLearning q;

  Fakeduino(QLearning _q) {
    q = _q;
    move(q.getNextMove());
  }
  
  void move(int state){
   println("I moved to position " + state);
   lastMove = millis();
   moveTime = random(500, 2000);
  }
  
  void update(){
    if (millis() > lastMove + moveTime){
      move(q.getNextMove());
    }    
  }
  
}
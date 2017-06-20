//This class is solely used testing purposes, to emulate the behavior of the Arduino.  
class Fakeduino {
  long lastMove;
  float moveTime;
  QLearning q;
  StateManager sm;

  Fakeduino(QLearning _q, StateManager _sm) {
    q = _q;
    sm = _sm;
    move(q.getNextMove());
  }
  
  void move(int state){
   moveTime = random(500, 2000);
   println("I moved to position " + state);
   sm.setScreenAngle(state);
   lastMove = millis();
  }
  
  void update(){
    if (millis() > lastMove + moveTime){
      move(q.getNextMove());
    }    
  }
  
}
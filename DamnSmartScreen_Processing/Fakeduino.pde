//This class is solely used testing purposes, to emulate the behavior of the Arduino.  
class Fakeduino {

  QLearning q;
  int arduinoState;
  int targetState;
 

  Fakeduino(QLearning _q) {
    q = _q;
    move(q.getNextMove());
  }

  void move(int state) {

    byte out = byte(state); //turns integer into byte
    port.write(out); 
  }
  
  

  void update() {
    if(arduinoState == targetState){
    move(q.getNextMove());
    }
  }
  
  void setArduinoState(int state){
   arduinoState = state; 
  }
  
}
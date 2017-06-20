//This class is solely used testing purposes, to emulate the behavior of the Arduino.  
class ArduinoInterface {

  
  QLearning q;
  int arduinoState;
  int targetState;
  int stepsPerState = 200/motorsteps;
  boolean started = false;

  ArduinoInterface(QLearning _q) {
    q = _q;
    //targetState = ;
    move(q.getNextMove());
  }

  void move(int state) {
    //while(port.available() == 0){}
    println("state: "+state);
    targetState = state;
    byte out = byte(state*stepsPerState); //turns integer into byte
    port.write(out);
    
  }

  void serialE(Serial event) {
    String val;

    val = event.readStringUntil('\n');

    if (val != null) {
      val = trim(val);
      arduinoState = int(val);
      arduinoState = arduinoState/stepsPerState;
      println(targetState);
      if (arduinoState == targetState||!started) {
        move(q.getNextMove());
        if(!started){started = true;}
      }
      sm.setScreenAngle(arduinoState);
      println("Arduino moved to: "+arduinoState);
    }
  }
}
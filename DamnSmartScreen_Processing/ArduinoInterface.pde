//This class is solely used testing purposes, to emulate the behavior of the Arduino.  
class ArduinoInterface {

  QLearning q;
  int arduinoState;
  int targetState;

  ArduinoInterface(QLearning _q) {
    q = _q;
    move(q.getNextMove());
  }

  void move(int state) {

    byte out = byte(state); //turns integer into byte
    port.write(out);
  }

  void serialE(Serial event) {
    String val;

    val = event.readStringUntil('\n');

    if (val != null) {
      val = trim(val);
      arduinoState = int(val);
      if (arduinoState == targetState) {
        move(q.getNextMove());
      }
      println("Arduino moved to: "+arduinoState);
    }
  }
}
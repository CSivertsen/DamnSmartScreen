//This class tranlates the relative position scheme used in QLearning to absolute positions used for the motor and camera and vice versa.
class StateManager {
  
  int motorSteps;
  int poiState;
  int screenState;
  QLearning ql;
  Fakeduino f;
  ArduinoInterface ai;
    
  StateManager(int steps, QLearning _ql, ArduinoInterface _ai){
    motorSteps = steps;
    ql = _ql;
    //f = _f;
    ai = _ai;
  }
  
  //Used to update QLearning to the correct state
  void updateQState(){
    int currentState;
    
    currentState = ((poiState - screenState) + motorSteps) % motorSteps; 
    //println("QLearning state set to: \t" + currentState + "\t" + poiState + "\t" + screenState );
    ql.setState(currentState);
  }
  
  //Translates a state from QLearning to a position for the ArduinoInterface
  int moveToState(int currentState, int nextState){  
    
    int moveState = (motorSteps + (screenState - (currentState - nextState))) % motorSteps;  
    //ai.move(moveState);
    //f.move(moveState);
    println(currentState + "\t" + nextState + "\t" + moveState);
    return moveState;
  }
  
  void setScreenAngle(int angle){
    screenState = angle;
    sm.updateQState();
  }
  
  void setPoiAngle(float deg, Person p){
    //Convert angle to state
    Person poi = c.getPersonOfInterest();
    if(p.equals(poi)){
      //println("Received angle: " + deg);
      float d = new Float(motorSteps/(360 / deg));
      //poiState = d.intValue()-1;
      poiState = (int) Math.round(d);
      sm.updateQState();
    }
  }
  
}
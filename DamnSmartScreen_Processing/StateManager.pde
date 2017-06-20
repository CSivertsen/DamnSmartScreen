//This class tranlates the relative position scheme to absolute positions and vice versa.
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
    ai = _ai;
  }
  
  //Used to update QLearning to the correct state
  void updateQState(){
    int currentState;
    
    currentState = ((poiState - screenState) + motorSteps) % motorSteps; 
    
    ql.setState(currentState);
  }
  
  //Translates a state from QLearning to a position for the ArduinoInterface
  void moveToState(int currentState, int nextState){
    
    int moveState = (motorSteps + (screenState - (currentState - nextState))) % motorSteps;  
    //ai.move(moveState);
    ai.move(moveState);
    
  }
  
  void setScreenAngle(int angle){
    screenState = angle;
    sm.updateQState();
  }
  
  void setPoiAngle(double deg, Person p){
    //Convert angle to state
    Person poi = c.getPersonOfInterest();
    if(p.equals(poi)){
      Double d = new Double(motorSteps/(360 / deg));
      //poiState = d.intValue()-1;
      poiState = (int) Math.round(d);
      sm.updateQState();
    }
  }
  
}
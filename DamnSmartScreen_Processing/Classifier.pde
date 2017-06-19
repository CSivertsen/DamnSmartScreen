//A simple classifying class based on heuristics to determine person behavior
class Classifier {
  Person personOfInterest;
  PVector center;
  PVector lastScreenToPerson;  
  float lastRelDistLength;
  float speedMin = 5; // ten (arbitrary number) is related to the speed people are allowed to move backwards
  int speedMax = 100;
  QLearning ql; 
  int borderX = 50;
  int borderY = 50;


  Classifier(PVector c, QLearning _ql) {
    ql  = _ql;
    center = c; // center of the screen where the turning screen is placed
    //println("Center: " + c);
    lastScreenToPerson = new PVector(0, 0);
  }

  void update() {
    if (!persons.isEmpty()) {
      for (int i = 0; i < persons.size(); i ++) {
        checkAttention(persons.get(i));
      }
      selectPersonOfInterest();
    }
  }

  // speedBound should be a constant defining below what speed
  // from moving away from the screen a person loses attention
  void checkAttention(Person p) {        
    PVector pos = p.getAveragePosition();
    PVector lastPosition = (PVector) p.getLastPositions().get(0);
    float lastX = lastPosition.x;
    float lastY = lastPosition.y;
    float speedMinTemp = speedMin;
    //println(pos);

    PVector screenToPerson = PVector.sub(center, pos);

    float lastScreenToPersonLength = lastScreenToPerson.mag();
    float screenToPersonLength = screenToPerson.mag();

    PVector relDist = PVector.sub(screenToPerson, lastScreenToPerson);
    float relDistLength = relDist.mag();
    //println("relDist = " + relDistLength);

    speedMinTemp = speedMinTemp + 0.3*sq(screenToPersonLength/40);

    if (p.isAttentive) {
      if (relDistLength >= speedMinTemp && relDistLength <= speedMax && lastScreenToPersonLength < screenToPersonLength && lastX >= borderX && lastX <= width - borderX && lastY >= borderY && lastY <= height - borderY ) { 
        p.setAttention(false);
        if (p.equals(getPersonOfInterest())) {
          println("Difference = " + (lastScreenToPersonLength - screenToPersonLength) + "\t RelDist: " + relDistLength );
          println("screenToPersonLength = " + screenToPersonLength + "\t lastScreenToPersonLength = " + lastScreenToPersonLength  + "lastX = " + lastX + "\t lastY = " + lastY);
          ql.reinforce();
        }
      }
    } else  if (lastScreenToPersonLength >= screenToPersonLength && relDistLength < speedMax) {
      p.setAttention(true);
      //println(p.getId() + " is attentive");
    }    

    lastRelDistLength = relDistLength;
    lastScreenToPerson = screenToPerson;
  }

  boolean personOfInterestPresent(Person pOI) {

    if (pOI != null) {
      if (!persons.isEmpty()) {
        for (int i = 0; i < persons.size(); i++ ) {
          if (pOI.equals(persons.get(i))) {
            return  true;
          }
        }
      }
    }
    return false;
  }

  void selectPersonOfInterest() {
    //if (!persons.isEmpty()) {

    if (personOfInterest == null || !personOfInterestPresent(personOfInterest) ||  personOfInterest.isAttentive() == false) {
      if (persons.size() == 1) {
        personOfInterest = persons.get(0);
        checkAttention(persons.get(0));
      } else if (persons.size() > 1) {
        float[] distances = new float[persons.size()];

        // get distances from every person relative to the screen
        // it also checks the attention of every person
        for (int i = 0; i < persons.size(); i++) {
          PVector screenToPerson = PVector.sub(center, persons.get(i).avPosition);
          distances[i] = screenToPerson.mag();

          checkAttention(persons.get(i)); 

          if (personOfInterestPresent(personOfInterest)) {
            if (!personOfInterest.isAttentive) {

              // find the index number of the person that is closest 
              // to the screen and set that person to be personOfInterest
              // if he is also attentive (showing attention)
              int minIndex = 0;
              float min = max(distances); 
              for (int j = 0; j < distances.length; j++) {
                if (persons.get(j).isAttentive()) {
                  if (distances[j] < min) {
                    min = distances[j];
                    minIndex = j;
                  }
                  personOfInterest = persons.get(minIndex);
                } else {
                  personOfInterest = null;
                }
              }
            }
          } else {
            personOfInterest = null;
          }
        }
      }
    }
    //}
  }

  Person getPersonOfInterest() {
    if (personOfInterest != null) {
      return personOfInterest;
    } else {
      return null;
    }
  }

  void printPOI() {
    if (getPersonOfInterest() != null) {
      Person p = getPersonOfInterest();
      println("POI is " + p.id);
    } else {
      println("No POI have been detected");
    }
  }
}
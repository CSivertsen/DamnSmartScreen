//A simple classifying class based on heuristics to determine person behavior
class Classifier {
  Person personOfInterest;
  PVector center;
  PVector lastscreenToPerson;  
  float lastRelDistLength;
  int speedThreshold = 10; // ten (arbitrary number) is related to the speed people are allowed to move backwards
  QLearning ql; 
  

  Classifier(PVector c, QLearning _ql) {
    ql  = _ql;
    center = c; // center of the screen where the truning screen is placed
  }

  // speedBound should be a constant defining below what speed
  // from moving away from the screen a person loses attention
  void checkAttention(Person p, float speedBound) {        PVector pos = p.getAveragePosition();
    PVector screenToPerson = PVector.sub(center, pos);

    float lastscreenToPersonLenght = lastscreenToPerson.mag();
    float screenToPersonLength = screenToPerson.mag();

    PVector relDist = PVector.sub(screenToPerson, lastscreenToPerson);
    float relDistLength = relDist.mag();

    if (relDistLength >= speedBound && lastscreenToPersonLenght < screenToPersonLength) { 
      p.setAttention(false);
      if (p.equals(getPersonOfInterest())){
        ql.reinforce();
      }
    } else {
      p.setAttention(true);
    }    

    lastRelDistLength = relDistLength;
    lastscreenToPerson = screenToPerson;
  }

  boolean personOfInterestPresent(Person pOI) {
    if (!persons.isEmpty()) {
      for (int i = 0; i < persons.size(); i++ ) {
        if (pOI.equals(persons.get(i))) {
          return  true;
        } 
      }
    }
    return false;
  }

  void selectPersonOfInterest() {
    if (!persons.isEmpty()) {
      ArrayList<Person> ps = new ArrayList();

      if (personOfInterest == null || !personOfInterestPresent(personOfInterest) ||  personOfInterest.isAttentive() == false) {
        if (persons.size() == 1) {
          personOfInterest = persons.get(0);
        } else if (persons.size() > 1) {
          float[] distances = new float[persons.size()];

          // get distances from every person relative to the screen
          // it also checks the attention of every person
          for (int i = 0; i < persons.size(); i++) {
            ps.add(persons.get(i));
            PVector screenToPerson = PVector.sub(center, ps.get(i).avPosition);
            distances[i] = screenToPerson.mag();

            checkAttention(ps.get(i), speedThreshold); 

            if (personOfInterestPresent(personOfInterest)) {
              if (!personOfInterest.isAttentive) {

                // find the index number of the person that is closest 
                // to the screen and set that person to be personOfInterest
                // if he is also attentive (showing attention)
                int minIndex = 0;
                float min = max(distances); 
                for (int j = 0; j < distances.length; j++) {
                  if (ps.get(j).isAttentive()) {
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
    }
  }

  Person getPersonOfInterest() {
    if (personOfInterest != null) {
      return personOfInterest;
    } else {
      return null;
    }
  }
  
  void printPOI(){
    if(getPersonOfInterest() != null){
      Person p = getPersonOfInterest();
      println("POI is " + p.id); 
    } else {
      println("No POI have been detected");
    }
  }
}
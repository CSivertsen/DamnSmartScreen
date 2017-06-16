class Classifier {
  Person personOfInterest;
  PVector center;
  PVector lastscreenToPerson;
  float lastRelDistLength;

  Classifier(PVector c) {
    center = c; // center of the screen where the truning screen is placed
  }

  // speedBound should be a constant defining below what speed
  // from moving away from the screen a person loses attention
  void checkAttention(Person p, float speedBound) {     
    PVector pos = p.getAveragePosition();
    PVector screenToPerson = PVector.sub(center, pos);

    float lastscreenToPersonLenght = lastscreenToPerson.mag();
    float screenToPersonLength = screenToPerson.mag();

    PVector relDist = PVector.sub(screenToPerson, lastscreenToPerson);
    float relDistLength = relDist.mag();

    if (relDistLength >= speedBound && lastscreenToPersonLenght < screenToPersonLength) { 
      p.setAttention(false);
    } else {
      p.setAttention(true);
    }    

    lastRelDistLength = relDistLength;
    lastscreenToPerson = screenToPerson;
  }

  boolean personOfInterestPresent(Person pOI) {
    if (!persons.isEmpty()) {
      for (int i = 0; i < persons.size(); i++ ) {
        if (pOI.id == persons.get(i).id) {
          return  true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  void selectPersonOfInterest() {
    if (!persons.isEmpty()) {
      Person[] ps = new Person[persons.size()];

      //if (!personOfInterestPresent(personOfInterest) && personOfInterest.isAttentive() == false {
      if (personOfInterest == null || !personOfInterestPresent(personOfInterest) ||  personOfInterest.isAttentive() == false) {
        if (persons.size() == 1) {
          personOfInterest = persons.get(0);
        } else if (persons.size() > 1) {
          float[] distances = new float[persons.size()];

          // get distances from every person relative to the screen
          // it also checks the attention of every person
          for (int i = 0; i < persons.size(); i++) {
            ps[i] = persons.get(i);
            PVector screenToPerson = PVector.sub(center, ps[i].avPosition);
            distances[i] = screenToPerson.mag();

            checkAttention(ps[i], 20); // twenty (arbitrary number) is related to the speed people are allowed to move backwards
          }

          // find the index number of the person that is closest 
          // to the screen and set that person to be personOfInterest
          // if he is also attentive (showing attention)
          int minIndex = 0;
          float min = max(distances); 
          for (int i = 0; i < distances.length; i++) {
            if (ps[i].isAttentive()) {
              if (distances[i] < min) {
                min = distances[i];
                minIndex = i;
              }
              personOfInterest = persons.get(minIndex);
            } else {
              personOfInterest = null;
            }
          }
        }
      }
    } else {
      personOfInterest = null;
    }
  }

  Person getPersonOfInterest() {
    if (personOfInterest != null) {
      return personOfInterest;
    } else {
      return null;
    }
  }
}
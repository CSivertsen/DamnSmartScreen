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
  
  boolean checkPersonOfInterestPresent(Person[] ps, Person pOI){
    for (int i = 0; i < ps.size(); i++) {
      if (pOI.id == ps[i].id){
          return  true;
      } else {
        return false;
      }
    } 
  }

  void selectPersonOfInterest() {
    if (!persons.isEmpty()) {
      Person[] ps = new Person[persons.size()];

      
      
      //if (!personOfInterest.isAttentive) {
      if (ps.size() == 1) {
        personOfInterest = persons.get(0);
      } else if (persons.size() > 1) {
        float[] distances = new float[persons.size()];


        // get distances from every person relative to the screen
        // it also checks the attention of every person
        for (int i = 0; i < ps.size(); i++) {
          ps[i] = persons.get(i);
          PVector screenToPerson = PVector.sub(center, ps[i].avPosition);
          distances[i] = screenToPerson.mag();
          
          checkAttention(ps[i], 20); // twenty (arbitrary number) is related to the speed people are allowed to move backwards
        }

        
        if (personOfinterestPresent){
        if (!personOfInterest.isAttentive) {
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
            }
          }
        }
      }
    }
  }
}
//This class determines through difference in contrast the movement in the frame.
class VideoAnalysis {
  PImage prevFrame;
  int centerSize = 250;

  int threshold = 100;
  float r1;
  float g1;
  float b1;
  float r2;
  float g2;
  float b2;

  int counter;
  int available;
  int count = 0;

  //BLOB
  int blobCounter = 0;
  ArrayList<Blob> blobs = new ArrayList<Blob>();
  int blobLength;

  VideoAnalysis(Capture v) {
    video =  v;
    video.start();
    prevFrame = createImage(width, height, RGB);
  }

  void update() {
    saveFirstFrame();

    loadPixels();
    video.loadPixels();
    ArrayList<Blob> currentBlobs = new ArrayList<Blob>();
    checkPixels(currentBlobs);
    updatePixels();
    keepCurrentBlobsSmall(currentBlobs);
    currentBlobsToPersons(currentBlobs);

    for (Blob b : currentBlobs) {
      b.show();
    } 
    for (Person p : persons) {
      p.show();
    }

    textAlign(RIGHT);
    fill(0);
    //text(currentBlobs.size(), width-10, 40);
    //text(blobs.size(), width-10, 80);
    textSize(24);
    text("color threshold: " + threshold, width-10, 50);  



    delay(50);
    fill(255, 0, 0);
    //storeInPerson();
  }

  void saveFirstFrame() { //saves the 10th frame after start in prevFrame
    if (video.available() == true) {
      video.read();
      if (count < 10) {
        prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);   //Screesnhot van video input
        prevFrame.updatePixels();  //put screenshot in PrevFrame
        count++;
      }
    }
  }

  void checkPixels(ArrayList<Blob> currentBlobs) {
    for (int x = 0; x < video.width; x = x+20 ) {
      for (int y = 0; y < video.height; y = y+20 ) {
        if (x > width/2 - centerSize/2 & x < width/2 + centerSize/2 && y > height/2 - centerSize/2 && y < height/2 + centerSize/2) {
          // Ignoring all pixels in the center of the screen
        } else {
          r1 = 0;
          g1 = 0;
          b1 = 0;
          r2 = 0;
          g2 = 0;
          b2 = 0;
          for (int i = 0; i < 20; i++) { // add rgb value of each pixel in 20 x 20 block to r1, g1, b1 and compares it to baseline
            for (int s = 0; s < 20; s++) {
              int loc = x+i + (y+s)*video.width;            
              color current = video.pixels[loc];      
              color baseline = prevFrame.pixels[loc]; 
              pixels[loc] = video.pixels[loc];

              r1 = r1 + red(current); 
              g1 = g1 + green(current); 
              b1 = b1 + blue(current);
              r2 = r2 + red(baseline); 
              g2 = g2 + green(baseline); 
              b2 = b2 + blue(baseline);
              if (s == 19 && i == 19) // find mean value of 20 x 20 block
              {
                r1 = r1/400;
                g1 = g1/400;
                b1 = b1/400;
                r2 = r2/400;
                g2 = g2/400;
                b2 = b2/400;
              }
            }
          }
          float diff = dist(r1, g1, b1, r2, g2, b2); //calculate difference of 2 images by finding distance between point in 3-dimensional rgb space  

          if (diff > threshold) { //check difference over treshold          
            boolean found = false;
            for (Blob b : currentBlobs) {
              if (b.isNear(x, y)) { //checks for overlap with existing blob
                b.setPos(x, y);     //changes position of/add to existing blob
                found = true;
                break;
              }
            }

            if (!found) {     // create new blob if there are no overlapping blobs
              Blob b = new Blob(x, y);
              currentBlobs.add(b);
            }
          }
        }
      }
    }
  }
  void keepCurrentBlobsSmall(ArrayList<Blob> currentBlobs) {
    for (int i = currentBlobs.size()-1; i >= 0; i--) {
      if (currentBlobs.get(i).size() < 500) {
        currentBlobs.remove(i);
      }
    }
  }

  void currentBlobsToPersons(ArrayList<Blob> currentBlobs) {

    //If there are no persons detected earlier
    if (persons.isEmpty() && currentBlobs.size() > 0) {
      for (Blob b : currentBlobs) {
        b.setId(blobCounter);
        persons.add(new Person(blobCounter, b.getCenter(), sm));
        blobCounter++;
      }
    //If there are more blobs than person we iterate over to the persons arraylist
    } else if (persons.size() <= currentBlobs.size()) {
      // Match whatever blobs you can match
      for (Person p : persons) {
        float recordD = 200; 
        Blob matched = null;
        for (Blob cb : currentBlobs) {

          PVector centerB = (PVector) p.getLastPositions().get(0);
          PVector centerCB = cb.getCenter();         
          float d = PVector.dist(centerB, centerCB);
          if (d < recordD && !cb.taken) {
            recordD = d; 
            matched = cb;
          }
        }
        if (matched != null) {
          matched.taken = true;
          p.addPosition(matched.getCenter());
        }
      }

      // Whatever is leftover make new persons
      for (Blob b : currentBlobs) {
        if (!b.taken) {
          b.setId(blobCounter);
          persons.add(new Person(blobCounter, b.getCenter(), sm));
          blobCounter++;
        }
      }
      
    // If there are more persons than blobs
    } else if (persons.size() > currentBlobs.size()) {
      for (Person p : persons) {
        p.taken = false;
      }
      // Match whatever blobs and persons you can match
      for (Blob cb : currentBlobs) {
        float recordD = 500;
        Person matched = null;
        for (Person p : persons) {
          PVector centerB = (PVector)p.getLastPositions().get(0);
          PVector centerCB = cb.getCenter();         
          float d = PVector.dist(centerB, centerCB);
          if (d < recordD && !p.taken) {
            recordD = d; 
            matched = p;
          }
        }
        if (matched != null) {
          matched.taken = true;
          matched.become(cb);
        }
      }
      // Remove the remaining persons
      for (int i = persons.size() - 1; i >= 0; i--) {
        Person p = persons.get(i);
        if (!p.taken) {
          println("Removing person");
          persons.remove(i);
        }
      }
    }
  }
}
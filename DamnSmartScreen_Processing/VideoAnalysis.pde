class VideoAnalysis {
  PImage prevFrame;


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
  float distThreshold = 180;
  ArrayList<Blob> blobs = new ArrayList<Blob>();
  int blobLength;

  //PERSON CLASS
  ArrayList<Person> persons = new ArrayList<Person>();



  VideoAnalysis(Capture v) {
    video =  v;
    video.start();
    prevFrame = createImage(1280, 720, RGB);
  }

  void update() {

    if (video.available() == true) {
      video.read();
      if (count < 10) {
        //prevFrame.loadPixels();
        prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);   //Screesnhot van video input
        prevFrame.updatePixels();  //put screenshot in PrevFrame
        count++;
        //println(count);
      }
    }


    loadPixels();
    video.loadPixels();

    ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

    for (int x = 0; x < video.width; x = x+20 ) 
    {
      for (int y = 0; y < video.height; y = y+20 ) 
      {
        if (x > width/2 - 125 & x < width/2 + 125 && y > height/2 - 125 && y < height/2 + 125) 
        {
        } else 
        {
          r1 = 0;
          g1 = 0;
          b1 = 0;
          r2 = 0;
          g2 = 0;
          b2 = 0;
          for (int i = 0; i < 20; i++) 
          {
            for (int s = 0; s < 20; s++) 
            {
              int loc = x+i + (y+s)*video.width;            
              color current = video.pixels[loc];      
              color previous = prevFrame.pixels[loc]; 
              pixels[loc] = video.pixels[loc];

              r1 = r1 + red(current); 
              g1 = g1 + green(current); 
              b1 = b1 + blue(current);
              r2 = r2 + red(previous); 
              g2 = g2 + green(previous); 
              b2 = b2 + blue(previous);
              if (s == 19 && i == 19) 
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
          float diff = dist(r1, g1, b1, r2, g2, b2); //calculate distance difference of 2 images

          if (diff > threshold) {           
            boolean found = false;
            for (Blob b : currentBlobs) {
              if (b.isNear(x, y)) {
                b.setPos(x, y);
                found = true;
                break;
              }
            }

            if (!found) {
              Blob b = new Blob(x, y);
              currentBlobs.add(b);
            }
          }
        }
      }
    }

    updatePixels();

    //Array niet te groot
    for (int i = currentBlobs.size()-1; i >= 0; i--) {
      if (currentBlobs.get(i).size() < 500) {
        currentBlobs.remove(i);
      }
    }

    // There are no blobs!
    if (persons.isEmpty() && currentBlobs.size() > 0) {
      //println("Adding blobs!");
      for (Blob b : currentBlobs) {
        b.setId(blobCounter);
        //blobs.add(b);
        //perons.add(new Person(blobCounter, 
        persons.add(new Person(blobCounter, b.getCenter()));
        
        blobCounter++;
      }
    } else if (persons.size() <= currentBlobs.size()) {
      // Match whatever blobs you can match
      for (Person p:persons) {
        float recordD = 1000;
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
        matched.taken = true;
        p.addPosition(matched.getCenter());
      }

      // Whatever is leftover make new blobs
      for (Blob b : currentBlobs) {
        if (!b.taken) {
          //b.id = blobCounter;
          b.id = blobCounter;

          //blobs.add(b);
          persons.add(new Person(blobCounter, b.getCenter()));
          
          blobCounter++;
        }
      }
    } else if (persons.size() > currentBlobs.size()) {
      for (Person p : persons) {
        p.taken = false;
      }


      // Match whatever blobs you can match
      for (Blob cb : currentBlobs) {
        float recordD = 1000;
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

      for (int i = persons.size() - 1; i >= 0; i--) {
        Person p = persons.get(i);
        if (!p.taken) {
          //blobs.remove(i);
          persons.remove(i);
        }
      }
    }

    for (Blob b: currentBlobs) {
      b.show();
    } 
    for(Person p: persons){
      p.show();
    }



    textAlign(RIGHT);
    fill(0);
    //text(currentBlobs.size(), width-10, 40);
    //text(blobs.size(), width-10, 80);
    textSize(24);
    text("color threshold: " + threshold, width-10, 50);  
    text("distance threshold: " + distThreshold, width-10, 25);


    delay(50);
    fill(255, 0, 0);
    //storeInPerson();
    
    //Print personslist
    
    for(Person p : persons){
      int id = p.getId();
      println("Id = "+ id);
    }
    
  }
}
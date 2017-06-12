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
        println(count);
      }
    }
    counter = 0;
    for (Blob b : blobs) {
      int id = b.getId();
      //println(b.getId());
      println("counter: " + counter +" ID: " + id);
      if (id == counter) {
        available = counter+1;
      } else {
        available = 0;
      }
      counter++;
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
                b.add(x, y);
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
    if (blobs.isEmpty() && currentBlobs.size() > 0) {
      println("Adding blobs!");
      for (Blob b : currentBlobs) {
        b.id = available;
        blobs.add(b);
        blobCounter++;
      }
    } else if (blobs.size() <= currentBlobs.size()) {
      // Match whatever blobs you can match
      for (Blob b : blobs) {
        float recordD = 1000;
        Blob matched = null;
        for (Blob cb : currentBlobs) {
          PVector centerB = b.getCenter();
          PVector centerCB = cb.getCenter();         
          float d = PVector.dist(centerB, centerCB);
          if (d < recordD && !cb.taken) {
            recordD = d; 
            matched = cb;
          }
        }
        matched.taken = true;
        b.become(matched);
      }

      // Whatever is leftover make new blobs
      for (Blob b : currentBlobs) {
        if (!b.taken) {
          //b.id = blobCounter;
          b.id = available;

          blobs.add(b);
          blobCounter++;
        }
      }
    } else if (blobs.size() > currentBlobs.size()) {
      for (Blob b : blobs) {
        b.taken = false;
      }


      // Match whatever blobs you can match
      for (Blob cb : currentBlobs) {
        float recordD = 1000;
        Blob matched = null;
        for (Blob b : blobs) {
          PVector centerB = b.getCenter();
          PVector centerCB = cb.getCenter();         
          float d = PVector.dist(centerB, centerCB);
          if (d < recordD && !b.taken) {
            recordD = d; 
            matched = b;
          }
        }
        if (matched != null) {
          matched.taken = true;
          matched.become(cb);
        }
      }

      for (int i = blobs.size() - 1; i >= 0; i--) {
        Blob b = blobs.get(i);
        if (!b.taken) {
          blobs.remove(i);
        }
      }
    }

    for (Blob b : blobs) {
      b.show();
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
    storeInPerson();
  }
  void storeInPerson() {

    println("length: "+ blobs.size());
    //blobLength = blobs.size();
    println(blobs);
    for (Blob b : blobs) {
      int id = b.getId();
      PVector v = b.getCenter();
      Person p = new Person(id, v);
      persons.add(p);
      p.printInfo();
    }
  }
}
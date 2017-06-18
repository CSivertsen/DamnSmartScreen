import processing.video.*;
import processing.serial.*;

VideoAnalysis va;
Classifier c;
QLearning ql;
Capture video;
Fakeduino f; 

ArrayList<Person> persons = new ArrayList<Person>();
int motorsteps = 200;

void setup() {
  size(640, 480); //Screen size should correspond to camera resolution

  //Initializing camera
  String[] cameras = Capture.list();
  video = new Capture(this, width, height, 30); // Last parameter is framerate. Default is 30 

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      print(i);
      println(cameras[i]);
    }
    video = new Capture(this, cameras[13]); //38 for external webcam
  }
  
  //Initializing objects
  va = new VideoAnalysis(video);
  ql = new QLearning(motorsteps, true, true);
  c = new Classifier(new PVector(width/2, height/2), ql);
  f = new Fakeduino(ql); 
}

void draw() {
  //VideoAnalysis, Classification and Fakeduino is run on every frame. 
  va.update();
  c.selectPersonOfInterest();
  f.update();
}

void keyReleased(){
  if (key == 'r'){
    ql.printR(ql.R);
  } else if (key == 'q'){
    ql.printQ();
  } else if (key == 'p'){
    c.printPOI();
  } else if (key == 'l'){
    //Print all persons
    println("All persons:");
    for (Person p : persons) {
      int id = p.getId();
      println("Id = "+ id);
    }
  } else if (key == 's'){
    ql.savePolicy();
  }
}
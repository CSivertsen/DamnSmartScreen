import processing.video.*;
import processing.serial.*;

VideoAnalysis va;
Classifier c;
QLearning ql;
Capture video;
//Fakeduino f; 
ArduinoInterface ai;

Serial port;

ArrayList<Person> persons = new ArrayList<Person>();
int motorsteps = 10; //200 should be devidable by motorsteps

void setup() {

  size(1280, 720); //Screen size should correspond to camera resolution

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
    video = new Capture(this, cameras[38]); //38 for external webcam
  }

  //Initializing objects
  va = new VideoAnalysis(video);
  ql = new QLearning(motorsteps, true, true);
  c = new Classifier(new PVector(width/2, height/2), ql);
  //f = new Fakeduino(ql); 

  String p = Serial.list()[0];
  port = new Serial(this, p, 9600);
  ai = new ArduinoInterface(ql);
}

void draw() {
  //VideoAnalysis, Classification and Fakeduino is run on every frame. 
  if (video.available()) {
    va.update();
    //c.selectPersonOfInterest();
    c.update();
    //f.update();
  }
}

void keyReleased() {
  if (key == 'r') {
    ql.printR(ql.R);
  } else if (key == 'q') {
    ql.printQ();
  } else if (key == 'p') {
    c.printPOI();
  } else if (key == 'l') {
    //Print all persons
    println("All persons:");
    for (Person p : persons) {
      int id = p.getId();
      println("Id = "+ id);
    }
  } else if (key == 's') {
    ql.savePolicy();
  } else if (key == CODED) {
    if (keyCode == ENTER) {
      ql.reinforce();
    }
  }
}


  void serialEvent(Serial event) {
    ai.serialE(event);
  }
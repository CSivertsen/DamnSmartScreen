import processing.video.*;
import processing.serial.*;

VideoAnalysis va;

Capture video;



void setup() {
  //persons = new Person[val];
  //PVector testV = new PVector(20,30);
  //for (int i = 0; i < val; i++) {
  //  persons[i] = new Person(val, testV);
  //}
  //persons[0].setPosition(test2);
  //persons[0].printInfo();
  size(1280, 720); //needed for video

  String[] cameras = Capture.list();
  video = new Capture(this, width, height, 10); //30


  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      print(i);
      println(cameras[i]);
    }
    video = new Capture(this, cameras[6]);   //38
  }

  va = new VideoAnalysis(video);
}

void draw() {
  va.update();
}
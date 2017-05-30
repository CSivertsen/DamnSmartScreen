#define stp 2
#define dir 3
#define MS1 4
#define MS2 5
#define EN  6

int ledPin = 13;
int angle = 0;
int saveAngle = 0;

void setup()  {
  Serial.begin(9600);
  pinMode(ledPin, 13);

  pinMode(stp, OUTPUT);
  pinMode(dir, OUTPUT);
  pinMode(MS1, OUTPUT);
  pinMode(MS2, OUTPUT);
  pinMode(EN, OUTPUT);
  digitalWrite(stp, LOW);
  digitalWrite(dir, LOW);
  digitalWrite(MS1, LOW);
  digitalWrite(MS2, LOW);
  digitalWrite(EN, LOW);
}


void loop() {
  if (Serial.available()) {
    angle = Serial.read();
  }
  if (saveAngle != angle) {
    int deltaAngle = angle - saveAngle;
    if (deltaAngle > 99){
      deltaAngle = deltaAngle - 200;
    }
    else if (deltaAngle < -99){
      deltaAngle = deltaAngle + 200;
    }
    if (deltaAngle < 0) {
      digitalWrite(dir,LOW);
    }
    else{
      digitalWrite(dir,HIGH);
    }
      digitalWrite(MS1, HIGH); //Pull MS1, and MS2 high to set logic to 1/8th microstep resolution
  digitalWrite(MS2, HIGH);
    deltaAngle = abs(deltaAngle);
      for (int x = 0; x < deltaAngle*16; x++) //Loop the forward stepping enough times for motion to be visible
      {
        digitalWrite(stp, HIGH); //Trigger one step forward
        delay(1);
        digitalWrite(stp, LOW); //Pull step pin low so it can be triggered again
        delay(1);
      }
      delay(10);
   
  }
  saveAngle = angle;
}


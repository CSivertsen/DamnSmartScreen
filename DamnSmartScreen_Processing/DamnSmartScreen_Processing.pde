/*
this Main sketch was only made to test the person class
*/

<<<<<<< HEAD
QLearning ql;

void setup() {
  for (int i = 0; i < 10; i++) {
    p = new Person(i, 2, 3);
  }
  int val = p.getId();
  println("val = " + val);
  
  qlTest();
}

void draw() {
}

void qlTest(){
  
  ql = new QLearning(200);
=======

Person[] persons;
int val = 10;
PVector test2 = new PVector(40,80);

void setup() {
  persons = new Person[val];
  PVector testV = new PVector(20,30);
  for (int i = 0; i < val; i++) {
    persons[i] = new Person(val, testV);
  }
  persons[0].setPosition(test2);
  persons[0].printInfo();
}
>>>>>>> refs/remotes/origin/master

void draw() {
}
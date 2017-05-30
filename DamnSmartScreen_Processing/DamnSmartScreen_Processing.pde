Person[] persons;
int val = 10;
PVector p;

void setup() {
  persons = new Person[val];
  PVector testV = new PVector(20,30);
  for (int i = 0; i < val; i++) {
    persons[i] = new Person(val, testV);
  }
  //int val = persons[0].getId();
  persons[0].printInfo();
}

void draw() {
}
Person[] persons;
int val = 10;
PVector p;

void setup() {
  persons = new Person[val];
  for (int i = 0; i < val; i++) {
    persons[i] = new Person(val,p);
  }
  int val = persons[0].getId();
  println("val = " + val);
}

void draw() {
}
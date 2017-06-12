//comment to test GitHUb
Person p;
int c = 1;

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

}
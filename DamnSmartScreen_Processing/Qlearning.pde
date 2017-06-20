class QLearning {

  double alpha = 0.1; // Learning rate
  double gamma = 0.9; // Eagerness - 0 looks in the near future, 1 looks in the distant future

  int penalty = -10;

  double[][] Q;    // Q learning
  int[][] R;       // Reward lookup

  int statesCount; 
  int posListSize = 10;
  ArrayList<Integer> lastPositions = new ArrayList<Integer>();

  boolean isLearning = true;
  boolean loadPolicy = true;
  
  int currentState; 

  QLearning(int size, boolean learning, boolean load) {
    statesCount = size;
    R = new int[statesCount][statesCount];
    Q = new double[statesCount][statesCount];
    lastPositions.add(0);
    isLearning = learning;
    loadPolicy = load;
    if (loadPolicy) {
      loadPolicy();
    }
  }

  // Prints the weight for all states in the current situation to the console. 
  void showPolicy() {
    println("Policy:");
  }

  int getNextMove() {
    int nextState = getPolicyFromState(currentState);
    setLastPositions(nextState);
    currentState = nextState;
    return nextState;
  }

  //
  void reinforce() {
    if (isLearning) {
      println("Reinforcing");
      int backtrack = 3;

      for (int i = 0; i < backtrack-1; i++) {
        double q = Q[lastPositions.get(i+1)][lastPositions.get(i)];
        double maxQ = maxQ(lastPositions.get(i));
        //int r = R[lastPositions.get(i+1)][lastPositions.get(1)];
        int r = penalty;
        double value = q + alpha * (r + gamma * maxQ - q) * backtrack/(i+1); //Not a beautiful way of back-propagating, but I think it works for now.
        Q[lastPositions.get(i+1)][lastPositions.get(i)] = value;
      }
    }
  }

  //Saves the last positions, so we can backpropagate the reinforcement
  void setLastPositions(int p) {
    if (lastPositions.size() == 0) {
      lastPositions.add(p);
    } else if (lastPositions.size() > 0 && lastPositions.size() <= posListSize) {
      if (lastPositions.size() == posListSize) {
        lastPositions.remove(posListSize-1);
      }
      lastPositions.add(0, p);
    }
  }

  //Returns the highest Q value from the available states
  double maxQ(int nextState) {
    double maxValue = -Double.MAX_VALUE;
    for (int nextAction = 0; nextAction < statesCount; nextAction++) {
      double value = Q[nextState][nextAction];
      if (value > maxValue) {
        maxValue = value;
      }
    }  
    return maxValue;
  }

  //Find the state with the highest Q value from the available states 
  int getPolicyFromState(int state) {
    ArrayList<Integer> bestStates = new ArrayList(); 
    double maxValue = -Double.MAX_VALUE;
    int policyGotoState = state;

    // Pick to move to the state that has the maximum Q value
    for (int nextState = 0; nextState < statesCount; nextState++) {
      double value = Q[state][nextState];

      if (value > maxValue) {
        maxValue = value;
      }
    }

    for (int nextState = 0; nextState < statesCount; nextState++) {
      double value = Q[state][nextState];

      if (value == maxValue) {
        bestStates.add(nextState);
      }
    }

    policyGotoState = bestStates.get(round(random(bestStates.size()-1)));

    return policyGotoState;
  }
  
  void setState(int state){
    currentState = state;
  }

  // Used for debugging
  void printQ() {
    System.out.println("Q matrix");
    for (int i = 0; i < Q.length; i++) {
      System.out.print("From state " + i + ":  ");
      for (int j = 0; j < Q[i].length; j++) {
        System.out.printf("%6.2f ", (Q[i][j]));
      }
      System.out.println();
    }
  }

  // Used for debugging
  void printR(int[][] matrix) {
    System.out.printf("%25s", "States: ");
    for (int i = 0; i <= 8; i++) {
      System.out.printf("%4s", i);
    }
    System.out.println();

    for (int i = 0; i < statesCount; i++) {
      System.out.print("Possible states from " + i + " :[");
      for (int j = 0; j < statesCount; j++) {
        System.out.printf("%4s", matrix[i][j]);
      }
      System.out.println("]");
    }
  }

  void savePolicy() {
    ArrayList<TableRow> rows = new ArrayList();
    Table table = new Table();
    for (int i = 0; i < statesCount; i++) {
      table.addColumn(str(i));
      rows.add(table.addRow());
    }

    for (int i = 0; i < statesCount; i++) {
      for (int j = 0; j < statesCount; j++) {
        table.setDouble(i, j, Q[i][j]);
      }
    }
    saveTable(table, "data/policy.csv");
    println("Table saved");
  }

  void loadPolicy() {
    Table table;
    table = loadTable("policy.csv", "header");

    for (int i = 0; i < statesCount; i++) {
      for (int j = 0; j < statesCount; j++) {
        Q[i][j] = table.getDouble(i,j);
      }
    }
    println("Table loaded");
  }
}
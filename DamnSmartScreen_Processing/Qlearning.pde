class QLearning {

  double alpha = 0.1; // Learning rate
  double gamma = 0.9; // Eagerness - 0 looks in the near future, 1 looks in the distant future

  int penalty = -10;

  double[][] Q;    // Q learning
  int[][] R;       // Reward lookup

  int statesCount; 
  int posListSize = 10;
  ArrayList<Integer> lastPositions = new ArrayList<Integer>();

  QLearning(int size) {
    statesCount = size;
    R = new int[statesCount][statesCount];
    Q = new double[statesCount][statesCount];
  }

  // Prints the weight for all states in the current situation to the console. 
  void showPolicy() {
    println("Policy:");
  }

  int move() {
    int currentState = lastPositions.get(0);
    int nextState = getPolicyFromState(currentState);
    setLastPositions(nextState);
    
    //Consider if this should call the arduino interface directly
    return nextState;
  }

  void reinforce() {
    int backtrack = 3;

    for (int i = 0; i < backtrack; i++) {
      double q = Q[lastPositions.get(i+1)][lastPositions.get(1)];
      double maxQ = maxQ(lastPositions.get(1));
      int r = R[lastPositions.get(i+1)][lastPositions.get(1)];
      double value = q + alpha * (r + gamma * maxQ - q) * backtrack/(i+1); //Not a beautiful way of back-propagating, but I think it works for now.
      Q[lastPositions.get(i+1)][lastPositions.get(1)] = value;
    }
  }

  void setLastPositions(int p) {
    if (lastPositions.size() == 0) {
      lastPositions.add(p);
    } else if (lastPositions.size() > 0 && lastPositions.size() <= posListSize) {
      if (lastPositions.size() == posListSize) {
        lastPositions.remove(posListSize+1);
      }
      lastPositions.add(0, p);
    }
  }


  double maxQ(int nextState) {
    double maxValue = Double.MIN_VALUE;
    for (int nextAction = 0; nextAction < statesCount; nextAction++) {
      double value = Q[nextState][nextAction];

      if (value > maxValue) {
        maxValue = value;
      }
    }  
    return maxValue;
  }

  int getPolicyFromState(int state) {

    double maxValue = Double.MIN_VALUE;
    int policyGotoState = state;

    // Pick to move to the state that has the maximum Q value
    for (int nextState = 0; nextState < statesCount; nextState++) {
      double value = Q[state][nextState];

      if (value > maxValue) {
        maxValue = value;
        policyGotoState = nextState;
      }
    }
    return policyGotoState;
  }

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

  // Used for debug
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
}
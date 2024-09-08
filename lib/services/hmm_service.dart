///Hidden Markov Model (HMM) algorithm
library;

class HMMService {
  // Define the states and observations for HMM
  final List<String> states = ['Normal', 'Attack'];

  // Define transition probabilities between states
  final Map<String, Map<String, double>> transitionProbabilities = {
    'Normal': {'Normal': 0.9, 'Attack': 0.1},
    'Attack': {'Normal': 0.2, 'Attack': 0.8},
  };

  // Define emission probabilities for each state
  final Map<String, Map<String, double>> emissionProbabilities = {
    'Normal': {
      'NormalTraffic': 0.7,
      'IncreasedTraffic': 0.2,
      'AbnormalCommand': 0.1
    },
    'Attack': {
      'NormalTraffic': 0.1,
      'IncreasedTraffic': 0.4,
      'AbnormalCommand': 0.5
    },
  };

  // Define initial state probabilities
  final Map<String, double> initialProbabilities = {
    'Normal': 0.8,
    'Attack': 0.2,
  };

  // Forward algorithm for HMM
  double forwardAlgorithm(List<String> observations) {
    Map<String, double> alpha =
        {}; // forward probabilities for the first observation

    // Initialize forward probabilities for the first observation
    for (var state in states) {
      alpha[state] = initialProbabilities[state]! *
          emissionProbabilities[state]![observations[0]]!;
    }

    // Process remaining observations
    for (int t = 1; t < observations.length; t++) {
      Map<String, double> newAlpha = {};
      for (var nextState in states) {
        newAlpha[nextState] = 0;
        for (var nextState in states) {
          newAlpha[nextState] =
              0.0; // Explicitly set to 0.0 to ensure it's not null
          for (var currentState in states) {
            double increment = alpha[currentState]! *
                transitionProbabilities[currentState]![nextState]! *
                emissionProbabilities[nextState]![observations[t]]!;
            newAlpha[nextState] = newAlpha[nextState]! + increment;
          }
        }
      }
      alpha = newAlpha;
    }

    // Sum over all final state probabilities
    double totalProbability = 0;
    for (var state in states) {
      totalProbability += alpha[state]!;
    }
    return totalProbability;
  }
}

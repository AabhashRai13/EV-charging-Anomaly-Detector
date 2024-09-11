import 'dart:convert';
import 'dart:math';  // Import the math library
import 'package:http/http.dart' as http;

class HMMService {
  List<List<double>> transitionProbabilities = [];
  List<List<double>> means = [];
  List<List<double>> covariances = [];

  // Function to fetch HMM probabilities from the Python API
  Future<void> fetchHMMProbabilities() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/get_hmm_probabilities'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("HMM Probabilities: $jsonResponse");
      transitionProbabilities = (jsonResponse['transition_matrix'] as List)
          .map((row) => List<double>.from(row))
          .toList();
      means = (jsonResponse['means'] as List)
          .map((row) => List<double>.from(row))
          .toList();
      covariances = (jsonResponse['covariances'] as List)
          .map((row) => List<double>.from(row))
          .toList();
    } else {
      throw Exception('Failed to fetch HMM probabilities');
    }
  }

  // Forward algorithm for anomaly detection using the fetched probabilities
  double forwardAlgorithm(List<double> observation) {
    if (transitionProbabilities.isEmpty || means.isEmpty || covariances.isEmpty) {
      throw Exception('HMM parameters not loaded');
    }

    List<double> likelihoods = [0.0, 0.0];

    for (int state = 0; state < 2; state++) {
      double likelihood = 1.0;
      for (int i = 0; i < observation.length; i++) {
        double diff = observation[i] - means[state][i];
        likelihood *= (1 / sqrt(2 * pi * covariances[state][i])) *  // Use sqrt() from dart:math
                      exp(-0.5 * (diff * diff) / covariances[state][i]);
      }
      likelihoods[state] = likelihood;
    }

    double normalProbability = likelihoods[0] * transitionProbabilities[0][0];
    double abnormalProbability = likelihoods[1] * transitionProbabilities[0][1];

    return abnormalProbability / (normalProbability + abnormalProbability);
  }
}

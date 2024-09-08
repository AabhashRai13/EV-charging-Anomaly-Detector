import 'dart:async';
import 'package:ev_charging_anomaly_detector/entities/ev_session.dart';
import 'package:ev_charging_anomaly_detector/services/pomcp_algorithm.dart';
import 'dart:math';
import 'hmm_service.dart';

class EVController {
  final HMMService hmmService = HMMService();
  final POMCPService pomcpService = POMCPService();
  List<EVSession> evSessions = [];
  Timer? timer;

  // Function to generate random data
  void startDataGeneration(Function onDataGenerated, Function onAnomalyDetected) {
    _generateRandomData(onDataGenerated, onAnomalyDetected);
  }

  // Stop data generation when needed
  void stopDataGeneration() {
    timer?.cancel();
  }

  // Private function to generate random data
  void _generateRandomData(Function onDataGenerated, Function onAnomalyDetected) {
    // Generate random session data
    EVSession newSession = EVSession(
      sessionId: evSessions.length + 1,
      timestamp: DateTime.now().toString(),
      networkTraffic: "${100 + evSessions.length * 10} MB",
      energyUsage: 30 + evSessions.length,
      eventType: evSessions.length % 3 == 0 ? 'AbnormalCommand' : 'NormalTraffic',
    );
    evSessions.add(newSession);
    onDataGenerated(evSessions);  // Update UI with new data

    // Run HMM anomaly detection
    detectAnomalies(onAnomalyDetected);
    
    // Set random delay for the next session
    int randomDelay = Random().nextInt(5) + 1;
    timer = Timer(Duration(seconds: randomDelay), () {
      _generateRandomData(onDataGenerated, onAnomalyDetected);
    });
  }

  // Detect anomalies using HMM and POMCP
  void detectAnomalies(Function onAnomalyDetected) {
    List<String> eventTypes = evSessions.map((session) => session.eventType).toList();
    double probability = hmmService.forwardAlgorithm(eventTypes);
    
    String status;
    if (probability < 0.3) {
      status = 'Anomaly Detected: Redirecting to Decoy Node';
      
      // Apply POMCP algorithm to redirect the attack
      List<String> attackPath = pomcpService.generateAttackPath();
      String mitigationAction = pomcpService.applyPOMCP(attackPath);
      status += ' | $mitigationAction';
    } else {
      status = 'System is Operating Normally';
    }

    onAnomalyDetected(status);  // Update the status on the UI
  }
}

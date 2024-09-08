import 'dart:math';
import 'package:ev_charging_anomaly_detector/entities/ev_session.dart';

class DataGeneratorService {
  final Random random = Random();

  // Function to generate a random EV session
  EVSession generateRandomSession(int sessionId) {
    String timestamp = DateTime.now().toString();
    String networkTraffic = "${random.nextInt(300) + 100} MB";
    int energyUsage = random.nextInt(50) + 20;
    String eventType;

    // Randomly assign event types based on probabilities
    int eventTypeRandomizer = random.nextInt(100);
    if (eventTypeRandomizer < 70) {
      eventType = 'NormalTraffic';
    } else if (eventTypeRandomizer < 90) {
      eventType = 'IncreasedTraffic';
    } else {
      eventType = 'AbnormalCommand';
    }

    return EVSession(
      sessionId: sessionId,
      timestamp: timestamp,
      networkTraffic: networkTraffic,
      energyUsage: energyUsage,
      eventType: eventType,
    );
  }
}

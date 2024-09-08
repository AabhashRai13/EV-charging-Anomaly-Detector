import 'package:ev_charging_anomaly_detector/core/theme.dart';
import 'package:ev_charging_anomaly_detector/entities/ev_session.dart';
import 'package:ev_charging_anomaly_detector/services/controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Charging Anomaly Detector (Real-Time)',
      theme: AppTheme.purplePinkTheme(),  // Apply the purple-pink theme
      home: const EVHomePage(),
    );
  }
}

class EVHomePage extends StatefulWidget {
  const EVHomePage({super.key});

  @override
  EVHomePageState createState() => EVHomePageState();
}

class EVHomePageState extends State<EVHomePage> {
  List<EVSession> evSessions = [];
  String anomalyStatus = "Waiting for data...";
  String redirectionStatus = "";  // Separate status for path redirection
  EVSession? latestAnomalySession;  // To store the most recent abnormal session
  Color anomalyColor = Colors.black;  // Default color for waiting status
  bool isGenerating = false;  // To track whether data generation is running
  final EVController evController = EVController();  // Instantiate the controller

  @override
  void dispose() {
    evController.stopDataGeneration();  // Stop data generation when the app is closed
    super.dispose();
  }

  // Callback function for when new data is generated
  void onDataGenerated(List<EVSession> sessions) {
    setState(() {
      // Insert the newest session at the beginning of the list
      evSessions.insert(0, sessions.last); 
    });
  }

  // Callback function for anomaly detection
  void onAnomalyDetected(String status) {
    setState(() {
      if (status.contains('Anomaly Detected')) {
        anomalyStatus = 'Anomaly Detected';
        anomalyColor = Colors.red;  // Red for anomalies
        
        // Parse the redirection status from the main status message
        redirectionStatus = status.split('|').last.trim();
        
        // Find the most recent abnormal session
latestAnomalySession = evSessions.firstWhere((session) => session.eventType == 'AbnormalCommand', orElse: () => EVSession.defaultData());        
      } else {
        anomalyStatus = 'System is Operating Normally';
        anomalyColor = Colors.green;  // Green for normal operation
        redirectionStatus = '';  // No redirection status when the system is normal
        latestAnomalySession = null;  // Reset the anomaly session
      }
    });
  }

  // Start data generation
  void startGeneratingData() {
    evController.startDataGeneration(onDataGenerated, onAnomalyDetected);
    setState(() {
      isGenerating = true;
    });
  }

  // Stop data generation
  void stopGeneratingData() {
    evController.stopDataGeneration();
    setState(() {
      isGenerating = false;
    });
  }

  // Function to format the timestamp to hh:mm:ss
  String formatTime(String timestamp) {
    DateTime parsedTime = DateTime.parse(timestamp);
    return DateFormat('HH:mm:ss').format(parsedTime);  // Format to hr:min:sec
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('EV Charging Anomaly Detector'),
      ),
      body: Column(
        children: [
          // Display anomaly status at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Anomaly Status
                Text(
                  anomalyStatus,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: anomalyColor,  // Dynamic color change based on anomaly status
                  ),
                ),
                // Redirection Status (if anomaly detected)
                if (redirectionStatus.isNotEmpty)
                  Text(
                    redirectionStatus,
                    style:const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.orangeAccent,  // Display redirection status in orange
                    ),
                  ),
              ],
            ),
          ),
          
          // Widget to display the most recent anomaly session
          if (latestAnomalySession != null && latestAnomalySession!.sessionId > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.red[50],  // Light red background to highlight the anomaly session
                elevation: 5,
                child: ListTile(
                  title: Text(
                    'Recent Anomalous Session (Session ${latestAnomalySession!.sessionId})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Network Traffic: ${latestAnomalySession!.networkTraffic}'),
                      const SizedBox(height: 4),
                      Text('Energy Usage: ${latestAnomalySession!.energyUsage} kWh'),
                      const SizedBox(height: 4),
                      Text('Generated at: ${formatTime(latestAnomalySession!.timestamp)}'),
                    ],
                  ),
                ),
              ),
            ),
          
          // Expanded list of EV charging sessions
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: evSessions.length,
                reverse: false,  // Newest data will be at the top due to insert(0, session)
                itemBuilder: (context, index) {
                  EVSession session = evSessions[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin:const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListTile(
                        title: Text(
                          'Session ${session.sessionId} - ${session.eventType}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         const   SizedBox(height: 4),
                            Text(
                              'Network Traffic: ${session.networkTraffic}, Energy Usage: ${session.energyUsage} kWh',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                         const   SizedBox(height: 4),
                            Text(
                              'Generated at: ${formatTime(session.timestamp)}',  // Display the formatted time
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        trailing: (session.eventType == 'AbnormalCommand')
                            ?const Icon(Icons.warning, color: Colors.redAccent, size: 30)
                            :const Icon(Icons.check_circle, color: Colors.green, size: 30),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Start/Stop buttons for controlling data generation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isGenerating ? null : startGeneratingData,  // Disable if already running
                      child: const Text('Start Generating'),
                    ),
                    ElevatedButton(
                      onPressed: isGenerating ? stopGeneratingData : null,  // Disable if not running
                      child: const Text('Stop Generating'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EVSession {
  final int sessionId;
  final String timestamp;
  final String networkTraffic;
  final int energyUsage;
  final String eventType;

  EVSession({
    required this.sessionId,
    required this.timestamp,
    required this.networkTraffic,
    required this.energyUsage,
    required this.eventType,
  });

  factory EVSession.fromJson(Map<String, dynamic> json) {
    return EVSession(
      sessionId: json['SessionID'],
      timestamp: json['Timestamp'],
      networkTraffic: json['NetworkTraffic'],
      energyUsage: json['EnergyUsage'],
      eventType: json['EventType'],
    );
  }
    static EVSession defaultData() {
    return EVSession(
      sessionId: 0,
      timestamp: "",
      networkTraffic: "None",
      energyUsage: 0,
      eventType: "None",
    );
  }
}

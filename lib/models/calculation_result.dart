class CalculationResult {
  final double distanceMeters;
  final double timeSeconds;
  final double paceSecondsPerKm;
  final DateTime dateTime;

  CalculationResult({
    required this.distanceMeters,
    required this.timeSeconds,
    required this.paceSecondsPerKm,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'distanceMeters': distanceMeters,
      'timeSeconds': timeSeconds,
      'paceSecondsPerKm': paceSecondsPerKm,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory CalculationResult.fromJson(Map<String, dynamic> json) {
    return CalculationResult(
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      timeSeconds: (json['timeSeconds'] as num).toDouble(),
      paceSecondsPerKm: (json['paceSecondsPerKm'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  String get formattedDistance {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(2)} km';
    }
    return '${distanceMeters.round()} m';
  }

  String get formattedTime {
    final h = (timeSeconds / 3600).floor();
    final m = ((timeSeconds % 3600) / 60).floor();
    final s = (timeSeconds % 60).round();
    
    if (h > 0) {
      return '${h}h ${m}m ${s}s';
    }
    return '${m}m ${s}s';
  }

  String get formattedPace {
    final m = (paceSecondsPerKm / 60).floor();
    final s = (paceSecondsPerKm % 60).round();
    return '${m}:${s.toString().padLeft(2, '0')} min/km';
  }
}

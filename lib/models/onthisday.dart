class OnThisDayResponse {
  final int timestamp;
  final List<OnThisDayEvent> events;

  OnThisDayResponse({required this.timestamp, required this.events});

  factory OnThisDayResponse.fromJson(Map<String, dynamic> json) =>
      OnThisDayResponse(
        timestamp: json['timestamp'] as int? ?? 0,
        events:
            (json['events'] as List<dynamic>)
                .map((e) => OnThisDayEvent.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
}

class OnThisDayEvent {
  final String year;
  final String content;
  final double sortYear;
  final String type;

  OnThisDayEvent({
    required this.year,
    required this.content,
    required this.sortYear,
    required this.type,
  });

  factory OnThisDayEvent.fromJson(Map<String, dynamic> json) => OnThisDayEvent(
    year: json['year'] as String? ?? '',
    content: json['content'] as String? ?? '',
    sortYear: (json['sort_year'] as num).toDouble(),
    type: json['type'] as String? ?? '',
  );
}

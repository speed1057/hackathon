class Team {
  final String id;
  final String eventId;
  final String name;
  final List<String> members;
  final DateTime createdAt;

  Team({
    required this.id,
    required this.eventId,
    required this.name,
    required this.members,
    required this.createdAt,
  });

  Team copyWith({
    String? id,
    String? eventId,
    String? name,
    List<String>? members,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      name: json['name'] as String,
      members: List<String>.from(json['members'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Team{id: $id, eventId: $eventId, name: $name, members: $members, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          eventId == other.eventId &&
          name == other.name &&
          members == other.members &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      eventId.hashCode ^
      name.hashCode ^
      members.hashCode ^
      createdAt.hashCode;
}

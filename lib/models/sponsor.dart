class Sponsor {
  final String id;
  final String name;
  final String logoUrl;
  final String? websiteUrl;
  final String tier; // 'platinum', 'gold', 'silver', 'bronze'

  const Sponsor({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.websiteUrl,
    required this.tier,
  });

  factory Sponsor.fromJson(Map<String, dynamic> json) => Sponsor(
    id: json['id'] as String,
    name: json['name'] as String,
    logoUrl: json['logoUrl'] as String,
    websiteUrl: json['websiteUrl'] as String?,
    tier: json['tier'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'logoUrl': logoUrl,
    'websiteUrl': websiteUrl,
    'tier': tier,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sponsor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class JobOpportunity {
  final String id;
  final String title;
  final String company;
  final String companyLogoUrl;
  final String description;
  final String applyUrl;
  final String? location;
  final String? salary;
  final String? prize;
  final String type; // 'full-time', 'part-time', 'internship', 'contract'
  final List<String> tags;
  final DateTime postedDate;
  final DateTime? applicationDeadline;

  const JobOpportunity({
    required this.id,
    required this.title,
    required this.company,
    required this.companyLogoUrl,
    required this.description,
    required this.applyUrl,
    this.location,
    this.salary,
    this.prize,
    required this.type,
    required this.tags,
    required this.postedDate,
    this.applicationDeadline,
  });

  factory JobOpportunity.fromJson(Map<String, dynamic> json) => JobOpportunity(
    id: json['id'] as String,
    title: json['title'] as String,
    company: json['company'] as String,
    companyLogoUrl: json['companyLogoUrl'] as String,
    description: json['description'] as String,
    applyUrl: json['applyUrl'] as String,
    location: json['location'] as String?,
    salary: json['salary'] as String?,
    prize: json['prize'] as String?,
    type: json['type'] as String,
    tags: (json['tags'] as List<dynamic>).cast<String>(),
    postedDate: DateTime.parse(json['postedDate'] as String),
    applicationDeadline: json['applicationDeadline'] != null
        ? DateTime.parse(json['applicationDeadline'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'company': company,
    'companyLogoUrl': companyLogoUrl,
    'description': description,
    'applyUrl': applyUrl,
    'location': location,
    'salary': salary,
    'prize': prize,
    'type': type,
    'tags': tags,
    'postedDate': postedDate.toIso8601String(),
    'applicationDeadline': applicationDeadline?.toIso8601String(),
  };

  bool get hasDeadline => applicationDeadline != null;
  bool get isExpired =>
      hasDeadline && applicationDeadline!.isBefore(DateTime.now());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobOpportunity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

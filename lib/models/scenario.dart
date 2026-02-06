// lib/models/scenario.dart (또는 api_service.dart 하단)

class Scenario {
  final int id;
  final String source;
  final String companyName;
  final String title;
  final String description;
  final String? repoUrl; // null일 수 있음
  final String dueAt;
  final String status;
  final int submissionsCount;

  Scenario({
    required this.id,
    required this.source,
    required this.companyName,
    required this.title,
    required this.description,
    this.repoUrl,
    required this.dueAt,
    required this.status,
    required this.submissionsCount,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'],
      source: json['source'],
      companyName: json['companyName'] ?? '시스템 생성',
      title: json['title'],
      description: json['description'],
      repoUrl: json['repoUrl'],
      dueAt: json['dueAt'].toString().split('T')[0],
      status: json['status'],
      submissionsCount: json['submissionsCount'],
    );
  }
}

class Submission {
  final int id;
  final int scenarioId;
  final int userAccountId;
  final String content;
  final String submittedAt;
  final bool isAdopted;
  final String? adoptedAt;

  Submission({
    required this.id,
    required this.scenarioId,
    required this.userAccountId,
    required this.content,
    required this.submittedAt,
    required this.isAdopted,
    this.adoptedAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      scenarioId: json['scenarioId'],
      userAccountId: json['userAccountId'],
      content: json['content'],
      submittedAt: json['submittedAt'].toString().split('T')[0], // 날짜 가공
      isAdopted: json['isAdopted'] ?? false,
      adoptedAt: json['adoptedAt'],
    );
  }
}
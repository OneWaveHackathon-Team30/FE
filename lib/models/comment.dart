class Comment {
  final int id;
  final int submissionId;
  final int authorId;
  final String authorNickname;
  final String content;
  final String createdAt;

  Comment({
    required this.id,
    required this.submissionId,
    required this.authorId,
    required this.authorNickname,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      submissionId: json['submissionId'],
      authorId: json['authorId'],
      authorNickname: json['authorNickname'] ?? '익명',
      content: json['content'],
      createdAt: json['createdAt'].toString().split('T')[0], // YYYY-MM-DD 형식 가공
    );
  }
}
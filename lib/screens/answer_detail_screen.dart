import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../services/api_service.dart';

class AnswerDetailScreen extends StatefulWidget {
  final int scenarioId;
  final int submissionId;
  final String username;
  final String date;
  final String content;
  final int commentCount;

  const AnswerDetailScreen({
    super.key,
    required this.scenarioId,
    required this.submissionId,
    required this.username,
    required this.date,
    required this.content,
    required this.commentCount,
  });

  @override
  State<AnswerDetailScreen> createState() => _AnswerDetailScreenState();
}

class _AnswerDetailScreenState extends State<AnswerDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  void _refreshComments() {
    setState(() {
      _commentsFuture = ApiService().getComments(widget.submissionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('답변 상세보기')),
      body: Column(
        children: [
          // 1. 답변 본문 영역 (기존 코드)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Divider(height: 30),
                  Text(widget.content), // 마크다운 렌더러 사용 권장
                  const SizedBox(height: 30),
                  const Text('댓글', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // 2. 댓글 목록 영역
                  _buildCommentList(),
                ],
              ),
            ),
          ),

          // 3. 댓글 입력창 영역
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentList() {
    return FutureBuilder<List<Comment>>(
      future: _commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final comments = snapshot.data ?? [];
        if (comments.isEmpty) return const Text('첫 댓글을 남겨보세요.');

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.authorNickname, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(comment.content),
                  Text(comment.createdAt, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(hintText: '댓글을 입력하세요...', border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF7C4DFF)),
            onPressed: () async {
              if (_commentController.text.trim().isEmpty) return;

              bool success = await ApiService().createComment(
                  widget.submissionId,
                  _commentController.text.trim()
              );

              if (success) {
                _commentController.clear();
                _refreshComments(); // 댓글 목록 새로고침
              }
            },
          ),
        ],
      ),
    );
  }
}
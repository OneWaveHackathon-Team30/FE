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
      _commentsFuture = ApiService().getComments(widget.submissionId); // 댓글 목록 조회
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '답변 상세보기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작성자 정보
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.person, color: Colors.grey, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(widget.date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 40),

                  // 답변 내용
                  Text(
                    widget.content,
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                  const SizedBox(height: 40),

                  // 댓글 섹션 타이틀
                  const Text('댓글', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // 댓글 목록 영역
                  _buildCommentList(),
                ],
              ),
            ),
          ),

          // 댓글 입력창 영역
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
        if (comments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('첫 댓글을 남겨보세요.', style: TextStyle(color: Colors.grey[500])),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.authorNickname, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(comment.content, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(comment.createdAt, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
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
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: '댓글을 입력하세요...',
                border: InputBorder.none, // BorderSide.none에서 InputBorder.none으로 수정
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF7C4DFF)),
            onPressed: () async {
              final content = _commentController.text.trim();
              if (content.isEmpty) return;

              // 댓글 작성 API 호출
              bool success = await ApiService().createComment(
                widget.submissionId,
                content,
              );

              if (success) {
                _commentController.clear();
                _refreshComments(); // 목록 새로고침
              }
            },
          ),
        ],
      ),
    );
  }
}
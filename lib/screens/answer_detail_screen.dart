import 'package:flutter/material.dart';

class AnswerDetailScreen extends StatefulWidget {
  final String username;
  final String date;
  final String content;
  final int commentCount;

  const AnswerDetailScreen({
    super.key,
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
  final List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    // 샘플 댓글 데이터
    _comments.addAll([
      Comment(
        username: '이지은',
        date: '2025.05.18 14:20',
        content: '정말 공감되는 내용이네요! 특히 소통의 중요성에 대해서 다시 한번 생각해봅니다. 좋은 정보 감사합니다.',
      ),
      Comment(
        username: '박지성',
        date: '2025.05.18 15:45',
        content: '초기 설계 단계에서 어떤 툴을 사용하셨는지 궁금합니다. 저희 팀도 비슷한 고민을 하고 있거든요.',
      ),
      Comment(
        username: '최유리',
        date: '2025.05.19 09:12',
        content: '무엇보다 단박 감사합니다. 스크랩해갔고 나중에 다시 읽어봐야겠어요.',
      ),
      Comment(
        username: '정민준',
        date: '2025.05.19 11:30',
        content: '문서화의 중요성을 다시 깨달았습니다. 감사합니다.',
      ),
    ]);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '답변',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF212121)),
            onPressed: () {
              // 더보기 메뉴
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 원본 답변
                  _buildOriginalAnswer(),

                  const SizedBox(height: 8),

                  // 댓글 헤더
                  _buildCommentHeader(),

                  // 댓글 목록
                  ..._comments.map((comment) => _buildCommentCard(comment)),
                ],
              ),
            ),
          ),

          // 댓글 입력 영역
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildOriginalAnswer() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 작성자 정보
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 답변 내용
          Text(
            widget.content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),

          const SizedBox(height: 16),

          // 댓글 수
          Row(
            children: [
              Icon(
                Icons.comment_rounded,
                size: 18,
                color: Colors.grey[400],
              ),
              const SizedBox(width: 4),
              Text(
                '${_comments.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            '댓글 ${_comments.length}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 아이콘
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 댓글 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  comment.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 프로필 아이콘
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 입력 필드
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: '맛글을 입력하세요...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 전송 버튼
            GestureDetector(
              onTap: () {
                if (_commentController.text.trim().isNotEmpty) {
                  setState(() {
                    _comments.add(
                      Comment(
                        username: '나',
                        date: DateTime.now().toString().substring(0, 16).replaceAll('-', '.'),
                        content: _commentController.text,
                      ),
                    );
                    _commentController.clear();
                  });
                }
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C4DFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Comment {
  final String username;
  final String date;
  final String content;

  Comment({
    required this.username,
    required this.date,
    required this.content,
  });
}
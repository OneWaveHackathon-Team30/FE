import 'package:flutter/material.dart';
import 'package:onewave_fe/widgets/common_widgets.dart';
import 'answer_detail_screen.dart';
import 'answer_write_screen.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String category;
  final String title;
  final String dueDate;
  final String field;
  final String participants;
  final bool isCompleted;

  const ChallengeDetailScreen({
    super.key,
    required this.category,
    required this.title,
    required this.dueDate,
    required this.field,
    required this.participants,
    this.isCompleted = false,
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  final TextEditingController _answerController = TextEditingController();
  final List<Answer> _answers = [
    Answer(
      username: '김철수',
      date: '2025.05',
      content: '### 제안 배경 아커머스 플랫폼 내에서 20대 사용자의 구매 전환율을 높이기 위해 생성형 AI를 활용한 가상 피팅 룸 기능을 제안합니다.',
      comments: 4,
      isMy: false,
    ),
    Answer(
      username: '이영희',
      date: '2025.05',
      content: '#### 1. 이용 방식 전반 데이터 분석을 통한 차별화. 이를 방지 전략입니다. 사용자가 검색 단계에서 이탈하는 데 실시간으...',
      comments: 2,
      isMy: false,
    ),
    Answer(
      username: '나의 답변',
      date: '2025.05',
      content: '# AI 챗봇 도입 기획안 검색 행위 최적화와 결합된 AI 챗봇 도입입니다. 사용자의 검색 의도를 파악해...',
      comments: 0,
      isMy: true,
    ),
  ];

  @override
  void dispose() {
    _answerController.dispose();
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
          '퀘스트 상세',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더 정보
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 카테고리 배지들
                        Row(
                          children: [
                            CareerBadge(text: '답변 받는 중', color: Color(0xFF7C4DFF)),
                            const SizedBox(width: 8),
                            CareerBadge(text: 'AI 생성', color: Color(0xFF616161)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 제목
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 정보 카드
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // 마감 일자
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '마감 일자',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 16,
                                          color: Color(0xFF7C4DFF),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.dueDate,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF212121),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // 참여 인원
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '참여 인원',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.people_outline,
                                          size: 16,
                                          color: Color(0xFF7C4DFF),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.participants,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF212121),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 생성자
                        Row(
                          children: [
                            Text(
                              '생성자',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Color(0xFF7C4DFF),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.field,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 퀘스트 설명
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '퀘스트 설명',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '본 퀘스트는 이커머스 플랫폼의 사용자 이탈률을 분석하고, AI 기술을 접목하여 개인화된 추천 시스템을 제안하는 실무형 과제입니다.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 수행 가이드
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C4DFF).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF7C4DFF).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '수행 가이드',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildGuideLine('특정 타겟 유저층 정의 (MZ세대 등)'),
                              _buildGuideLine('현재 서비스의 UI/UX 문제점 도출'),
                              _buildGuideLine('AI 기반 해결 방안 및 기대효과 작성'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 안내 메시지
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                                color: Color(0xFFFFA726),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF616161),
                                    ),
                                    children: [
                                      TextSpan(text: '제출물 형식은 '),
                                      TextSpan(
                                        text: '마크다운(Markdown)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: ' 입력만 가능합니다.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 제출된 답변
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                                children: [
                                  const TextSpan(text: '제출된 답변  '),
                                  TextSpan(
                                    text: '${_answers.length}',
                                    style: const TextStyle(
                                      color: Color(0xFF7C4DFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 안내 메시지
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C4DFF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Color(0xFF7C4DFF),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'AI 생성 퀘스트로 모든 답안자의 답변이 공개됩니다.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 답변 리스트
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _answers.length,
                          itemBuilder: (context, index) {
                            return _buildAnswerCard(_answers[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // 하단 답변 입력 영역
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 답변 작성 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnswerWriteScreen(
                          questTitle: widget.title,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '마크다운으로 답변 제출하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF212121),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(Answer answer) {
    return GestureDetector(
      onTap: () {
        // 답변 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnswerDetailScreen(
              username: answer.username,
              date: answer.date,
              content: answer.content,
              commentCount: answer.comments,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: answer.isMy ? const Color(0xFF7C4DFF).withOpacity(0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: answer.isMy ? const Color(0xFF7C4DFF) : Colors.transparent,
            width: answer.isMy ? 2 : 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 프로필 아이콘
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 사용자 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            answer.username,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          if (answer.isMy) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C4DFF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'MY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        answer.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 답변 내용
            Text(
              answer.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // 좋아요
            Row(
              children: [
                Icon(
                  Icons.comment_rounded,
                  size: 18,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  '${answer.comments}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Answer {
  final String username;
  final String date;
  final String content;
  final int comments;
  final bool isMy;

  Answer({
    required this.username,
    required this.date,
    required this.content,
    required this.comments,
    required this.isMy,
  });
}
import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final List<Quest> _myQuests = [
    Quest(
      category: 'AI 퀘스트',
      categoryColor: const Color(0xFF7C4DFF),
      title: '판매의 숨결 단계 간소화 UX 설계',
      subtitle: '제품 환골 · 심사 중',
      date: '2025.02.14',
    ),
    Quest(
      category: '기업 퀘스트',
      categoryColor: const Color(0xFF00C853),
      title: 'OTT 서비스 개인화 추천 UI 개선',
      subtitle: '채택됨',
      date: '2025.02.08',
      isAdopted: true,
    ),
    Quest(
      category: 'AI 퀘스트',
      categoryColor: const Color(0xFF7C4DFF),
      title: '배달 앱 정확도↑진 전환율 개선',
      subtitle: '채택됨',
      date: '2025.01.28',
      isAdopted: true,
    ),
  ];

  final List<AdoptedAnswer> _adoptedAnswers = [
    AdoptedAnswer(
      solutionNumber: '#0324',
      title: 'OTT 서비스 추천 UI 개선안',
    ),
    AdoptedAnswer(
      solutionNumber: '#0211',
      title: '배달 앱 전환율 최적화 보고서',
    ),
    AdoptedAnswer(
      solutionNumber: '#0105',
      title: '커머스 필터 시스템 재설계',
    ),
  ];

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
          '마이 페이지',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 섹션
            _buildProfileSection(),

            const SizedBox(height: 16),

            // 채택 현황
            _buildStaminaSection(),

            const SizedBox(height: 24),

            // 내가 쓴 문제 목록
            _buildMyQuestsSection(),

            const SizedBox(height: 24),

            // 채택된 답변 링크
            _buildAdoptedAnswersSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // 프로필 아이콘
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF7C4DFF),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Center(
              child: Text(
                'CQ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // 사용자 이름
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '김유저',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaminaSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF7C4DFF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 체력 정보
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '채택 횟수',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '3',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C4DFF),
                        height: 1.0,
                      ),
                    ),
                    SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        '회',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7C4DFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 트로피 아이콘
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Color(0xFF7C4DFF),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyQuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '내가 쓴 문제 목록',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 퀘스트 리스트
        Container(
          color: Colors.white,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _myQuests.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              return _buildQuestCard(_myQuests[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuestCard(Quest quest) {
    return InkWell(
      onTap: () {
        // 퀘스트 상세 페이지로 이동
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리와 날짜
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: quest.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    quest.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: quest.categoryColor,
                    ),
                  ),
                ),
                Text(
                  quest.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 제목
            Text(
              quest.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),

            const SizedBox(height: 8),

            // 부제목
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: quest.isAdopted
                    ? const Color(0xFF00C853).withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                quest.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: quest.isAdopted
                      ? const Color(0xFF00C853)
                      : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdoptedAnswersSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '채택된 답변 링크',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),

          // 채택된 답변 목록
          ..._adoptedAnswers.map((answer) => _buildAdoptedAnswerCard(answer)),
        ],
      ),
    );
  }

  Widget _buildAdoptedAnswerCard(AdoptedAnswer answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // 솔루션 상세 페이지로 이동
        },
        child: Row(
          children: [
            // 링크 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF7C4DFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.link,
                color: Color(0xFF7C4DFF),
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solution ${answer.solutionNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7C4DFF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    answer.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            ),

            // 화살표 아이콘
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class Quest {
  final String category;
  final Color categoryColor;
  final String title;
  final String subtitle;
  final String date;
  final bool isAdopted;

  Quest({
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isAdopted = false,
  });
}

class AdoptedAnswer {
  final String solutionNumber;
  final String title;

  AdoptedAnswer({
    required this.solutionNumber,
    required this.title,
  });
}
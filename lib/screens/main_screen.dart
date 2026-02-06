import 'package:flutter/material.dart';
import 'package:onewave_fe/widgets/common_widgets.dart';
import 'quest_detail_screen.dart';
import 'mypage_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 로고
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 30,),
                      children: const [
                        TextSpan(
                          text: 'Career',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' Quest',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C4DFF),    // 기존 보라색 유지
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 프로필 아이콘
                  GestureDetector(
                    onTap: () {
                      // 마이페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyPageScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C4DFF).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'CQ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C4DFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 탭바
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF7C4DFF),
                unselectedLabelColor: Colors.grey[500],
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: const Color(0xFF7C4DFF),
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'AI 생성'),
                  Tab(text: '기업 주최'),
                ],
              ),
            ),

            // 탭 컨텐츠
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // AI 생성 탭
                  _buildChallengeList(),
                  // 기업 주최 탭 (동일한 리스트)
                  _buildChallengeList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildChallengeCard(
          category: '답변 받는 중',
          categoryColor: const Color(0xFF7C4DFF),
          title: '신입 서비스 기획자를 위한 AI 역량 강화 프로젝트: 이커머스 분석',
          dueDate: '2025.05.30',
          field: 'AI 커리어 튜터',
          participants: '128명 참여 중',
        ),
        const SizedBox(height: 16),
        _buildChallengeCard(
          category: '채택 중',
          categoryColor: const Color(0xFFFF9800),
          title: '데이터 사이언티스트 실무 과제: 금융 트렌드 예측 모델링',
          dueDate: '2025.04.15',
          field: '데이터 마스터 AI',
          participants: '84명 참여 중',
        ),
        const SizedBox(height: 16),
        _buildChallengeCard(
          category: '채택 완료',
          categoryColor: Colors.grey[400]!,
          title: 'UX/UI 디자인 시스템 구축 가이드라인 제작 챌린지',
          dueDate: '2025.03.10',
          field: '디자인 멘토 AI',
          participants: '256명 참여 완료',
          isCompleted: true,
        ),
      ],
    );
  }

  Widget _buildChallengeCard({
    required String category,
    required Color categoryColor,
    required String title,
    required String dueDate,
    required String field,
    required String participants,
    bool isCompleted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // 챌린지 상세 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChallengeDetailScreen(
                  category: category,
                  title: title,
                  dueDate: dueDate,
                  field: field,
                  participants: participants,
                  isCompleted: isCompleted,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 배지
                CareerBadge(text: category, color: categoryColor),
                const SizedBox(height: 16),

                // 제목
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // 마감일
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '마감 일자 : $dueDate',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 생성자 필드
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '생성자 : $field',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 참여자 수와 화살표
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      participants,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (isCompleted)
                      GestureDetector(
                        onTap: () {
                          print('결과 보기 클릭');
                        },
                        child: const Text(
                          '결과 보기',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF7C4DFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
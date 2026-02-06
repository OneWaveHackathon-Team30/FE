import 'package:flutter/material.dart';
import 'package:onewave_fe/widgets/common_widgets.dart';
import 'quest_detail_screen.dart';
import 'mypage_screen.dart';
import '../services/api_service.dart';
import '../models/scenario.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Scenario>> _scenariosFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scenariosFuture = ApiService().getScenarios();
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
            // lib/screens/main_screen.dart의 TabBarView 부분
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // AI 생성 탭 (GEMINI 데이터 조회)
                  _buildChallengeList('GEMINI'),
                  // 기업 주최 탭 (COMPANY 데이터 조회)
                  _buildChallengeList('COMPANY'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeList(String sourceFilter) {
    return FutureBuilder<List<Scenario>>(
      future: _scenariosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('에러 상세: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        // source 값에 따라 필터링 (GEMINI: AI 생성, COMPANY: 기업 주최)
        final filteredList = snapshot.data!
            .where((s) => s.source == sourceFilter)
            .toList();

        if (filteredList.isEmpty) {
          return const Center(child: Text('등록된 퀘스트가 없습니다.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final scenario = filteredList[index]; // 여기서 scenario가 정의됨
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildChallengeCard(
                scenario: scenario,
                category: scenario.status == 'OPEN' ? '답변 받는 중' : '마감됨',
                categoryColor: scenario.status == 'OPEN' ? const Color(0xFF7C4DFF) : Colors.grey,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChallengeCard({
    required Scenario scenario,
    required String category,
    required Color categoryColor,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChallengeDetailScreen(scenarioId: scenario.id),
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
                  scenario.title,
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
                      '마감 일자 : ${scenario.dueAt}',
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
                      '생성자 : ${scenario.companyName}',
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
                      '${scenario.submissionsCount}명 참여 중', // participants -> 계산된 문자열
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                    if (isCompleted)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyPageScreen(),
                            ),
                          );
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
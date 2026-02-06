import 'package:flutter/material.dart';
import '../models/scenario.dart';
import '../services/api_service.dart';
import 'answer_detail_screen.dart';

// lib/screens/quest_detail_screen.dart

class ChallengeDetailScreen extends StatefulWidget {
  final int scenarioId;

  const ChallengeDetailScreen({super.key, required this.scenarioId});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late Future<Scenario> _scenarioFuture;

  @override
  void initState() {
    super.initState();
    // 화면이 열릴 때 ID를 기반으로 상세 정보 조회 시작
    _scenarioFuture = ApiService().getScenarioById(widget.scenarioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('퀘스트 상세')),
      body: FutureBuilder<Scenario>(
        future: _scenarioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('데이터를 찾을 수 없습니다.'));
          }

          final scenario = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scenario.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('작성자: ${scenario.companyName}', style: TextStyle(color: Colors.grey[600])),
                const Divider(height: 40),

                const Text('과제 설명', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(scenario.description), // 서버에서 받은 긴 설명 표시

                if (scenario.repoUrl != null) ...[
                  const SizedBox(height: 20),
                  const Text('참조 저장소', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(scenario.repoUrl!, style: const TextStyle(color: Colors.blue)),
                ],

                const SizedBox(height: 40),
                // 여기에 '답변하기' 버튼 등을 배치할 수 있습니다.
              ],
            ),
          );
        },
      ),
    );
  }

  // lib/screens/quest_detail_screen.dart 내부에 추가

  Widget _buildSubmissionList() {
    return FutureBuilder<List<Submission>>(
      future: ApiService().getSubmissions(widget.scenarioId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final submissions = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('답변 ${submissions.length}개',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // ScrollView 안에 있으므로 필수
              physics: const NeverScrollableScrollPhysics(),
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final item = submissions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(item.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('제출일: ${item.submittedAt}'),
                    trailing: item.isAdopted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () async {
                      // 답변 상세 페이지로 이동
                      final bool? shouldRefresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnswerDetailScreen(
                            scenarioId: widget.scenarioId,
                            submissionId: item.id,
                            username: 'User #${item.userAccountId}', // 나중에 서버에서 닉네임을 주면 대체하세요.
                            date: item.submittedAt,
                            content: item.content,
                            commentCount: 0, // 현재 API에 댓글 수가 없다면 임시로 0을 넣습니다.
                          ),
                        ),
                      );

                      // 만약 상세 페이지에서 '채택' 등의 작업이 일어나고 돌아왔다면 목록 새로고침
                      if (shouldRefresh == true) {
                        setState(() {
                          // FutureBuilder가 다시 실행되도록 처리 (필요 시)
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
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

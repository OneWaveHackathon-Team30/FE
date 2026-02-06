import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AnswerWriteScreen extends StatefulWidget {
  final String questTitle;

  const AnswerWriteScreen({
    super.key,
    required this.questTitle,
  });

  @override
  State<AnswerWriteScreen> createState() => _AnswerWriteScreenState();
}

class _AnswerWriteScreenState extends State<AnswerWriteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _contentController = TextEditingController();
  bool _showGuide = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 샘플 마크다운 가이드 텍스트
    _contentController.text = '''마크다운 형식을 사용하여 답변을 작성해보세요.

예시:
### 주요 특징
- 결과물 UI 디자인
- 직관적인 UX''';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contentController.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '답변 작성',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _submitAnswer,
            child: const Text(
              '등록',
              style: TextStyle(
                color: Color(0xFF7C4DFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 탭 바
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF7C4DFF),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF7C4DFF),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: '에디터'),
                Tab(text: '미리보기'),
              ],
            ),
          ),

          // 마크다운 툴바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildToolbarButton(Icons.format_bold, 'B', _insertBold),
                  _buildToolbarButton(Icons.format_italic, 'I', _insertItalic),
                  _buildToolbarButton(Icons.title, 'H', _insertHeading),
                  _buildToolbarButton(Icons.format_quote, '""', _insertQuote),
                  _buildToolbarButton(Icons.format_list_bulleted, '•', _insertBulletList),
                  _buildToolbarButton(Icons.format_list_numbered, '1.', _insertNumberedList),
                  _buildToolbarButton(Icons.link, '', _insertLink),
                  _buildToolbarButton(Icons.image, '', _insertImage),
                  _buildToolbarButton(Icons.code, '</>', _insertCode),
                ],
              ),
            ),
          ),

          // 컨텐츠 영역
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 에디터 탭
                _buildEditorTab(),
                // 미리보기 탭
                _buildPreviewTab(),
              ],
            ),
          ),

          // 가이드 바텀 시트
          if (_showGuide) _buildGuideBottomSheet(),

          // 제출 버튼
          Container(
            padding: const EdgeInsets.all(20),
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
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '답변 제출하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: label.isEmpty
              ? Icon(icon, size: 18, color: const Color(0xFF212121))
              : Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditorTab() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _contentController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF212121),
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText: '제목을 입력하세요',
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {}); // 미리보기 업데이트
        },
      ),
    );
  }

  Widget _buildPreviewTab() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: _contentController.text.isEmpty
            ? Center(
          child: Text(
            '작성된 내용이 없습니다',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[400],
            ),
          ),
        )
            : Markdown(
          data: _contentController.text,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              fontSize: 15,
              color: Color(0xFF212121),
              height: 1.6,
            ),
            h1: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
            h2: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
            h3: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
            listBullet: const TextStyle(
              fontSize: 15,
              color: Color(0xFF212121),
            ),
            code: TextStyle(
              fontSize: 14,
              backgroundColor: Colors.grey[100],
              color: const Color(0xFF7C4DFF),
            ),
            blockquote: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideBottomSheet() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7C4DFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF7C4DFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '마크다운 가이드',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '# 제목, **굵게**, [링크](url) 등 마크다운 문법을 사용하여 내용을 더 풍성하게 꾸며보세요.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showGuide = false;
              });
            },
            icon: Icon(
              Icons.close,
              color: Colors.grey[600],
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // 마크다운 삽입 함수들
  void _insertBold() {
    _insertMarkdown('**', '**', '굵은 텍스트');
  }

  void _insertItalic() {
    _insertMarkdown('*', '*', '기울임 텍스트');
  }

  void _insertHeading() {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final lineStart = text.lastIndexOf('\n', selection.start - 1) + 1;

    final newText = text.substring(0, lineStart) +
        '### ' +
        text.substring(lineStart);

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: lineStart + 4),
    );
  }

  void _insertQuote() {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final lineStart = text.lastIndexOf('\n', selection.start - 1) + 1;

    final newText = text.substring(0, lineStart) +
        '> ' +
        text.substring(lineStart);

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: lineStart + 2),
    );
  }

  void _insertBulletList() {
    _insertAtLineStart('- ', '항목');
  }

  void _insertNumberedList() {
    _insertAtLineStart('1. ', '항목');
  }

  void _insertLink() {
    _insertMarkdown('[', '](url)', '링크 텍스트');
  }

  void _insertImage() {
    _insertMarkdown('![', '](url)', '이미지 설명');
  }

  void _insertCode() {
    _insertMarkdown('`', '`', '코드');
  }

  void _insertMarkdown(String before, String after, String placeholder) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final start = selection.start;
    final end = selection.end;

    String selectedText = '';
    if (start != end) {
      selectedText = text.substring(start, end);
    } else {
      selectedText = placeholder;
    }

    final newText = text.substring(0, start) +
        before +
        selectedText +
        after +
        text.substring(end);

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: start + before.length,
        extentOffset: start + before.length + selectedText.length,
      ),
    );
  }

  void _insertAtLineStart(String prefix, String placeholder) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final lineStart = text.lastIndexOf('\n', selection.start - 1) + 1;

    final newText = text.substring(0, lineStart) +
        prefix +
        placeholder +
        text.substring(lineStart);

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: lineStart + prefix.length,
        extentOffset: lineStart + prefix.length + placeholder.length,
      ),
    );
  }

  void _submitAnswer() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('답변 내용을 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 답변 제출 처리
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('답변 제출'),
        content: const Text('답변을 제출하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 작성 화면 닫기
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('답변이 제출되었습니다'),
                  backgroundColor: Color(0xFF7C4DFF),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(
                    bottom: 100,
                    left: 20,
                    right: 20,
                  ),
                ),
              );
            },
            child: const Text('제출'),
          ),
        ],
      ),
    );
  }
}
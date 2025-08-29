import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/models/chat_message.dart';
import '../../../../shared/models/ai_model.dart';

class ChatHistoryScreen extends ConsumerStatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  ConsumerState<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends ConsumerState<ChatHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatMessage> _allMessages = [];
  List<ChatMessage> _filteredMessages = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final querySnapshot = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: user.uid)
          .get();

      final messages = querySnapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
          .toList();

      // 클라이언트 사이드에서 타임스탬프로 정렬 (최신순)
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        _allMessages = messages;
        _filteredMessages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('채팅 기록을 불러오는 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterMessages() {
    setState(() {
      _filteredMessages = _allMessages.where((message) {
        bool matchesCategory = _selectedCategory == 'all' || 
                              message.category.name == _selectedCategory;
        bool matchesSearch = _searchQuery.isEmpty ||
                            message.content.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  Future<void> _deleteMessage(String messageId) async {
    try {
      await _firestore.collection('chats').doc(messageId).delete();
      
      setState(() {
        _allMessages.removeWhere((message) => message.id == messageId);
        _filteredMessages.removeWhere((message) => message.id == messageId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('메시지가 삭제되었습니다'),
          backgroundColor: AppTheme.calmColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('메시지 삭제 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAllMessages() async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final querySnapshot = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: user.uid)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      setState(() {
        _allMessages.clear();
        _filteredMessages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 채팅 기록이 삭제되었습니다'),
          backgroundColor: AppTheme.calmColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('채팅 기록 삭제 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportChatHistory() async {
    final chatData = _allMessages.map((message) => {
      'timestamp': message.timestamp.toIso8601String(),
      'type': message.type.name,
      'category': message.category.name,
      'content': message.content,
    }).toList();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('채팅 기록 내보내기 기능이 곧 제공될 예정입니다'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundStart,
              AppTheme.backgroundEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildSearchAndFilter(),
              _buildStats(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildMessagesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '채팅 기록 관리',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 20,
              ),
            ),
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportChatHistory();
                  break;
                case 'deleteAll':
                  _showDeleteAllDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 12),
                    Text('기록 내보내기'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'deleteAll',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text('모든 기록 삭제', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              _searchQuery = value;
              _filterMessages();
            },
            decoration: InputDecoration(
              hintText: '메시지 내용 검색...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', '전체'),
                const SizedBox(width: 8),
                _buildFilterChip('flirting', '썸'),
                const SizedBox(width: 8),
                _buildFilterChip('dating', '연애중'),
                const SizedBox(width: 8),
                _buildFilterChip('breakup', '이별후'),
                const SizedBox(width: 8),
                _buildFilterChip('reconciliation', '재회'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = category;
        });
        _filterMessages();
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildStats() {
    final totalMessages = _allMessages.length;
    final userMessages = _allMessages.where((m) => m.type == MessageType.user).length;
    final aiMessages = _allMessages.where((m) => m.type == MessageType.ai).length;

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('전체 메시지', totalMessages.toString(), Icons.chat_bubble_outline),
          _buildStatItem('내 메시지', userMessages.toString(), Icons.person_outline),
          _buildStatItem('AI 응답', aiMessages.toString(), Icons.psychology_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    if (_filteredMessages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppTheme.textHint,
            ),
            SizedBox(height: 16),
            Text(
              '채팅 기록이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _filteredMessages.length,
      itemBuilder: (context, index) {
        final message = _filteredMessages[index];
        return _buildMessageTile(message);
      },
    );
  }

  Widget _buildMessageTile(ChatMessage message) {
    final isUser = message.type == MessageType.user;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isUser ? AppTheme.primaryColor : AppTheme.accentColor,
                child: Icon(
                  isUser ? Icons.person : Icons.psychology,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isUser ? '나' : 'AI 상담사',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                _formatTimestamp(message.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textHint,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                onPressed: () => _showDeleteDialog(message.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.content,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getCategoryColor(message.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getCategoryLabel(message.category),
              style: TextStyle(
                fontSize: 12,
                color: _getCategoryColor(message.category),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  String _getCategoryLabel(ConsultationCategory category) {
    switch (category) {
      case ConsultationCategory.flirting:
        return '썸';
      case ConsultationCategory.dating:
        return '연애중';
      case ConsultationCategory.breakup:
        return '이별후';
      case ConsultationCategory.reconciliation:
        return '재회';
    }
  }

  Color _getCategoryColor(ConsultationCategory category) {
    switch (category) {
      case ConsultationCategory.flirting:
        return Colors.pink;
      case ConsultationCategory.dating:
        return Colors.blue;
      case ConsultationCategory.breakup:
        return Colors.orange;
      case ConsultationCategory.reconciliation:
        return Colors.purple;
    }
  }

  void _showDeleteDialog(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('메시지 삭제'),
        content: const Text('이 메시지를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMessage(messageId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모든 채팅 기록 삭제'),
        content: const Text('모든 채팅 기록을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllMessages();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('모든 기록 삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
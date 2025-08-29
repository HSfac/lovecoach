import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _chatNotifications = true;
  bool _promotionNotifications = false;
  bool _systemNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _chatNotifications = prefs.getBool('chat_notifications') ?? true;
      _promotionNotifications = prefs.getBool('promotion_notifications') ?? false;
      _systemNotifications = prefs.getBool('system_notifications') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('email_notifications', _emailNotifications);
    await prefs.setBool('chat_notifications', _chatNotifications);
    await prefs.setBool('promotion_notifications', _promotionNotifications);
    await prefs.setBool('system_notifications', _systemNotifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      appBar: AppBar(
        title: const Text('알림 설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 헤더
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // 푸시 알림 섹션
              _buildSection(
                '푸시 알림',
                [
                  _NotificationItem(
                    title: '푸시 알림 허용',
                    subtitle: '앱에서 보내는 모든 알림을 받습니다',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                        if (!value) {
                          _chatNotifications = false;
                          _systemNotifications = false;
                        }
                      });
                      _saveSettings();
                    },
                  ),
                  _NotificationItem(
                    title: '채팅 알림',
                    subtitle: 'AI 상담사의 응답 알림',
                    value: _chatNotifications && _pushNotifications,
                    onChanged: _pushNotifications ? (value) {
                      setState(() {
                        _chatNotifications = value;
                      });
                      _saveSettings();
                    } : null,
                  ),
                  _NotificationItem(
                    title: '시스템 알림',
                    subtitle: '앱 업데이트, 점검 등 중요 알림',
                    value: _systemNotifications && _pushNotifications,
                    onChanged: _pushNotifications ? (value) {
                      setState(() {
                        _systemNotifications = value;
                      });
                      _saveSettings();
                    } : null,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 이메일 알림 섹션
              _buildSection(
                '이메일 알림',
                [
                  _NotificationItem(
                    title: '이메일 알림 허용',
                    subtitle: '이메일로 알림을 받습니다',
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                        if (!value) {
                          _promotionNotifications = false;
                        }
                      });
                      _saveSettings();
                    },
                  ),
                  _NotificationItem(
                    title: '프로모션 알림',
                    subtitle: '할인, 이벤트 등 혜택 정보',
                    value: _promotionNotifications && _emailNotifications,
                    onChanged: _emailNotifications ? (value) {
                      setState(() {
                        _promotionNotifications = value;
                      });
                      _saveSettings();
                    } : null,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 알림 시간 설정
              _buildTimeSettings(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '알림 설정',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '받고 싶은 알림을 선택하세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_NotificationItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              
              return Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: item.onChanged != null ? AppTheme.textPrimary : AppTheme.textHint,
                      ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: item.onChanged != null ? AppTheme.textSecondary : AppTheme.textHint,
                      ),
                    ),
                    value: item.value,
                    onChanged: item.onChanged,
                    activeColor: AppTheme.primaryColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey[200],
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '알림 시간 설정',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.bedtime, color: AppTheme.accentColor),
            title: const Text('방해 금지 모드'),
            subtitle: const Text('22:00 - 08:00 (알림 음소거)'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: 방해 금지 모드 설정
              },
              activeColor: AppTheme.primaryColor,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
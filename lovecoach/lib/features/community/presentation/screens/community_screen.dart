import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/providers/community_provider.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/widgets/notification_widget.dart';
import '../../../../shared/utils/notification_utils.dart';
import '../widgets/post_card.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> categories = [
    {'key': 'all', 'label': '전체'},
    {'key': 'dating', 'label': '연애'},
    {'key': 'relationship', 'label': '관계'},
    {'key': 'breakup', 'label': '이별'},
    {'key': 'advice', 'label': '조언'},
    {'key': 'chat', 'label': '잡담'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    
    // Add demo notifications on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationUtils.addDemoNotifications(ref);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateProvider).value;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '커뮤니티',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          NotificationBell(
            onTap: () {
              showNotificationPanel(context);
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.pink,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.pink,
          onTap: (index) {
            ref.read(selectedCategoryProvider.notifier).state = categories[index]['key']!;
          },
          tabs: categories.map((category) => Tab(text: category['label'])).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          return Consumer(
            builder: (context, ref, child) {
              final postsAsync = ref.watch(communityPostsProvider(category['key']!));
              
              return postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '아직 게시글이 없어요',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '첫 번째 게시글을 작성해보세요!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(communityPostsProvider(category['key']!));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 80),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final isLiked = currentUser != null && 
                            post.likedBy.contains(currentUser.uid);
                        
                        return PostCard(
                          post: post,
                          isLiked: isLiked,
                          onTap: () {
                            context.push('/community/post/${post.id}');
                          },
                          onLike: () {
                            if (currentUser != null) {
                              ref.read(communityNotifierProvider.notifier)
                                  .toggleLike(post.id, currentUser.uid);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '게시글을 불러올 수 없어요',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/community/write');
        },
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
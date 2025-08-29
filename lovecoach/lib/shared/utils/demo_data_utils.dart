import '../models/user_model.dart';
import '../models/community_post.dart';
import '../models/comment.dart';

class DemoDataUtils {
  // Create demo users with different subscription status and ranks
  static List<UserModel> createDemoUsers() {
    return [
      // Premium Master user
      UserModel(
        id: 'user1',
        email: 'master@example.com',
        displayName: '러브마스터',
        isSubscribed: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
        communityPostCount: 150,
        communityCommentCount: 500,
        communityLikeReceived: 800,
        communityLikeGiven: 300,
        communityRank: 'master',
      ),
      
      // Premium Gold user
      UserModel(
        id: 'user2',
        email: 'gold@example.com',
        displayName: '연애고수',
        isSubscribed: true,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
        communityPostCount: 50,
        communityCommentCount: 120,
        communityLikeReceived: 180,
        communityLikeGiven: 100,
        communityRank: 'gold',
      ),
      
      // Regular Silver user
      UserModel(
        id: 'user3',
        email: 'silver@example.com',
        displayName: '연애중급자',
        isSubscribed: false,
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        updatedAt: DateTime.now(),
        communityPostCount: 20,
        communityCommentCount: 60,
        communityLikeReceived: 90,
        communityLikeGiven: 50,
        communityRank: 'silver',
      ),
      
      // Regular Bronze user
      UserModel(
        id: 'user4',
        email: 'bronze@example.com',
        displayName: '연애초보',
        isSubscribed: false,
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
        updatedAt: DateTime.now(),
        communityPostCount: 8,
        communityCommentCount: 25,
        communityLikeReceived: 30,
        communityLikeGiven: 20,
        communityRank: 'bronze',
      ),
      
      // Premium Diamond user
      UserModel(
        id: 'user5',
        email: 'diamond@example.com',
        displayName: '다이아연애',
        isSubscribed: true,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now(),
        communityPostCount: 80,
        communityCommentCount: 200,
        communityLikeReceived: 400,
        communityLikeGiven: 150,
        communityRank: 'diamond',
      ),
      
      // Regular Newbie user
      UserModel(
        id: 'user6',
        email: 'newbie@example.com',
        displayName: '연애새싹',
        isSubscribed: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        communityPostCount: 1,
        communityCommentCount: 3,
        communityLikeReceived: 5,
        communityLikeGiven: 2,
        communityRank: 'newbie',
      ),
    ];
  }
  
  static List<CommunityPost> createDemoPosts() {
    final users = createDemoUsers();
    
    return [
      CommunityPost(
        id: 'post1',
        authorId: users[0].id,
        authorName: users[0].displayName!,
        title: '연애 고민 들어주세요 💕',
        content: '3개월째 사귀고 있는데 요즘 연락이 줄어들어서 불안해요. 이런 상황에서는 어떻게 해야 할까요? 경험담이나 조언 부탁드려요!',
        category: 'dating',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        likeCount: 24,
        commentCount: 8,
        likedBy: ['user2', 'user3', 'user4'],
        author: users[0],
      ),
      
      CommunityPost(
        id: 'post2',
        authorId: users[1].id,
        authorName: users[1].displayName!,
        title: '이별 후 극복 방법 공유해요',
        content: '2년 연애하다가 최근에 헤어졌어요. 아직 마음이 정리가 안 되는데, 어떻게 하면 빨리 일어설 수 있을까요? 같은 경험 있으신 분들 조언 부탁드려요 ㅠㅠ',
        category: 'breakup',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        likeCount: 15,
        commentCount: 12,
        likedBy: ['user1', 'user3', 'user5'],
        author: users[1],
      ),
      
      CommunityPost(
        id: 'post3',
        authorId: users[2].id,
        authorName: users[2].displayName!,
        title: '첫 데이트 팁 공유해요! ✨',
        content: '다음 주에 첫 데이트 예정인데 너무 긴장돼요. 어떤 옷을 입을지, 어디서 만날지, 대화 주제는 뭘로 할지... 첫 데이트 성공 팁 있으면 알려주세요!',
        category: 'dating',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
        likeCount: 31,
        commentCount: 6,
        likedBy: ['user1', 'user4', 'user5', 'user6'],
        author: users[2],
      ),
      
      CommunityPost(
        id: 'post4',
        authorId: users[3].id,
        authorName: users[3].displayName!,
        title: '소개팅에서 이런 사람 어떻게 생각하세요?',
        content: '어제 소개팅을 했는데, 상대방이 계속 전 연인 얘기만 하더라고요. 이런 경우에는 어떻게 생각하시나요? 다시 만날 가치가 있을까요?',
        category: 'advice',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        likeCount: 18,
        commentCount: 9,
        likedBy: ['user2', 'user5'],
        author: users[3],
      ),
      
      CommunityPost(
        id: 'post5',
        authorId: users[4].id,
        authorName: users[4].displayName!,
        title: '장거리 연애하시는 분들 계신가요? 💙',
        content: '서울-부산 장거리 연애 중인데 정말 힘들어요. 만나는 것도 쉽지 않고, 연락만으로는 아쉬움이 많아요. 장거리 연애 꿀팁이나 경험담 공유해주세요!',
        category: 'relationship',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        likeCount: 42,
        commentCount: 15,
        likedBy: ['user1', 'user2', 'user3', 'user6'],
        author: users[4],
      ),
      
      CommunityPost(
        id: 'post6',
        authorId: users[5].id,
        authorName: users[5].displayName!,
        title: '연애 초보 질문 있어요! 🌱',
        content: '처음으로 누군가에게 관심이 생겼는데 어떻게 어필해야 할지 모르겠어요. 너무 적극적이면 부담스러워할까봐 걱정되고... 조심스럽게 다가가는 방법 알려주세요!',
        category: 'dating',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        likeCount: 8,
        commentCount: 4,
        likedBy: ['user1', 'user2'],
        author: users[5],
      ),
    ];
  }
  
  static List<Comment> createDemoComments() {
    final users = createDemoUsers();
    
    return [
      Comment(
        id: 'comment1',
        postId: 'post1',
        authorId: users[1].id,
        authorName: users[1].displayName!,
        content: '저도 비슷한 경험이 있어요. 직접 물어보는 게 제일 좋을 것 같아요. 서로 솔직하게 얘기하면 해결될 거예요!',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likeCount: 5,
        likedBy: ['user2', 'user4'],
        author: users[1],
      ),
      
      Comment(
        id: 'comment2',
        postId: 'post1',
        authorId: users[4].id,
        authorName: users[4].displayName!,
        content: '연락이 줄어드는 건 자연스러운 일이에요. 너무 걱정하지 마세요. 가끔 먼저 연락해보시는 것도 좋을 것 같아요 😊',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        likeCount: 8,
        likedBy: ['user1', 'user3', 'user5'],
        author: users[4],
      ),
      
      Comment(
        id: 'comment3',
        postId: 'post2',
        authorId: users[0].id,
        authorName: users[0].displayName!,
        content: '시간이 약이라는 말이 정말 맞아요. 저도 예전에 비슷한 경험이 있었는데, 새로운 취미나 활동을 시작하면서 조금씩 나아졌어요. 힘내세요!',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likeCount: 12,
        likedBy: ['user2', 'user3', 'user4', 'user5'],
        author: users[0],
      ),
      
      Comment(
        id: 'comment4',
        postId: 'post3',
        authorId: users[2].id,
        authorName: users[2].displayName!,
        content: '첫 데이트는 너무 부담스럽지 않게 카페에서 만나는 게 어떨까요? 대화하기도 편하고 분위기도 좋을 것 같아요!',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        likeCount: 7,
        likedBy: ['user3', 'user6'],
        author: users[2],
      ),
    ];
  }
  
  // Get user by ID from demo data
  static UserModel? getDemoUserById(String userId) {
    final users = createDemoUsers();
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }
}
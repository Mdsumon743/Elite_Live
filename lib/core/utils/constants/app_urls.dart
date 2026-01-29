class AppUrls {

  /// vps
  ////static const String _baseUrl = 'http://206.162.244.144:5020/api/v1';
  ///static const String _baseUrl = 'http://10.0.20.169:5020/api/v1';
  static const String _baseUrl = 'https://api.elites-livestream.com/api/v1';
  //  ';


  //create

  //create
  static const String registerUrl = '$_baseUrl/users/create';
  static const String loginUrl = '$_baseUrl/auth/login';

  /// profile set up
  static const String setUpProfile = "$_baseUrl/auth/profile";
  static const String user = '$_baseUrl/auth/profile';

  /// others user flow
   static String getOtherUserInfo(String userId) => "$_baseUrl/users/$userId";
   static String getOthersUserScheduleEvent(String userId) => "$_baseUrl/event/user/event/$userId";
   static String getOthersUserRecording(String userId) => "$_baseUrl/event/user/recording/$userId";
   static String getOthersUserFundingEvent(String userId) => "$_baseUrl/event/user-funding/event/$userId";
  /// setting flow
  static const String getMyRecording = "$_baseUrl/event/my/recording";
  static  String myEvent(int page, int limit) => "$_baseUrl/event/my/event";
  static const String getMyCrowdFund = "$_baseUrl/event/my-funding/event";

  static const String socialLogin = '$_baseUrl/auth/auth-login';
  static const String verifyOtp = '$_baseUrl/users/signup-verification';

  static const String sendOtp = '$_baseUrl/auth/send-otp';
  static const String verifyForgotOtp = '$_baseUrl/auth/verify-otp';
  static const String resetPass = '$_baseUrl/auth/reset-password';
  static const String changePassword = "$_baseUrl/auth/change-password";
  static const String deleteAccount = "$_baseUrl/auth/delete-account";

  static const String setProfile = '$_baseUrl/auth/set-profile';
  static const String setProfilePic = '$_baseUrl/auth/update-profile-image';

  static const String notifications =
      '$_baseUrl/notifications/my-notifications';

  /// event section
  static const String createEvent = "$_baseUrl/event";
  static String getAllEvent(int page, int limit) =>
      "$_baseUrl/event/schedule/event?page=$page&limit=$limit";
  static String getAllCrowdFunding(int page, int limit) =>
      "$_baseUrl/event/funding/event?page=$page&limit=$limit";
  /// like unlike
  static String createLike(String eventId) => "$_baseUrl/event/like-unlike/$eventId";
  static String createComment(String eventId) => "$_baseUrl/event/comment/$eventId";
  static String getComment(String eventId) => "$_baseUrl/event/comment/$eventId";
  static String createReply (String commentId) => "$_baseUrl/event/reply-comment/$commentId";

  /// Group flow
  static const String createGroup = "$_baseUrl/group/create";
  static const String discoverGroup = "$_baseUrl/group/discover-groups";
  static String searchGroup(String search) => "$_baseUrl/group/discover-groups?search=$search";
  static String joinGroup(String groupId) => "$_baseUrl/group/join-group/$groupId";
  static const String joinedGroup = "$_baseUrl/group/joined-groups";
  static String groupInfo(String groupId) => "$_baseUrl/group/$groupId";
  static String groupUser(String groupId) => "$_baseUrl/group/all-users/invite/$groupId";

  static String searchUser(String groupId, String search) => "$_baseUrl/group/all-users/invite/$groupId?search=$search";
  static String leaveGroup(String groupId) => "$_baseUrl/group/leave-group/$groupId";
  static String inviteGroup(String groupId, String userId) => "$_baseUrl/group/invite-group/$groupId/$userId";
  static String updateGroup(String groupId) => "$_baseUrl/group/$groupId";
  static String deleteGroup(String groupId) => "$_baseUrl/group/$groupId";
  static String createGroupPost(String groupId) => "$_baseUrl/group/create/post/$groupId";
  static String deleteGroupPost(String postId) => "$_baseUrl/group/post/$postId";
  static String getPostInfo(String postId) => "$_baseUrl/group/postinfo/$postId";
  static String createPostComment(String postId) => "$_baseUrl/group/comment/post/$postId";
  static String likePost (String postId) => "$_baseUrl/group/like/post/$postId";
  static String replyComment(String commentId) => "$_baseUrl/group/reply-comment/post/$commentId";

  /// follow unfollow section
  static String followUser(String userId) => "$_baseUrl/group/follow-unfollow/$userId";
  static const String myFollowing = "$_baseUrl/group/my/following";
  static const String myFollower = "$_baseUrl/group/my/followers";
  static String searchFollowing(String search) => "$_baseUrl/group/my/following?search=$search";

/// payment gateway integration
  static const String createPayment = "$_baseUrl/";
  static const String createPayoutAccount = "$_baseUrl/donation/connected/account";
  static String giveDonation(String eventId)=> "$_baseUrl/donation/$eventId";
  static String getConnectedAccountBalance = "$_baseUrl/donation/stripe/balance";
  static const String instantPayout = "$_baseUrl/donation/instant/payout";



  static const String googleAuth = '$_baseUrl/auth/google-login';

  /// live flow
  static const String  createLive = "$_baseUrl/live/create/streaming";
  static  String endLive(String streamId) => "$_baseUrl//live/close/streaming/$streamId";
  static String createPool(String streamId) => "$_baseUrl/polls/$streamId";
  static String getSinglePool(String streamId) => "$_baseUrl/polls/$streamId";
  static String updatePool(String poolId) => "$_baseUrl/polls/$poolId";
  static String deletePool(String poolId) => "$_baseUrl/polls/$poolId";
  static String votePool(String poolId) => "$_baseUrl/polls/submit/vote/$poolId";
  static  String poolResult(String streamId) => "$_baseUrl/polls/result/$streamId";
  static String startRecording(String streamId) => "$_baseUrl/live/start/recording/$streamId";
  static String stopRecording(String streamId) => "$_baseUrl/live/stop/recording/$streamId";
  static String startLive(String streamId) => "$_baseUrl/live/start/streaming/$streamId";
  static String banUser(String streamId) => "$_baseUrl/live/ban/user/live/$streamId";
  static String updateWatchCount(String streamId) => "$_baseUrl/live/watch-count/$streamId";

  /// Home Flow
  static String getAllRecordedLive(int page, int limit) => "$_baseUrl/event/all/event?page=$page&limit=$limit";
  static String getAllFollowingRecordedLive(int page, int limit) => "$_baseUrl/event/following/event?page=$page&limit=$limit";
  static const String topInfluencerLive = "$_baseUrl/live/top-influencers/live";


  /// search flow
  static const String getOtherUser = "$_baseUrl/auth/user-list";
  static String searchOtherUser(String search) => "$_baseUrl/auth/user-list?search=$search";
  static const String getAllRecordingVideo = "$_baseUrl/event/all/recording";
  /// setting flow
  static String addModerator(String userId) => "$_baseUrl/auth/add-moderator/$userId";



  /// notification flow
   static const String getAllNotification = "$_baseUrl/notification";
   static String updateNotificationStatus(String notificationId)  => "$_baseUrl/notification/$notificationId";

}

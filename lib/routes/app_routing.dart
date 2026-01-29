

import 'package:elites_live/features/event/presentation/screen/others_user_details_screen.dart';
import 'package:elites_live/features/event/presentation/screen/others_user_schedule_event_screen.dart';
import 'package:elites_live/features/home/presentation/screen/payment_web_view_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../../features/on_boarding/screen/slider_screen.dart';
import '../../features/profile/presentation/screen/edit_profile.dart';
import '../../features/splash/screen/splash_screen.dart';
import '../features/authentication/forgot_pass/presentation/screen/create_new_pass_screen.dart';
import '../features/authentication/forgot_pass/presentation/screen/forgot_otp_screen.dart';
import '../features/authentication/forgot_pass/presentation/screen/forgot_pass_screen.dart';
import '../features/authentication/forgot_pass/presentation/screen/pass_changed_screen.dart';
import '../features/authentication/set_up_profile/screen/set_up_profile_screen.dart';
import '../features/authentication/sign_in/screen/sign_in_screen.dart';
import '../features/authentication/sign_up/screen/sign_up_otp_screen.dart';
import '../features/authentication/sign_up/screen/sign_up_screen.dart';
import '../features/event/presentation/screen/create_funding_screen.dart';
import '../features/event/presentation/screen/create_schedule_screen.dart';
import '../features/group/presentation/screen/create_group.dart';
import '../features/group/presentation/screen/create_post_screen.dart';
import '../features/group/presentation/screen/discover_group.dart';
import '../features/group/presentation/screen/group_post_screen.dart';
import '../features/group/presentation/screen/group_screen.dart';
import '../features/group/presentation/screen/invite_people_screen.dart';
import '../features/live/presentation/screen/live_screen.dart';
import '../features/live/presentation/screen/subscription_screen.dart';
import '../features/live/presentation/screen/upgrade_premimu_screen.dart';
import '../features/live/presentation/screen/my_live_screen.dart';
import '../features/main_view/presentation/screen/main_view_screen.dart';
import '../features/notification/presentation/screen/notification.dart';
import '../features/profile/presentation/screen/billing_details.dart';
import '../features/profile/presentation/screen/billing_payment.dart';
import '../features/profile/presentation/screen/card_details.dart';
import '../features/profile/presentation/screen/change_password.dart';
import '../features/profile/presentation/screen/earning_overview.dart';
import '../features/profile/presentation/screen/moderator.dart';
import '../features/profile/presentation/screen/payment_info.dart';
import '../features/profile/presentation/screen/settings.dart';
import '../features/profile/presentation/screen/upgrade_premium.dart';
import '../features/profile/presentation/screen/wallet.dart';


class AppRoute {
  static const String splash = '/SplashScreen';
  static const String slider = '/SliderScreen';
  static const String signIn = '/SignInScreen';
  static const String signUp = '/SignUpScreen';
  static const String signOtp = '/SignOtpScreen';
  static const String forgotPassword = '/ForgotPasswordScreen';
  static const String forgotPasswordOtp = '/ForgotPasswordOtpScreen';
  static const String resetPassword = '/ResetPasswordScreen';
  static const String passwordChanged = '/PasswordChangedScreen';
  static const String setupProfile = '/SetupProfileScreen';
  static const String mainView = '/MainViewScreen';
  static const String settings = '/settings';
  static const String editProfile = '/edit_profile';
  static const String premium = '/premium';
  static const String changePass = '/changePass';
  static const String carddetails = '/carddetails';
  static const String moderator = '/moderator';
  static const String earnings = '/earnings';
  static const String wallet = '/wallet';
  static const String bank = '/bank';
  static const String bankDetails = '/bankDetails';
  static const String paymentInfo = '/payment_info';

  /// added by sharif 
  static const String group = "/group";
  static const String notification = "/notification";
  static const String invite = "/invite";
  static const String createGroup = "/createGroup";
  static const String discoverGroup = "/discoverGroup";
  static const String groupPost = "/groupPost";
  static const String createPost = "/createPost";
  static const String createEvent = "/createEvent";
  static const String createFunding = "/createFunding";
  static const String liveScreen = "/live";
  static const String premiumScreen = "/premium";
  static const String subscription = "/subscription";
  static const String myLive = "/myLive";
  static const paymentWebView = '/payment-webview';
  static const othersUser = '/otherUser';
  static const othersSchedule = '/otherSchedule';



  static final route = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: slider,
      page: () => SliderScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signIn,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signUp,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signOtp,
      page: () => SignUpOtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPassScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: forgotPasswordOtp,
      page: () => ForgotOtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: resetPassword,
      page: () => CreateNewPassScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: passwordChanged,
      page: () => PasswordChangedScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: setupProfile,
      page: () => SetUpProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: mainView,
      page: () => MainViewScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: settings,
      page: () => SettingsPage(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: editProfile,
      page: () => EditProfilePage(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: premium,
      page: () => PremiumPage(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: changePass,
      page: () => ChangePassword(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: carddetails,
      page: () => CardDetails(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: moderator,
      page: () => ModeratorPage(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: subscription,
      page: () => SubscriptionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: earnings,
      page: () => EarningsPage(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: wallet,
      page: () => WalletPage(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: bank,
      page: () => BillingPaymentPage(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: bankDetails,
      page: () => BillingDetailsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: paymentInfo,
      page: () => PaymentInfoPage(),
      transition: Transition.rightToLeft,
    ),
    
    /// added by sharif
    GetPage(name: group, page: ()=>GroupScreen(), transition: Transition.rightToLeft), 
    GetPage(name: notification, page: ()=>NotificationScreen(), transition: Transition.rightToLeft),
    GetPage(name: invite, page: ()=>InvitePeopleScreen(), transition: Transition.rightToLeft),
    GetPage(name: createGroup, page: ()=>CreateGroupScreen(), transition: Transition.rightToLeft),
    GetPage(name: discoverGroup, page: ()=>DiscoverGroup(), transition: Transition.rightToLeft),
    GetPage(name: groupPost, page: ()=>GroupPostScreen(), transition: Transition.rightToLeft),
    GetPage(name: createPost, page: ()=>CreatePostScreen(), transition: Transition.rightToLeft),
    GetPage(name: createEvent, page: ()=>CreateScheduleScreen(), transition: Transition.rightToLeft),
    GetPage(name: createFunding, page: ()=>CreateFundingScreen(), transition: Transition.rightToLeft),
    GetPage(name: liveScreen, page: ()=>CreateLiveScreen(), transition: Transition.rightToLeft),
    GetPage(name: premiumScreen, page: ()=>UpgradePremiumScreen(), transition: Transition.rightToLeft),
    GetPage(name: subscription, page: ()=>SubscriptionScreen(), transition: Transition.rightToLeft),
    GetPage(name: myLive, page: ()=>MyLiveScreen(), transition: Transition.rightToLeft),
    GetPage(name: paymentWebView, page: ()=>PaymentWebViewScreen(), transition: Transition.rightToLeft),
    GetPage(name: othersUser, page: ()=>OthersUserDetailsScreen(), transition: Transition.rightToLeft),
    GetPage(name: othersSchedule, page: ()=>OthersUserScheduleEventScreen(), transition: Transition.rightToLeft),


    GetPage(
      name: premium,
      page: () => PremiumPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}

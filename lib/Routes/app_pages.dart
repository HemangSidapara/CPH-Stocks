import 'package:cph_stocks/Screens/home_screen/home_bindings.dart';
import 'package:cph_stocks/Screens/home_screen/home_view.dart';
import 'package:cph_stocks/Screens/sign_in_screen/sign_in_bindings.dart';
import 'package:cph_stocks/Screens/sign_in_screen/sign_in_view.dart';
import 'package:cph_stocks/Screens/splash_screen/splash_bindings.dart';
import 'package:cph_stocks/Screens/splash_screen/splash_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

Duration transitionDuration = const Duration(milliseconds: 400);

class AppPages {
  static final pages = [
    ///Splash Screen
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashView(),
      binding: SplashBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///SignIn Screen
    GetPage(
      name: Routes.signInScreen,
      page: () => const SignInView(),
      binding: SignInBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),

    ///Home Screen
    GetPage(
      name: Routes.homeScreen,
      page: () => const HomeView(),
      binding: HomeBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
  ];
}

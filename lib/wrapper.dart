import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/constants.dart';
import '/controllers/address_controller.dart';
import '/controllers/card_details_controller.dart';
import '/controllers/cart_controller.dart';
import '/controllers/favorites_controller.dart';
import '/controllers/home_controller.dart';
import '/controllers/user_controller.dart';
import '/screens/authentication/onboarding_welcome.dart';
import '/screens/authentication/splash_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends AuthState<Wrapper> {
  @override
  void initState() {
    recoverSupabaseSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: kOffBlack),
      ),
    );
  }
}

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Get.off(() => const OnBoardingWelcomeScreen());
    }
  }

  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      Get.put(HomeController());
      Get.put(FavoritesController());
      Get.put(CartController());
      Get.put(UserController());
      Get.put(AddressController());
      Get.put(CardDetailsController());
      Get.to(() => SplashScreen(), transition: Transition.fadeIn);
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    kDefaultDialog("Error", message);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '/constants.dart';
import '/controllers/cart_controller.dart';
import '/controllers/user_controller.dart';
import '/screens/cart/order_success_screen.dart';

class CODController extends GetxController {
  final CartController _cartController = Get.find();
  final UserController _userController = Get.find();

  void handlePaymentSuccess() {
    _cartController.removeAllFromCart();
    Get.off(
      () => const OrderSuccessScreen(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }
}

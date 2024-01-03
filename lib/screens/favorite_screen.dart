// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/constants.dart';
import '/controllers/cart_controller.dart';
import '/controllers/favorites_controller.dart';
import '/screens/cart/cart_screen.dart';
import '/screens/search_delegate/favorite_search_delegate.dart';
import '/widgets/tabbed/bottom_navbar.dart';
import '/widgets/tiles/favorite_list_tile.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
  final FavoritesController _favoritesController = Get.find();
  final CartController _cartController = Get.find();
  void _onCartTap() {
    Get.to(
      () => CartScreen(),
      transition: Transition.fade,
    );
  }

  void _addAllToCart() async {
    for (int i = 0; i < _favoritesController.favoritesList.length; i++) {
      await _cartController.addToCart(
          _favoritesController.favoritesList.elementAt(i),
          _favoritesController.favoritesList.elementAt(i).colorsList[0],
          showSnackbar: false);
    }
    Get.snackbar(
      "Added to Cart",
      "All the favorite items have been added to the cart",
      onTap: (_) {
        Get.closeCurrentSnackbar();
        Get.to(
          CartScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 600),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: kOnExitConfirmation,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              showSearch(context: context, delegate: FavoriteSearchDelegate());
            },
            icon: SvgPicture.asset("assets/icons/search_icon.svg"),
          ),
          title: const Text(
            "FAVORITE",
            style: kMerriweatherBold16,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _onCartTap,
              icon: SvgPicture.asset("assets/icons/cart_icon.svg"),
            )
          ],
        ),
        bottomNavigationBar: const BottomNavBar(selectedPos: 1),
        body: Obx(() {
          if (_favoritesController.favoritesList.isEmpty) {
            return const Center(
              child: Text("No Product added to favorites List"),
            );
          } else {
            return Stack(
              children: [
                ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _favoritesController.favoritesList.length,
                  itemBuilder: (context, index) {
                    return FavoriteListTile(
                      product:
                          _favoritesController.favoritesList.elementAt(index),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 12,
                      thickness: 1,
                      color: kSnowFlakeWhite,
                      indent: 20,
                      endIndent: 20,
                    );
                  },
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 10,
                  child: ElevatedButton(
                    onPressed: _addAllToCart,
                    style: ElevatedButton.styleFrom(
                      elevation: 8, backgroundColor: kOffBlack,
                      minimumSize: const Size(50, 50),
                      shadowColor: kOffBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Add all to my cart",
                      style:
                          kNunitoSansSemiBold18.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '/constants.dart';
import '/widgets/tabbed/bottom_navbar.dart';
import '/widgets/tiles/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: kOnExitConfirmation,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "NOTIFICATION",
            style: kMerriweatherBold16,
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: const BottomNavBar(selectedPos: 2),
        body: ListView.separated(
          itemCount: 10,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return NotificationTile(
              name: "Your order #${(index + 1) * 103} has been confirmed",
              description:
                  "Lorem ipsum dolor amet, consectetur adipiscing elit. Turpis pretium et in arcu adipiscing nec. Turpis pretium et in arcu adipiscing nec. ",
              isNew: (index == 1 || index == 8) ? true : false,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 0,
              thickness: 1,
              color: kSnowFlakeWhite,
              indent: 20,
              endIndent: 20,
            );
          },
        ),
      ),
    );
  }
}

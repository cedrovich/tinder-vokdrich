import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:tinder_yt/blocs/setup_data_bloc/setup_data_bloc.dart';
import '../blocs/authentication_bloc/authentication_bloc.dart';
import '../screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../screens/home/views/home_screen.dart';
import '../screens/profile/views/profile_screen.dart';

class CustomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  const CustomNavBar({
    super.key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  });

  Widget _buildItem(ItemConfig item, bool isSelected) {
    final title = item.title;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: IconTheme(
            data: IconThemeData(
              size: item.iconSize,
              color: isSelected
                  ? item.activeForegroundColor
                  : item.inactiveForegroundColor,
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
        ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                child: Text(
                  title,
                  style: item.textStyle.apply(
                    color: isSelected
                        ? item.activeForegroundColor
                        : item.inactiveForegroundColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      decoration: navBarDecoration,
      height: navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final (index, item) in navBarConfig.items.indexed)
            Expanded(
              child: InkWell(
                onTap: () => navBarConfig.onItemSelected(index),
                child: _buildItem(item, navBarConfig.selectedIndex == index),
              ),
            ),
        ],
      ),
    );
  }
}

class PersistentTabScreen extends StatelessWidget {
  const PersistentTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Persistent Tab Screen')),
      bottomNavigationBar: CustomNavBar(
        navBarConfig: NavBarConfig(
          items: [
            ItemConfig(
              icon: const Icon(CupertinoIcons.home),
              title: "Home",
              activeForegroundColor: Colors.pink,
              inactiveForegroundColor: Colors.grey,
            ),
            ItemConfig(
              icon: const Icon(CupertinoIcons.person),
              title: "Profile",
              activeForegroundColor: Colors.pink,
              inactiveForegroundColor: Colors.grey,
            ),
          ],
          selectedIndex: 0,
          onItemSelected: (index) {
            // Manejo de selección de índice
          },
        ),
      ),
    );
  }
}

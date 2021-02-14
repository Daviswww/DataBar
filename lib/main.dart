import 'package:drink_bot/views/screens/order/order_screens.dart';
import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:drink_bot/models/v2_menus.dart';
import 'package:drink_bot/services/api_manager.dart';
import 'package:drink_bot/views/screens/menu/menu_screen.dart';
import 'package:drink_bot/views/list/list_view.dart';

void main() => runApp(DrinkBot());

class DrinkBot extends StatefulWidget {
  @override
  State createState() {
    return _DrinkBot();
  }
}

class _DrinkBot extends State {
  Widget _child;
  Future<Menus> _menus;

  @override
  void initState() {
    _menus = API_Manager().getMenus();
    _child = OrderScreen();
    super.initState();
  }

  @override
  Widget build(context) {
    // Build a simple container that switches content based of off the selected navigation item
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.cyan[900],
        extendBody: true,
        body: _child,
        // endDrawer: DrawerScreens(),
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(
                svgPath: "assets/icons/coffee.svg",
                backgroundColor: Color(0xFF2B2129),
                extras: {"label": "coffee"}),
            FluidNavBarIcon(
                svgPath: "assets/icons/shopping-cart.svg",
                backgroundColor: Color(0xFF586C50),
                extras: {"label": "tea"}),
            FluidNavBarIcon(
                svgPath: "assets/icons/clipboard.svg",
                backgroundColor: Color(0xFF865B2E),
                extras: {"label": "list"}),
          ],
          onChange: _handleNavigationChange,
          style: FluidNavBarStyle(
            barBackgroundColor: Colors.blueGrey[50],
            iconUnselectedForegroundColor: Colors.white,
            iconSelectedForegroundColor: Colors.white,
          ),
          scaleFactor: 1.5,
          defaultIndex: 1,
          itemBuilder: (icon, item) => Semantics(
            label: icon.extras["label"],
            child: item,
          ),
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = MenuScreen(
            menu: _menus,
            menuIndex: 0,
          );
          break;
        case 1:
          _child = OrderScreen();
          break;
        case 2:
          _child = ListScreen();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}

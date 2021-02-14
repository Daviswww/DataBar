import 'package:flutter/material.dart';
import 'package:drink_bot/models/v2_menus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drink_bot/views/screens/form/form_screen.dart';
import 'package:drink_bot/widget/transitions/transitions.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({
    Key key,
    @required this.menu,
    @required this.menuIndex,
  }) : super(key: key);
  final Future<Menus> menu;
  final int menuIndex;
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static Color backgroundColor = Color(0xFFDD8E58);
  static Color cardColor = Color(0xFFE5D1B8);
  static Color borderColor = Color(0xFF708A81);
  static Color iconBackgroundColor = Color(0xFFC29561);
  static List drinkImage = ['coffee', 'coca-tea', 'soda'];
  int drinkType = 0;
  @override
  void initState() {
    drinkType = widget.menuIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 120.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 4,
                blurRadius: 5,
                offset: Offset(0, -4),
              ),
            ],
          ),
        ),
        buildFutureBuilder(),
      ],
    );
  }

  FutureBuilder<Menus> buildFutureBuilder() {
    return FutureBuilder<Menus>(
      future: widget.menu,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildMainMenu(snapshot);
        } else {
          return buildProgressBar();
        }
      },
    );
  }

  SafeArea buildMainMenu(AsyncSnapshot<Menus> snapshot) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  snapshot.data.payload.menu[drinkType].series,
                  style: buildTitleTextStyle(),
                ),
                Spacer(),
                buildDrinkTypeContainer(Icons.local_cafe, 0),
                buildDrinkTypeContainer(Icons.emoji_food_beverage, 1),
                buildDrinkTypeContainer(Icons.local_bar, 2),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.payload.menu[drinkType].items.length,
                  itemBuilder: (context, index) {
                    var drink =
                        snapshot.data.payload.menu[drinkType].items[index];
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      height: 130,
                      width: 200,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(2, 8),
                          ),
                        ],
                      ),
                      child: DrinkCard(
                        borderColor: borderColor,
                        drink: drink,
                        iconBackgroundColor: iconBackgroundColor,
                        iconImage: drinkImage[drinkType],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDrinkTypeContainer(IconData icon, int type) {
    return Container(
      padding: EdgeInsets.all(8),
      child: InkWell(
        customBorder: new CircleBorder(),
        onTap: () {
          setState(() {
            drinkType = type;
          });
        },
        splashColor: Colors.red,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: drinkType == type ? Colors.orange : Colors.transparent,
              shape: BoxShape.circle),
          child: new Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  TextStyle buildTitleTextStyle() => TextStyle(
        fontFamily: 'Bebas Neue',
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  Center buildProgressBar() {
    return Center(
      child: Stack(
        children: <Widget>[
          // Image.asset("assets/images/giphy.gif"),
          CircularProgressIndicator(
            strokeWidth: 10,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class DrinkCard extends StatelessWidget {
  const DrinkCard({
    Key key,
    @required this.borderColor,
    @required this.drink,
    @required this.iconBackgroundColor,
    @required this.iconImage,
  }) : super(key: key);

  final Color borderColor;
  final Item drink;
  final Color iconBackgroundColor;
  final String iconImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 10,
              color: borderColor,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        drink.item,
                        style: TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 30,
                        child: FloatingActionButton(
                          heroTag: drink.itemId,
                          backgroundColor: Colors.black,
                          child: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              SlideRightRoute(
                                page: FormRoute(drink: drink),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        height: 30,
                        width: 1,
                        color: Colors.black54,
                      ),
                      CardInfo(
                        isDisplay: drink.mediumPrice != 0,
                        text: "M: ${drink.mediumPrice}",
                        blockColor: Colors.white,
                      ),
                      CardInfo(
                        isDisplay: drink.largePrice != 0,
                        text: "L: ${drink.largePrice}",
                        blockColor: Colors.white,
                      ),
                      CardInfo(
                        isDisplay: drink.cold,
                        text: "cold",
                        blockColor: Colors.blue[200],
                      ),
                      CardInfo(
                        isDisplay: drink.hot,
                        text: "hot",
                        blockColor: Colors.red[200],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              child: Container(
                height: 10,
                color: borderColor,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                height: 80,
                width: 80,
                child: SvgPicture.asset(
                  'assets/icons/$iconImage.svg',
                ),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CardInfo extends StatelessWidget {
  const CardInfo({
    Key key,
    @required this.isDisplay,
    @required this.text,
    @required this.blockColor,
  }) : super(key: key);

  final bool isDisplay;
  final String text;
  final Color blockColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(isDisplay ? 4.0 : 0.0),
      padding: EdgeInsets.all(isDisplay ? 4.0 : 0.0),
      child: Text(
        isDisplay ? text : "",
        style: TextStyle(
          fontFamily: 'Bebas Neue',
          fontSize: 14,
        ),
      ),
      decoration: BoxDecoration(
        color: blockColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDisplay ? 0.4 : 0.0),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
    );
  }
}

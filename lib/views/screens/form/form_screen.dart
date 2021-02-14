import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drink_bot/models/v2_menus.dart';
import 'package:drink_bot/services/api_manager.dart';
import 'package:flutter/cupertino.dart';

class FormRoute extends StatefulWidget {
  const FormRoute({
    Key key,
    @required this.drink,
  }) : super(key: key);
  final Item drink;

  @override
  _FormRouteState createState() => _FormRouteState();
}

class _FormRouteState extends State<FormRoute> {
  static Color backgroundColor = Colors.teal;
  bool isLike = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 16.0),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(3, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: isLike ? Colors.red[400] : Colors.grey,
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  isLike = !isLike;
                });
              },
            ),
          ),
        ],
      ),
      body: SelectForm(
        drink: widget.drink,
      ),
    );
  }
}

class SelectForm extends StatefulWidget {
  const SelectForm({
    Key key,
    @required this.drink,
  }) : super(key: key);
  final Item drink;

  @override
  _SelectFormState createState() => _SelectFormState();
}

class _SelectFormState extends State<SelectForm> {
  final myController = TextEditingController();

  String orderBy = "Alice";
  String cupSize = "medium";
  int cupIce = 1;
  int cupSugar = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: <Widget>[
                      buildDrinkBlock(widget.drink),
                      buildSugarBlock(),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.0),
                    child: buildCupSizeButton(),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        Icons.check,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              SingleChildScrollView(
                            child: alertDialog(),
                          ),
                        );
                      },
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal[900],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        buildIceBlock(),
      ],
    );
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      title: Text('請輸入名字'),
      content: TextFormField(
        controller: myController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () async {
            setState(() {
              orderBy = myController.text;
              final response = API_Manager().postOrder(
                  orderBy, cupSize, widget.drink.itemId, cupSugar, cupIce);
              response.then((value) {
                if (value.statusCode == 200) {
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('$orderBy的訂單送出'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('訂單飛到外太空了啦～'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
            });
            Navigator.pop(context);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // 甜度區塊
  Stack buildSugarBlock() {
    return Stack(
      children: <Widget>[
        Container(
          width: 270,
          height: 40,
          color: Colors.white,
        ),
        Container(
          width: 270,
          height: 320,
          decoration: BoxDecoration(
            color: Colors.teal[600],
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(48),
              topLeft: Radius.circular(48),
            ),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0, left: 10.0),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0, left: 10.0),
                        child: SvgPicture.asset(
                          "assets/icons/sugar-cubes.svg",
                          width: 40,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0, left: 16.0),
                    child: Text(
                      "Sugar",
                      style: GoogleFonts.philosopher(
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    // 甜度文字
                    buildSelectSugarButton("無糖", 1),
                    buildSelectSugarButton("微糖", 2),
                    buildSelectSugarButton("半糖", 3),
                    buildSelectSugarButton("正常糖", 4),
                  ],
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container buildSelectSugarButton(String text, int id) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: 10.0),
            width: cupSugar == id ? 5 : 0,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Container(
            width: 100,
            child: TextButton(
              style: buildTextButtonStyle(),
              child: Text(
                text,
                style: GoogleFonts.cinzel(
                  textStyle: buildSelectButtonStyle(),
                ),
              ),
              onPressed: () {
                setState(() {
                  cupSugar = id;
                });
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                topLeft: Radius.circular(48),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: 10.0),
            width: cupSugar == id ? 5 : 0,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 商品價錢名稱區塊
  Container buildDrinkBlock(Item drink) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 270,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(48),
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Text(
              drink.item,
              style: buildTextStyle(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/images/coffee-cup.svg",
                  width: 150,
                ),
                Text(
                  cupSize == "medium"
                      ? "\$${drink.mediumPrice}"
                      : "\$${drink.largePrice}",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 冰塊區塊
  Container buildIceBlock() {
    return Container(
      margin: EdgeInsets.only(
        top: 260,
        left: 180,
      ),
      height: 340,
      decoration: BoxDecoration(
        color: Color(0xFFFFF3D1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          bottomLeft: Radius.circular(48),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(5, 8),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0, left: 30.0),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0, left: 30.0),
                        child: SvgPicture.asset(
                          "assets/icons/ice-cube.svg",
                          width: 40,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0, left: 16.0),
                    child: Text(
                      "Ice",
                      style: GoogleFonts.philosopher(
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 冰塊文字
              buildSelectIceButton("熱熱", 1),
              buildSelectIceButton("正常冰", 2),
              buildSelectIceButton("少冰", 3),
              buildSelectIceButton("去冰", 4),
            ],
          ),
        ],
      ),
    );
  }

  Container buildSelectIceButton(String text, int id) {
    return Container(
      margin: EdgeInsets.only(left: 50, top: 10),
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: 10.0),
            width: cupIce == id ? 5 : 0,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Container(
            width: 100,
            child: TextButton(
              style: buildTextButtonStyle(),
              child: Text(
                text,
                style: GoogleFonts.cinzel(
                  textStyle: buildSelectButtonStyle(),
                ),
              ),
              onPressed: () {
                setState(() {
                  cupIce = id;
                });
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                topLeft: Radius.circular(48),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: 10.0),
            width: cupIce == id ? 5 : 0,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle buildTextButtonStyle() {
    return ButtonStyle(
      overlayColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
    );
  }

  Column buildCupSizeButton() {
    return Column(
      children: [
        buildSelectSizeButton("M", "medium"),
        buildSelectSizeButton("L", "large"),
      ],
    );
  }

  Container buildSelectSizeButton(String text, String id) {
    return Container(
      margin: EdgeInsets.all(20),
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: cupSize == id ? Color(0xFFFFF3D1) : Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: TextButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          setState(() {
            cupSize = id;
          });
        },
      ),
    );
  }

  TextStyle buildTextStyle() {
    return TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle buildSelectButtonStyle() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }
}

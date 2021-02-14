import 'package:drink_bot/views/list/page_view_holder.dart';

import 'package:flutter/material.dart';
import 'package:drink_bot/models/v2_orders.dart';
import 'package:drink_bot/services/api_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Future<Orders> _orders;
  PageController _controller;
  PageViewHolder holder;

  static List<Color> cardColor = [
    Color(0xFFEFEDEE),
    Color(0xFFE2D753),
    Color(0xFFCE6543),
    Color(0xFF66D2CE),
    Color(0xFF5B7FBB),
    Color(0xFFBB5B5B),
    Color(0xFF66D287),
    Color(0xFFBB9D5B),
    Color(0xFFA466D2),
  ];
  @override
  void initState() {
    _orders = API_Manager().getOrders();
    holder = PageViewHolder(value: 0.0);
    _controller = PageController(initialPage: 0, viewportFraction: 1.0);
    _controller.addListener(() {
      holder.setValue(_controller.page);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Orders>(
      future: _orders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildListOrders(snapshot);
        } else {
          return buildProgressBar();
        }
      },
    );
  }

  Container buildListOrders(AsyncSnapshot<Orders> snapshot) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 1,
              child: ChangeNotifierProvider<PageViewHolder>.value(
                value: holder,
                child: Stack(
                  children: <Widget>[
                    PageView.builder(
                      controller: _controller,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.payload.weekOrders.length,
                      itemBuilder: (context, index) {
                        var order = snapshot.data.payload.weekOrders[index];
                        return OrderBlock(
                            order: order, index: index, cardColor: cardColor);
                      },
                    ),
                    TopCircleImage(cardColor: cardColor),
                    Positioned(
                      top: 60,
                      left: 30,
                      child: Text(
                        "詳細訂單",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack buildProgressBar() {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.all(10),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/giphy.gif",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              strokeWidth: 10,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class TopCircleImage extends StatelessWidget {
  const TopCircleImage({
    Key key,
    @required this.cardColor,
  }) : super(key: key);
  final List<Color> cardColor;
  @override
  Widget build(BuildContext context) {
    double value = Provider.of<PageViewHolder>(context).value;
    // debugPrint("$value");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 100),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Stack(
            children: [
              Center(
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/beans.svg",
                    width: 50,
                    color: cardColor[value.toInt() % 9],
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: value == value.toInt() ? 1 : 0,
                child: Container(
                  margin: EdgeInsets.all(10),
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg_${value.toInt() % 16}.jpeg",
                      ),
                      fit: BoxFit.fill,
                    ),
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

class OrderBlock extends StatelessWidget {
  const OrderBlock({
    Key key,
    @required this.order,
    @required this.index,
    @required this.cardColor,
  }) : super(key: key);

  final WeekOrder order;
  final int index;
  final List<Color> cardColor;
  @override
  Widget build(BuildContext context) {
    double value = Provider.of<PageViewHolder>(context).value;

    return Container(
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            height: 400,
            color: Colors.black,
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: value == value.toInt() ? 195 : 0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor[index % 9],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                Spacer(),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: value == value.toInt() ? 195 : 0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF313131),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Color(0xFF313131),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  buildOrderInfoCard(),
                ],
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  Center buildOrderInfoCard() {
    return Center(
      child: Container(
        height: 350,
        width: 300,
        margin: EdgeInsets.only(top: 50),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              margin: EdgeInsets.only(right: 70, bottom: 60),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: cardColor[index % 9].withOpacity(0.9),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
            Column(
              children: <Widget>[
                Spacer(),
                buildBar(),
                buildBar(),
                buildBar(),
                buildBar(),
                Spacer(),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        width: 200,
                        child: Text(
                          "${order.orderBy}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rockSalt(
                            textStyle: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          "assets/icons/dots-menu.svg",
                          width: 20.0,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  buildOrderInfoText("Price", order.price.toString()),
                  buildOrderInfoText("Item", order.item),
                  buildOrderInfoText(
                      "Size", order.size == "medium" ? "中杯" : "大杯"),
                  buildOrderInfoText("Ice", order.iceTag),
                  buildOrderInfoText("Sugar", order.sugarTag),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "${order.orderTime}",
                        style: GoogleFonts.rockSalt(
                          textStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: cardColor[index % 9],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Text buildOrderInfoText(String tag, String text) {
    return Text(
      "$tag : $text",
      style: GoogleFonts.rockSalt(
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Row buildBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          width: 20,
          height: 5,
          color: Colors.black,
        ),
      ],
    );
  }
}

class LinePath extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(20, size.height);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

import 'package:drink_bot/models/v2_orders.dart';
import 'package:drink_bot/services/api_manager.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return OrderView();
  }
}

class OrderView extends StatefulWidget {
  const OrderView({
    Key key,
  }) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  Future<Orders> _orders;

  @override
  void initState() {
    _orders = API_Manager().getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("點餐資訊"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cached_rounded),
            onPressed: () {
              setState(() {
                _orders = API_Manager().getOrders();
                Scaffold.of(context).showSnackBar(
                  new SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('訂單已更新！'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: OrdersDelivery(orders: _orders),
    );
  }
}

class OrdersDelivery extends StatefulWidget {
  OrdersDelivery({
    Key key,
    @required this.orders,
  }) : super(key: key);
  final Future<Orders> orders;
  @override
  _OrdersDeliveryState createState() => _OrdersDeliveryState();
}

class _OrdersDeliveryState extends State<OrdersDelivery> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Orders>(
      future: widget.orders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildListContainer(snapshot);
        } else {
          return buildProgressBar();
        }
      },
    );
  }

  Container buildListContainer(AsyncSnapshot<Orders> snapshot) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            height: 100,
            child: Row(
              children: <Widget>[
                Text(
                  "總杯數：${snapshot.data.payload.weekOrders.length} 杯",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Text(
                  "總金額：\$${snapshot.data.payload.totalPrice}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.payload.aggregateOrders.length,
              itemBuilder: (context, index) {
                var order = snapshot.data.payload.aggregateOrders[index];
                return Container(
                  height: 300,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 32.0),
                        height: double.maxFinite,
                        width: 5,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 32.0),
                        height: 5,
                        width: double.maxFinite,
                        color: Colors.white,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "#${index + 1}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          width: 280,
                          height: 200,
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 16.0, left: 16.0, bottom: 8),
                                    child: Text(
                                      order.item,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    height: 5,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        buildTagTextContainer(
                                            "大小",
                                            order.size == "large"
                                                ? "大杯"
                                                : "中杯"),
                                        buildTagTextContainer(
                                            "甜度", order.sugarTag),
                                        buildTagTextContainer(
                                            "冰塊", order.iceTag),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_drop_up,
                                        size: 40,
                                      ),
                                      onPressed: () {},
                                    ),
                                    Text(
                                      "x${order.number}",
                                      style: GoogleFonts.fredokaOne(
                                        textStyle: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        size: 40,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 10,
                                height: double.infinity,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildTagTextContainer(String text, String tag) {
    return Container(
      child: Center(
        child: Text(
          "$text : $tag",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Center buildProgressBar() {
    return Center(
      child: Stack(
        children: <Widget>[
          // Image.asset("assets/images/giphy.gif"),
          CircularProgressIndicator(
            strokeWidth: 10,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'user.dart'; 
import 'package:sport_facility/mainscreen.dart';


class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid,val;
  PaymentScreen({this.user,this.orderid,this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String titlecenter = "Loading your payment";
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFFD50000),
        title: Text('Payment'),
      ),
      body: WillPopScope(
        onWillPop: _onbackPressed,
        child: Column(
        children: <Widget>[
          Expanded(child: WebView(
            initialUrl: 'https://lilbearandlilpanda.com/uumsportfacilities/php/payment.php?email='+
            widget.user.email +
            '&mobile=' +
            widget.user.phone +
            '&name=' +
            widget.user.name +
            '&amount=' +
            widget.val +
            '&orderid=' +
            widget.orderid,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            
            ),)
        ],),
      )
    );
  }
  Future<bool> _onbackPressed () {
    setState(() {
      widget.user.hours = "0";
    });
    
    return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user
      )));
  }


}
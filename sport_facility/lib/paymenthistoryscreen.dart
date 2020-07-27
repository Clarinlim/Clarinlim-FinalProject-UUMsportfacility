import 'package:flutter/material.dart';
import 'package:sport_facility/user.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booking.dart';
import 'package:sport_facility/BookingDetailScreen.dart';


class PaymentHistoryScreen extends StatefulWidget {
  final User user;

 const PaymentHistoryScreen({Key key, this.user}) : super(key: key);
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;

  String titlecenter = "Loading Payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm:a');
  var parseDate;
  double screenHeight, screenWidth;

  @override
  void initState(){
    super.initState();
    _loadPaymentHistory();
    
  }
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:AppBar(
        backgroundColor:Color(0xFFD50000),
        title: Text('Payment History List'),
      ),
      body: Center(
        child:Column(children: <Widget>[
          Text("Payment History",
          style:TextStyle
          (color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
          ),
          _paymentdata == null
          ? Flexible(
            child: Container(
              child:Center(
                child: Text(
                  titlecenter,
                  style:TextStyle(
                    color: Color.fromRGBO(242,35,24,1),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
              )
            )
            )
            :Expanded(
              child: ListView.builder(
                itemCount: _paymentdata == null ? 0:_paymentdata.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: InkWell(
                      onTap: () => loadBookingDetails(index),
                      child: Card(
                        shape: RoundedRectangleBorder(
                         borderRadius:BorderRadius.circular(10.0)),
                       color: Colors.white,
                        elevation:10,
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                (index + 1).toString(),
                                style:TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              )),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "RM" + _paymentdata[index]['total'],
                                  style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
                                ),
                                 Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _paymentdata[index]['orderid'],
                                                style: TextStyle(
                                                    color: Colors.red,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                _paymentdata[index]['billid'],
                                                style: TextStyle(
                                                    color: Colors.red,fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                          Expanded(
                                        child: Text(
                                          f.format(DateTime.parse(
                                              _paymentdata[index]['date'])),
                                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                                        ),
                                        flex: 2,
                                      ),
                          ],)
                      ),

                    ));
                },
              ))

        ],)
      ),
    );
  }

 Future<void> _loadPaymentHistory() async{
 
   String urlLoadJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/load_paymenthistory.php";
   await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
 }


loadBookingDetails(int index) {
  Booking booking = new Booking(
    orderid: _paymentdata[index]['orderid'],
        billid: _paymentdata[index]['billid'],
        //prodid:_paymentdata[index]['prodid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
          context, 
        MaterialPageRoute(
          builder:(BuildContext context) => BookingDetailScreen(
            booking: booking,
          ) ));
}
}
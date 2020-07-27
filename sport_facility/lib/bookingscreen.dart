import 'package:flutter/material.dart';
import 'package:sport_facility/payment.dart';
import 'package:sport_facility/user.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sport_facility/mainscreen.dart';
import 'payment.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:async';
class BookingScreen extends StatefulWidget {
  final User user;

  const BookingScreen({Key key, this.user}) :super(key:key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
List bookdata;
double screenHeight, screenWidth;
double _hours = 0.0, _totalprice = 0.0;
double amountpay;
bool _storeCredit = false;
String _date = "Not Set";
String _time = "Not Set";
String titlecenter = "Loading your booking";


@override 
void initState(){
  super.initState();
  _loadbook();
}

  @override
 Widget build(BuildContext context) {
   screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
   return WillPopScope(
     onWillPop: _onbackPressed,
    child: Scaffold(
     appBar: AppBar(
       backgroundColor:Color(0xFFD50000),
       title:Text ('My Booking'),
       actions: <Widget>[
         IconButton(
           icon: Icon(MdiIcons.deleteEmpty),
           onPressed: () {
             deleteAll();
           },)
       ],
     ),
     body: Container(
       child:Column(
         children: <Widget>[
           Text("Content of your Booking", style: TextStyle (color: Colors.white, fontSize:16)),
           bookdata == null
           ? Flexible(
             child: Container(
               child:Center(
                 child:Text(
                   titlecenter,
                   style: TextStyle(
                    color: Colors.white,
                    fontSize:15,
                   ),
                 )
               )))
               : Expanded(
                 child: ListView.builder(
                   itemCount: bookdata == null ? 1: bookdata.length + 2,
                   itemBuilder:(context, index){
                     if(index == bookdata.length){
                       return Container(
                         height:screenHeight / 3.0,
                         width:screenWidth /7.0,
                         child: InkWell(
                           onLongPress: () =>{print("Delete")},
                           child: Card(
                             shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20.0),
                              ),
                             elevation: 5,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children:<Widget>[
                                 Text("Choose Your Date",
                                 style:TextStyle(
                                   fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                 SizedBox(height:5),
                                 RaisedButton(
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                     elevation: 4.0,
                                     onPressed: () {
                                       DatePicker.showDatePicker(context,
                                        theme: DatePickerTheme(
                                       containerHeight: 210.0,
                                       ),
                                     showTitleActions: true,
                                             minTime: DateTime(2000, 1, 1),
                                           maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                                            print('confirm $date');
                                             _date = '${date.year} - ${date.month} - ${date.day}';
                                           setState(() {});
                                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                                          },
                                          child: Container(
                                         alignment: Alignment.center,
                                          height: 50.0,
                                         child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                                 Row(
                                                   children: <Widget>[
                                                    Container(
                                                    child: Row(
                                                     children: <Widget>[
                                                      Icon(
                                                       Icons.date_range,
                                                       size: 18.0,
                                                      color: Colors.red,
                                                     ),
                                                      Text(
                                                       " $_date",
                                                     style: TextStyle(
                                                    color: Colors.red,
                                                   fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                                 ),
                                               ],
                                            ),
                                           )
                                         ],
                                  ),
                                 Text(
                                 "Change",
                                   style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
                    RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 4.0,
                onPressed: ()  {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                    print('confirm $time');
                    _time = '${time.hour} : ${time.minute} : ${time.second}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.red,
                                ),
                                Text(
                                  " $_time",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                          ),
                          ],
                            ),
                        ),
                          color: Colors.white,
                         )   
                          ]
                        ),
                      )
                     ));
                    }

                       if(index == bookdata.length +1){
                         return Container(
                           child:Card(
                             shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20.0),
                             ),
                             elevation: 5,
                             child: Column(
                               children:<Widget>[
                                 SizedBox(height:10,
                                 ),
                                 Text("Payment",
                                 style: TextStyle(
                                   fontSize:20.0,fontWeight: FontWeight.bold,color: Colors.white )),
                                 SizedBox(height:25),
                                 Container(
                                   padding:EdgeInsets.fromLTRB(50, 10, 50, 10),
                                   child: Table(
                                     defaultColumnWidth: FlexColumnWidth(1.0),
                                     columnWidths: {
                                       0: FlexColumnWidth(7),
                                       1: FlexColumnWidth(3),
                                     },
                                     children: [
                                       TableRow(children: [
                                         TableCell(
                                           child: Container(
                                             alignment:Alignment.centerLeft,
                                             height:20,
                                             child:Text(
                                               "Total Item Price ",
                                               style:TextStyle(
                                                 fontWeight: FontWeight.bold, color: Colors.white))),
                                               ),
                                               TableCell(
                                                 child: Container(
                                                   alignment: Alignment.centerLeft,
                                                   height:20,
                                                   child:Text(
                                                     "RM " + _totalprice.toStringAsFixed(2) ?? "0.0",
                                                     style: TextStyle(
                                                       fontWeight: FontWeight.bold, color:Colors.white,fontSize:14)),
                                                 ))
                                       ]),
                                       TableRow(children: [
                                         TableCell(
                                           child: Container(
                                             alignment:Alignment.centerLeft,
                                             height:20,
                                             child:Text(
                                               "Store Credit RM " + widget.user.credit,
                                               style:TextStyle(
                                                 fontWeight: FontWeight.bold, color: Colors.white))),
                                               ),
                                                TableCell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Checkbox(
                                                    value: _storeCredit,
                                                    checkColor: Colors.white,
                                                    activeColor: Colors.red,
                                                    onChanged: (bool value) {
                                                      _onStoreCredit(value);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                         TableCell(
                                           child: Container(
                                             alignment:Alignment.centerLeft,
                                             height:20,
                                             child:Text(
                                               "Total Amount",
                                               style:TextStyle(
                                                 fontWeight: FontWeight.bold, color: Colors.white))),
                                               ),
                                                TableCell(
                                                child: Container(
                                                  alignment:Alignment.centerLeft,
                                                  height: 20,
                                                  child: Text(
                                                    "RM " + amountpay.toStringAsFixed(2) ?? "0.0",
                                                    style: TextStyle(
                                                       fontWeight: FontWeight.bold, color:Colors.white,fontSize:14))
                                                ),
                                              ),
                                           ]),
                                        ],
                                   ),
                                 ),
                                 SizedBox(height:10),
                                 MaterialButton(
                                   shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                            minWidth: 200,
                                            height:45,
                                            child:Text('Make Payment'), 
                                            color: Color.fromRGBO(242,35,24,1),
                                            textColor: Colors.white,
                                            elevation: 10,
                                            onPressed:(){
                                              if (_date == "Not Set" || _time == "Not Set")
                                                Toast.show("Please set your date and time.", context,
                                                  duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                              else
                                                makePaymentdialog();
                                            }
                                 )
                               ]
                             ),)
                         );
                       }
                   
                     index -=0;
                     return Card(
                       shape: RoundedRectangleBorder(
                         borderRadius:BorderRadius.circular(15.0)),
                       elevation: 10,
                       child: Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                       child: Row(
                         children:<Widget>[
                           Column(
                             children: <Widget>[
                               Container(
                                 height: screenHeight /8,
                                 width: screenWidth /5,
                                 child:ClipOval(
                                   child: CachedNetworkImage(
                                     fit:BoxFit.fill,
                                     imageUrl:
                                    "http://lilbearandlilpanda.com/uumsportfacilities/images/${bookdata[index]['id']}.png",
                                    placeholder:(context, url) =>
                                    new CircularProgressIndicator(),
                                    errorWidget:(context,url,error)=>
                                    new Icon(Icons.error),
                                   )),
                               ),
                               Text("RM " + bookdata[index]['price'],
                               style: TextStyle(
                                 color:Colors.white,
                               ),
                               ),
                             ],
                             ),
                             Padding(
                               padding: EdgeInsets.fromLTRB(5, 1, 8, 2),
                               child: SizedBox(
                                 width:2,
                                 child:Container(
                                   height: screenWidth/3.5,
                                   color: Colors.white60,
                                   ))),
                                   Container(
                                     height: screenHeight / 5.0,
                                     width: screenWidth / 1.44,
                                     child: Column( 
                                       children:<Widget>[
                                         Flexible(
                                           child:Column(
                                             children:<Widget>[
                                               new Text(
                                                 bookdata[index]['name'],
                                                 textAlign: TextAlign.left,
                                                 style: TextStyle(fontWeight:FontWeight.bold,
                                                        fontSize: 17,
                                                        color: Colors.white),
                                                        
                                               ),
                                               Text(
                                                    "Available " + bookdata[index]['hours'] + " hrs",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Your book hours " + bookdata[index]['chours'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                    height:25,
                                                    child:Row(
                                                      mainAxisAlignment:MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        FlatButton(
                                                          onPressed: () => {
                                                            _updateBook(index,"add")}, 
                                                            child: Icon(
                                                              MdiIcons.plus,
                                                               color: Color.fromRGBO(242,35,24,1),
                                                            )),
                                                            Text(
                                                              bookdata[index]['chours'],
                                                               style: TextStyle(
                                                              color: Colors.white,
                                                             ),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () => {
                                                                _updateBook(index, "remove")
                                                              }, 
                                                              child: Icon(
                                                                MdiIcons.minus,
                                                                color: Color.fromRGBO(242,35,24,1),
                                                                )),
                                                              ])
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children:<Widget>[
                                                                Text(
                                                                  "Total RM " + bookdata[index]['yourprice'],
                                                                   style: TextStyle(
                                                              fontWeight:FontWeight .bold,
                                                              color: Colors.white)),
                                                              FlatButton(
                                                                onPressed: () => {
                                                                  _deleteBook(index)
                                                                },
                                                                 child: Icon(
                                                                   MdiIcons.delete,
                                                                   color: Color.fromRGBO(242,35,24,1),
                                                                 ))
                                                              ]
                                                            )
                                             ]
                                           ) ,)
                                       ]
                                     ),
                                   )

                       ]),
                       ));
                   })
       )])
     ),
   )
   );
   
 }

  void _loadbook() {
    _totalprice = 0.0;
    _hours = 0.0;
    amountpay = 0.0;
    //ProgressDialog pr = new ProgressDialog(context,
        //type: ProgressDialogType.Normal, isDismissible: false);
   // pr.style(message: "Updating ...");
    //pr.show();
    String urlLoadJobs = "https://lilbearandlilpanda.com/uumsportfacilities/php/load_book.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
     // pr.dismiss();
      if (res.body == "Book Empty") {
        //pr.dismiss();
        //Navigator.of(context).pop(false);
        widget.user.hours = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }           
      setState(() {
        var extractdata = json.decode(res.body);
        bookdata = extractdata["book"];
        for (int i= 0; i < bookdata.length; i++) { 
          _hours = double.parse(bookdata[i]['chours']) +
                  //int.parse(bookdata[i]['hours']) +
              _hours;
          _totalprice = double.parse(bookdata[i]['yourprice']) + _totalprice;
        }
        amountpay = _totalprice;
        print(_hours);
        print(_totalprice);
        //.dismiss();
      });
    }).catchError((err) {
      print(err);
     // pr.dismiss();
    });
   // pr.dismiss();
  }

  _updateBook(int index, String op) {
    int curhours = int.parse(bookdata[index]['hours']);
    int hours = int.parse(bookdata[index]['chours']);
    if(op == "add") {
      hours++;
      if (hours > (curhours - 2)) {
        Toast.show("Hours not available", context,
        duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if(op == "remove"){
      hours--;
      if(hours == 0){
        _deleteBook(index);
        return;
      }
    }
    String urlLoadJobs = "http://lilbearandlilpanda.com/uumsportfacilities/php/update_book.php";
    http.post(urlLoadJobs, body: {
      "email":widget.user.email,
      "prodid":bookdata[index]['id'],
      "hours":hours.toString()
    }).then((res) {
      print(res.body);
      if(res.body==("success")){
        Toast.show("Book Updated", context,
        duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
        _loadbook();
        
      }else{
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err){
      print(err);
      
    });
  }

  _deleteBook(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                http.post("http://lilbearandlilpanda.com/uumsportfacilities/php/delete_book.php",
                    body: {
                      "email": widget.user.email,
                      "prodid": bookdata[index]['id'],
                    }).then((res) {
                  print(res.body);
                  if (res.body == "failed") {
                    Navigator.of(context).pop();
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.of(context).pop();
                    List respond = res.body.split(",");
                    if (res.body == "success,0"){
                      setState(() {
                        widget.user.hours = "0";
                      });
                      Toast.show("No book already.", context,
                        duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                      Navigator.push(context, 
                     MaterialPageRoute(
                       builder: (BuildContext context)=> MainScreen(
                        user: widget.user)));
                      
                    }
                    setState(() { 
                      widget.user.hours = respond[1];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM); 
                        _loadbook();
                    
                    
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(242,35,24,1),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(242,35,24,1),
                ),
              )),
        ],
      ),
    );
  }

 

  void _onStoreCredit(bool newvalue) => setState(() {
    _storeCredit = newvalue;
    if(_storeCredit){
      _updatePayment();
    }else{
      _updatePayment();
    }
  });

  void makePaymentdialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content:
              new Text("Are you sure want to make payment?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(242,35,24,1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                makePayment();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                 color: Color.fromRGBO(242,35,24,1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
  });

  }

 Future <void> makePayment() async{
    if (amountpay < 0) {
      double newamount = amountpay * -1;
      await _payusingstorecredit(newamount);
      //print(amountpay);
      Toast.show("No book already.", context,
                        duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                      Navigator.push(context, 
                     MaterialPageRoute(
                       builder: (BuildContext context)=> MainScreen(
                        user: widget.user)));
     _loadbook();
      return;
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1,4) + "-" + 
    formatter.format(now) + randomAlphaNumeric(6);
    print(orderid);
    await Navigator.push(
    context, 
    MaterialPageRoute(
      builder:(BuildContext context)=> PaymentScreen(
        user:widget.user,
        val:_totalprice.toStringAsFixed(2),
        orderid:orderid,
      )));
      _loadbook();
 
  }
 Future<void> _payusingstorecredit(double newamount) async{
String urlPayment = "https://lilbearandlilpanda.com/uumsportfacilities/php/paymentsc.php";
await http.post(urlPayment, body : {
  "userid":widget.user.email,
  "amount": _totalprice.toStringAsFixed(2),
  "orderid": generateOrderid(),
  "newcr":newamount.toStringAsFixed(2)
}).then((res) {
  print(res.body);
}).catchError((err){
print(err);
});
  }

  String generateOrderid() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1,4) + 
    "-" +
    formatter.format(now) +
    randomAlphaNumeric(6);
    return orderid;

}

  void _updatePayment() {
    _hours = 0.0;
    _totalprice = 0.0;
    amountpay = 0.0;
    setState(() {
      for (int i = 0; i < bookdata.length; i++) {
          _hours = double.parse(bookdata[i]['chours']) +
                  //int.parse(bookdata[i]['hours']) +
              _hours;
          _totalprice = double.parse(bookdata[i]['yourprice']) + _totalprice;
        }
        print(_storeCredit);
        if(_storeCredit){
          amountpay = _totalprice - double.parse(widget.user.credit); 
        }else{
          amountpay = _totalprice;
        }
        print(_hours);
        print(_totalprice);
    });
  }

  void deleteAll() {
    showDialog(
      context: context,
    builder: (context) => new AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style:TextStyle(color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
          onPressed: () {
            http.post(
              "http://lilbearandlilpanda.com/uumsportfacilities/php/delete_book.php",
            body: {
              "email": widget.user.email,
            }).then((res) {
              print(res.body);

              if(res.body.contains("success")){
                setState(() {
                  widget.user.hours = "0";
                });
                Toast.show("No book already.", context,
            duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                Navigator.push(context, 
            MaterialPageRoute(
              builder: (BuildContext context)=> MainScreen(
                user: widget.user)));
                
           }else{
             
             Toast.show("Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              Navigator.of(context).pop();
           }
            }).catchError((err){
              print(err);
            });
            /*Toast.show("Clear book", context,
            duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (BuildContext context)=> MainScreen(
                user: widget.user)));*/

          },
          child: Text(
            "Yes",
            style:TextStyle(
             color: Color.fromRGBO(242,35,24,1),
              ),
          )),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(false);

            },
            child: Text("Cancel",
            style:TextStyle(
              color: Color.fromRGBO(242,35,24,1),
            )),
            )
        ],  
    ));
  }

  Future<bool> _onbackPressed () {
      return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user
      )));
  }

}


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_facility/ProfileScreen.dart';
import 'package:sport_facility/mapsample.dart';
import 'package:sport_facility/paymenthistoryscreen.dart';
import 'package:sport_facility/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:sport_facility/adminfacility.dart';
import 'bookingscreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class MainScreen extends StatefulWidget {
 final User user;

 const MainScreen ({Key key, this.user}):super(key:key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
GlobalKey<RefreshIndicatorState> refreshKey;

List facilitiesdata; 
int curnumber = 1;
bool _visible = false;
double screenHeight,screenWidth;
String curtype = " All";
String bookhours = "0";
int hours = 1;
bool _isadmin = false;
String titlecenter = "No facilities found";
//static final CameraPosition _center =CameraPosition(target: LatLng(6.4576, 100.5053),);
   @override
   void initState(){
     super.initState();
     _loadfacility();
     _loadbookhours();
     //_getlocation();
   
  
      refreshKey = GlobalKey<RefreshIndicatorState>();
     if (widget.user.email == "admin@sportfacility.com") {
      _isadmin = true;
     }
        }
       

   @override
    Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
       screenWidth = MediaQuery.of(context).size.width;
      TextEditingController _facilitiesController = new TextEditingController();

      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer:mainDrawer(context),
          appBar: AppBar(
            backgroundColor:Color(0xFFD50000),
            title:Text(
              'Facilities List',
              style:TextStyle(
                )
            ),
                actions: <Widget>[
                GestureDetector(
                  child: Row(
                    children:<Widget>[ 
                        Icon(Icons.alarm_add, color: Colors.white, size: 25),
                        Text(bookhours)
                    ]
                  ),
                  onTap: (){
                    if (widget.user.email == "unregistered@sportfacility.com") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
                    }
                   else if (widget.user.email == "admin@sportfacility.com") {
                Toast.show("Admin mode !!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
                      }else if (widget.user.hours == "0") {
                Toast.show("Book empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
                      }
                    setState(() { 
                      hours = 1;  
                      hours++; 
                    }); 
                    
                    Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => BookingScreen(
                     user:widget.user, 
                    ))
                    );
                  },
                  ),
                 IconButton(
                   icon: _visible
                   ? new Icon(Icons.expand_less)
                   : new Icon(Icons.expand_more),
                   onPressed: (){
                     setState(() {
                       if(_visible){
                         _visible = false;
                       } else {
                         _visible = true;
                       }
                     });
                   },
                 ),
               ]
          ),   
               body: RefreshIndicator(
                 key: refreshKey,
                 color: Color.fromRGBO(242,35,24,1),
                 onRefresh: () async {
                   await refreshList();
                 },
                child:Container(
                 child:Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                       Visibility(
                         visible: _visible,
                         child: Card(
                           elevation: 5,
                           child: Container(
                             margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children:<Widget>[
                                 Flexible(
                                   child: Container(
                                     height:40,
                                     width: 500,
                                     child:TextField(
                                        style: new TextStyle(color:Colors.white),
                                       autofocus: false,
                                       controller: _facilitiesController,
                                       decoration: InputDecoration(
                                         icon: Icon(Icons.search),
                                         border:OutlineInputBorder(),
                                        hintText: "E.g:Tennis court",
                                        hintStyle: TextStyle(fontSize: 13.0)
                                       ),
                                     )
                                   )),
                                   Flexible(
                                     child: RaisedButton(
                                      color: Color.fromRGBO(242,35,24,1),
                                       onPressed: () =>
                                       _sortItembyName(_facilitiesController.text),
                                       shape: new RoundedRectangleBorder(
                                       borderRadius:new BorderRadius.circular(50.0)),
                                       elevation: 5,
                                       child: Text(
                                         "Search ",
                                         style: TextStyle(color:Colors.white),
                                       )
                                     ))
                               ]
                             ),
                           ),
                         ),
                         ),
                       Visibility(
                       visible: _visible,
                       child: Card(
                         elevation:10,
                         child:Padding(
                           padding: EdgeInsets.fromLTRB(65, 5, 65, 5),
                           child:SingleChildScrollView(
                             scrollDirection:Axis.horizontal,
                             child: Row(
                               children: <Widget>[
                                 Column(
                                   children: <Widget>[
                                     FlatButton(onPressed: () =>_sortItem("All"),
                                     shape: new RoundedRectangleBorder(
                                           borderRadius:new BorderRadius.circular(50.0)),
                                     color: Color.fromRGBO(242,35,24,1),
                                     padding:EdgeInsets.all(10.0),
                                      child:Column(
                                        children:<Widget>[
                                          Icon(
                                               MdiIcons.update,
                                               color: Colors.white,
                                             ),
                                          Text(
                                            "All",
                                            style:TextStyle(color: Colors.white),
                                          )
                                        ]
                                      ))
                                   ],
                                   ),
                                   SizedBox(width: 5,
                                   ),
                                   Column(
                                     children: <Widget>[
                                       FlatButton(
                                         onPressed: () => _sortItem("Free"),
                                         color: Color.fromRGBO(242,35,24,1),
                                         shape: new RoundedRectangleBorder(
                                           borderRadius:new BorderRadius.circular(50.0)),
                                         padding:EdgeInsets.all(10.0),
                                         child: Column(
                                           children: <Widget>[
                                             Icon(
                                               MdiIcons.cashRemove,
                                               color: Colors.white,
                                             ),
                                           Text(
                                             "Free",
                                             style: TextStyle(color:Colors.white) ,
                                           )
                                           ],
                                       ))
                                       ],
                                       ),
                                       SizedBox(
                                         width: 5,
                                         ),
                                    Column(
                                     children: <Widget>[
                                      FlatButton(
                                         onPressed: () => _sortItem("Paid"),
                                         shape: new RoundedRectangleBorder(
                                           borderRadius:new BorderRadius.circular(50.0)
                                         ),
                                         color: Color.fromRGBO(242,35,24,1),
                                         padding: EdgeInsets.all(10.0),
                                         child: Column(
                                           children: <Widget>[
                                             Icon(
                                               MdiIcons.cash,
                                               color:Colors.white,
                                             ),
                                           Text(
                                             "Paid",
                                             style: TextStyle(color:Colors.white) ,
                                           )
                                           ],
                                       ))
                                       ],
                                       ),
                                       SizedBox(
                                         width: 5,)
                               ],)
                           ) ,)
                       ),),
                         Text(curtype,
                         style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white)),
                         facilitiesdata == null                
                         ? Flexible(
                           child:Container(
                             child:Center(
                               child: Text(
                                 titlecenter,
                                 style: TextStyle(
                                   color: Color.fromRGBO(242,35,24,1),
                                   fontSize: 22,
                                   fontWeight: FontWeight.bold),
                                 ),
                                 )
                           ))
                           :Expanded(
                           child: GridView.count(
                             crossAxisCount: 2,
                             childAspectRatio:0.70,
                             children:List.generate(facilitiesdata.length, (index){
                               return new Card(
                                 shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  ),
                                 color: Colors.white,
                                 elevation:10, 
                                 child:Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap:() => _onImageDisplayDetails(index),
                                        child: Container( 
                                         height: 160,
                                        width: 200, 
                                        decoration: new BoxDecoration(
                                          //border:Border.all(color:Colors.white),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:"https://lilbearandlilpanda.com/uumsportfacilities/images/${facilitiesdata[index]['id']}.png",
                                          fit:BoxFit.cover,      
                                        placeholder: (context,url) => 
                                        new CircularProgressIndicator(),
                                        errorWidget: (context,url, error) =>
                                        new Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height:5),
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(facilitiesdata[index]['name'],                
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black87)),
                                          new Text(
                                          "RM"+ facilitiesdata[index]['price'],
                                          style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                          ),
                                          new Text(
                                            "Maximum hours:" + facilitiesdata[index]['hours'],
                                          style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(50.0)),
                                              minWidth: 130,
                                              height: 35,
                                            child: Text('Booking'),
                                            color: Color.fromRGBO(242,35,24,1),
                                            textColor: Colors.white,  
                                            elevation: 10,
                                            onPressed: () => _gobookingdialog(index),
                                            ),
                                    ],),
                                  ));
                                  }
                           ))) 
                           ],)
               )),
               floatingActionButton: FloatingActionButton.extended(
                 onPressed:()async{
                  if (widget.user.email == "unregistered@sportfacility.com") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.email == "admin@sportfacility.com") {
                Toast.show("Admin mode !!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.hours == "0") {
                Toast.show("Book empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else {
                   await Navigator.push(
                     context, 
                     MaterialPageRoute(
                       builder: (BuildContext context) => BookingScreen(
                         user: widget.user,  
                       )));
                       _loadfacility();
                       _loadbookhours();    
              }
                 },
              
                 label: SizedBox(
                    child: Row(children: <Widget>[ //
                      Icon(Icons.alarm_add, size:26, color: Colors.white),
                      Center(child: Text(bookhours, maxLines: 1,style: TextStyle(fontSize:15, fontWeight: FontWeight.w500, color: Colors.white)),)
                    ],),
                 ),
                 foregroundColor: Colors.white,
                 backgroundColor:Color(0xFFD50000),
               ),
       ));
         }
        
  

void _loadfacility() async{
  String urlloadsJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/load_facilities.php";
        await http.post(urlloadsJobs,body:{}). then((res){
          if (res.body == "No data") {
            bookhours = "0";
            titlecenter ="No Product Found";
            setState(() {
              facilitiesdata = null;
            });
          }else{
           setState(() {
             var extractdata = json.decode(res.body);
             facilitiesdata = extractdata ["facility"];
             bookhours = widget.user.hours; 
            print(facilitiesdata);
           });
          }
         }).catchError((err){
           print(err);
         });
}

void _loadbookhours() async{
  String urlLoadsJobs = "https://lilbearandlilpanda.com/uumsportfacilities/php/load_bookhours.php";
  await http.post(urlLoadsJobs, body: {
    "email": widget.user.email,
  }).then((res) {
    if (res.body == "No data"){
    }else{
      widget.user.hours = res.body;
    }
  });
  
}


mainDrawer(BuildContext context) {
   return Drawer(
           child: ListView(
             children: <Widget>[        
               UserAccountsDrawerHeader(
                 decoration: BoxDecoration(
                   color:Colors.redAccent,
                 ),
                 accountName: Text(widget.user.name), 
                 accountEmail: Text(widget.user.email),
                 otherAccountsPictures: <Widget>[
                   Text( "RM "  + 
                    widget.user.credit,
                   style: TextStyle(fontSize: 16.0, color:Colors.black,fontWeight: FontWeight.bold),
                   ),
                 ],
                 currentAccountPicture: CircleAvatar(
                   backgroundColor: 
                   Theme.of(context).platform == TargetPlatform.android
                   ? Colors.red
                   : Colors.white,
                   child: Text(
                    widget.user.name.toString().substring(0,1).toUpperCase(),
                     style:TextStyle(fontSize: 25.0),
                   ),
                   backgroundImage: NetworkImage(
                     "https://lilbearandlilpanda.com/uumsportfacilities/profileimages/${widget.user.email}.jpg"),
                    ),
                    onDetailsPressed: () => {
                      Navigator.pop(context),
                      Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProfileScreen(
                          user: widget.user,
                        )))
                    },
                 ),
                 SizedBox(height: 5),
                 Card(
                 child:ListTile(
                   leading: Icon(Icons.supervised_user_circle),
                   title:Text("User Profile", 
                   style:TextStyle(color: Colors.white,
                   fontWeight: FontWeight.bold,
                   ),
                   ),
                   trailing:Icon(Icons.keyboard_arrow_right),
                   onTap: () => {
                     Navigator.pop(context),
                     Navigator.push(context, 
                     MaterialPageRoute(
                       builder: (BuildContext context) => ProfileScreen(
                       user: widget.user ,
                       )))
                   })),
                   SizedBox(height: 5),
                   Card(
                   child:ListTile(
                   leading: Icon(Icons.list),
                   title: Text("Facilities List",
                   style:TextStyle(color: Colors.white,
                   fontWeight: FontWeight.bold,
                   ),
                   ),
                   trailing: Icon(Icons.keyboard_arrow_right),
                   onTap: () => {
                     Navigator.pop(context),
                   _loadfacility(),
                   },
                 )),
                 SizedBox(height: 5),
                 Card(
                   elevation: 5,
                   //color: Colors.red,
                   child:ListTile(
                   leading: Icon(Icons.alarm_add),
                   title: Text("Facility booking",
                   style:TextStyle(color: Colors.white,
                   fontWeight: FontWeight.bold,
                   ),
                   ),
                   trailing: Icon(Icons.keyboard_arrow_right),
                   onTap: () => {
                     Navigator.pop(context),
                     gotobook(),
                    })),
                    SizedBox(height: 5),
                  Card(
                   child:ListTile(
                   leading: Icon(Icons.payment),
                   title:Text("Payment History", 
                   style:TextStyle(color: Colors.white,
                   fontWeight: FontWeight.bold,
                   ),
                   ),
                   trailing:Icon(Icons.keyboard_arrow_right),
                   onTap: () => {
                     Navigator.pop(context),
                     Navigator.push(context, 
                     MaterialPageRoute(
                       builder: (BuildContext context) => PaymentHistoryScreen(
                       user: widget.user ,
                       )))
                   })),
                   SizedBox(height: 5),
                    Visibility(
                      visible: _isadmin,
                      child: Column(
                        children:<Widget>[
                          Divider(
                            height: 10,
                            color: Colors.white60,
                            ),
                            Center(
                              child:Text(
                                "Admin Menu",
                                style:TextStyle(
                                  fontSize: 15, 
                                  fontWeight:FontWeight.w100,
                                  color: Colors.white), 
                              ),
                            ),
                            SizedBox(height: 5),
                            Card(
                            child:ListTile(
                              leading: Icon(Icons.edit),
                              title:Text(
                                "My Facility",
                                style:TextStyle(
                                  color: Colors.white,
                                  ),
                              ),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () => {
                                Navigator.pop(context),
                                Navigator.push(context, 
                                MaterialPageRoute(
                                  builder:(BuildContext context) =>
                                  AdminFacility(
                                    user:widget.user,
                                  )))
                              })), 
                        ]
                      ),
                      )
             ],
           ),
           );
}

_sortItembyName(String prname) {
  try{
    print(prname);
    ProgressDialog pr = new ProgressDialog(context,
    type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message:"Searching...");
    pr.show();
    //pr.dismiss();
    String urlLoadJobs = "https://lilbearandlilpanda.com/uumsportfacilities/php/load_facilities.php";
    http.post(urlLoadJobs,body:{
      "name": prname.toString(),
    }).then((res){
      if(res.body == "nodata"){
        Toast.show("Product not found",context,
        duration:Toast.LENGTH_LONG,gravity:Toast.BOTTOM);
        pr.dismiss();
        FocusScope.of(context).requestFocus(new FocusNode());
        return;
      }
      setState(() {
        var extractdata =json.decode(res.body);
        facilitiesdata = extractdata ["facility"];
        FocusScope.of(context).requestFocus(new FocusNode());
        curtype = prname;
        pr.dismiss();
      });
    }).catchError((err){
      pr.dismiss();
    });
    pr.dismiss();
  }on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  
}

_sortItem(String type) {
  try{
     ProgressDialog pr = new ProgressDialog(context,
     type:ProgressDialogType.Normal, isDismissible:true);
     pr.style(message:"Searching...");
     pr.show();
     String urlLoadJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/load_facilities.php";
     http.post(urlLoadJobs,body:{
       "type":type,
     }).then((res){
       setState(() {
         curtype = type;
         var extractdata = json.decode(res.body);
         facilitiesdata = extractdata ["facility"];
         FocusScope.of(context).requestFocus(new FocusNode());
         pr.dismiss();
       });
     }).catchError((err){
       print(err);
       pr.dismiss();    
     });
     pr.dismiss();
   }catch (e){
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
   }
}


  _gobookingdialog(int index) {
    if (widget.user.email == "unregistered@sportfacility.com") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
    }
    if (widget.user.email == "admin@sportfacility.com") {
                Toast.show("Admin mode !!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
    }

    hours = 1;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context,newSetState){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Row(
             //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,  
            children:[
             Image.network(
             "https://lilbearandlilpanda.com/uumsportfacilities/images/${facilitiesdata[index]['id']}.png",
             width:200, height: 200,
             fit: BoxFit.cover),  
         ]
       ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Book "+  facilitiesdata[index]['name'] + " to booking  ?",
                    style: TextStyle(color:Colors.white, fontSize: 16,fontWeight: FontWeight.bold
                     )
                  ),
                  SizedBox(height:25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text(
                    "Select hours of facility",
                    style: TextStyle(color:Colors.white,
                     )
                  ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                            newSetState(() {
                              if (hours > 1){
                                hours--;
                              }
                            })
                          },
                          child: Icon(
                            MdiIcons.minus,
                             color: Color.fromRGBO(242,35,24,1),
                          ),
                          ),
                          Text(
                            hours.toString(),
                            style:TextStyle(color: Colors.white,
                            )
                          ),
                          FlatButton(
                            onPressed: () =>{
                            newSetState(() {
                              if (hours < 
                              (int.parse(facilitiesdata[index]['hours'])-7)) {
                                hours++;

                              }else{
                                Toast.show("Hours not available", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                              }
                          })
                            },
                          child: Icon(
                            MdiIcons.plus,
                            color: Color.fromRGBO(242,35,24,1),
                          ))
                        ],
                        )
                    ]
                  )
                ],),
       actions: <Widget> [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              _booking(index);
            },
            child: Text(
              "Yes",
              style:TextStyle(
                color: Color.fromRGBO(242,35,24,1),
              )
           )),
            MaterialButton(
              onPressed: (){
                Navigator.of(context).pop(false);    
              },
              child: Text("Cancel",
              style: TextStyle(
                color: Color.fromRGBO(242,35,24,1),
              ),
              )),
        ],
      );
        });
  });

  }

  void _booking(int index) {
    try {
      int chours = int.parse(facilitiesdata[index]["hours"]);
      //print(chours);
      print(facilitiesdata[index]["id"]);
      print(widget.user.email);
      if(chours > 0){
        //ProgressDialog pr = new ProgressDialog(context,
        //type: ProgressDialogType.Normal,isDismissible: true);
       // pr.style(message:"Add to Booking...");
        //pr.show();
        //pr.dismiss();
        String urlLoadJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/insert_book.php";
        http.post(urlLoadJobs,body: {
          "email": widget.user.email,
          "prodid":facilitiesdata[index]["id"],
          "hours": hours.toString()
        }).then((res){
          print(res.body);
            if(res.body == "failed"){
              Toast.show("Failed add to booking", context,
              duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
             // pr.dismiss();
              return;
            }else{
              List respond = res.body.split(",");
              setState(() {
                bookhours = respond[1];
                widget.user.hours = bookhours;
              });
              Toast.show("Done add to booking", context,
              duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
            }
           // pr.dismiss();
          }).catchError((err){
            print(err);
           // pr.dismiss();
          });
          //pr.dismiss();
        }else{
          Toast.show("Fully Book", context,
          duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
        }      
  }catch (e){
    Toast.show(" Failed add to book", context,
    duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
  }
  }

  gotobook() async {
    if (widget.user.email == "unregistered@sportfacility.com") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
    }else if (widget.user.email == "admin@sportfacility.com") {
                Toast.show("Admin mode !!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;   
  }else if (widget.user.hours == "0") {
      Toast.show("Book empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
  }else{
    await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BookingScreen(
                    user: widget.user,
                  )));
                  _loadfacility();
                  _loadbookhours();
                  
  }

  }
 Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
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
        ) ??
        false;
  }


  Future <Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadfacility();
    return null;
}



 _onImageDisplayDetails(int index) {
   showDialog(
     context: context,
     builder: (context){
       return StatefulBuilder(builder: (context, newSetState){
         return AlertDialog(
           shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Row(
             //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,  
            children:[
             Image.network(
             "https://lilbearandlilpanda.com/uumsportfacilities/images/${facilitiesdata[index]['id']}.png",
             width:200, height: 200,
             fit: BoxFit.cover),  
         ]
       ),
       content: new Column(
         mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "ID: "+  facilitiesdata[index]['id'],
                    style: TextStyle(color:Colors.white, fontSize: 16,fontWeight: FontWeight.bold
                     )
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Name: "+  facilitiesdata[index]['name'],
                    style: TextStyle(color:Colors.white, fontSize: 16,fontWeight: FontWeight.bold
                     ),
                  ),
                  SizedBox(height:5),
                    RatingBar(
                   initialRating: 3,
                   minRating: 1,
                   direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                  Icons.star,color: Colors.amber,),
                   onRatingUpdate: (rating) {
                  print(rating);
                  },
                   ),
                  MaterialButton(
                    color: Colors.red,
                    minWidth: 100,
                    height: 40,
                    child:Icon(MdiIcons.locationEnter),
                    onPressed: ()=> 
                    Navigator.push(
                      context, 
                    MaterialPageRoute(
                      builder: (BuildContext context)=> MapSampleState(
                      ))))
                  
                ]),
                


         );
       });
     });
   
     

 }
   
  }







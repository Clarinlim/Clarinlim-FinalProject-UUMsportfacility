import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sport_facility/loginscreen.dart';
import 'package:sport_facility/registrationscreen.dart';
import 'package:sport_facility/storecredit.dart';
import 'user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';
import 'loginscreen.dart';
import 'registrationscreen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String server = "https://lilbearandlilpanda.com/uumsportfacilities";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
double screenHeight, screenWidth;
@override
  void initState() {
    super.initState();
    print("profile screen");
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.emptyCache();
  }


  @override
  Widget build(BuildContext context) {
   parsedDate = DateTime.parse(widget.user.datereg);
   screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    
    return Scaffold(
      appBar: AppBar(
         backgroundColor:Color(0xFFD50000),
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Card(
              //color: Colors.red,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            //color:Colors.red,
                            child:Table(
                              defaultColumnWidth: FlexColumnWidth(2.5),
                              columnWidths: {
                                0:FlexColumnWidth(4.0),
                                1:FlexColumnWidth(7.5),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                      child:Container(
                                         alignment:Alignment.centerLeft,
                                          height:20,
                                          child:Text("Name",
                                           style:TextStyle(
                                          fontWeight: FontWeight.bold, 
                                          color:Colors.white))),
                                ),
                                TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: Text(widget.user.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                              ]),
                              TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text("Email",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height:30,
                                      child: Text(widget.user.email,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11.5,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text("Phone",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text(widget.user.phone,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 30,
                                        child: Text("DateReg",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text(f.format(parsedDate),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ]),
                              ]),
                        )),
                        SizedBox(width: 10),
                        Row(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children:<Widget>[
                          GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            height: 130,
                            width: 120,
                            decoration: new BoxDecoration(
                              //shape: BoxShape.circle,
                              //border: Border.all(color: Colors.black),
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  "https://lilbearandlilpanda.com/uumsportfacilities/profileimages/${widget.user.email}.jpg",
                              placeholder: (context, url) => new SizedBox(
                                  height: 10.0,
                                  width: 10.0,
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  new Icon(MdiIcons.cameraIris, size: 64.0),
                            ),
                          ),
                        ),  
                          ]
                        )
                      ],
                    ),
                    SizedBox(
                      height:2,
                    ),
                    Divider(
                      height:6,
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:<Widget>[
                        Text(
                          "Store Credit : "  + "RM" +  widget.user.credit,
                          style:TextStyle(
                            fontWeight:FontWeight.bold,
                            color:Colors.white, fontSize: 15.0)
                        ),
                      ]
                    )
                  ]
                 )
               )
            ),
            Container(
              color: Color.fromRGBO(242,35,24,1),
              child: Center(
                child:Text(" Set Your Profile",
                style:TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  )
                )
              ),
            ),
            Divider(
              height: 5,
              color: Colors.grey,
            ),
            Expanded(

                //color: Colors.red,
                child: ListView(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    shrinkWrap: true,
                    children: <Widget>[
                  MaterialButton(
                    onPressed: changeName,
                    child: Text("CHANGE NAME",
                    style: TextStyle(fontSize: 16.0,color: Colors.white),
                    ),
                  ),
                  Divider(
                       height: 10,
                       color: Colors.grey,
                      ),
                  MaterialButton(
                    onPressed: changePassword,
                    child: Text("CHANGE PASSWORD",
                   style: TextStyle(fontSize: 16.0,color: Colors.white),
                   ),
                  ),
                   Divider(
                       height: 10,
                       color: Colors.grey,
                      ),
                  MaterialButton(
                    onPressed: changePhone,
                    child: Text("CHANGE PHONE NUMBER",
                   style: TextStyle(fontSize: 16.0,color: Colors.white),
                    ),
                  ),
                   Divider(
                       height: 10,
                       color: Colors.grey,
                      ),
                  MaterialButton(
                    onPressed: _gotologinPage,
                    child: Text("BACK TO LOGIN",
                   style: TextStyle(fontSize: 16.0,color: Colors.white),
                    ),
                  ),
                   Divider(
                       height: 10,
                       color: Colors.grey,
                      ),

                  MaterialButton(
                    onPressed: _registerAccount,
                    child: Text("REGISTER AN ACCOUNT",
                    style: TextStyle(fontSize: 16.0,color: Colors.white),
                    ),
                  ),
                   Divider(
                       height: 10,
                       color: Colors.grey,
                      ),
                  MaterialButton(
                    onPressed: buyStoreCredit,
                    child: Text("BUY STORE CREDIT",
                    style: TextStyle(fontSize: 16.0,color: Colors.white),
                    ),
                  ),
                ])), 

           ])));

  }


  void _takePicture() async {
     if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    File _image = await ImagePicker.pickImage(
      source:ImageSource.camera, maxHeight:400, maxWidth:300);
      if(_image == null){
        Toast.show("Please take a picture first", context, 
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }else{
        String base64Image = base64Encode(_image.readAsBytesSync());
        print(base64Image);
        String urlLoadJobs = "https://lilbearandlilpanda.com/uumsportfacilities/php/upload_image.php";
        http.post(urlLoadJobs, body: {
          "encoded_string":base64Image,
          "email": widget.user.email,
          //"encoded_string":base64Image,
        }).then((res){
          print(res.body);
          if (res.body == ("Success")) {
            setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
            });
            Navigator.of(context).pop();
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (BuildContext context) => ProfileScreen(user:widget.user)
            ));
          } else {
            Toast.show("failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }

        }).catchError((err){
          print(err);
        });
        
      }
  }

  

  void changeName() {
    if(widget.user.email == "unregistered"){
      Toast.show("Please register to use this function", context,
      duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      return;
    }
    if(widget.user.email == "admin@yahoo.com"){
      Toast.show("Admin Mode !!", context,
      duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              "Change you Name ?",
              style:TextStyle(
                color: Colors.white)
              ),
              content: new TextField(
                style:TextStyle(color: Colors.white),
                controller:nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  icon: Icon(
                    Icons.person,
                    color: Color.fromRGBO(242,35,24,1),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:Colors.red),
                  ),
              )),
                actions: <Widget>[
                  new FlatButton(
                    child:new Text(
                      "Yes",
                      style:TextStyle(
                        color: Color.fromRGBO(242,35,24,1),
                        )
                    ),
                    onPressed: () => 
                    _changeName(nameController.text.toString())),
                    new FlatButton(
                      child: new Text("No",
                      style:TextStyle(
                        color: Color.fromRGBO(242,35,24,1),
                        )
                      ),
                      onPressed: () => {Navigator.of(context).pop()},
              )
         ]);
      });
  }

_changeName(String name) {
   if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (name == "" || name == null) {
      Toast.show("Please enter your new name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ReCase rc = new ReCase(name);
    print(rc.titleCase.toString());
    http.post("https://lilbearandlilpanda.com/uumsportfacilities/php/update_profile.php", body: {
      "email":widget.user.email,
      "name": rc.titleCase.toString(),
    }).then((res) {
      if(res.body == "success"){
        print('in success');
        setState(() {
          widget.user.name = rc.titleCase;
        });
        Toast.show("Success", context,
        duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      }else {}
    }).catchError((err){
      print(err);
    });
}

  void changePassword() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController oldpassController = TextEditingController();
    TextEditingController newpassController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              "Change Your Password ?",
              style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content:new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    style: TextStyle(
                        color: Colors.white,
                      ),
                      controller:oldpassController,
                      obscureText:true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        icon: Icon(
                          Icons.lock,
                          color: Color.fromRGBO(242,35,24,1),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:Colors.red),
                  ),
                      )),
                  TextField(
                    style: TextStyle(
                        color: Colors.white,
                      ),
                      controller:newpassController,
                      obscureText:true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        icon: Icon(
                          Icons.lock,
                          color: Color.fromRGBO(242,35,24,1),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:Colors.red),
                  ),
                      ))
                ]),
                actions: <Widget>[
                  new FlatButton(
                     child: new Text(
                       "Yes",
                       style:TextStyle(
                         color: Color.fromRGBO(242,35,24,1),
                       )
                     ),
                     onPressed: () => updatePassword(
                       oldpassController.text, newpassController.text)),
                   
                       new FlatButton( 
                         child: new Text(
                           "No",
                           style:TextStyle(
                         color: Color.fromRGBO(242,35,24,1),
                       )
                         ),
                         onPressed: () => {Navigator.of(context).pop()},
                         ),
                ]);
      });
  }
  updatePassword(String pass1, String pass2) {
     if (pass1 == "" || pass2 == "") {
      Toast.show("Please enter your password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post("https://lilbearandlilpanda.com/uumsportfacilities/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res){
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pass2;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
    }


  void changePhone() {
     if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController phoneController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your phone number ?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'New Phone Number',
                    icon: Icon(
                      Icons.phone,
                      color: Color.fromRGBO(242,35,24,1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:Colors.red),
                  ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                       color: Color.fromRGBO(242,35,24,1),
                      ),
                    ),
                    onPressed: () =>
                        _changePhone(phoneController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Color.fromRGBO(242,35,24,1),
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }
  _changePhone(String phone) {
     if (phone == "" || phone == null || phone.length < 9) {
      Toast.show("Please enter your new phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post("https://lilbearandlilpanda.com/uumsportfacilities/php/update_profile.php", body: {
      "email": widget.user.email,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.phone = phone;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void _gotologinPage() {
    print(widget.user.name);
    showDialog(
      context: context,
    builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title:new Text(
                " Go to Login Page ?",
                style: TextStyle(
              color: Colors.white,
            )),
            content: new Text("Are you sure ?",
            style: TextStyle(
              color: Colors.white,
            ),
            ),
            actions: <Widget>[
              new FlatButton( 
                child: new Text(
                  "Yes",
                  style: TextStyle(
                       color: Color.fromRGBO(242,35,24,1),
                      ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
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

  void _registerAccount() {
    print(widget.user.name);
    showDialog(
      context: context,
    builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title:new Text(
                " Register a new account?",
                style: TextStyle(
              color: Colors.white,
            )),
            content: new Text("Are you sure ?",
            style: TextStyle(
              color: Colors.white,
            ),
            ),
            actions: <Widget>[
              new FlatButton( 
                child: new Text(
                  "Yes",
                  style: TextStyle(
                       color: Color.fromRGBO(242,35,24,1),
                      ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext context) => RegistrationScreen()));
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
  
  void buyStoreCredit() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    else if (widget.user.email == "admin@sportfacility.com") {
                Toast.show("Admin mode !!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
    }
     TextEditingController creditController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Buy Store Credit?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: creditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter RM',
                    icon: Icon(
                      Icons.attach_money,
                      color: Color.fromRGBO(242,35,24,1),
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Color.fromRGBO(242,35,24,1),
                      ),
                    ),
                    onPressed: () =>
                        _buyCredit(creditController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Color.fromRGBO(242,35,24,1),
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _buyCredit(String cr) {
    print("RM" + cr);
    if(cr.length <= 0){
      Toast.show("Please enter correct amount", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context)=> new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Buy store credit RM ' + cr,
              style:TextStyle(color: Colors.white,
              )
            ),
            content: new Text(
              'Are you sure to buy store credit ? ',
              style:TextStyle(color: Colors.white,
              )
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text(
                  "Yes",
                  style:TextStyle(
                   color: Color.fromRGBO(242,35,24,1),
                    )
                ),
                onPressed: (){
                  Navigator.of(context).pop(false);
                  Navigator.of(context).pop(false);
                  Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (BuildContext context)=> StoreCreditScreen(
                      user:widget.user,
                      val: cr,       
                    )));
                },
              ),
              new FlatButton(
                 child: new Text(
                 "Cancel",
                    style:TextStyle(
                        color: Color.fromRGBO(242,35,24,1))
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),      
            ],
      ));
  }
}

  




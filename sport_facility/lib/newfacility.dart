import 'package:flutter/material.dart';
import 'dart:io'; 
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class NewFacility extends StatefulWidget {
  @override
  _NewFacilityState createState() => _NewFacilityState();
}

class _NewFacilityState extends State<NewFacility> {
TextEditingController facidEditingController = new TextEditingController();
TextEditingController facnameEditingController = new TextEditingController();
TextEditingController priceEditingController = new TextEditingController();
TextEditingController hrsEditingController = new TextEditingController(); 

//TextEditingController typeEditingController = new TextEditingController();
double screenHeight, screenWidth;
final focus0 = FocusNode();
final focus1 = FocusNode();
final focus2 = FocusNode();
final focus3 = FocusNode();
File _image;
String pathAsset = 'assets/images/camera.png';
String typeSelected;
  List <String> listType = [
    "Free", "Paid"
  ];
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Color(0xFFD50000),
          title: Text('New Facility'),
        ),
        body: Center(
          child: Container(
            child:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => {_choose()},
                    child: Container(
                      height:screenHeight / 3,
                      width: screenWidth / 1.8,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                          image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                          fit: BoxFit.cover,
                          ),
                          border:Border.all(
                            width:3.0,
                            color:Colors.grey,
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  ),
                  SizedBox (height: 5),
                  Text("Clik to upload a picture of facilty",
                  style:TextStyle(fontSize: 12.0, color: Colors.white)),
                  SizedBox(height: 5),
                  Container(
                  width: screenWidth/1.2,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child:Table(
                        defaultColumnWidth: FlexColumnWidth(1.0),
                        columnWidths: {
                        0:FlexColumnWidth(4.0),
                        1:FlexColumnWidth(7.0),
                      },
                      children: [
                        TableRow(children: [
                          TableCell(
                            child:Container(
                              alignment:Alignment.centerLeft,
                              height:30,
                              child:Text("Facility ID",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                color:Colors.white,
                              ))),
                              ),
                              TableCell(
                               child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                  height: 30,
                                  child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  //child: GestureDetector(
                                    //onTap: _showPopupMenu,
                                    //onTapDown: _storePosition,
                                    child: TextFormField(
                                       style: TextStyle(
                                         color: Colors.white),
                                  controller: facidEditingController,
                                   keyboardType: TextInputType.number,
                                   textInputAction: TextInputAction.next,
                                   onFieldSubmitted: (v) {
                                     FocusScope.of(context).requestFocus(focus0);
                                 },
                                   decoration: new InputDecoration(
                                     contentPadding: const EdgeInsets.all(5),
                                     fillColor: Colors.white,
                                     border: new OutlineInputBorder(
                                     borderRadius:new BorderRadius.circular(5.0),
                                     borderSide: new BorderSide(),
                                    ),
                                   ), 
                                         ),
                                  ))),
                              
                        ]),
                        TableRow(children: [
                          TableCell(
                            child:Container(
                              alignment:Alignment.centerLeft,
                              height:30,
                              child:Text("Facility Name",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                color:Colors.white,
                              ))),
                              ),
                              TableCell(
                               child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                  height: 30,
                                  child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: TextFormField(
                                    style: TextStyle(
                                  color: Colors.white,
                                   ),
                                   controller: facnameEditingController,
                                   keyboardType: TextInputType.text,
                                   textInputAction: TextInputAction.next,
                                   focusNode: focus0,
                                   onFieldSubmitted: (v) {
                                     FocusScope.of(context).requestFocus(focus1);
                                   },
                                   decoration: new InputDecoration(
                                     contentPadding: const EdgeInsets.all(5),
                                     fillColor: Colors.white,
                                     border: new OutlineInputBorder(
                                     borderRadius:new BorderRadius.circular(5.0),
                                     borderSide: new BorderSide(),
                                    ),
                                   ), 
                                 )),
                              )),
                        ]),
                        TableRow(children: [
                          TableCell(
                            child:Container(
                              alignment:Alignment.centerLeft,
                              height:30,
                              child:Text("Price (RM)",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                color:Colors.white,
                              ))),
                              ),
                              TableCell(
                               child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                  height: 30,
                                  child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: TextFormField(
                                    style: TextStyle(
                                  color: Colors.white,
                                   ),
                                   controller: priceEditingController,
                                   keyboardType: TextInputType.number,
                                   textInputAction: TextInputAction.next,
                                   focusNode: focus1,
                                   onFieldSubmitted: (v) {
                                     FocusScope.of(context).requestFocus(focus2);
                                   },
                                   decoration: new InputDecoration(
                                     contentPadding: const EdgeInsets.all(5),
                                     fillColor: Colors.white,
                                     border: new OutlineInputBorder(
                                     borderRadius:new BorderRadius.circular(5.0),
                                     borderSide: new BorderSide(),
                                    ),
                                   ), 
                                 )),
                              )),
                        ]),
                        TableRow(children: [
                          TableCell(
                            child:Container(
                              alignment:Alignment.centerLeft,
                              height:30,
                              child:Text("Hours",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                color:Colors.white,
                              ))),
                              ),
                              TableCell(
                               child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                  height: 30,
                                  child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: TextFormField(
                                    style: TextStyle(
                                  color: Colors.white,
                                   ),
                                   controller: hrsEditingController,
                                   keyboardType: TextInputType.number,
                                   textInputAction: TextInputAction.next,
                                   focusNode: focus2,
                                   onFieldSubmitted: (v) {
                                     FocusScope.of(context).requestFocus(focus3);
                                   },
                                   decoration: new InputDecoration(
                                     contentPadding: const EdgeInsets.all(5),
                                     fillColor: Colors.white,
                                     border: new OutlineInputBorder(
                                     borderRadius:new BorderRadius.circular(5.0),
                                     borderSide: new BorderSide(),
                                    ),
                                   ), 
                                 )),
                              )),
                        ]),
                        TableRow(children:[
                          TableCell(
                            child: Container(
                              alignment:Alignment.centerLeft,
                              height:30,
                              child:Text("Type",
                              style:TextStyle(
                                fontWeight:FontWeight.bold,
                                color:Colors.white,
                              )),
                            )),
                             TableCell(
                               child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                 height: 40,
                                 child: Container(
                                  height: 40,
                                   child: DropdownButton(
                                    hint: Text('Type',
                                    style: TextStyle(
                                      color: Color.fromRGBO(242,35,24,1), ),
                                            ), // Not necessary for Option 1
                                            value: typeSelected,
                                            onChanged: (newValue) {
                                              setState(() {
                                                typeSelected = newValue;
                                                print(typeSelected);
                                              });
                                            },
                                            items: listType.map((typeSelected) {
                                              return DropdownMenuItem(
                                                child: new Text(typeSelected,
                                                    style: TextStyle(
                                                     color: Color.fromRGBO(242,35,24,1), 
                                                       )),
                                                value: typeSelected,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                        ])
                      ],
                      ),
                    ),
                
                   )),
                    MaterialButton(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                    minWidth: screenWidth / 1.5,
                    height: 40,
                    child: Text('Insert New Facility'),
                    color: Color.fromRGBO(242,35,24,1),
                    textColor: Colors.white,
                    elevation: 5,
                    onPressed: _insertNewFacility,
                    ),
                    ]
              ),

            )
            
          ),
        ),
      
    );
  }

 void _choose() async{
   _image = await ImagePicker.pickImage(
     source: ImageSource.gallery, maxHeight: 800, maxWidth:800);
     _cropImage();
     setState(() {});
 }

 Future <Null> _cropImage() async{
   File croppedFile = await ImageCropper.cropImage( 
     sourcePath: _image.path,
     aspectRatioPresets:Platform.isAndroid
     ? [
       CropAspectRatioPreset.square,
     ]
     :[
       CropAspectRatioPreset.square,
     ],
     androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(0xFFD50000),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
       title: 'Cropper',
        ));
        if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
}

  
 

void _insertNewFacility() {
  if (facidEditingController.text.length > 5) {
      Toast.show("Please enter facility Id", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
 if (facnameEditingController.text.length < 4) {
      Toast.show("Please enter facility name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }if (hrsEditingController.text.length < 1) {
      Toast.show("Please enter facility hours", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter facility price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
  }
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New Facility Id " + facidEditingController.text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
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
                insertFacility();
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
    }
  );
}


void insertFacility() {
  double price = double.parse(priceEditingController.text);
 String base64Image = base64Encode(_image.readAsBytesSync());
 String urlLoadJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/insert_facility.php"; 
  http.post (urlLoadJobs, body:{
    "id": facidEditingController.text,
    "name":facnameEditingController.text,
    "price": price.toStringAsFixed(2),
    "type":typeSelected,
    "hours":hrsEditingController.text,
    "encoded_string":base64Image,
  }).then((res){
    print(res.body);
    if (res.body =="found"){
        Toast.show("Product id already in database", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
  }).catchError((err) {
    print(err);
  });
  }
}






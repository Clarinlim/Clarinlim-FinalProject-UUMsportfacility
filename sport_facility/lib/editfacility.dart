import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'facility.dart';
import 'user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
class EditFacility extends StatefulWidget {
final User user;
final Facility facility;

const EditFacility({Key key, this.user, this.facility}) : super(key: key);
  @override
  _EditFacilityState createState() => _EditFacilityState();
}

class _EditFacilityState extends State<EditFacility> {
TextEditingController facnameEditingController = new TextEditingController();
TextEditingController priceEditingController = new TextEditingController();
TextEditingController hrsEditingController = new TextEditingController(); 
//TextEditingController typeEditingController = new TextEditingController();
double screenHeight, screenWidth;
final focus0 = FocusNode();
final focus1 = FocusNode();
final focus2 = FocusNode();
//final focus3 = FocusNode();
bool _takepicture = true;
bool _takelocalpicture = false;
File _image;
String typeSelected;
  List<String> listType = [
    "Free", "Paid"
  ];

  @override
  void initState() {
    super.initState();
    print("edit Facility");
    facnameEditingController.text = widget.facility.name;
    priceEditingController.text = widget.facility.price;
    hrsEditingController.text = widget.facility.hours;
    //typeEditingController.text = widget.facility.type;
    typeSelected = widget.facility.type;
    print(hrsEditingController.text);
  }
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor:Color(0xFFD50000),
          title: Text('Update Your Facility'),
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _choose,
                  child: Column(
                    children: [
                      Visibility(
                        visible: _takepicture,
                        child: Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1.5,
                          child:CachedNetworkImage( 
                            fit:BoxFit.fill,
                            imageUrl: "https://lilbearandlilpanda.com/uumsportfacilities/images/${widget.facility.id}.png",
                            placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                            errorWidget: (context,url,error) =>
                            new Icon(Icons.error),
                          )
                        ),
                        ),
                        Visibility(
                          visible: _takelocalpicture,
                          child: Container(
                            height: screenHeight / 3,
                            width: screenWidth / 1.5,
                            decoration: BoxDecoration(
                              image: new DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                                  image: _image == null
                                  ? AssetImage('assets/images/camera.png')
                                  : FileImage(_image),
                                  fit: BoxFit.cover
                                  )
                            ),
                          ),
                          )
                    ]
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  width: screenWidth/1.2,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child:Table(defaultColumnWidth: FlexColumnWidth(1.0),
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
                                  height: 30,
                                  child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: Text(" " + widget.facility.id,
                                  style: TextStyle(
                                  color: Colors.white,
                                   ),
                                 )),
                              )),
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
                    ),
                
                ),
                SizedBox(height: 3),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                    minWidth: screenWidth / 1.5,
                    height: 40,
                    child: Text('Update Product'),
                    color: Color.fromRGBO(242,35,24,1),
                    textColor: Colors.white,
                    elevation: 5,
                    onPressed: () => updateFacilityDialog(),
                    ),
              ],
            ),
          ),
        ),
      
    );
  }

  void _choose() async{
    _image = await ImagePicker.pickImage(
      source:ImageSource.gallery, maxHeight: 800, maxWidth: 800);
      _cropImage();
      setState(() {});

  }
 Future<Null> _cropImage() async{
   File croppedFile = await ImageCropper.cropImage( 
     sourcePath: _image.path,
     aspectRatioPresets:Platform.isAndroid
     ? [
       CropAspectRatioPreset.square,
       ]
     : [
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

        if (croppedFile !=null){
         _image = croppedFile;
         setState(() {
           _takepicture = false;
           _takelocalpicture = true;
         });
        }
 }

updateFacilityDialog() {
showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Facility Id " + widget.facility.id,
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
                updateFacility();
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
      },
    );
}




  void updateFacility() {
    if (facnameEditingController.text.length < 4) {
      Toast.show("Please enter facility name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
      if (priceEditingController.text.length < 1) {
      Toast.show("Please enter facility price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    
    }if (hrsEditingController.text.length < 1) {
      Toast.show("Please enter facility hours", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    
    double price = double.parse(priceEditingController.text);

  String base64Image;
    if (_image!=null){
      base64Image = base64Encode(_image.readAsBytesSync());
      String urlLoadJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/update_facility.php";
      http.post(urlLoadJobs, body: {
      "id": widget.facility.id,
      "name": facnameEditingController.text,
      "price": price.toStringAsFixed(2),
      "type": typeSelected,
      "hours": hrsEditingController.text,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Update success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Update failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
     
    });
    }else{
      String urlLoadJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/update_facility.php";
       http.post(urlLoadJobs, body: {
      "id": widget.facility.id,
      "name": facnameEditingController.text,
      "price": price.toStringAsFixed(2),
      "type": typeSelected,
      "hours": hrsEditingController.text,
    }).then((res) {
      print(res.body);
     
      if (res.body == "success") {
        Toast.show("Update success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Update failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      
    });
    }

  }
}
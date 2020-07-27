import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:sport_facility/loginscreen.dart';

void main() => runApp(RegistrationScreen());

class RegistrationScreen extends StatefulWidget {
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isChecked = false;

  String urlRegister ="https://lilbearandlilpanda.com/uumsportfacilities/php/user_register.php";
  TextEditingController _nameEditController = new TextEditingController();
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _phoneEditController = new TextEditingController();
  TextEditingController _passEditController = new TextEditingController();
  String name;
  String credit;

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              Container(decoration: BoxDecoration(image: DecorationImage(
               image:AssetImage('assets/images/login.png'), fit: BoxFit.cover
                )),
            
            
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Card(
                  elevation: 10,
                  child: Form(
                  child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text("REGISTRATION FORM",
                            
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:20,
                                ))),
                          TextFormField(
                             style: new TextStyle(color:Colors.white),
                            controller: _nameEditController,
                            keyboardType: TextInputType.text, 
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: const Color(0xF0fd0202)),
                              labelText: 'Name',
                              hintText: "Enter your name",    
                              icon: Icon(Icons.person),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.red),
                              ),
                            )),
                        TextFormField(
                           style: new TextStyle(color:Colors.white),
                            controller: _emailEditController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: const Color(0xF0fd0202)),
                              labelText: 'Email',
                              hintText: "Enter your email",  
                              icon: Icon(Icons.email),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.red),
                              ),
                            )),
                        TextFormField(
                           style: new TextStyle(color:Colors.white),
                            controller: _phoneEditController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: const Color(0xF0fd0202)),
                              labelText: 'phone',
                              hintText: "Enter your phone number",   
                              icon: Icon(Icons.phone),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.red),
                              ),
                            )),
                        TextFormField(
                           style: new TextStyle(color:Colors.white),
                          controller: _passEditController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: const Color(0xF0fd0202)),
                            labelText: 'Password',
                            hintText: "Enter your password",
                            icon: Icon(Icons.lock),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.red),
                              ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Checkbox(
                                value: _isChecked,
                                checkColor: Colors.white,
                              activeColor: Colors.red,
                                onChanged: (bool value) {
                                  _onChange(value);
                                },
                              ),
                              GestureDetector(
                                onTap: _showEULA,
                                child: Text('Agree to Terms ',
                                    style: TextStyle(
                                      fontSize: 16,color: Colors.white
                                    )),
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0)),
                                minWidth: 150,
                                height: 50,
                                child: Text('Register'),
                                color: Colors.red,
                                textColor: Colors.white,
                                elevation: 10,
                                onPressed: _onRegister,
                              
                              )
                            ]),
                      ])),)
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Registered ?  ", style: TextStyle(fontSize: 16.0,color:Colors.white)),
                    GestureDetector(
                        onTap: _loginScreen,
                        child: Text("Login",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold,color:Colors.white)))
                  ],
                )
              ],
            ),
          ),
          ]
          )
          )
          );
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _showEULA() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("EULA"),
            content: new Container(
                child: Column(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                      softWrap: true,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                        ),
                        text:
                            "This End-User License Agreement is a legal agreement between you and XiaoPanda This EULA agreement governs your  acquisition and use of our UUM Sport Facilities software (Software) directly from XiaoPanda or indirectly through a XiaoPanda authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the UUM Sport Facilities software. It provides a license to use the UUM Sport Facilities software and contains warranty information and liability disclaimers. If you register for a free trial of the UUM Sport Facilities software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the UUM Sport Facilities software, you are confirming your  acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by XiaoPanda herewith regardless of whether other software is referred to or described herein. The terms also apply to any XiaoPanda updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for UUM Sport Facilities . XiaoPanda shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of XiaoPanda. XiaoPanda reserves the right to grant licences to use the Software to third parties",
                      ),
                    ),
                  ))
            ])),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void _onRegister() {
    String name = _nameEditController.text;
    String email = _emailEditController.text;
    String phone = _phoneEditController.text;
    String password = _passEditController.text;
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    

    showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    titleTextStyle: TextStyle(color:Colors.white,fontSize: 25.0),
                    contentTextStyle: TextStyle(color:Colors.white,fontSize: 15.0),
                    title:new Text("Confirmation massage"),
                    content:new Container(
                      
                      height: 50,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Are you sure want to create account?",
                          ),
                          ],),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child:new Text ("Yes"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (!_isChecked) {
                           Toast.show("Please Accept Term", context,
                                 duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }else{
                            _createAcc(name, email, phone, password);
                      } }
                     ),
                  new FlatButton(
                    child:new Text("No"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    }
                  )
                  ]);

                }
                );
    
                }
  
   void _createAcc(String name, String email, String phone,String password){
    if((email.contains("@") & email.contains(".com")) & (_validatePhoneAndPassword(phone, password)==false)== true){
        http.post(urlRegister, body: {
        "name": name,
        "email": email,
        "phone": phone,
        //"credit": credit,
        "password": password,
        }).then((res) {
        if (res.body==( "success")) {
          Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
                Toast.show("Registration done", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
    else{
      Toast.show("Registration failed, please check your email or phone number format.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
      
  }

  
  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}

bool _validatePhoneAndPassword(String phone, String password){// to validate if phone number is in correct format.
      List<String> alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
      bool wrongInput = false;
      for(int count = 0; count < 25; count++){
        if (phone.contains(alphabet[count]) || phone.contains(alphabet[count].toUpperCase()) ){
          wrongInput = true;
        }
      }
      return wrongInput;
      }
      
      
  





  
 


  




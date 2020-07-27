import 'package:flutter/services.dart';
import 'package:sport_facility/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:sport_facility/registrationscreen.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sport_facility/user.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  String urlLogin = "https://lilbearandlilpanda.com/uumsportfacilities/php/user_login.php";

  @override 
  void initState(){
    super.initState();
    print("Hello i'm in INITSTATE");
    loadPref();

  }
  
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body:Stack(
              children:<Widget>[
         Container(decoration: BoxDecoration(image: DecorationImage(
               image:AssetImage('assets/images/login.png'), fit: BoxFit.cover
                )),),

            Align(
              child:Container(
                child:Column(children: <Widget>[
                  SizedBox(
                height: 270,
              ),
              Card(
                elevation:10,
                  child: Container(
                      height: 260,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text("LOGIN",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w900
                              )),
                        ),
                        TextField(
                            controller: _emailController,
                            style: new TextStyle(color:Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(   
                              labelStyle: TextStyle( color: const Color(0xF0fd0202),fontSize: 18.0),
                              labelText: 'Email',
                               icon: Icon(Icons.email),
                               
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.red),
                              ),
                              
                            )),
                        TextField(
                          controller: _passController,
                          style: new TextStyle(color:Colors.white),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: const Color(0xF0fd0202),fontSize: 18.0),  
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                            
                             enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Colors.red),
                              ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Checkbox(
                              value: rememberMe,
                              checkColor: Colors.white,
                              activeColor: Colors.red,
                              onChanged: (bool value) {
                                _onRememberMeChanged(value);
                              },
                            ),
                            Text('Remember Me',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(width: 50,),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text('Login'),
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: _userlogin,
                            ),
                  ],
                 )
                ]
              )
              )),
               Container(
                child: Column(
                  children:<Widget>[
                    SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account? ", style: TextStyle(fontSize: 16.0,color:Colors.white),),
              GestureDetector(
                onTap: _registerUser,
                child: Text(
                  "Create Account",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forgot your password? ", style: TextStyle(fontSize: 16.0, color: Colors.white)),
              GestureDetector(
                onTap: _forgotPassword,
                child: Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ],
          )
         ]
       )
       ),

                ]
                )
    
              )
            ),
        ])
              ),
    );
      }
                                                             
                                                             
void _onRememberMeChanged(bool newValue) => setState(() {
  rememberMe = newValue;
  print(rememberMe);
  if(rememberMe){
    savepref(true);
  }else{
    savepref(false);
      }
    });

    Future<bool> _onBackPressed(){
      return showDialog(
        context: context,
        builder:(context)=>new AlertDialog(
          
          title:new Text('Confrim?'),
          content: new Text('Exit an App?'),
          titleTextStyle: TextStyle(
            color:Colors.white,fontSize: 25.0),
            contentTextStyle: TextStyle(color:Colors.white),
          actions: <Widget>[
            MaterialButton(
              onPressed: (){
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            
            child:Text("Exit")),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
            },
            child: Text("Cancel")),
            ],
          ),
        )??
        false;
    }
                                                          
    void _registerUser() {
      Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) =>RegistrationScreen()));

    }
                           
            void _forgotPassword() {
              TextEditingController phoneController = TextEditingController();
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title:new Text("Forget Password?"),
                    titleTextStyle: TextStyle(
                      color:Colors.white,fontSize: 25.0),
                      contentTextStyle: TextStyle(color:Colors.white),
                    content:new Container(
                      height: 100,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Key in your recovery email",
                          ),
                          TextField(
                             style: new TextStyle(color:Colors.white),
                            decoration:InputDecoration(    
                              labelText:'Email',
                              icon:Icon(Icons.email), 
                            )
                      )],),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child:new Text ("Yes"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            print(
                              phoneController.text,
                            );
                          }
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
            
     void _userlogin() async{
       ProgressDialog pr = new ProgressDialog(context,
       type:ProgressDialogType.Normal, isDismissible:false);
       pr.style(message: "Log in...");
       pr.show();
        String _email =_emailController.text;
         String _password = _passController.text;

         http.post(urlLogin,body:{
           "email": _email,
           "password": _password,
         }).then((res){
           var string = res.body;
           print(res.body);
           List userdata = string.split(",");
           if (userdata[0] == "success"){
             User _user = new User(
               name:userdata[1],
               email: _email,
               phone: userdata[3],
               credit: userdata[4],
               datereg: userdata[5],
               hours:userdata[6],
               password: _password,
               );
               
               pr.dismiss();
    
            Navigator.push(
             context,
             MaterialPageRoute(
               builder:(BuildContext context)=> MainScreen(
                 user: _user,
 
             )));
             Toast.show("Login Done",context,
             duration:Toast.LENGTH_LONG,gravity:Toast.BOTTOM);
           }else{
             pr.dismiss();
             Toast.show("Login failed", context,
             duration: Toast.LENGTH_LONG,gravity:Toast.BOTTOM);
           }
         }).catchError((err){
           print(err);
           pr.dismiss();

         });
         }
     void loadPref()async{
       SharedPreferences prefs = await SharedPreferences.getInstance();
       String email =(prefs.getString('email'))??'';
       String password = (prefs.getString('pass'))??'';
       if(email.length>1){
         setState((){
           _emailController.text =email;
           _passController.text = password;
           rememberMe = true;
         });
       }
     }


      void savepref(bool value) async {
        String email =_emailController.text;
        String password = _passController.text;
        SharedPreferences prefs= await SharedPreferences.getInstance();
        if(value){
          await prefs.setString('email',email);
          await prefs.setString('pass',password);
          Toast.show("Preferences have been saved",context,
           duration: Toast.LENGTH_SHORT, gravity:Toast.BOTTOM);
        }else{
          await prefs.setString('email','');
          await prefs.setString('pass','');
          setState((){
            _emailController.text = '';
            _passController.text = '';
            rememberMe = false;

          });
          Toast.show("Preferences have removed",context,
          duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
        }

        }
      }
    
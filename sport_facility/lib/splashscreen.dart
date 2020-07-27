
import 'package:flutter/material.dart';
//import 'package:sport_facility/loginscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sport_facility/mainscreen.dart';
import 'user.dart';
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.loraTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      title: 'Material App',
      home: Scaffold(
        body: Container(
          child:Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage('assets/images/splash.png'),
                    fit:BoxFit.contain) 
                )
                ),
                Container(height: 660, child:ProgressIndicator(),
                )],
                ),

        ),

      ),
    );
  }
}
class ProgressIndicator extends StatefulWidget{
@override 
_ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> 
with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> animation;

  @override 
  void initState(){
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this);
      animation = Tween(begin:0.0,end:1.0).animate(controller)
      ..addListener((){
        setState(() {
          if (animation.value>0.99){
            controller.stop();
            loadpref(this.context);

           // Navigator.push( 
            //  context,
            //  MaterialPageRoute(
             //   builder: (BuildContext context) => LoginScreen()));
            
          }
          
        });
      });
        controller.repeat();
  }
  @override 
  void dispose(){
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Align(
      alignment: Alignment(0,0.6),
      child: new Container(
        child: CircularProgressIndicator(
          value:animation.value,
          valueColor:new AlwaysStoppedAnimation<Color>(Colors.redAccent),
        ),
        )
    );
  }

  void loadpref(BuildContext ctx) async {
    print('Inside loadpref()');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? '');
    String pass = (prefs.getString('pass') ?? '');
    print("Splash:Preference" + email + "/" + pass);
    if (email.length > 5) {
      //login with email and password
      loginUser(email, pass, ctx);
    } else {
      loginUser("unregistered","123456",ctx);
    }

  }

  void loginUser(String email, String pass, BuildContext ctx) {
    http.post("https://lilbearandlilpanda.com/uumsportfacilities/php/user_login.php", body:{
      "email": email,
      "password": pass,
    }).then((res){
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
         User _user = new User(
               name:userdata[1],
               email: email,
               phone: userdata[3],
               credit: userdata[4],
               datereg: userdata[5],
               hours:userdata[6],
               password: pass,
               );
               Navigator.push(
                 context, 
                 MaterialPageRoute(
                   builder: (BuildContext context) => MainScreen(
                     user: _user,
                   )));
      }else{
        Toast.show("Fail to login with stored credential. Login as unregistered account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loginUser("unregistered@sportfacility.com","123456",ctx);
      }
    }).catchError((err){
      print(err);

    });
  }

}

import 'package:ewaa_application/screens/forget_passward.dart';
import 'package:ewaa_application/screens/home.dart';
import 'package:ewaa_application/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../style.dart';
import '../widgets/button.dart';
import '../widgets/textFields.dart';

class Login extends StatefulWidget {
  static const String screenRoute = "login_page";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  // we need to hash passward
  TextEditingController _passward = TextEditingController();
  TextEditingController _repeatePassward = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isloading = false;

  // to avoid memory problem we used disopse
  void dispose() {
    _username.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _passward.dispose();
    _repeatePassward.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formState = new GlobalKey<FormState>();
    translateErrorMassage(errorMassage) {
      var errorAfterTranslate = "";
      switch (errorMassage) {
        case "[firebase_auth/wrong-password]":
          errorAfterTranslate = "كلمة المرور خاطئة";

          break;
        case "[firebase_auth/user-not-found]":
          errorAfterTranslate = " البريد الالكتروني غير موجود";

          break;

        default:
          errorAfterTranslate = "غير معروف";
      }
      return errorAfterTranslate;
    }

    void _showErrorDialog(error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('error'),
            content: Text(error),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Color.fromRGBO(116, 98, 133, 1), fontSize: 15),
                ),
              ),
            ],
          );
        },
      );
    }

    vaildateFields() async {
      var formatData = formState.currentState;
      var isVailda = formatData!.validate();
      if (isVailda) {
        setState(() {
          _isloading = true;
        });
        try {
          print("vaild");
          await _auth.signInWithEmailAndPassword(
              email: _email.text.trim(), password: _passward.text.trim());
          Navigator.pushNamed(context, HomePage.screenRoute);
        } catch (error) {
          setState(() {
            _isloading = false;
          });
          var firstIndexOfErrorMss = error.toString().indexOf('[');
          var lastIndexOfErrorMss = error.toString().indexOf(']');

          var errorCode = error
              .toString()
              .substring(firstIndexOfErrorMss, lastIndexOfErrorMss + 1);
          print(errorCode);
          var errorAfterTranslate = translateErrorMassage(errorCode);
          _showErrorDialog(errorAfterTranslate);
        }
      } else {
        _showErrorDialog("قم بتعبئة جميع الحقول");
      }
      setState(() {
        _isloading = false;
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
                height: 130,
                child: Image.asset("images/logo.png"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Center(
                  child: Text(
                    "إيواء",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: formState,
                  child: Column(
                    children: [
                      TextFields(
                        "البريد الالكتروني",
                        Icons.email,
                        TextInputType.emailAddress,
                        _email,
                        (email) {
                          bool isvalid = EmailValidator.validate(email!);
                          print(isvalid);
                          if (email.isEmpty) {
                            return "الرجاء ادخال البريد الالكتروني";
                          } else if (!isvalid) {
                            return "الايميل غير صحيح";
                          }
                          return null;
                        },
                        null,
                        false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFields(
                        "كلمه المرور",
                        Icons.key,
                        TextInputType.visiblePassword,
                        _passward,
                        (passward) {
                          if (passward.isEmpty) {
                            return "الرجاد ادخال كلمه المرور";
                          }
                          return null;
                        },
                        Icons.remove_red_eye,
                        true,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, ForgfetPassward.screenRoute);
                          },
                          child: Text(
                            "نسيت كلمة المرور",
                            style: TextStyle(
                                color: Style.purpole,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'ElMessiri',
                                decoration: TextDecoration.underline,
                                decorationColor: Style.purpole),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _isloading
                  ? Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 155, 140, 181)),
                            backgroundColor: Style.purpole,
                          )),
                    )
                  : MyButton(
                      color: Style.buttonColor_pink,
                      title: "تسجيل الدخول",
                      onPeressed: vaildateFields,
                      minwidth: 180,
                      circular: 100,
                    ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, HomePage.screenRoute);
                      },
                      child: Text("تخطي",
                          style: TextStyle(
                            color: Style.buttonColor_pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'ElMessiri',
                          )),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Register.screenRoute);
                    },
                    child: Text(
                      "ليس لديك حساب؟",
                      style: TextStyle(
                        color: Style.buttonColor_pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'ElMessiri',
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

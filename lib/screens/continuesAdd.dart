import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewaa_application/catPersonailty.dart';
import 'package:ewaa_application/dogPersonailty.dart';
import 'package:ewaa_application/screens/home.dart';
import 'package:ewaa_application/screens/profile.dart';
import 'package:ewaa_application/screens/register.dart';
import 'package:ewaa_application/widgets/listView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../style.dart';
import '../widgets/button.dart';
import '../widgets/fieldAdd.dart';

class ContinuesAdd extends StatefulWidget {
  static const String screenRoute = "continuesAdd_page";

  @override
  State<ContinuesAdd> createState() => _ContinuesAddState();
}

class _ContinuesAddState extends State<ContinuesAdd> {
  var _incolustion;
  var _Neutering;
  var healthPassport;
  var _healthProfile;
  TextEditingController _reasonsOfAdoption = TextEditingController();
  TextEditingController _supplies = TextEditingController();
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  TextEditingController _nameOfHospital = TextEditingController();
  bool? _checkbox = false;
  var _petSelectedList = [];

  bool selected = false;
  final _auth = FirebaseAuth.instance;
  late User siginUser;
  String? url;
  int numberOfAdd = 0;
  bool _isloading = false;
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

  Widget buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.only(left: 26, right: 26),
      alignment: Alignment.topRight,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Style.black,
          fontSize: 24,
          fontFamily: 'ElMessiri',
        ),
      ),
    );
  }

  textWidget(lable) {
    return Text(
      lable,
      style: TextStyle(
          color: Style.purpole, fontFamily: 'ElMessiri', fontSize: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgument =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    var petImage = routeArgument["image"];
    var Petname = routeArgument["name"];
    var gender = routeArgument["gender"];
    String type = routeArgument['type'];
    String breed = routeArgument['breed'];
    String color = routeArgument['color'];
    String age = routeArgument['age'];
    var numberOfSelected = 0;

    add() async {
      try {
        if (_auth != null && numberOfAdd < 1) {
          siginUser = _auth.currentUser!;
          setState(() {
            _isloading = true;
          });
          final uId = siginUser.uid;
          final petID = Uuid().v4();
          print(uId);
          final imagePet = FirebaseStorage.instance
              .ref()
              .child("petsImage")
              .child(petID + "jpg");

          await imagePet.putFile(petImage);
          imagePet.getDownloadURL().then((value) {
            print(value);
          });
          url = await imagePet.getDownloadURL();

          await FirebaseFirestore.instance.collection("pets").doc(petID).set({
            "petId": petID,
            "petName": Petname,
            "gender": gender,
            "category": type,
            "breed": breed,
            "color": color,
            "age": age,
            "ownerId": uId,
            "isAdopted": false,
            "addedAt": Timestamp.now(),
            "incolustion": _incolustion,
            "Neutering": _Neutering,
            "healthPassport": healthPassport,
            "healthProfile": _healthProfile,
            "nameOfHospital": _nameOfHospital.text,
            "reasonsOfAdoption": _reasonsOfAdoption.text,
            "supplies": _supplies.text,
            "personalites": _petSelectedList,
            "image": url,
          });
          numberOfAdd = 1;

          Fluttertoast.showToast(
              msg: "?????? ?????????????? ??????????",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Style.textFieldsColor_lightpink,
              textColor: Style.purpole,
              fontSize: 16.0);
          Navigator.pushNamed(context, HomePage.screenRoute);
        }
      } catch (error) {
        print(error.toString());
        print("error to add");
        print(_Neutering);
        setState(() {
          _isloading = false;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent, //transparent
            elevation: 0.0,
            iconTheme: IconThemeData(color: Style.black, size: 28),
            toolbarHeight: 75,
            title: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.only(left: 20),
                  icon: Icon(
                    Icons.person_sharp,
                    size: 30,
                  ),
                  onPressed: () {
                    if (_auth.currentUser == null) {
                      Navigator.pushNamed(context, Register.screenRoute);
                    } else {
                      Navigator.pushNamed(context, ProfilePage.screenRoute);
                    }
                  },
                ),
                SizedBox(
                  width: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/logo.png",
                      height: 35,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "??????????",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_forward_sharp,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ]),
        drawer: listView(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true, // use it
                scrollDirection: Axis.vertical,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  buildSectionTitle(context, "?????????????? ????????"),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 26, right: 26),
                    child: Row(
                      children: [
                        Text(
                          "???? ???? ????????",
                          style: TextStyle(
                            color: Style.black,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          width: 45,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "????",
                              groupValue: _incolustion,
                              title: Text("????"),
                              onChanged: (value) {
                                setState(() {
                                  _incolustion = value;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "??????",
                              groupValue: _incolustion,
                              title: Text("??????"),
                              onChanged: (value) {
                                setState(() {
                                  _incolustion = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 26, right: 26),
                    child: Row(
                      children: [
                        Text(
                          "??????????????:",
                          style: TextStyle(
                            color: Style.black,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          width: 76,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "????",
                              groupValue: _Neutering,
                              title: Text("????"),
                              onChanged: (value) {
                                setState(() {
                                  _Neutering = value;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "??????",
                              groupValue: _Neutering,
                              title: Text("??????"),
                              onChanged: (value) {
                                setState(() {
                                  _Neutering = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 26, right: 26),
                    child: Row(
                      children: [
                        Text(
                          "???? ???? ???????? ??????:",
                          style: TextStyle(
                            color: Style.black,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "????",
                              groupValue: healthPassport,
                              title: Text("????"),
                              onChanged: (value) {
                                setState(() {
                                  healthPassport = value;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "??????",
                              groupValue: healthPassport,
                              title: Text("??????"),
                              onChanged: (value) {
                                setState(() {
                                  healthPassport = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 26, right: 26),
                    child: Row(
                      children: [
                        Text(
                          "???? ???? ?????? ??????",
                          style: TextStyle(
                            color: Style.black,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "????",
                              groupValue: _healthProfile,
                              title: Text("????"),
                              onChanged: (value) {
                                setState(() {
                                  _healthProfile = value;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RadioListTile(
                              activeColor: Style.purpole,
                              contentPadding: EdgeInsets.all(0),
                              tileColor: Colors.purple.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              value: "??????",
                              groupValue: _healthProfile,
                              title: Text("??????"),
                              onChanged: (value) {
                                setState(() {
                                  _healthProfile = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: formState,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        _healthProfile == "??????"
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                child: FileldsAdd(
                                    "?????? ??????????????",
                                    _nameOfHospital,
                                    TextInputType.text, (value) {
                                  if (value.isEmpty) {
                                    return "???????????? ?????????? ?????? ??????????????";
                                  }
                                  if (!RegExp(
                                          r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_ ]+$')
                                      .hasMatch(value)) {
                                    return "???????????? ?????????? ?????? ?????? ?????????? ?????? ????????";
                                  }
                                  return null;
                                }, 1, 15),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        buildSectionTitle(context, "??????????"),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget("?????? ?????????? ????????????/??????????????????"),
                              SizedBox(
                                height: 10,
                              ),
                              FileldsAdd("?????? ?????? ????????????", _reasonsOfAdoption,
                                  TextInputType.text, (value) {
                                return null;
                              }, 5, 100),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildSectionTitle(
                          context,
                          "???????????????????? /????????????????????",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget("???????????????????? ?? ????????????????????/?????? ??????????????"),
                              SizedBox(
                                height: 10,
                              ),
                              FileldsAdd("???????? ???????????????? ???????????? ????????????",
                                  _supplies, TextInputType.text, (value) {
                                return null;
                              }, 5, 50),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildSectionTitle(
                          context,
                          "??????????????",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            runSpacing: 8,
                            direction: Axis.horizontal,
                            children: type == "????"
                                ? CatPersonailty.Personailty.map((chip) =>
                                    FilterChip(
                                      pressElevation: 17,
                                      selected:
                                          _petSelectedList.contains(chip.label),
                                      onSelected: (value) {
                                        setState(() {
                                          if (value) {
                                            _petSelectedList.add(chip.label);
                                          } else {
                                            _petSelectedList.removeWhere(
                                                (label) => label == chip.label);
                                          }
                                        });
                                      },
                                      selectedColor: Style.buttonColor_pink,
                                      labelPadding: EdgeInsets.all(4),
                                      label: Text(chip.label.toString()),
                                      backgroundColor:
                                          Style.textFieldsColor_lightpink,
                                    )).toList()
                                : DogPersonailty.Personailty.map((chip) =>
                                    FilterChip(
                                      pressElevation: 17,
                                      selected:
                                          _petSelectedList.contains(chip.label),
                                      onSelected: (value) {
                                        setState(() {
                                          if (value) {
                                            _petSelectedList.add(chip.label);
                                          } else {
                                            _petSelectedList.removeWhere(
                                                (label) => label == chip.label);
                                          }
                                        });
                                      },
                                      selectedColor: Style.buttonColor_pink,
                                      labelPadding: EdgeInsets.all(4),
                                      label: Text(chip.label.toString()),
                                      backgroundColor:
                                          Style.textFieldsColor_lightpink,
                                    )).toList()),
                        SizedBox(
                          height: 30,
                        ),
                        _isloading
                            ? Center(
                                child: Container(
                                    width: 40,
                                    height: 50,
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 155, 140, 181)),
                                      backgroundColor: Style.purpole,
                                    )),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                child: MyButton(
                                  color: Style.buttonColor_pink,
                                  title: "??????????",
                                  onPeressed: () {
                                    bool isComplete = true;
                                    if (formState.currentState!.validate()) {
                                      if (_healthProfile == null ||
                                          healthPassport == null ||
                                          _incolustion == null ||
                                          _Neutering == null) {
                                        isComplete = false;
                                        _showErrorDialog(
                                            "???? ???????????? ???????? ?????????????????? ????????????");
                                      }

                                      if (_petSelectedList.isEmpty) {
                                        isComplete = false;
                                        _showErrorDialog(
                                            "????  ???????????? ?????????????? ?????????? ?????????????? ????????????");
                                      }
                                      if (isComplete) {
                                        add();
                                      }
                                    } else {
                                      _showErrorDialog(
                                          "???? ???????????? ???????? ?????????????? ?????????????????? ");
                                    }
                                  },
                                  minwidth: 500,
                                  circular: 0,
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

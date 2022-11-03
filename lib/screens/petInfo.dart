import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewaa_application/screens/editPetInfo.dart';
import 'package:ewaa_application/screens/home.dart';
import 'package:ewaa_application/screens/profile.dart';
import 'package:ewaa_application/screens/register.dart';
import 'package:ewaa_application/widgets/button.dart';
import 'package:ewaa_application/widgets/listView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class PetInfo extends StatefulWidget {
  //static const String screenRoute = "petInfo_page";
  final String petId;
  final String owner;

  PetInfo({required this.petId, required this.owner});
  @override
  State<PetInfo> createState() => _PetInfoState();
}

class _PetInfoState extends State<PetInfo> with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  late final IssameUser;
  var userName = "";
  late User siginUser;
  late ScrollController sc;

  late TabController _tabController;
  var needing =
      " وغير مشروط. إنه يحبني بقدر ما أحبه أو في بعض الأحيان أكثر ما أحبه أو في بعض الأحيان أكثر.كلبي مخلص لي بشكل لا يصدق ";

  late List<dynamic> petPersonailty;
  // pet data
  late var petName;
  late var petGender;
  late var petCategory;
  late var petBreed;
  late var petColor;
  late var petAge;
  late var addedAt;
  late var incolustion;
  late var Neutering;
  late var healthPassport;
  late var healthProfile;
  late var nameOfHospital;
  late var reasonsOfAdoption;
  late var supplies;
  late var personalites = [];
  late var image;
  bool _isloading = false;
  void initState() {
    super.initState();
    getData();

    petPersonailty = ["مرح", "لطيف", "ودود مع الاطفال", "هادئ"];
  }

  void getData() async {
    try {
      final _user = _auth.currentUser;
      if (_user != null) {
        siginUser = _user;
        var ownerId = widget.owner;
        if (ownerId == siginUser.uid) {
          setState(() {
            IssameUser = true;
          });
        } else {
          setState(() {
            IssameUser = false;
          });
        }
      } else {
        setState(() {
          IssameUser = false;
        });
      }
      final DocumentSnapshot petInfo = await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.petId)
          .get();

      setState(() {
        petName = petInfo.get("petName");
        petGender = petInfo.get("gender");
        petCategory = petInfo.get("category");
        personalites = petInfo.get("personalites");
        petAge = petInfo.get('age');
        petBreed = petInfo.get("breed");
        Timestamp uplodedAt = petInfo.get("addedAt");
        var uplodedAtDate = uplodedAt.toDate();
        addedAt =
            '${uplodedAtDate.year}-${uplodedAtDate.month}-${uplodedAtDate.day}';
        petColor = petInfo.get("color");
        incolustion = petInfo.get("incolustion"); //التطعيم
        Neutering = petInfo.get("Neutering"); // التعقيم
        healthProfile = petInfo.get("healthProfile");
        healthPassport = petInfo.get("healthPassport");
        nameOfHospital = petInfo.get("nameOfHospital");
        reasonsOfAdoption = petInfo.get("reasonsOfAdoption");
        supplies = petInfo.get("supplies");
        image = petInfo.get("image");
        _isloading = true;
      });
    } catch (error) {
      setState(() {
        _isloading = false;
      });
    }
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.only(left: 26, right: 26),
      alignment: Alignment.topRight,
      child: Text(
        title,
        style: TextStyle(
          color: Style.black,
          fontSize: 20,
          fontFamily: 'ElMessiri',
        ),
      ),
    );
  }

  Widget infoPet(String title, String info) {
    return Container(
      padding: EdgeInsets.all(4),
      width: 110,
      height: 78,
      decoration: BoxDecoration(
        color: Style.textFieldsColor_lightpink,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.261258602142334),
          topRight: Radius.circular(4.261258602142334),
          bottomLeft: Radius.circular(4.261258602142334),
          bottomRight: Radius.circular(4.261258602142334),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Style.black,
                fontSize: 15,
                fontFamily: 'ElMessiri',
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              info,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Style.purpole,
                fontSize: 15,
                fontFamily: 'ElMessiri',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 4, vsync: this);
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
                      "إيواء",
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
        body: SingleChildScrollView(
          child: !_isloading
              ? Center(
                  child: Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(
                        top: 280,
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 155, 140, 181)),
                        backgroundColor: Style.purpole,
                      )),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Container(
                        width: double.infinity,
                        height: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                image == "" ? "" : image,
                              ),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.695652961730957),
                            topRight: Radius.circular(8.695652961730957),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 30),
                                child: Text(
                                  petName == "" ? petCategory : petName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Style.black,
                                    fontFamily: 'ElMessiri',
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 30),
                                child: Text(
                                  addedAt == null ? "" : addedAt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Style.black,
                                    fontFamily: 'ElMessiri',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.share_outlined,
                                color: Style.buttonColor_pink,
                                size: 30,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.favorite_border,
                                color: Style.buttonColor_pink,
                                size: 30,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(4.348630905151367),
                            bottomRight: Radius.circular(4.348630905151367),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.15000000596046448),
                                offset: Offset(0, 3.4789044857025146),
                                blurRadius: 8.697261810302734)
                          ],
                          color: Style.gray,
                        ),
                        child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            indicatorColor: Style.buttonColor_pink,
                            tabs: [
                              Tab(
                                child: Text(
                                  "معلومات عامة",
                                  style: TextStyle(
                                    color: Style.purpole,
                                    fontFamily: 'ElMessiri',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "معلومات صحية",
                                  style: TextStyle(
                                    color: Style.purpole,
                                    fontFamily: 'ElMessiri',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "اسباب العرض للتبني/الشخصيه ",
                                  style: TextStyle(
                                    color: Style.purpole,
                                    fontFamily: 'ElMessiri',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "المستلزمات",
                                  style: TextStyle(
                                    color: Style.purpole,
                                    fontFamily: 'ElMessiri',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 300, //300
                        decoration: BoxDecoration(),
                        child:
                            TabBarView(controller: _tabController, children: [
                          Container(
                            width: double.maxFinite,
                            // height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                buildSectionTitle(context, " معلومات عامة"),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    infoPet("الجنس",
                                        petGender == "" ? "" : petGender),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    infoPet(
                                        "العمر", petAge == "" ? "" : petAge),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    infoPet("النوع",
                                        petCategory == "" ? "" : petCategory),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    infoPet("الفصيله",
                                        petBreed == "" ? "" : petBreed),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    infoPet("اللون",
                                        petColor == "" ? "" : petColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              buildSectionTitle(context, "معلومات صحية"),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      infoPet("هل تم التطعيم",
                                          incolustion == "" ? "" : incolustion),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      infoPet(
                                          " هل له ملف صحي",
                                          healthProfile == ""
                                              ? " "
                                              : healthProfile),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      infoPet(
                                          " هل له جواز صحي",
                                          healthPassport == ""
                                              ? " "
                                              : healthPassport),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      infoPet(
                                          "اسم العياده",
                                          nameOfHospital == ""
                                              ? " ليس لديه جواز صحي"
                                              : nameOfHospital),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      infoPet(
                                          "التعقيم",
                                          incolustion == ""
                                              ? " "
                                              : incolustion),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            child: Container(
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildSectionTitle(
                                      context, "اسباب العرض للتبني"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: 30, left: 12),
                                    child: Text(
                                      reasonsOfAdoption == ""
                                          ? "لم يتم  ذكر الاسباب"
                                          : reasonsOfAdoption,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'ElMessiri',
                                          color: Style.purpole),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildSectionTitle(context, "الشخصية"),
                                  Wrap(
                                    spacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    verticalDirection: VerticalDirection.down,
                                    runSpacing: 8,
                                    direction: Axis.horizontal,
                                    children: personalites
                                        .map((petPer) => Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Style
                                                      .textFieldsColor_lightpink,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Style
                                                          .textFieldsColor_lightpink)),
                                              child: Text(
                                                petPer,
                                                style: TextStyle(
                                                    fontFamily: 'ElMessiri',
                                                    color: Style.purpole),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            width: double.maxFinite,
                            child: Column(children: [
                              SizedBox(
                                height: 20,
                              ),
                              buildSectionTitle(
                                  context, "المستلزمات/الاحتياجات"),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 30, left: 12),
                                  child: Text(
                                      supplies == ""
                                          ? "لم يتم ذكر المستلزمات او الاحتياجات"
                                          : supplies,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'ElMessiri',
                                          color: Style.purpole))),
                            ]),
                          ),
                        ]),
                      ),
                      MyButton(
                        color: Style.buttonColor_pink,
                        title:
                            IssameUser ? "تعديل المعلومات" : "ارسال طلب التبني",
                        onPeressed: () {
                          try {
                            if (IssameUser) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPetInfo(
                                    petId: widget.petId,
                                    owner: widget.owner,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {}
                        },
                        minwidth: 350,
                        circular: 0,
                      ),
                    ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(238, 252, 249, 249),
          currentIndex: 0,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromARGB(189, 116, 115, 115),
          unselectedItemColor: Color.fromARGB(189, 116, 115, 115),
          unselectedLabelStyle: TextStyle(fontFamily: "ElMessiri"),
          selectedLabelStyle: TextStyle(fontFamily: "ElMessiri"),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "البحث",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "المفضلة",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: "الإشعارات",
            ),
          ],
          onTap: (value) {
            if (0 == value) {
              Navigator.pushReplacementNamed(context, HomePage.screenRoute);
            } else if (1 == value) {
              //   Navigator.pushReplacementNamed(context, .screenRoute);
            } else if (2 == value) {
              //Navigator.pushReplacementNamed(context, .screenRoute);
            } else if (3 == value) {
              // Navigator.pushReplacementNamed(context, .screenRoute);
            }
          },
        ),
      ),
    );
  }
}

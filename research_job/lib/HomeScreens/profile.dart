import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:research_job/Screens/login.dart';
import 'package:research_job/Widgets/button_nav_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Profile extends StatefulWidget {
  final String userID;

  const Profile({required this.userID, Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phone = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userID)
          .get();

      if (!userDoc.exists) {
        return;
      }

      setState(() {
        name = userDoc['name'] ?? '';
        email = userDoc['email'] ?? '';
        phone = userDoc['phone'] ?? '';
        imageUrl = userDoc['profileImage'] ?? '';
        Timestamp joinedAtTimeStamp = userDoc['createdAt'];
        var joinedDate = joinedAtTimeStamp.toDate();
        joinedAt = "${joinedDate.year}-${joinedDate.month}-${joinedDate.day}";
      });

      User? user = _auth.currentUser;
      final _uid = user?.uid;
      setState(() {
        _isSameUser = _uid == widget.userID;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              fct();
            },
          )),
    );
  }

  void _openWhatsAppChat() async {
    var url = "https://wa.me/$phone?text=HelloWorld";
    launchUrlString(url);
  }

  void _mainTo() async {
    final Uri params = Uri(
      scheme: "mailto",
      path: email,
      query:
          "subject=Write subject here,Please&body=Hello, please write details here",
    );
    final url = params.toString();
    launchUrlString(url);
  }

  void _callPhoneNumber() async {
    var url = "tel://$phone";
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.cyan.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: ButtonNavBar(indexNum: 3),
        backgroundColor: Colors.transparent,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Stack(
                    children: [
                      Card(
                        color: Colors.white10,
                        margin: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name ?? "Name here",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 30),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Account Information:",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 22),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: userInfo(
                                  icon: Icons.email,
                                  content: email.isEmpty ? "N/A" : email,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: userInfo(
                                  icon: Icons.phone,
                                  content: phone.isEmpty ? "N/A" : phone,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: userInfo(
                                  icon: Icons.calendar_today,
                                  content: "Joined: $joinedAt",
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              _isSameUser
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _contactBy(
                                            color: Colors.green,
                                            fct: () {
                                              _openWhatsAppChat();
                                            },
                                            icon: FontAwesome.whatsapp),
                                        _contactBy(
                                            color: Colors.red,
                                            fct: () {
                                              _mainTo();
                                            },
                                            icon: Icons.mail_outline),
                                        _contactBy(
                                            color: Colors.purple,
                                            fct: () {
                                              _callPhoneNumber();
                                            },
                                            icon: Icons.call),
                                      ],
                                    ),
                              !_isSameUser
                                  ? Container()
                                  : Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 30),
                                        child: MaterialButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                    'Confirm Logout'),
                                                content: const Text(
                                                    'Are you sure you want to log out?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                      _auth.signOut();
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginScreen()),
                                                      );
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          color: Colors.black,
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Icon(
                                                  Icons.logout,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.26,
                            height: size.width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 8,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  imageUrl.isEmpty
                                      ? 'https://static.vecteezy.com/system/resources/previews/001/921/774/non_2x/beautiful-woman-red-hair-in-frame-circular-avatar-character-free-vector.jpg'
                                      : imageUrl,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

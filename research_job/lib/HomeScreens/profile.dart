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
        name = userDoc['name'] ?? 'Guest User';
        email = userDoc['email'] ?? 'N/A';
        phone = userDoc['phone'] ?? 'N/A';
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
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactBy({
    required Color color,
    required Function fct,
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
                onPressed: () {
                  fct();
                },
              )),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          
        ),
        
      ],
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
            Colors.deepPurple.shade700,
            Colors.blue.shade400,
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
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
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Divider(
                                thickness: 1,
                                color: Colors.white24,
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                "Account Information:",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 15),
                              userInfo(
                                icon: Icons.email,
                                content: email.isEmpty ? "N/A" : email,
                              ),
                              userInfo(
                                icon: Icons.phone,
                                content: phone.isEmpty ? "N/A" : phone,
                              ),
                              userInfo(
                                icon: Icons.calendar_today,
                                content: "Joined: $joinedAt",
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.white24,
                              ),
                              const SizedBox(height: 35),
                              _isSameUser
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _contactBy(
                                          color: Colors.green,
                                          fct: _openWhatsAppChat,
                                          icon: FontAwesome.whatsapp,
                                          label: "WhatsApp",
                                        ),
                                        _contactBy(
                                          color: Colors.red,
                                          fct: _mainTo,
                                          icon: Icons.mail_outline,
                                          label: "Email",
                                        ),
                                        _contactBy(
                                          color: Colors.purple,
                                          fct: _callPhoneNumber,
                                          icon: Icons.call,
                                          label: "Call",
                                        ),
                                      ],
                                    ),
                              if (_isSameUser)
                                Center(
                                  child: MaterialButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Confirm Logout'),
                                          content: const Text(
                                              'Are you sure you want to log out?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(),
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
                                                        LoginScreen(),
                                                  ),
                                                );
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    color: Colors.black,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.logout,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  imageUrl.isEmpty
                                      ? 'https://i.ibb.co/2kRcpMx/avatar.png'
                                      : imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

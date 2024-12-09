import 'package:flutter/material.dart';
import 'package:research_job/HomeScreens/profile.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure to import url_launcher correctly

class AllCompanyWidget extends StatefulWidget {
  final String createdAt;
  final String name;
  final String email;
  final String phone;
  final String profileImage;

  AllCompanyWidget({
    required this.createdAt,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
  });

  @override
  State<AllCompanyWidget> createState() => _AllCompanyWidgetState();
}

class _AllCompanyWidgetState extends State<AllCompanyWidget> {

  // Function to handle email launching
  void _mainTo() async {
    var mailUrl = "mailto:${widget.email}";  // Construct mailto URL
    print("Trying to launch mailto URL: $mailUrl");  // Debug print for the mailto URL
    
    // Check if the mail URL can be launched
    if (await canLaunch(mailUrl)) {
      print("Launching email client...");  // Debug print if the URL can be launched
      await launch(mailUrl);  // Launch the mail app
    } else {
      print("Could not launch email client.");  // Debug print if the URL cannot be launched
      throw "Error Occurred: Cannot launch mail client.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(userID: widget.createdAt)),
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
              widget.profileImage.isEmpty
                  ? 'https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-PNG-Photos.png'
                  : widget.profileImage,
            ),
          ),
        ),
        title: Text(
          widget.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Visit Profile",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _mainTo();  // Call the method to launch the email client
          },
          icon: Icon(
            Icons.mail_outline,
            size: 30,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

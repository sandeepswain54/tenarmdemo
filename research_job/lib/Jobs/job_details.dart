import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:research_job/Screens/home_screen.dart';
import 'package:research_job/Services/global_methods.dart';
import 'package:research_job/Widgets/comments_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetails extends StatefulWidget {
  final String uploadedBy;
  final String jobID;

  const JobDetails({
    required this.uploadedBy,
    required this.jobID,
  });

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isCommenting = false;
  String? jobTitle;
  String? jobDescription;
  String? jobCategory;
  bool? recruitment;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? deadlineDate;
  String? postedDate;
  String? userImageUrl;
  String? authorName;
  String? name;
  bool isDeadlineAvailable = false;
  bool showComment = false;

  // Fetch job details from Firestore
  void getJobData() async {
    try {
      final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
          .collection("jobs")
          .doc(widget.jobID)
          .get();

      if (jobDatabase.exists) {
        setState(() {
          jobTitle = jobDatabase.get("jobTitle");
          jobDescription = jobDatabase.get("jobDescription");
          recruitment = jobDatabase.get("recruitment");
          emailCompany = jobDatabase.get("email");
          locationCompany = jobDatabase.get("location");
          applicants = jobDatabase.get("applicants");
          postedDateTimeStamp = jobDatabase.get("createdAt");
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = "${postDate.year}-${postDate.month}-${postDate.day}";
        });

        final DocumentSnapshot userDatabase = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.uploadedBy)
            .get();

        if (userDatabase.exists) {
          setState(() {
            userImageUrl = userDatabase.get("profileImageUrl") ?? '';
            authorName = userDatabase.get("name") ?? '';
            locationCompany = userDatabase.get("location") ?? '';
          });
        } else {
          print("User data not found");
        }
      } else {
        print("Job not found in Firestore");
      }
    } catch (error) {
      print("Error fetching job data: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  Widget dividerWidget() {
    return Column(
      children: [
        SizedBox(height: 10),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
        scheme: "mailto",
        path: emailCompany,
        query:
            "subject=Applying for $jobTitle&body=Hello,please attach Resume CV file");
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef =
        FirebaseFirestore.instance.collection("jobs").doc(widget.jobID);

    docRef.update({
      'applicants': applicants + 1,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
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
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            icon: const Icon(
              Icons.close,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.grey,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  userImageUrl == null
                                      ? "https://h-o-m-e.org/wp-content/uploads/2022/04/Blank-Profile-Picture-0.jpg"
                                      : userImageUrl!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authorName == null ? '' : authorName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                locationCompany == null ? '' : locationCompany!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                jobTitle ?? "Job Title Not Available",
                                maxLines: 3,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          jobDescription ?? "No Description Available",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        dividerWidget(),
                        Text(
                          "Posted On: ${postedDate ?? "N/A"}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                        dividerWidget(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Job Description Header
                            Text(
                              "Job Description",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                height: 10), // Add spacing below the header

                            // Applicants Count

                            const SizedBox(
                                height: 10), // Add spacing below the count

                            // Job Description Content
                            Text(
                              jobDescription ?? '',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    10), // Add spacing below the description

                            // Divider
                            dividerWidget(),
                            const SizedBox(
                                height: 10), // Add spacing below the divider

                            // Applicants Row with Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Applicants",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                    width: 10), // Space between text and icon
                                Icon(
                                  Icons.how_to_reg_sharp,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                    width: 10), // Space between icon and count
                                Text(
                                  applicants.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid ==
                                widget.uploadedBy
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dividerWidget(),
                                  Text(
                                    "Recruitment",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          final _uid = user!.uid;
                                          if (_uid == widget.uploadedBy) {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection("jobs")
                                                  .doc(widget.jobID)
                                                  .update(
                                                      {"recruitment": true});
                                            } catch (error) {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      "Action cannot be performed",
                                                  ctx: context);
                                            }
                                          } else {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    "You cannot perform this action",
                                                ctx: context);
                                          }
                                          getJobData();
                                        },
                                        child: Text(
                                          "ON",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_box,
                                        color: recruitment == true
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 40),
                                      TextButton(
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          final _uid = user!.uid;
                                          if (_uid == widget.uploadedBy) {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection("jobs")
                                                  .doc(widget.jobID)
                                                  .update(
                                                      {"recruitment": false});
                                            } catch (error) {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      "Action cannot be performed",
                                                  ctx: context);
                                            }
                                          } else {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    "You cannot perform this action",
                                                ctx: context);
                                          }
                                          getJobData();
                                        },
                                        child: Text(
                                          "OFF",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_box_outline_blank,
                                        color: recruitment == false
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isDeadlineAvailable
                                ? 'Deadline Passed out'
                                : "Actively Recruiting, Send CV/Resume:",
                            style: TextStyle(
                                color: isDeadlineAvailable
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.normal,
                                fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              applyForJob();
                            },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                "Easy Apply Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Uploaded on:",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              postedDate == null ? '' : postedDate!,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Deadline date:",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              deadlineDate == null ? '' : deadlineDate!,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        dividerWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              child: _isCommenting
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: TextField(
                                            focusNode: _focusNode,
                                            controller: _commentController,
                                            style:
                                                TextStyle(color: Colors.white),
                                            maxLength: 200,
                                            keyboardType: TextInputType.text,
                                            maxLines: 6,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.black,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.pink))),
                                          ),
                                        ),
                                        Flexible(
                                            child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  if (_commentController
                                                          .text.length <
                                                      7) {
                                                    GlobalMethod.showErrorDialog(
                                                        error:
                                                            "Comment cannot be less than 7 characters",
                                                        ctx: context);
                                                  } else {
                                                    final _generatedId =
                                                        const Uuid().v4();
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("jobs")
                                                        .doc(widget.jobID)
                                                        .update({
                                                      "jobComments": FieldValue
                                                          .arrayUnion([
                                                        {
                                                          "userId": FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid,
                                                          "commentId":
                                                              _generatedId,
                                                          "name": name,
                                                          "userImageUrl":
                                                              userImageUrl,
                                                          "commentBody":
                                                              _commentController
                                                                  .text,
                                                          "time":
                                                              Timestamp.now(),
                                                        }
                                                      ])
                                                    });
                                                    await Fluttertoast.showToast(
                                                        msg:
                                                            "Your comment has been added",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        fontSize: 18);
                                                    _commentController.clear();
                                                  }
                                                  setState(() {
                                                    showComment = true;
                                                  });
                                                },
                                                color: Colors.blueAccent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  "Post",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isCommenting =
                                                        !_isCommenting;
                                                    showComment = false;
                                                  });
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                          ],
                                        ))
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _isCommenting = !_isCommenting;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add_comment,
                                              color: Colors.blueAccent,
                                              size: 40,
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showComment = true;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.arrow_drop_down_circle,
                                              color: Colors.blueAccent,
                                              size: 40,
                                            ))
                                      ],
                                    )),
                          showComment == false
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.all(16),
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection("jobs")
                                        .doc(widget.jobID)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        if (snapshot.data == null ||
                                            !snapshot.data!.exists) {
                                          return const Center(
                                            child: Text(
                                                "No Comments for this job"),
                                          );
                                        } else {
                                          final jobComments =
                                              snapshot.data!["jobComments"]
                                                  as List<dynamic>?;

                                          if (jobComments == null ||
                                              jobComments.isEmpty) {
                                            return const Center(
                                              child: Text(
                                                  "No Comments for this job"),
                                            );
                                          }

                                          return ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final comment =
                                                  jobComments[index];

                                              // Safely retrieve fields with default values
                                              final commentId =
                                                  comment["commentId"] ??
                                                      "Unknown ID";
                                              final commenterId =
                                                  comment["userId"] ??
                                                      "Unknown User";
                                              final commenterName =
                                                  comment["name"] ??
                                                      "Anonymous";
                                              final commentBody = comment[
                                                      "commentBody"] ??
                                                  "No comment text provided.";
                                              final commenterImageUrl =
                                                  comment["userImageUrl"] ?? "";

                                              return CommentsWidget(
                                                commentId: commentId,
                                                commenterId: commenterId,
                                                commenterName: commenterName,
                                                commentBody: commentBody,
                                                commenterImageUrl:
                                                    commenterImageUrl,
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return const Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              );
                                            },
                                            itemCount: jobComments.length,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

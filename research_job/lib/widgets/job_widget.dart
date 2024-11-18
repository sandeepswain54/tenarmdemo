import 'package:flutter/material.dart';

class JobWidget extends StatefulWidget {
  final String BuisnessTitle;
  final String BuisnessDescription;
  final String JobId;
  final String uploadBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.BuisnessTitle,
    required this.BuisnessDescription,
    required this.JobId,
    required this.uploadBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: ListTile(
        onTap: (){

        },
        onLongPress: (){

        },
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10
        ),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1
 ,
              ),

            )
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.BuisnessTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:  Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
               style: TextStyle(
            color:  Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13
          ),
            ),
            SizedBox(height: 8,),

            Text(
              widget.BuisnessDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
               style: TextStyle(
            color:  Colors.black,
      
            fontSize: 15
          ),
            ),


          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}

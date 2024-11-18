import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class UploadJob extends StatefulWidget {
  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {
  final TextEditingController _businessSectorController =
      TextEditingController(text: 'Select Business Sector');

  final TextEditingController _businessTitleController =
      TextEditingController();

  final TextEditingController _businessDescriptionController =
      TextEditingController();

  final TextEditingController _applicationDeadlineController =
      TextEditingController(text: "Application Close Date");

  final _formKey = GlobalKey<FormState>();
  DateTime? _pickedDate;
  Timestamp? _deadlineDate;
  bool _isLoading = false;

  String? userName;
  String? userImage;
  String? userLocation;

  @override
  void dispose() {
    _businessSectorController.dispose();
    _businessTitleController.dispose();
    _businessDescriptionController.dispose();
    _applicationDeadlineController.dispose();
    super.dispose();
  }

  void _uploadJob() async {
    if (_formKey.currentState!.validate() && _deadlineDate != null) {
      setState(() {
        _isLoading = true;
      });
      final jobId = const Uuid().v4();
      final user = FirebaseAuth.instance.currentUser;

      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
          'jobId': jobId,
          'uploadedBy': user!.uid,
          'email': user.email,
          'businessSector': _businessSectorController.text,
          'businessTitle': _businessTitleController.text,
          'businessDescription': _businessDescriptionController.text,
          'deadlineDate': _deadlineDate,
          'createdAt': Timestamp.now(),
        });

        Fluttertoast.showToast(msg: "Job uploaded successfully!");
        _clearForm();
      } catch (error) {
        Fluttertoast.showToast(msg: "Error: $error");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields properly!");
    }
  }

  void _clearForm() {
    _businessSectorController.clear();
    _businessTitleController.clear();
    _businessDescriptionController.clear();
    _applicationDeadlineController.text = "Application Close Date";
    _deadlineDate = null;
  }

  Future<void> _pickDateDialog() async {
    _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );

    if (_pickedDate != null) {
      setState(() {
        _deadlineDate = Timestamp.fromDate(_pickedDate!);
        _applicationDeadlineController.text =
            "${_pickedDate!.day}/${_pickedDate!.month}/${_pickedDate!.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Job")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _businessSectorController,
                decoration: const InputDecoration(labelText: 'Business Sector'),
                validator: (value) =>
                    value!.isEmpty ? "Field cannot be empty" : null,
              ),
              TextFormField(
                controller: _businessTitleController,
                decoration: const InputDecoration(labelText: 'Business Title'),
                validator: (value) =>
                    value!.isEmpty ? "Field cannot be empty" : null,
              ),
              TextFormField(
                controller: _businessDescriptionController,
                decoration: const InputDecoration(
                    labelText: 'Business Description'),
                validator: (value) =>
                    value!.isEmpty ? "Field cannot be empty" : null,
              ),
              TextFormField(
                controller: _applicationDeadlineController,
                readOnly: true,
                onTap: _pickDateDialog,
                decoration: const InputDecoration(labelText: 'Deadline'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadJob, child: const Text("Upload Job")),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _transactionType = 'MM Transfer to HQ';
  File? _evidenceImage;

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _evidenceImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('expenses/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }

  void _saveData() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? imageUrl;
      if (_evidenceImage != null) {
        imageUrl = await _uploadImage(_evidenceImage!);
      }

      final data = {
        'amount': int.tryParse(_amountController.text) ?? 0,
        'transactionType': _transactionType,
        'comment': _commentController.text,
        'evidenceImage': imageUrl,
        'timestamp': Timestamp.now(),
      };

      FirebaseFirestore.instance.collection('expenses').add(data).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save data: $error')));
      });
    }
  }

  Widget _buildInputField({required String label, TextInputType keyboardType = TextInputType.text, required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(label: 'Amount', keyboardType: TextInputType.number, controller: _amountController),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _transactionType,
                  items: ['MM Transfer to HQ', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _transactionType = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    labelText: 'Type of Transaction',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 12),
              _buildInputField(label: 'Comment', controller: _commentController),
              SizedBox(height: 16),
              if (_evidenceImage != null)
                Image.file(_evidenceImage!),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.camera_alt),
                label: Text('Capture Image as Evidence'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveData,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

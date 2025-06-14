import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retinalapp/img_list.dart'; // Your UploadedScansPage

class UploadRetinalScanPage extends StatefulWidget {
  @override
  _UploadRetinalScanPageState createState() => _UploadRetinalScanPageState();
}

class _UploadRetinalScanPageState extends State<UploadRetinalScanPage> {
  File? _selectedImage;
  final picker = ImagePicker();
  String? _eyeSide;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _notesController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _uploadScan() async {
    if (_selectedImage == null || _eyeSide == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select image and eye side')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('retina_scans/$fileName');
      final uploadTask = await storageRef.putFile(_selectedImage!);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('retinal_scans').add({
        'url': imageUrl,
        'eyeSide': _eyeSide,
        'notes': _notesController.text,
        'date': _selectedDate.toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Upload Successful'),
          content: Text('Your scan has been uploaded.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => UploadedScansPage()),
                );
              },
              child: Text('View Scans'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Retinal Scan', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(
                  icon: Icons.camera_alt,
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildCircleButton(
                  icon: Icons.upload,
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_selectedImage!, height: 200),
              ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Eye Side',
                border: OutlineInputBorder(),
              ),
              value: _eyeSide,
              items: ['Left', 'Right']
                  .map((side) => DropdownMenuItem(value: side, child: Text(side)))
                  .toList(),
              onChanged: (value) => setState(() => _eyeSide = value),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Scan Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text('Pick Date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadScan,
                icon: _isUploading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(Icons.cloud_upload, color: Colors.white),
                label: Text(
                  _isUploading ? 'Uploading...' : 'Upload Scan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  disabledBackgroundColor: Colors.blue[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.blue[700],
        radius: 32,
        child: Icon(icon, size: 28, color: Colors.white),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retinalapp/img_list.dart';

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
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _uploadScan() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (_selectedImage == null || _eyeSide == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select image and eye side')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final analysis = await _callBackendAnalysis(_selectedImage!);

      await FirebaseFirestore.instance.collection('retinal_scans').add({
        'userId': userId,
        'eyeSide': _eyeSide,
        'notes': _notesController.text,
        'date': _selectedDate.toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
        'average_tortuosity': analysis['average_tortuosity'],
        'max_tortuosity': analysis['max_tortuosity'],
        'num_vessels': analysis['num_vessels'],
        'retinopathy_grade': analysis['retinopathy_grade'],
        'edema_risk': analysis['edema_risk'],
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Upload Successful'),
          content: Text('Your scan has been uploaded and analyzed.'),
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

  Future<Map<String, dynamic>> _callBackendAnalysis(File imageFile) async {
    final uri = Uri.parse('http://10.0.2.2:8000/analyze-file');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      return jsonDecode(resBody);
    } else {
      throw Exception('Backend error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF5A6E97);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: Text('Upload Retinal Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt, size: 28),
                  label: Text('Camera', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  onPressed: () => _pickImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file, size: 28),
                  label: Text('Gallery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                ),
              ],
            ),
            if (_selectedImage != null) ...[
              SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_selectedImage!, height: 220),
              ),
            ],
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Eye Side', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    value: _eyeSide,
                    hint: Text('Select Eye Side'),
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF5A6E97)),
                    dropdownColor: Colors.white,
                    items: ['Left', 'Right']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => _eyeSide = val),
                  ),
                  SizedBox(height: 24),
                  Text('Scan Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range, color: Color(0xFF5A6E97)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            DateFormat.yMMMMd().format(_selectedDate),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: _selectDate,
                          child: Text('Change', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5A6E97))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                  SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Optional note about this scan...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadScan,
                icon: _isUploading
                    ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Icon(Icons.cloud_upload, color: Colors.white,),
                label: Text(
                  _isUploading ? 'Uploading...' : 'Upload Retinal Scan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
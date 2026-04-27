import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../widgets/image_card.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _image;
  File? _mobileImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = picked;
        if (!kIsWeb) _mobileImage = File(picked.path);
        isLoading = true;
      });

      try {
        final res = await ApiService.sendToBackend(picked);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: res),
          ),
        );
      } catch (e) {
        print("Error: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, color: Color(0xFF2E7D32)),
            SizedBox(width: 6),
            Text(
              "NutriScan",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 420),
            padding: EdgeInsets.all(16),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 TITLE
                Text(
                  "Scan Your Food",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Understand what you eat. Make healthier choices.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),

                SizedBox(height: 20),

                ImageCard(image: _image, mobileImage: _mobileImage),

                SizedBox(height: 20),

                isLoading
                    ? Column(
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFF2E7D32),
                          ),
                          SizedBox(height: 10),
                          Text("Analyzing..."),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload),
                              SizedBox(width: 8),
                              Text(
                                "Upload Image",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
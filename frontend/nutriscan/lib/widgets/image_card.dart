import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class ImageCard extends StatelessWidget {
  final XFile? image;
  final File? mobileImage;

  const ImageCard({this.image, this.mobileImage});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        alignment: Alignment.center,
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: kIsWeb
                    ? Image.network(image!.path, fit: BoxFit.cover)
                    : Image.file(mobileImage!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 50, color: Colors.grey[400]),
                  SizedBox(height: 10),
                  Text(
                    "Upload food label image",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
      ),
    );
  }
}

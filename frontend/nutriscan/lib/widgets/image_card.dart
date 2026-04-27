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
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                Icon(Icons.image_outlined,
                    size: 50, color: Colors.grey[400]),
                SizedBox(height: 10),
                Text(
                  "Upload food label image",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
    );
  }
}
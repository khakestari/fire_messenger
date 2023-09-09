import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _picekdImage;

  void pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedImageFile != null) {
        _picekdImage = File(pickedImageFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        radius: 40,
        backgroundImage: _picekdImage != null ? FileImage(_picekdImage!) : null,
        child: _picekdImage == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_sharp,
                    color: Colors.orange,
                  ),
                  Text(
                    'Add image',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              )
            : null,
      ),
    );
  }
}

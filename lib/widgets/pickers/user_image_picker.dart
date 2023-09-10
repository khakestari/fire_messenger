import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File? pickedmage) imagePickFn;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _picekdImage;

  void pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 200,
    );
    if (pickedImageFile != null) {
      setState(() {
        _picekdImage = File(pickedImageFile.path);
      });
    }
    widget.imagePickFn(_picekdImage);
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

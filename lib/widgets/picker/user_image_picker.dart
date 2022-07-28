import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Future<void> Function(File image) imagePickFunction;

  const UserImagePicker({required this.imagePickFunction, Key? key})
      : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final image = await ImagePicker.platform.getImage(
      source: ImageSource.camera,
      imageQuality: 50, // range 0-100
      maxWidth: 150,
    ); 

    if (image == null) return;

    setState(() {
      _pickedImage = File(image.path);
    });

    widget.imagePickFunction(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}

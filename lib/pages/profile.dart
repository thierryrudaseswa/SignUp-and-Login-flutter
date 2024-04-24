import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thirder/pages/HomePage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => HomePage()),
                    (route) => false,
                  );
                },
                child: Icon(Icons.arrow_back),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: getImage(),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button(),
                  IconButton(
                    onPressed: () async {
                      XFile? pickedImage =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        setState(() {
                          image = pickedImage;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.teal,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider getImage() {
    if (image != null) {
      return FileImage(File(image!.path));
    }
    return AssetImage("assets/profile.jpg");
  }

  Widget button() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Add Pro Pic",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xff8a32f1), Color(0xffad32f9)],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? imagePath;

  @override
  void initState() {
    super.initState();
    getuser();
    loadimage();
  }

  Future<void> loadimage() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      imagePath = pref.getString('profile_image');
    });
  }

  Future<void> pickimage() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      int sdkint = int.parse(Platform.version.split('.').first);
      if (sdkint >= 33) {
        status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
          print('$status');
        }
      } 
      else {
        status = await Permission.storage.status;

        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }
    } 
    else {
      status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
    }

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 112, 149, 167),

          content: Center(
            child: Text(
              'Gallery permission is required to select an image.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
      return;
    }
    // ❌ Exit the function, don't continue to open the gallery

    // ✅ If permission is granted, proceed to open the gallery
    // 🎯 Create an instance of ImagePicker

    final picker = ImagePicker();

    // 📷 Launch the gallery and wait for the user to pick an image

    final pickedfile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedfile != null) {
      var pref = await SharedPreferences.getInstance();
      await pref.setString('profile_image', pickedfile.path);
      setState(() {
        imagePath = pickedfile.path;
      });
    }
  }

  String? NameValue;

  void getuser() async {
    var pref = await SharedPreferences.getInstance();
    var uname = pref.getString('User');
    NameValue = uname != null ? uname : 'No Value ';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Drawer(
        width: 280,
        child: Column(
          children: [
            Card(
              elevation: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 112, 149, 167),

                  borderRadius: BorderRadius.circular(11),
                ),
                height: 350,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: pickimage,

                      child: CircleAvatar(
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath!))
                            : null,
                        radius: 80,
                        child: imagePath == null
                            ? Icon(Icons.add_a_photo, size: 40)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Hello! ${NameValue.toString()}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Icon(Icons.info_outline, size: 22),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              ' We are a dedicated team committed to providing high-quality services and solutions to our users. Our mission is to deliver exceptional experiences with a focus on reliability, innovation, and customer satisfaction. Thank you for choosing our app!',

                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Icon(Icons.email_outlined, size: 22),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Email: aftabliaqat933@gmail.com\n\n'
                              'For any inquiries, support, or feedback, please feel free to reach out to us via email. '
                              'We are always available to assist you and ensure you have the best experience with our app.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          'Terms&Conditions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Icon(Icons.privacy_tip_outlined, size: 22),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'By using this application, you agree to comply with our terms and conditions. Please use the app responsibly and respect all applicable laws and regulations. We reserve the right to update these terms at any time, so please review them periodically.',
                              textAlign: TextAlign.justify,

                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Powered by',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              'NAJAF_DEVS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notex/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameInput extends StatefulWidget {
  @override
  State<UsernameInput> createState() => _UsernameInputState();
}

class _UsernameInputState extends State<UsernameInput> {
  TextEditingController name = TextEditingController();

  String warning = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              child: Text(
                'NoteX',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              color: Color.fromARGB(255, 112, 149, 167),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 140,
                  height: 140,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome!\nEnter Your Name:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(
              width: 300,
              child: TextField(
                onChanged: (_){
                  setState(() {
                    if(name!='')
                    warning='';
                    
                  });
                },
                controller: name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10),
             warning.isNotEmpty?
            Text(
              '$warning',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ):
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: Color.fromARGB(255, 115, 147, 163),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                ),
              ),
              onPressed: () async {
                var username = name.text.trim();
                var pref = await SharedPreferences.getInstance();
                pref.setString("User", username);
                if (username.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                } else {
                  setState(() {});
                  warning = 'Please enter username!';
                }
              },
              child: Text(
                'Proceed',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

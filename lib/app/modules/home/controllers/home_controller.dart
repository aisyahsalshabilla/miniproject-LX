// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final _firebaseAuth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   late User _user;
//   late String _name, _email, _phoneNumber, _photoUrl;
//   late File _image;

//   @override
//   void initState() {
//     super.initState();
//     _user = _firebaseAuth.currentUser!;
//     _name = _user.displayName!;
//     _email = _user.email!;
//     _phoneNumber = _user.phoneNumber!;
//     _photoUrl = _user.photoURL!;
//   }

//   Future<void> _updatePhoto() async {
//     final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       final Reference storageReference = FirebaseStorage.instance.ref().child('user_images').child(_user.uid);
//       await storageReference.putFile(_image);
//       final String downloadUrl = await storageReference.getDownloadURL();
//       await _firestore.collection('users').doc(_user.uid).update({
//         'photoURL': downloadUrl,
//       });
//       _photoUrl = downloadUrl;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl) : AssetImage('assets/images/profil.png'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _updatePhoto,
//               child: Text('Update Photo'),
//             ),
//             SizedBox(height: 16),
//             Text('Name: $_name'),
//             SizedBox(height: 8),
//             Text('Email: $_email'),
//             SizedBox(height: 8),
//             Text('Phone Number: $_phoneNumber'),
//           ],
//         ),
//       ),
//     );
//   }
// }
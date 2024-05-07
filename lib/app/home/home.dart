import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User _user;
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _photoUrl = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    _user = _firebaseAuth.currentUser!;
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      final userData = await _firestore.collection('users').doc(_user.uid).get();
      if (userData.exists) {
        setState(() {
          _name = userData['name'];
          _email = userData['email'];
          _phoneNumber = userData['phone_number'];
          _photoUrl = userData['photoURL'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updatePhoto() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      final Reference storageReference = FirebaseStorage.instance.ref().child('user_images').child(_user.uid);
      print('Starting to upload image to Firebase Storage...');
      await storageReference.putFile(_image!).whenComplete(() {
        print('Image uploaded to Firebase Storage.');
      });
      final String downloadUrl = await storageReference.getDownloadURL();
      print('Download URL: $downloadUrl');
      await _firestore.collection('users').doc(_user.uid).update({
        'photoURL': downloadUrl,
      }).whenComplete(() {
        print('Photo URL updated in Firestore.');
      });
      setState(() {
        _photoUrl = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // White Background
          Container(
            color: Colors.white,
          ),
          // Purple Shadow
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.purple[900]!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Blur Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (_photoUrl.isNotEmpty
                          ? NetworkImage(_photoUrl)
                          : AssetImage('assets/images/foto.jpg')) as ImageProvider<Object>?,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updatePhoto,
                  child: Text('Update Photo'),
                ),
                // SizedBox(height: 16),
                // Text('Hello, $_name'),
                // SizedBox(height: 8),
                // Text('Email: $_email'),
                // SizedBox(height: 8),
                // Text('Phone Number: $_phoneNumber'),
                SizedBox(height: 16),
                Text('Name: $_name'),
                SizedBox(height: 8),
                Text('Email: $_email'),
                SizedBox(height: 8),
                Text('Phone Number: $_phoneNumber'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final _firebaseAuth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   late User _user;
//   String _name = '';
//   String _email = '';
//   String _phoneNumber = '';
//   String _photoUrl = '';
//   File? _image;

//   @override
//   void initState() {
//     super.initState();
//     _user = _firebaseAuth.currentUser!;
//     _getUserData();
//   }

//   Future<void> _getUserData() async {
//     try {
//       final userData = await _firestore.collection('users').doc(_user.uid).get();
//       if (userData.exists) {
//         setState(() {
//           _name = _user.displayName ?? '';
//           _email = _user.email ?? '';
//           _phoneNumber = userData['phone_number'];
//           // Untuk alamat, sesuaikan dengan nama field di Firestore
//           _photoUrl = userData['photoURL'];
//         });
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }

//   Future<void> _updatePhoto() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       final Reference storageReference = FirebaseStorage.instance.ref().child('user_images').child(_user.uid);
//       print('Starting to upload image to Firebase Storage...');
//       await storageReference.putFile(_image!).whenComplete(() {
//         print('Image uploaded to Firebase Storage.');
//       });
//       final String downloadUrl = await storageReference.getDownloadURL();
//       print('Download URL: $downloadUrl');
//       await _firestore.collection('users').doc(_user.uid).update({
//         'photoURL': downloadUrl,
//       }).whenComplete(() {
//         print('Photo URL updated in Firestore.');
//       });
//       setState(() {
//         _photoUrl = downloadUrl;
//       });
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
//               // Tampilkan gambar dari _image jika _image tidak null, jika null maka tampilkan dari _photoUrl
//               backgroundImage: _image != null ? FileImage(_image!) : (_photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : AssetImage('assets/images/profil.png')) as ImageProvider<Object>?,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _updatePhoto,
//               child: Text('Update Photo'),
//             ),
//             SizedBox(height: 16),
//             // Tampilkan nama secara otomatis
//             Text('Hello, $_name'),
//             SizedBox(height: 8),
//             // Tampilkan email
//             Text('Email: $_email'),
//             SizedBox(height: 8),
//             // Tampilkan nomor telepon
//             Text('Phone Number: $_phoneNumber'),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';

// // // class HomePage extends StatefulWidget {
// // //   @override
// // //   _HomePageState createState() => _HomePageState();
// // // }

// // // class _HomePageState extends State<HomePage> {
// // // //   final _firebaseAuth = FirebaseAuth.instance;
// // // //   final _firestore = FirebaseFirestore.instance;
// // // //   late User _user;
// // // //   String _name = '';
// // // //   String _email = '';
// // // //   String _phoneNumber = '';
// // // //   String _photoUrl = '';
// // // //   File? _image;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _user = _firebaseAuth.currentUser!;
// // // //     _name = _user.displayName ?? '';
// // // //     _email = _user.email ?? '';
// // // //     _phoneNumber = _user.phoneNumber ?? '';
// // // //     _photoUrl = _user.photoURL ?? '';
// // // //   }

// // // //   Future<void> _updatePhoto() async {
// // // //     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
// // // //     if (pickedFile != null) {
// // // //       setState(() {
// // // //         _image = File(pickedFile.path);
// // // //       });
// // // //       final Reference storageReference = FirebaseStorage.instance.ref().child('user_images').child(_user.uid);
// // // //       await storageReference.putFile(_image!);
// // // //       final String downloadUrl = await storageReference.getDownloadURL();
// // // //       await _firestore.collection('users').doc(_user.uid).update({
// // // //         'photoURL': downloadUrl,
// // // //       });
// // // //       setState(() {
// // // //         _photoUrl = downloadUrl;
// // // //       });
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Home'),
// // // //       ),
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             CircleAvatar(
// // // //               radius: 50,
// // // //               // Tampilkan gambar dari _image jika _image tidak null, jika null maka tampilkan dari _photoUrl
// // // //               backgroundImage: _image != null ? FileImage(_image!) : (_photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : AssetImage('assets/images/profil.png')) as ImageProvider<Object>?,
// // // //             ),
// // // //             SizedBox(height: 16),
// // // //             ElevatedButton(
// // // //               onPressed: _updatePhoto,
// // // //               child: Text('Update Photo'),
// // // //             ),
// // // //             SizedBox(height: 16),
// // // //             Text('Name: $_name'),
// // // //             SizedBox(height: 8),
// // // //             Text('Email: $_email'),
// // // //             SizedBox(height: 8),
// // // //             Text('Phone Number: $_phoneNumber'),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final _firebaseAuth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   late User _user;
//   String _name = '';
//   String _email = '';
//   String _phoneNumber = '';
//   String _photoUrl = '';
//   File? _image;

//   @override
//   void initState() {
//     super.initState();
//     _user = _firebaseAuth.currentUser!;
//     _name = _user.displayName ?? '';
//     _email = _user.email ?? '';
//     _phoneNumber = _user.phoneNumber ?? '';
//     _photoUrl = _user.photoURL ?? '';
//   }

//   Future<void> _updatePhoto() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       final Reference storageReference = FirebaseStorage.instance.ref().child('user_images').child(_user.uid);
//       await storageReference.putFile(_image!);
//       final String downloadUrl = await storageReference.getDownloadURL();
//       await _firestore.collection('users').doc(_user.uid).update({
//         'photoURL': downloadUrl,
//       });
//       setState(() {
//         _photoUrl = downloadUrl;
//       });
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
//               backgroundImage: _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : AssetImage('assets/images/profil.png') as ImageProvider<Object>?,
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

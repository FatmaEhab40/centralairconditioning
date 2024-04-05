import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyFirebaseOptions {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;


  MyFirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
  });

  static FirebaseOptions platform = const FirebaseOptions(
      apiKey: "AIzaSyAPEAZlciZ-z0ERSN_WJ9xr78d4Tvum-qA",
      authDomain: "central-air-conditioning-35edc.firebaseapp.com",
      projectId: "central-air-conditioning-35edc",
      storageBucket: "central-air-conditioning-35edc.appspot.com",
      messagingSenderId: "737892810655",
      appId: "1:737892810655:web:822820f2a53efb9fee47aa",
      measurementId: "G-LY6BYVJ57M"
  );

  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return platform;
    }else if (Platform.isWindows) {
      return platform;
    } else if (Platform.isIOS) {
      return platform;
    } else {
      throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }
}

class ConstantVar{
  static  bool isObscure = true;
  static final nameController = TextEditingController();
  static final phoneController = TextEditingController();
  static final emailController = TextEditingController();
  static final passwordController1 = TextEditingController();
  static final passwordController2 = TextEditingController();
  static  final periodController = TextEditingController();
  static final roomController = TextEditingController();
  static final formKey = GlobalKey<FormState>();

  static final  List<Color> gradientList=[
    const Color(0xFF795548),
    const Color(0xFF8D6E63),
    const Color(0xFFA1887F),
    const Color(0xFFF9A825),
    const Color(0xFFF57F17)
  ];
  static const Color backgroundPage = Color(0xFFD7CCC8);
  static const Color backgroundContainer = Color(0xFF8D6E63);

  static final firestore=FirebaseFirestore.instance;
  static final auth=FirebaseAuth.instance;
  static final storage = FirebaseStorage.instance;

}

class Toast {
  String message;
  Color backgroundColor;
  Color textColor;
  double fontSize;

  Toast({this.backgroundColor=Colors.brown,
    this.textColor=Colors.white,
    this.fontSize=16.0,
    required this.message}) ;

  void toast(message,backgroundColor,textColor,fontSize) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize
    );
  }
}

class Periods {
  String duration = "";
  String id = "";
  String userId = ConstantVar.auth.currentUser!.uid;
  Periods(this.duration, this.id);

  Map<String, dynamic> toMap() {
    return {
      "duration": duration,
      "id": id,
      "userId": userId,
    };
  }

  Periods.fromMap(Map<dynamic, dynamic> data) {
    duration = data['duration'];
    id = data['id'];
    userId = data['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      "duration": duration,
      "id": id,
      "userId": userId,
    };
  }
}

class Rooms {
  String name = "";
  String id = "";
  String userId = ConstantVar.auth.currentUser!.uid;
  Rooms(this.name, this.id);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id": id,
      "userId": userId,
    };
  }

  Rooms.fromMap(Map<dynamic, dynamic> data) {
    name = data['name'];
    id = data['id'];
    userId = data['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "userId": userId,
    };
  }
}




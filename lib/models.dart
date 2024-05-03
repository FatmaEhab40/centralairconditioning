import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ConstantVar{
  static  bool isObscure = true;
  static final nameController = TextEditingController();
  static final phoneController = TextEditingController();
  static final emailController = TextEditingController();
  static final passwordController1 = TextEditingController();
  static final passwordController2 = TextEditingController();
  static  final periodController = TextEditingController();
  static  final indexController = TextEditingController();
  static final roomController = TextEditingController();
  static final formKey = GlobalKey<FormState>();

  static final  List<Color> gradientList=[
    const Color(0xFF795548),
    const Color(0xFF8D6E63),
    const Color(0xFFA1887F),
    const Color(0xFFF9A825),
    const Color(0xFFF57F17),
    //const Color.fromRGBO(255, 218, 0, 1.0)
  ];
  static const Color backgroundPage = Color(0xFFD7CCC8);
  static const Color backgroundContainer = Color(0xFF8D6E63);

  static final firestore=FirebaseFirestore.instance;
  static final auth=FirebaseAuth.instance;
  static final storage = FirebaseStorage.instance;

}

void toast(message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.brown,
      textColor: Colors.white,
      fontSize: 16.sp
  );
}

class Periods {
  String duration = "";
  String id = "";
  int index = 0;
  String userId = ConstantVar.auth.currentUser!.uid;
  Periods(this.duration, this.id);
      //,this.index);

  Map<String, dynamic> toMap() {
    return {
      "duration": duration,
      "id": id,
     // "index": index,
      "userId": userId,
    };
  }

  Periods.fromMap(Map<dynamic, dynamic> data) {
    duration = data['duration'];
    id = data['id'];
   // index = data['index'];
    userId = data['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      "duration": duration,
      "id": id,
     // "index": index,
      "userId": userId,
    };
  }
}

class Rooms {
  String name = "";
  String inSchedule = "";
  int noOfpeople=0;
  String id = "";
  int temp = 0 ;
  List<int> color = [0,0,0,0];
  String userId = ConstantVar.auth.currentUser!.uid;
  Rooms(this.name, this.id,this.noOfpeople,this.color);

  Map<String, dynamic> toMap() {
    return {
      "color": color,
      "temp": temp,
      "name": name,
      "noOfpeople" : noOfpeople,
      "id": id,
      "userId": userId,
     // "inSchedule":inSchedule
    };
  }

  Rooms.fromMap(Map<dynamic, dynamic> data) {
    name = data['name'];
    noOfpeople = data['noOfpeople'];
    id = data['id'];
    temp = data['temp'];
    color = List<int>.from(data['color']);
    userId = data['userId'];
  //  inSchedule = data['inSchedule'];
  }

  Map<String, dynamic> toJson() {
    return {
      "color": color,
      "temp": temp,
      "name": name,
      "noOfpeople" : noOfpeople,
      "id": id,
      "userId": userId,
      //"inSchedule":inSchedule
    };
  }
}

class Schedule {
  List<String> rooms = [];
  int index1 = 0;
  int index2 = 0;
  Schedule(this.rooms, this.index1, this.index2);

  Map<String, dynamic> toMap() {
    return {
      "rooms": rooms,
      "index1": index1,
      "index2": index2,
    };
  }

  Schedule.fromMap(Map<dynamic, dynamic> data) {
    rooms = List<String>.from(data['rooms']);
    index1 = data['index1'];
    index2 = data['index2'];
  }

  Map<String, dynamic> toJson() {
    return {
      "rooms": rooms,
      "index1": index1,
      "index2": index2,
    };
  }
}




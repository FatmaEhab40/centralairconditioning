// ignore_for_file: unrelated_type_equality_checks
import 'package:centralairconditioning/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:app_settings/app_settings.dart';
import 'login/page/login_screen.dart';


List<List<List<String>>> subjects = [
  [
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
  ],
  [
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
  ],
  [
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
  ],
  [
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
  ],
  [
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
  ],
  [
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
  ],
  [
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
    ["empty"],
  ],
];

Future<void> getSchedule(List<List<List<String>>> s) async {
  QuerySnapshot snapshot =
      await ConstantVar.firestore.collection("schedule").get();
  for (var doc in snapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    int index1 = data['index1'];
    int index2 = data['index2'];
    dynamic roomsData = List<String>.from(data['rooms']);

    if (roomsData is String) {
      s[index1][index2].add(roomsData);
      s[index1][index2].removeAt(0);
    } else if (roomsData is List<String>) {
      for (String room in roomsData) {
        s[index1][index2].add(room);
      }
      s[index1][index2].removeAt(0);
    }
  }
}


Future<bool> checkInternetConnection() async {
  bool hasConnection = await InternetConnectionChecker().hasConnection;
  if (hasConnection) {
    await Firebase.initializeApp();
  }
  return hasConnection;
}

Widget showDialog1() {
  return AlertDialog(
    backgroundColor: ConstantVar.backgroundPage,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))),
    title: GradientText(
      'No Internet Connection',
      style: GoogleFonts.eagleLake(fontSize: 20.sp),
      gradientType: GradientType.linear,
      colors: ConstantVar.gradientList,
      textAlign: TextAlign.center,
    ),
    content: const Text('Please check your internet connection.',
        textAlign: TextAlign.center),
    actions: [
      Center(
        child: TextButton(
          onPressed: () {
            AppSettings.openAppSettings(type: AppSettingsType.wifi);
          },
          child: const Text('OK', style: TextStyle(color: Colors.brown)),
        ),
      ),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getSchedule(subjects);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          useMaterial3: false,
        ),
        home:  FutureBuilder(
          future: checkInternetConnection(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return const LoginScreen();
              } else {
                return showDialog1(); // This should be a route, not a widget
              }
            }
            else {
              return const Center(child: CircularProgressIndicator(color: Colors.brown));
            }
          },
        ),

      );
    });
  }
}

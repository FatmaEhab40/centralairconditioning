import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../models.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';

class User {
  String name = "";
  String phone = "";
  String email = "";
  String id = "";
  String userId = "";

  User( this.name, this.phone, this.email, this.id) {
    userId = ConstantVar.auth.currentUser!.uid;
  }

  Map<String, dynamic> toMap() {
    return {
      "Name": name,
      "Phone": phone,
      "Email": email,
      "id": id,
      "UserId": userId,
    };
  }

  User.fromMap(Map<dynamic, dynamic> data) {
    data['Name'];
    data['Phone'];
    data['Email'];
    data['id'];
    data['UserId'];
  }
}

final cubit = ProfileCubit();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    cubit.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantVar.backgroundPage,
        appBar: AppBar(
            backgroundColor: ConstantVar.backgroundPage,
            title: GradientText(
              'Profile',
              style: GoogleFonts.eagleLake(fontSize: 20.sp),
              gradientType: GradientType.linear,
              colors: ConstantVar.gradientList,
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.brown,
            )
        ),
        body: BlocProvider(
          create: (context) => cubit,
          child: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) {
              return current is GetUsersSuccessState||
                  current is UpdateUsersSuccessState;
            },
            builder: (context, state) {
              return Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: ConstantVar.nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xFF3E2723),
                                  width: 5.sp)),
                          labelStyle: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xFF3E2723),
                                width: 5.sp),
                          ),
                          prefixIcon:
                          const Icon(Icons.person, color: Colors.brown),
                        ),
                        cursorColor: const Color(0xFF3E2723),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: ConstantVar.phoneController,
                        maxLength: 11,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xFF3E2723),
                                  width: 5.sp)),
                          labelStyle: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xFF3E2723),
                                width: 5.sp),
                          ),
                          prefixIcon: const Icon(Icons.phone_android,
                              color: Colors.brown),
                        ),
                        cursorColor: const Color(0xFF3E2723),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: ConstantVar.emailController,
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color(0xFF3E2723),
                                  width: 5.sp)),
                          labelStyle: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xFF3E2723),
                                width: 5.sp),
                          ),
                          prefixIcon:
                          const Icon(Icons.email, color: Colors.brown),
                        ),
                        cursorColor: const Color(0xFF3E2723),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            cubit.updateUserData();
                            cubit.getUserData();
                          },
                          style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.brown),
                          child: const Text("Update",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ));
            },
          ),
        ));
  }
}




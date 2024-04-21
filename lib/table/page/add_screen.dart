import 'package:centralairconditioning/table/page/table_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../models.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantVar.backgroundPage,
        centerTitle: true,
        title: GradientText(
          'Add',
          style: GoogleFonts.eagleLake(fontSize: 20.sp),
          gradientType: GradientType.linear,
          colors: ConstantVar.gradientList,
        ),
        iconTheme: const IconThemeData(
          color: Colors.brown,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.sp),
        padding: EdgeInsets.all(10.sp),
        child: Form(
          key: ConstantVar.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: ConstantVar.periodController,
                decoration: InputDecoration(
                    labelText: "Period",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp)),
                    labelStyle: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFF3E2723), width: 5.sp),
                    ),
                    prefixIcon: const Icon(Icons.access_time_filled,
                        color: Colors.brown),
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (ConstantVar.periodController.text.isEmpty ||
                              ConstantVar.periodController.text == "") {
                            toast("Not allowed");
                          } else {
                            cubit.addPeriod();
                            ConstantVar.periodController.clear();
                          }
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.brown)),
                cursorColor: const Color(0xFF3E2723),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Period is required !";
                  } else if (value == "") {
                    return "Period is wrong !";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.sp),
              TextFormField(
                controller: ConstantVar.roomController,
                decoration: InputDecoration(
                    labelText: "Room",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xFF3E2723), width: 5.sp)),
                    labelStyle: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFF3E2723), width: 5.sp),
                    ),
                    prefixIcon: const Icon(Icons.room, color: Colors.brown),
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (ConstantVar.roomController.text.isEmpty ||
                              ConstantVar.roomController.text == "") {
                            toast("Not allowed");
                          } else {
                            cubit.addRoom();
                            ConstantVar.roomController.clear();
                          }
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.brown)),
                cursorColor: const Color(0xFF3E2723),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Room is required !";
                  } else if (value == "") {
                    return "Room is wrong !";
                  }
                  return null;
                },
              ),
              SizedBox(height: 5.sp),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //         Navigator.pop(context);
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.brown,
              //       padding: EdgeInsets.symmetric(
              //           horizontal: 5.0.sp, vertical: 5.0.sp),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0.sp)),
              //     ),
              //     child: Text(
              //       "Save",
              //       style: TextStyle(color: Colors.white, fontSize: 15.sp),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

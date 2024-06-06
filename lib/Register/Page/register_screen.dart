import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../login/page/login_screen.dart';
import '../../models.dart';
import '../manager/register_cubit.dart';
import '../manager/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final cubit = RegisterCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          onStatChange(state);
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ConstantVar.backgroundPage,
            appBar: AppBar(
                backgroundColor: ConstantVar.backgroundPage,
                elevation: 0,
                iconTheme: const IconThemeData(
                  color: Colors.brown,
                )
            ),
            body: Form(
              key: ConstantVar.formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10.sp),
                  height: 200.sp,
                  child:
                  Center(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GradientText(
                            'Register',
                            style: GoogleFonts.eagleLake(fontSize: 30.sp),
                            gradientType: GradientType.linear,
                            colors: ConstantVar.gradientList,
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        TextFormField(
                            controller: ConstantVar.nameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723), width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723), width: 5.sp),
                              ),
                              prefixIcon:
                              const Icon(Icons.person, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Name is required !";
                              }
                              return null;
                            }),
                        SizedBox(height: 15.sp),
                        TextFormField(
                            controller: ConstantVar.phoneController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723), width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723), width: 5.sp),
                              ),
                              prefixIcon:
                              const Icon(Icons.phone, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            maxLength: 11,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone is required !";
                              }
                              return null;
                            }),
                        SizedBox(height: 15.sp),
                        TextFormField(
                            controller: ConstantVar.emailController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Academic email',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723), width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723), width: 5.sp),
                              ),
                              prefixIcon:
                              const Icon(Icons.email, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Academic email is required !";

                              }
                              if (!value.contains("@")&&
                                  !value.contains("o6u")&&
                                  !value.contains(".")&&
                                  !value.contains("edu")&&
                                  !value.contains(".")&&
                                  !value.contains("eg")
                              ) {
                                return "Academic email is wrong !";
                              }
                              return null;
                            }),
                        SizedBox(height: 15.sp),
                        TextFormField(
                            controller: ConstantVar.gmailController,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Gmail',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF3E2723),
                                    width: 2,
                                  )),
                              labelStyle: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF3E2723), width: 2),
                              ),
                              prefixIcon: Icon(Icons.email, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Gmail is required !";
                              }
                              if (value.contains("@")&&
                                  value.contains("gmail")&&
                                  value.contains(".")&&
                                  value.contains("com")){
                                return "Gmail is wrong !";
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 15.sp),
                        TextFormField(
                            controller: ConstantVar.passwordController1,
                            textInputAction: TextInputAction.done,
                            obscureText: state.isObscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                              const Icon(Icons.lock, color: Colors.brown),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    color: Colors.brown,
                                    state.isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                onPressed: () {
                                  context.read<RegisterCubit>().toggleObscureText();
                                },
                              ),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password is required !";
                              }
                              else if (value.length>=10 &&
                                  !value.contains("@")||
                                  !value.contains("_")) {
                                return "Password is weak !";
                              }
                              return null;
                            }
                        ),
                        SizedBox(height: 10.sp),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: ()  {
                              register();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.sp, vertical: 5.0.sp),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0.sp)),
                            ),
                            child: Text(
                              "Register",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void register()  {
    String gmail = ConstantVar.gmailController.text;
    String email = ConstantVar.emailController.text;
    String password = ConstantVar.passwordController1.text;
    String phone = ConstantVar.phoneController.text;
    String name = ConstantVar.nameController.text;
    cubit.createAccount(
        gmail:gmail,
        email:email,
        password:password,
        phone:phone,
        name:name);

  }

  void onRegisterSuccess() {
    toast("Account Created.");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void onStatChange(state) {
    if (state is RegisterSuccessState) {
      onRegisterSuccess();
    } else if (state is RegisterFailureState) {
      if (kDebugMode) {
        print(state.errorMessage);
      }
    }
  }


}

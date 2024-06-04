import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../login/page/login_screen.dart';
import '../../models.dart';
import '../../profile/page/profile_screen.dart';
import '../../table/page/table_screen.dart';
import '../manager/home_cubit.dart';
import '../manager/home_state.dart';
import 'dart:async';


final cubit = HomeCubit();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void refresh() {
    setState(() {
      // Trigger a rebuild of the screen
    });
  }
  @override
  void initState() {
    super.initState();
    cubit.getPeriods();
    cubit.getRooms();
    Future.delayed(const Duration(seconds: 5), () {
    cubit.checkSchedule();
    });
    Future.delayed(const Duration(seconds: 5), () {
      cubit.setData();
      cubit.fetchData(0);

    });
  }
  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ConstantVar.backgroundPage,
      appBar: AppBar(
        backgroundColor: ConstantVar.backgroundPage,
        
        iconTheme: const IconThemeData(color: ConstantVar.backgroundPage),
        title: GradientText(
          'Home',
          style: GoogleFonts.eagleLake(fontSize: 20.sp),
          gradientType: GradientType.linear,
          colors: ConstantVar.gradientList,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TableScreen(),
                  ));
            },
            style: ElevatedButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0.sp, vertical: 5.0.sp),
                backgroundColor: ConstantVar.backgroundPage,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.sp))),
            child: GradientText('Schedule',
                style: GoogleFonts.eagleLake(fontSize: 17.sp),
                colors: ConstantVar.gradientList),
          ),
          SizedBox(width: 20.sp),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ConstantVar.gradientList,
              ).createShader(bounds);
            },
            child: IconButton(
              iconSize: 20.sp,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person),
            ),
          ),
          SizedBox(width: 20.sp),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ConstantVar.gradientList,
              ).createShader(bounds);
            },
            child: IconButton(
              iconSize: 20.sp,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => cubit,
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) {
            return current is Reload||
             current is GetRoomsSuccessState||
             current is AddRoomsSuccessState||
             current is DeleteRoomsSuccessState||
             current is UpdateRoomsSuccessState;
          },
          builder: (context, state) {
                  return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: rooms.length ,
                        itemBuilder: (context, index) {
                        return listRooms(index);
                    },
               );
          },
        ),
      ),
    );
  }
  Widget listRooms(int index)   {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(15.sp),
          height: 60.sp,
          width:  58.sp,
          color: Color.fromRGBO(rooms[index].color[0], rooms[index].color[1], rooms[index].color[2], 1),
        ),
        Column(
          children: [
            Text(
              "${rooms[index].name} ",
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500, color: Colors.white),
             ),
            SizedBox(height: 10.sp),
            Text(
              'In schedule : ${rooms[index].inSchedule}',
              style:  TextStyle(fontSize: 17.sp,
                  fontWeight: FontWeight.w500, color: Colors.white),
            ),
            SizedBox(height: 10.sp),
            Image.asset(
              "assets/Container_background.png",
              // imageUrl:
              // "https://www.sisaairconditioning.com.au/wp-content/uploads/2021/12/Ducted-Air-Conditioning-Adelaide.png",
              width: 51.sp,
            ),
            SizedBox(height: 10.sp),
            Text(
              "Number of People: ${rooms[index].noOfpeople}",
              style:
               TextStyle(fontSize: 17.sp,fontWeight: FontWeight.w500, color: Colors.white),
            ),
            SizedBox(height: 10.sp),
            Text(
              "Temp: ${rooms[index].temp}",
              style:
              TextStyle(fontSize: 17.sp,fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ),
      ],
    );
    }


  }

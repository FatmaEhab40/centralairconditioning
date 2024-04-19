import 'package:cached_network_image/cached_network_image.dart';
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

final cubit =HomeCubit();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    cubit.getRooms();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantVar.backgroundPage,
      appBar: AppBar(
        backgroundColor: ConstantVar.backgroundPage,
        iconTheme: const IconThemeData(
          color: ConstantVar.backgroundPage,
        ),
        title:GradientText(
          'Home',
          style: GoogleFonts.eagleLake(fontSize: 20.sp),
          gradientType: GradientType.linear,
          colors: ConstantVar.gradientList,),
        actions: [
          TextButton(
            onPressed: (){ Navigator.push(
                context, MaterialPageRoute(
              builder: (context) => const TableScreen(),));
            },
            style: ElevatedButton.styleFrom(
                padding:  EdgeInsets.symmetric(
                    horizontal: 5.0.sp, vertical: 5.0.sp),
                backgroundColor: ConstantVar.backgroundPage,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.sp)
                )
            ),
            child: GradientText(
                'Table',
                style: GoogleFonts.eagleLake(fontSize: 17.sp),
                colors: ConstantVar.gradientList
            ),
          ),
          SizedBox(width: 20.sp),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return  LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ConstantVar.gradientList,
              ).createShader(bounds);
            },
            child:  IconButton(
              iconSize: 20.sp,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));},
              icon:  const Icon(Icons.person),
            ),
          ),
          SizedBox(width: 20.sp),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return  LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ConstantVar.gradientList,
              ).createShader(bounds);
            },
            child:  IconButton(
              iconSize: 20.sp,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              icon:  const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => cubit,
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) {
            return current is GetRoomsSuccessState ||
                current is DeleteRoomsSuccessState ||
                current is AddRoomsSuccessState ||
                current is UpdateRoomsSuccessState ;
          },
          builder: (context, state) {
            return ListView.builder(
              itemCount:cubit.rooms.length ,
              itemBuilder: (context, index) {
                return listRooms(index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget listRooms(int index) {
    const Color color=Colors.green;

    return Stack(alignment: Alignment.center,
      children: [
        Container(
          margin:  EdgeInsets.all(15.sp),
          padding:  EdgeInsets.all(15.sp),
          height: 45.sp,
          width: 50.sp,
          decoration: const BoxDecoration(
            color: color,
          ),
        ),
        Column(
          children: [
            Text(cubit.rooms[index].name,
              style:  TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              ),
            ),
            SizedBox(height: 10.sp),
            CachedNetworkImage(
              imageUrl:
              "https://www.sisaairconditioning.com.au/wp-content/uploads/2021/12/Ducted-Air-Conditioning-Adelaide.png",
              width: 45.sp,),
          ],
        ),

      ],
    );
  }
}







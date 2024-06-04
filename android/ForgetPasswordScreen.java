class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final cubit = ForgetPasswordCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          onStatChange(state);
        },
        child: Scaffold(
          backgroundColor: ConstantVar.backgroundPage,
          appBar: AppBar(
            backgroundColor: ConstantVar.backgroundPage,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.brown,
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(20.sp),
            padding: EdgeInsets.all(10.sp),
            height: 100.sp,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.sp),
                GradientText(
                  'Forget Password',
                  style: GoogleFonts.eagleLake(fontSize: 25.sp),
                  gradientType: GradientType.linear,
                  colors: ConstantVar.gradientList,
                ),
                SizedBox(height: 20.sp),
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
                      return null;
                    }
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ()  {
                      emailTrue();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0.sp, vertical: 5.0.sp),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0.sp)),
                    ),
                    child: Text("Done",
                      //"Reset Password",
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
    );
  }

  void emailTrue() async {
    String gmail = ConstantVar.gmailController.text;

    cubit.isEmailRegistered(gmail);
  }

  Future<void> onEmailSuccess() async {

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  const LoginScreen()));
  }

  void onStatChange(state) {
    if (state is ForgetPasswordSuccessState) {
      onEmailSuccess();

    } else if (state is ForgetPasswordFailureState) {
      toast(state.errorMessage);
    }
  }

}
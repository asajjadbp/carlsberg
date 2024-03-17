import 'package:carlsberg/Model/response/login_response_model.dart';
import 'package:carlsberg/utills/app_colors_new.dart';
import 'package:flutter/material.dart';

import '../../Model/request/login_request_model.dart';
import '../../Network/http_manager.dart';
import '../../utills/loading_widget.dart';
import '../../utills/user_session.dart';
import '../../widgets/buttons_widgets.dart';
import '../../widgets/toast_message_show.dart';
import '../home/home_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    // setState(() {
    //   // 102114
    //   // BP102114
    //   emailController.text = "10001";
    //   // "101010";
    //   passwordController.text = "888";
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height* 0.4,
                    child: Image.asset(
                      'assets/splash_screen/brandpartners.png',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: AppColors.primaryColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  )),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor, width: 1.0)),
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Username',
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(vertical: 23),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Username required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  )),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor, width: 1.0)),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.black),
                              prefixIcon: const Icon(
                                Icons.lock_open,
                                color: AppColors.primaryColor,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.primaryColor,
                                  )),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 23),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: isPasswordVisible,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          // const SizedBox(height: 2.0),
                          // Align(
                          //   alignment: AlignmentDirectional.centerEnd,
                          //   child: TextButton(
                          //     onPressed: () {
                          //
                          //     },
                          //     child: const Text('Forget Password ?',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.white),),
                          //   ),
                          // ),
                          const SizedBox(height: 12.0),
                          NormalButton(buttonName: "Login",
                          onTap: (){
                            _validateLoginForm();
                          },),
                        ],
                      ))
                ],
              ),
            ),
            if(isLoading)
              const LoaderWidget()
          ],
        ),
      ),
    );
  }

  void _validateLoginForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      HTTPManager()
          .loginUser(LoginRequestModel(
        id: emailController.text,
        password: passwordController.text,
      ))
          .then((value) async {

        LoginResponseModel logInResponseModel = value;
        setState(() {
          isLoading = false;
        });
        showToastMessage(true, "Logged in successfully");
        UserSessionState().setUserSession(
            true,
            logInResponseModel.data![0].id!.toString(),
            logInResponseModel.data![0].fullName!,
            logInResponseModel.data![0].email!);

       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));

      }).catchError((e) {
        showToastMessage(false, e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stady_square/bloc/app_cubit.dart';
import 'package:stady_square/bloc/app_state.dart';
import 'package:stady_square/custom_text_form_field.dart';

class RegisterView extends StatelessWidget {
   RegisterView({Key? key}) : super(key: key);

   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formKey,
                child: Column(
                    children: [
                      Image.asset(
                        'assets/image/logo.png',
                        height: 100,
                        width: 100,
                        fit:  BoxFit.cover,
                      ),
                      const SizedBox(height: 28),

                      CustomTextFormField(
                          controller: usernameController,
                          hintText: "user name",
                          textInputType:
                          TextInputType.text,
                          prefix: Icon(Icons.title , color:Color(0XFFCC5500),),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  "Please enter user name";
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.all(15)),

                      SizedBox(height: 20),

                      CustomTextFormField(
                          controller: fullNameController,
                          hintText: "full name",
                          textInputType:
                          TextInputType.text,
                          prefix: Icon(Icons.title , color:  Color(0XFFCC5500),),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  "Please enter full name";
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.all(15)),

                      SizedBox(height: 20),

                      CustomTextFormField(
                          controller: emailController,
                          hintText: "your email",
                          textInputType:
                          TextInputType.emailAddress,
                          prefix: Icon(Icons.email , color:Color(0XFFCC5500),),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return  "Please enter Email";
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.all(15)),

                      SizedBox(height: 20),

                      CustomTextFormField(
                          controller: passwordController,
                          hintText: "Password",
                          textInputType:
                          TextInputType.text,
                          obscureText: true,
                          prefix: Icon(Icons.lock ,color:Color(0XFFCC5500)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.all(15)),

                      SizedBox(height: 20),

                      CustomTextFormField(
                          controller: phoneController,
                          hintText: "Phone",
                          textInputType: TextInputType.number,
                          prefix: Icon(Icons.call,color: Color(0XFFCC5500)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter phone";
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.all(15)),

                      const SizedBox(height: 25),

                      BlocConsumer<AppCubit, AppState>(
                          builder: (context,state){
                            var cubit = AppCubit.get(context);

                            return (state is LoadingSignUpState)?
                            const CircularProgressIndicator():
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0XFFCC5500))
                              ),
                              onPressed: () {
                                if(formKey.currentState!.validate()){
                                  cubit.signUp(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    userName: usernameController.text,
                                    fullName: fullNameController.text,
                                    phone: phoneController.text
                                  );
                                }
                              },
                              child: const Text(
                                'Sign up',
                                style:
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }, listener: (context,state){
                        if(state is SuccessSignUpState){

                          Navigator.pop(context);
                        }else if(state is ErrorSignUpState){
                          Fluttertoast.showToast(
                            msg: 'Please Enter Vaild Data',
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.TOP,
                            fontSize: 18,
                            textColor: Colors.white,
                          );
                        }

                      }),



                      SizedBox(height: 18),




                      GestureDetector(
                          onTap: () {
                           Navigator.of(context).pop();
                          },
                          child: RichText(
                              text: const TextSpan(children: [
                                TextSpan(
                                  text:
                                  "Do have an account",
                                  style: TextStyle(
                                    color:  Color(0XFFCC5500),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),),
                                TextSpan(text: " "),
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color:Color(0XFFCC5500),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),)
                              ]),
                              textAlign: TextAlign.left)),
                      SizedBox(height: 5)
                    ]))));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/auth/custom_text_form_field.dart';
import 'package:todo_app/auth/register/register.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/home.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login_screen';

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: 'Email',
                      controller: emailController,
                      validator: (text) {
                        ////trim bt filter spaces 2bl w b3d
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Email.';
                        }
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return 'Please Enter Valid Email.';
                        }
                        return null;
                      },

                      ///el @ tzhar fe el key board
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextFormField(
                      label: 'Password',
                      controller: passController,
                      validator: (text) {
                        ////trim bt filter spaces 2bl w b3d
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Password.';
                        }
                        if (text.length < 6) {
                          return 'Password must be at least 6 Characters.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone, //>> numbers & letter
                      //keyboardType: TextInputType.number, //numbers only
                      obscureText: true, //to make it unseen
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          login(context);
                        },
                        child: Text(
                          'Login',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text('Or Create Account'),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void login(BuildContext context) async {
    ///Valid == true , Not Valid == false , lw true hyb2a rg3 null
    /////show loading
    if (formKey.currentState?.validate() == true) {
      try {
        DialogUtils.showLoading(context: context, loadingLabel: 'Waiting');
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
          //hide loading
          //show message
        );
        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            content: 'Login Successfully.',
            title: 'Success',
            posActionName: 'OK',
            posAction: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            });
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              content:
                  'The supplied auth credential is incorrect, malformed or has expired.',
              title: 'Error',
              posActionName: 'OK');
          print(
              'The supplied auth credential is incorrect, malformed or has expired.');
        }
      } catch (e) {
        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            content: e.toString(),
            title: 'Error',
            posActionName: 'OK');
        print(e.toString());
      }
    }
  }
}

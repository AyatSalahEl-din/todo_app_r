import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/custom_text_form_field.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/provider/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  TextEditingController confirmPassController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  bool confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Account',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: 'User Name',
                      controller: nameController,
                      validator: (text) {
                        ////trim bt filter spaces 2bl w b3d
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter User Name.';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Email',
                      controller: emailController,
                      validator: (text) {
                        ////trim bt filter spaces 2bl w b3d
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Email.';
                        }
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
                      obscureText: !passwordVisible, //to make it unseen first
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    CustomTextFormField(
                      label: 'Confirm Password',
                      controller: confirmPassController,
                      validator: (text) {
                        ////trim bt filter spaces 2bl w b3d
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Confirm Password.';
                        }
                        if (text.length < 6) {
                          return 'Password must be at least 6 Characters.';
                        }
                        if (text != passController.text) {
                          return "Passwords Doesn't match";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      obscureText: !confirmPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          register(context);
                        },
                        child: Text('Create Account'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void register(BuildContext context) async {
    ///Valid == true , Not Valid == false , lw true hyb2a rg3 null
    ///show loading

    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(
        context: context,
        loadingLabel: 'Loading...',
      );
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);

        print('before database');
        await FirebaseUtils.addUserToFireStore(myUser);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(myUser);
        print('after database');

        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            content: 'Register Successfully.',
            title: 'Success',
            posActionName: 'OK',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              content: 'The password provided is too weak.',
              title: 'Error',
              posActionName: 'OK');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              content: 'The account already exists for that email.',
              title: 'Error',
              posActionName: 'OK');
          print('The account already exists for that email.');
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
        print(e);
      }
    }
  }
}

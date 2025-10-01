import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spot/core/theme/app_pallete.dart';
import 'package:spot/core/utils/snackbar.dart';
import 'package:spot/features/auth/presentation/Screens/login_page.dart';
import 'package:spot/features/auth/presentation/providers/auth_provider.dart';
import 'package:spot/features/auth/presentation/providers/obscure_provider.dart';
import 'package:spot/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:spot/features/home/presentation/screens/homepage.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  // controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  //values
  String userEmail = "";
  String userPassword = "";
  String userName = "";
  //key
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  //sign-up function
  void _signup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(authProvider.notifier)
          .signup(username: userName, email: userEmail, password: userPassword);

      ref.read(obscureProvider.notifier).state = false;
    }
  }

  //clearing text
  void _clearInputs() {
    _formKey.currentState?.reset();
    setState(() {
      userEmail = '';
      userPassword = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) async {
      if (next is AuthFailure) {
        showSnackBar(context, "Error While Creating User", error: false);
        ref.read(obscureProvider.notifier).state = false;
      } else if (next is AuthSucess) {
        _clearInputs();
        showSnackBar(context, "Signup Successful");
        ref.read(obscureProvider.notifier).state = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      }
    });

    final authState = ref.watch(authProvider);
    return Scaffold(
      body: authState is AuthLoading
          ? CircularProgressIndicator()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 45, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppPallete().primary,
                      child: FaIcon(
                        FontAwesomeIcons.peopleGroup,
                        color: AppPallete().background,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Join spot',
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(color: AppPallete().primary),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(
                      'Music that suits your mood',
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(color: AppPallete().primary),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      keyboardtype: TextInputType.name,
                      hintText: 'Username',
                      controller: usernameController,
                      onSaved: (value) => {userName = value!},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      hintText: 'Email',
                      controller: emailController,
                      keyboardtype: TextInputType.emailAddress,
                      onSaved: (value) => {userEmail = value!},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    AuthTextField(
                      keyboardtype: TextInputType.visiblePassword,
                      hintText: 'Password',
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                      onSaved: (value) => {userPassword = value!},
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete().primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: AppPallete().background,
                                ),
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppPallete().primary)),
                        SizedBox(width: 10),
                        Text('OR', style: TextStyle(height: 2)),
                        SizedBox(width: 10),
                        Expanded(child: Divider(color: AppPallete().primary)),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete().primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(double.infinity, 50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Countinue with',
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                color: AppPallete().background,
                              ),
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(width: 10),
                          FaIcon(
                            FontAwesomeIcons.google,
                            color: AppPallete().background,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(color: AppPallete().other),
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(color: AppPallete().primary),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

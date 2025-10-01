import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:spot/core/theme/app_pallete.dart';
import 'package:spot/core/utils/snackbar.dart';
import 'package:spot/features/auth/presentation/Screens/sign_up_page.dart';
import 'package:spot/features/auth/presentation/providers/auth_provider.dart';
import 'package:spot/features/auth/presentation/providers/obscure_provider.dart';
import 'package:spot/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:spot/features/home/presentation/screens/homepage.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //values
  String userEmail = "";
  String userPassword = "";
  //key
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //login method

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(authProvider.notifier)
          .login(email: userEmail, password: userPassword);
      ref.read(obscureProvider.notifier).state = false;
    }
  }

  //clearing
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
        ref.read(obscureProvider.notifier).state = false;
        showSnackBar(context, "Check The Credentials", error: false);
      } else if (next is AuthSucess) {
        ref.read(obscureProvider.notifier).state = false;
        _clearInputs();
        showSnackBar(context, "Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      }
    });
    return Scaffold(
      body: Container(
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
                keyboardtype: TextInputType.emailAddress,
                hintText: 'Email',
                controller: emailController,
                onSaved: (value) => {userEmail = value!},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Invalid email/password/name";
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
                onSaved: (value) => {userPassword = value!},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Invalid email/password/name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete().primary,
                        fixedSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(color: AppPallete().background),
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
                        textStyle: TextStyle(color: AppPallete().background),
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
                    "New To Spot? ",
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
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up ",
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

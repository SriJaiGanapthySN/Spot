import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spot/core/theme/app_pallete.dart';
import 'package:spot/features/auth/presentation/providers/obscure_provider.dart';

class AuthTextField extends ConsumerWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    required this.keyboardtype,
    required this.validator,
    required this.onSaved,
  });
  final TextInputType keyboardtype;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //provider for obscure text
    final obscure = ref.watch(obscureProvider);
    return TextFormField(
      controller: controller,
      obscureText: obscureText ? obscure : false,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppPallete().primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppPallete().primary),
        ),
        prefixIcon: Icon(
          hintText == 'Email'
              ? Icons.email
              : hintText == 'Username'
              ? Icons.person
              : Icons.lock,
          color: AppPallete().other,
        ),
        suffixIcon: hintText == 'Password'
            ? IconButton(
                icon: obscure
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                color: AppPallete().other,
                onPressed: () {
                  ref.read(obscureProvider.notifier).state = !obscure;
                },
              )
            : null,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

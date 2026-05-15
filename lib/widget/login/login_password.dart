import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:get/get.dart';
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final LoginController loginCtrl;
 
  const PasswordField({
    super.key,
    required this.controller,
    required this.loginCtrl,
  });
 
  @override
  Widget build(BuildContext context) {
    return Obx(() => TextField(
          controller: controller,
          obscureText: !loginCtrl.isPasswordVisible.value,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE89336)),
            ),
            suffixIcon: IconButton(
              onPressed: loginCtrl.togglePasswordVisibility,
              icon: Icon(
                loginCtrl.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:get/get.dart';
class LoginButton extends StatelessWidget {
  final LoginController loginCtrl;
 
  const LoginButton({super.key, required this.loginCtrl});
 
  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: loginCtrl.isLoading.value ? null : loginCtrl.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE89336),
              disabledBackgroundColor:
                  const Color(0xFFE89336).withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: loginCtrl.isLoading.value
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ));
  }
}
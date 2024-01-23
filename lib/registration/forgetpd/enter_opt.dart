import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/registration/forgetpd/reset_password.dart';
import 'package:flutter/material.dart';

class EnterOTP extends StatelessWidget {
  const EnterOTP({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

    void onChanged(String value, int index) {
      final nextIndex = index + 1;
      if (value.isNotEmpty && nextIndex < focusNodes.length) {
        FocusScope.of(context).requestFocus(focusNodes[nextIndex]);
      }
    }

    List<Widget> buildOTPTextField() {
      return List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: SizedBox(
            width: 50,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: TextFormField(
                  focusNode: focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    counter: SizedBox.shrink(),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => onChanged(value, index),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/forgetpassword/1.jpg"),
              const SizedBox(height: 20),
              const Text(
                "Forgot Password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Enter the one-time password sent to your email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildOTPTextField(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the OTP?",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      // Logic to resend OTP
                    },
                    child: const Text("Resend OTP",
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResetPassword()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        CustomColors.gradientStart,
                        CustomColors.gradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: const Text(
                    "Verify",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

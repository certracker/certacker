import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

    void onChanged(String value, int index) {
      final nextIndex = index + 1;
      if (value.isNotEmpty && nextIndex < focusNodes.length) {
        FocusScope.of(context).requestFocus(focusNodes[nextIndex]);
      }
    }

    List<Widget> buildInputFields() {
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Email verification",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32 , fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "We have sent an OTP code to your email and********son@gmail.com. Enter the OTP code below to verify.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: buildInputFields(),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle "Didn't receive email?" logic
                  },
                  child: const Text("Didn't receive email?"),
                ),
                const Text(
                  "You can resend code in 52s",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

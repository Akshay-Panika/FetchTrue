import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  void _sendOtp() async {
    String phone = _phoneController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter valid phone number")));
      return;
    }

    setState(() => _isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91$phone",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed: ${e.message}")));
        setState(() => _isLoading = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              verificationId: verificationId,
              phoneNumber: phone,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login via Phone")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Enter Phone Number", prefixText: "+91 "),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendOtp,
              child: Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}


class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  OtpVerificationScreen({required this.verificationId, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _verifying = false;

  void _verifyOtp() async {
    setState(() => _verifying = true);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _otpController.text.trim(),
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful ✅")));
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP ❌")));
    }

    setState(() => _verifying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("OTP sent to +91-${widget.phoneNumber}"),
            SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter OTP"),
            ),
            SizedBox(height: 20),
            _verifying
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _verifyOtp,
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}

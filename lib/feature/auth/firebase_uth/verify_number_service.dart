import 'package:firebase_auth/firebase_auth.dart';

typedef CodeSentCallback = Future<void> Function(String verificationId);

class VerifyNumberService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  /// 📤 Send OTP to the phone number
  Future<void> sendOtp(
      String phoneNumber, {
        required CodeSentCallback onCodeSent,
      }) async {
       try {
         await _auth.verifyPhoneNumber(
           phoneNumber: '+91$phoneNumber',
           timeout: const Duration(seconds: 30),

           /// Called when verification code is sent
           codeSent: (String verificationId, int? resendToken) async {
             _verificationId = verificationId;
             await onCodeSent(verificationId);
           },

           /// Called if verification completed automatically
           verificationCompleted: (PhoneAuthCredential credential) async {
             // Optional: Handle auto-verification if needed
             await _auth.signInWithCredential(credential);
           },

           /// Called if verification fails
           verificationFailed: (FirebaseAuthException e) {
             throw Exception(e.message ?? "Verification failed");
           },

           /// Called when code timeout
           codeAutoRetrievalTimeout: (String verificationId) {
             _verificationId = verificationId;
           },
           forceResendingToken: null,
         );
       }
       catch (e){
         throw Exception("OTP sending failed: ${e.toString()}");
       }
    }

  /// ✅ Verify OTP entered by user
  Future<bool> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw Exception("Verification ID is missing");
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Invalid OTP");
    }
  }
}

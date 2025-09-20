import 'package:firebase_auth/firebase_auth.dart';

typedef CodeSentCallback = Future<void> Function(String verificationId);
typedef AutoFillCallback = void Function(String? smsCode);

class VerifyNumberService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken; // for reliable resend

  /// 📤 Send OTP
  Future<void> sendOtp(
      String phoneNumber, {
        required CodeSentCallback onCodeSent,
        AutoFillCallback? onVerificationCompleted,
      }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        timeout: const Duration(seconds: 30),
        forceResendingToken: _resendToken,

        codeSent: (String verificationId, int? resendToken) async {
          _verificationId = verificationId;
          _resendToken = resendToken; // store for resend
          await onCodeSent(verificationId);
        },

        verificationCompleted: (PhoneAuthCredential credential) async {
          _verificationId = credential.verificationId;

          if (credential.smsCode != null) {
            onVerificationCompleted?.call(credential.smsCode);
          }

          // Sign in automatically if possible
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.message ?? "OTP verification failed");
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      throw Exception("OTP sending failed: ${e.toString()}");
    }
  }

  /// ✅ Verify OTP manually
  Future<bool> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw Exception("Verification ID missing or expired");
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Invalid OTP");
    }
  }

  /// ✅ Resend OTP
  Future<void> resendOtp(
      String phoneNumber, {
        required CodeSentCallback onCodeSent,
        AutoFillCallback? onVerificationCompleted,
      }) async {
    // OTP invalidate before resending
    invalidateOtp();
    await sendOtp(
      phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationCompleted: onVerificationCompleted,
    );
  }

  /// 🔒 Invalidate OTP manually
  void invalidateOtp() {
    _verificationId = null;
  }
}

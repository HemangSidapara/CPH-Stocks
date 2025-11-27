import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PhoneVerifyService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential phoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException error) verificationFailed,
    required void Function(String verificationId, int? resendToken) codeSent,
    int? forceResendingToken,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: (phoneAuthCredential) {
        log("Verification Completed: ${phoneAuthCredential.toString()}");
        verificationCompleted.call(phoneAuthCredential);
      },
      verificationFailed: (error) {
        log("Verification Failed: ${error.toString()}");
        verificationFailed.call(error);
      },
      codeSent: (String verificationId, int? resendToken) async {
        log("Code sent: VerificationId: $verificationId | Resend Token: $resendToken");
        codeSent.call(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log("Code auto retrieval timeout: $verificationId");
        codeAutoRetrievalTimeout.call(verificationId);
      },
      timeout: 30.seconds,
    );
  }
}

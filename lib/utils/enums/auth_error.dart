import 'package:flutter/material.dart';

enum AuthError {
  failed,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  operationNotAllowed,

  accountExistsWithDifferentCredential, // account-exists-with-different-credential
  invalidCredential, // invalid-credential
  userDisabled, // user-disabled
  userNotFound, // user-not-found
  wrongPassword, // wrong-password
  invalidVerificationCode, // invalid-verification-code
  invalidVerificationId, // invalid-verification-id

  //
  userNameAlreadyInUse,
  phoneAlreadyInUse;

  String textNotation(BuildContext context) {
    switch (this) {
      case failed:
        return 'inst.form_autherror_failed';
      case emailAlreadyInUse:
        return 'inst.form_autherror_emailAlreadyInUse';
      case invalidEmail:
        return 'inst.form_autherror_invalidEmail';
      case weakPassword:
        return 'inst.form_autherror_weakPassword';
      case operationNotAllowed:
        return 'inst.form_autherror_operationNotAllowed';
      case accountExistsWithDifferentCredential:
        return 'inst.form_autherror_accountExistsWithDifferentCredential';
      case invalidCredential:
        return 'inst.form_autherror_invalidCredential';
      case userDisabled:
        return 'inst.form_autherror_userDisabled';
      case userNotFound:
        return 'inst.form_autherror_userNotFound';
      case wrongPassword:
        return 'inst.form_autherror_wrongPassword';
      case invalidVerificationCode:
        return 'inst.form_autherror_invalidVerificationCode';
      case invalidVerificationId:
        return ' inst.form_autherror_invalidVerificationId';
      case userNameAlreadyInUse:
        return ' inst.form_autherror_userNameAlreadyInUse';
      case phoneAlreadyInUse:
        return 'inst.form_autherror_phoneAlreadyInUse';
    }
  }
}

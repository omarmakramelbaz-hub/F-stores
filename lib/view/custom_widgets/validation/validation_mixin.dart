import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../helpers/locale/app_locale_key.dart';

mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  String? validateName(String? value) {
    if (value!.trim().isEmpty) {
      return tr(AppLocaleKey.validateName);
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value!.trim().isEmpty) {
      return tr(AppLocaleKey.validateEmail);
    } else if (!_emailValidationStructure(value.trim())) {
      return tr(AppLocaleKey.validateEmailStructure);
    }
    return null;
  }

  bool _emailValidationStructure(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  String? validatePhone(String? value, {Country? country}) {
    if (value!.trim().isEmpty) {
      return tr(AppLocaleKey.validatePhone);
    } else if (value.startsWith('0')) {
      return tr(AppLocaleKey.validatePhoneStartWithZero);
    } else if (country != null && (value.trim().length != country.example.trim().length)) {
      return tr(AppLocaleKey.validatePhoneContainTenNumbers, args: [country.example.trim().length.toString()]);
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value!.trim().length < 8) {
      return tr(AppLocaleKey.validatePassword);
    }
    return null;
  }

  String _password = '';
  String? validateNewPassword(String? value) {
    _password = value!;
    if (value.trim().length < 6) {
      return tr(AppLocaleKey.validatePassword);
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value!.trim().length < 6) {
      return tr(AppLocaleKey.validatePassword);
    } else if (_password != value) {
      return tr(AppLocaleKey.validateConfirmPassword);
    }
    return null;
  }

  String? validateEmptyField(String? value) {
    if (value!.trim().isEmpty) {
      return tr(AppLocaleKey.validateEmpty);
    }
    return null;
  }

  String? validateEmptyDropDown(dynamic value) {
    if (value == null) {
      return tr(AppLocaleKey.validateEmpty);
    }
    return null;
  }

  String? validateEmptyMultiSelect(List<dynamic>? value) {
    if (value == null) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.isEmpty) {
      return tr(AppLocaleKey.validateEmpty);
    }
    return null;
  }

  String? validateFeeInShowDelegate({
    String? value,
    num kmPrice = 0,
    num percentage = 0,
    num distance = 0,
    num userBalance = 0,
    num actualPrice = 0,
    String? paymentType,
  }) {
    final double minAmount = distance - (distance * (percentage / 100));

    final double? inputValue = double.tryParse(value ?? '0');

    if (inputValue == null) {
      return AppLocaleKey.enterAmount.tr();
    }

    if (inputValue < minAmount) {
      return AppLocaleKey.minimumAmountToDeliver.tr().replaceAll('{}', minAmount.toStringAsFixed(0).toString());
    }
    if (inputValue - actualPrice > userBalance && paymentType == 'wallet') {
      return AppLocaleKey.notEnoughBalance.tr();
    }

    return null;
  }

  String? validateFee({String? value, num kmPrice = 0, num percentage = 0, num distance = 0}) {
    final double minAmount = distance - (distance * (percentage / 100));

    final double? inputValue = double.tryParse(value ?? '0');

    if (inputValue == null) {
      return AppLocaleKey.enterAmount.tr();
    }

    if (inputValue < minAmount) {
      return AppLocaleKey.minimumAmountToDeliver.tr().replaceAll('{}', minAmount.toStringAsFixed(0).toString());
    }

    return null;
  }

  String? validateNationalId(String? value) {
    if (value == null) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.isEmpty) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.length != 14) {
      return tr(AppLocaleKey.validateNationalId);
    }
    return null;
  }

  String? validateDrivingLicense(String? value) {
    if (value == null) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.isEmpty) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.length != 14) {
      return tr(AppLocaleKey.validateDrivingLicense);
    }
    return null;
  }

  String? validateTaxNumber(String? value) {
    if (value == null) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.isEmpty) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.length != 14) {
      return tr(AppLocaleKey.validateTaxNumber);
    }
    return null;
  }

  String? validateCommercialRegistrationNumber(String? value) {
    if (value == null) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.isEmpty) {
      return tr(AppLocaleKey.validateEmpty);
    } else if (value.length != 14) {
      return tr(AppLocaleKey.validateCommercialRegistrationNumber);
    }
    return null;
  }

  String? validateNameFourthly(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocaleKey.validateName.tr();
    }

    List<String> words = value.trim().split(RegExp(r'\s+'));

    if (words.length != 4) {
      return AppLocaleKey.validateNameFourthly.tr();
    }

    return null;
  }

  String? validateVCash(String? value, {Country? country}) {
    if (value!.trim().isEmpty) {
      return tr(AppLocaleKey.validatePhone);
    } else if (value.startsWith('0')) {
      return tr(AppLocaleKey.validatePhoneStartWithZero);
    } else if (!value.startsWith('10')) {
      return tr(AppLocaleKey.validateVCash);
    } else if (country != null && (value.trim().length != country.example.trim().length)) {
      return tr(AppLocaleKey.validatePhoneContainTenNumbers, args: [country.example.trim().length.toString()]);
    } else {
      return null;
    }
  }
}

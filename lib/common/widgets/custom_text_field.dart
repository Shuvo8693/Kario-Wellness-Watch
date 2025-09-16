import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_constant/app_constant.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? obscuringCharacter;
  final Color? fillColor,textColor;
  final Color? suffixIconColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final bool isPassword;
  final int? maxLines;
  final bool isEmail;
  final bool readOnly;
  final TextStyle? labelTextStyle;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.obscuringCharacter,
    this.fillColor ,
    this.suffixIconColor,
    this.prefixIcon,
    this.labelText,
    this.hintText,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.suffixIcon,
    this.validator,
    this.isPassword = false,
    this.maxLines,
    this.isEmail = false,
    this.readOnly = false,
    this.labelTextStyle,
    this.hintStyle,
    this.inputFormatters,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.onFieldSubmitted, this.textColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? _getDefaultKeyboardType(),
      obscuringCharacter: widget.obscuringCharacter ?? '*',
      maxLines: widget.isPassword ? 1 : (widget.maxLines ?? 1),
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator ?? _getDefaultValidator(),
      cursorColor: AppColors.primaryColor,
      obscureText: _obscureText,
      style: TextStyle(
        color: widget.textColor?? AppColors.black,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal ?? 20.w,
          vertical: widget.contentPaddingVertical ?? 20.w,
        ),
        fillColor: widget.fillColor ?? AppColors.white,
        filled: true,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: widget.prefixIcon,
        )
            : null,
        suffixIcon: _buildSuffixIcon(),
        prefixIconConstraints: BoxConstraints(
          minHeight: 24.w,
          minWidth: 24.w,
        ),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        labelStyle: widget.labelTextStyle,
        // border: _getDefaultBorder(),
        // enabledBorder: _getDefaultBorder(),
        // focusedBorder: _getDefaultBorder(),
        // errorBorder: _getDefaultBorder(isError: true),
        // focusedErrorBorder: _getDefaultBorder(isError: true),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return GestureDetector(
        onTap: _toggleObscureText,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: widget.suffixIconColor ?? Colors.black,
            size: 20,
          ),
        ),
      );
    } else if (widget.suffixIcon != null) {
      return Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: widget.suffixIcon,
      );
    }
    return null;
  }

  TextInputType _getDefaultKeyboardType() {
    if (widget.isEmail) return TextInputType.emailAddress;
    if (widget.isPassword) return TextInputType.visiblePassword;
    return TextInputType.text;
  }

  String? Function(String?)? _getDefaultValidator() {
    return (value) {
      final trimmedValue = value?.trim();

      if (trimmedValue?.isEmpty ?? true) {
        return _getEmptyFieldMessage();
      }

      if (widget.isEmail) {
        return _validateEmail(trimmedValue!);
      }

      if (widget.isPassword) {
        return _validatePassword(trimmedValue!);
      }

      return null;
    };
  }

  String _getEmptyFieldMessage() {
    if (widget.hintText != null) {
      return "Please ${widget.hintText!.toLowerCase()}";
    }
    if (widget.labelText != null) {
      return "Please enter ${widget.labelText!.toLowerCase()}";
    }
    return "This field is required";
  }

  String? _validateEmail(String email) {
    if (!AppConstants.emailValidator.hasMatch(email)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (!AppConstants.passwordValidator.hasMatch(password)) {
      return "Password must contain: uppercase, lowercase, number, and special character";
    }
    return null;
  }

  InputBorder _getDefaultBorder({bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: isError ? Colors.red : Colors.grey,
        width: 1.0,
      ),
    );
  }
}
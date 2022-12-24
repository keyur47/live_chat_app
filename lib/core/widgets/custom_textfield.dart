import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final bool readOnly;
  final TextEditingController controller;
  final int maxLine;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final Color? textColor;
  final double? fontSize;
  final int? maxLength;
  final double? radius;
  final bool enabled;
  final bool isPassword;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final TextStyle? labelStyle;
  final Color? hintTextColor;
  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final Color? disableBorderColor;
  final double? hintFontSize;
  final FontWeight? hintTextWeight;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final VoidCallback? onTap;
  final Color? enableColor;
  final Color? focusedColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsets? scrollPadding;
  final Widget? prefixWidget;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  CustomTextField(
      {Key? key,
      this.onChanged,
      this.maxLine = 1,
      this.maxLength,
      this.radius,
      this.fontSize,
      this.fillColor,
      this.textColor,
      this.isPassword = false,
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.hintText,
      this.labelText,
      this.labelStyle,
      this.hintTextColor,
      this.hintFontSize,
      this.hintTextWeight,
      this.textAlign,
      this.textAlignVertical,
      this.prefixIcon,
      this.suffixIcon,
      this.onTap,
      this.enableColor,
      this.focusedColor,
      this.cursorColor,
      required this.controller,
      this.contentPadding,
      this.prefixWidget,
      this.readOnly = false,
      this.textCapitalization,
      this.scrollPadding,
      this.validator,
      this.inputFormatters,
      this.disableBorderColor,
      this.enableBorderColor,
      this.focusBorderColor,
      this.initialValue})
      : super(key: key);

  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(radius ?? 10),
      child: ValueListenableBuilder(
          valueListenable: _isObscure,
          builder: (context, bool isObscure, _) {
            if (!isPassword) {
              isObscure = false;
            }
            return Container(
              height: SizeUtils.horizontalBlockSize * 15,
              decoration: const BoxDecoration(),
              child: TextFormField(
                initialValue: initialValue,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.none,
                readOnly: readOnly,
                style: TextStyle(
                    color: textColor ?? AppColors.black,
                    fontSize: fontSize ?? SizeUtils.fSize_16(),
                    fontWeight: FontWeight.w400),
                onTap: onTap,
                obscureText: isObscure,
                obscuringCharacter: '*',
                onChanged: onChanged,
                controller: controller,
                maxLines: maxLine,
                maxLength: maxLength,
                keyboardType: keyboardType,
                focusNode: focusNode,
                textAlignVertical: textAlignVertical,
                cursorColor: cursorColor ?? AppColors.teamColor,
                textAlign: textAlign ?? TextAlign.start,
                enabled: enabled,
                validator: validator,
                scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                    labelStyle: labelStyle,
                    labelText: labelText,
                    prefix: prefixWidget,
                    contentPadding: contentPadding ??
                        EdgeInsets.only(
                            top: SizeUtils.verticalBlockSize * 5,
                            right: SizeUtils.verticalBlockSize * 2,
                            left: SizeUtils.verticalBlockSize * 2),
                    isDense: true,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon == null && isPassword
                        ? IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility,
                              size: SizeUtils.verticalBlockSize * 2.5,
                              //  color: AppColors.darkGreyColor,
                            ),
                            onPressed: () {
                              _isObscure.value = !isObscure;
                            },
                          )
                        : suffixIcon,
                    counterText: "",
                    // contentPadding: const EdgeInsets.all(12),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      //color: hintTextColor ?? AppColors.buttonColor,
                      fontSize: hintFontSize ?? SizeUtils.fSize_16(),
                      fontWeight: hintTextWeight ?? FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: fillColor ?? AppColors.white,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius ?? 25),
                      ),
                      borderSide: BorderSide(
                          color: disableBorderColor ?? AppColors.buttonColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius ?? 25),
                      ),
                      borderSide: BorderSide(
                        color: enableBorderColor ?? AppColors.buttonColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(radius ?? 25)),
                        borderSide: BorderSide(
                            color: focusBorderColor ?? AppColors.buttonColor,
                            width: 1.5)),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(radius ?? 25)),
                      borderSide: const BorderSide(
                        color: AppColors.buttonColor,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(radius ?? 25)),
                      borderSide: const BorderSide(
                          color: AppColors.buttonColor, width: 1.5),
                    )),
              ),
            );
          }),
    );
  }
}

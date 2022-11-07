import 'package:actual/common/const/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {

  final String? hintText;
  final String? errorText;
  final bool? obscureText;
  final bool? autoFocus;
  final ValueChanged<String>? onChanged;

  CustomTextFormField({
    Key? key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autoFocus = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextFormField 테두리 씌울 때
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    // 시뮬레이터레서 TextFormField 키보드 안 올라 올 때
    // 'shift+command+k'
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText!, // 입력 중인 텍스트를 대치할 텍스트 사용 유무
      autofocus: false,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        filled: true, // TextField BG Color
        fillColor: INPUT_BG_COLOR,
        border: baseBorder, // 모든 Input 상태의 기본 세팅
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          // Widget.copyWith() => 해당 위젯의 속성 및 데이터 복사
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),// TextFormField Focus 상태일 때
      ),
    );
  }
}

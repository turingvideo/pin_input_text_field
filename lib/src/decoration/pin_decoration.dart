import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pin_input_text_field/src/cursor/cursor_painter.dart';
import 'package:pin_input_text_field/src/util/radius_util.dart';

import '../util/utils.dart';

part 'decoration_boxloose.dart';
part 'decoration_boxtight.dart';
part 'decoration_circle.dart';
part 'decoration_underline.dart';

enum PinEntryType { underline, boxTight, boxLoose, circle, customized }

class SupportGap {
  /// The adjacent box gap.
  double get getGapWidth => 0;

  /// The gaps between every two adjacent box, higher priority than [gapSpace].
  List<double>? get getGapWidthList => const [];
}

abstract class PinDecoration {
  /// The style of painting text.
  final TextStyle? textStyle;

  /// The style of obscure text.
  final ObscureStyle? obscureStyle;

  /// The error text that will be displayed if any error
  final String? errorText;

  /// The style of error text.
  final TextStyle? errorTextStyle;

  final String? hintText;

  final TextStyle? hintTextStyle;

  /// Text painted between every two adjacent pin cells.
  ///
  /// When null or empty, no separator is drawn.
  final String? separator;

  // The background color of index character
  final ColorBuilder? baseBgColorBuilder;

  PinEntryType get pinEntryType;

  const PinDecoration({
    this.textStyle,
    this.obscureStyle,
    this.errorText,
    this.errorTextStyle,
    this.hintText,
    this.hintTextStyle,
    this.separator,
    this.baseBgColorBuilder,
  });

  void drawPin(
    Canvas canvas,
    Size size,
    String text,
    int pinLength,
    Cursor? cursor,
    TextDirection textDirection,
  );

  void notifyChange(String pin);

  /// Creates a copy of this pin decoration with the given fields replaced
  /// by the new values.
  PinDecoration copyWith({
    TextStyle? textStyle,
    ObscureStyle? obscureStyle,
    String? errorText,
    TextStyle? errorTextStyle,
    String? hintText,
    TextStyle? hintTextStyle,
    ColorBuilder? bgColorBuilder,
  });

  PinDecoration withSeparator(String? separator) => this;

  void drawSeparators(
    Canvas canvas,
    List<double> centerXs,
    double mainHeight,
    TextDirection textDirection,
  ) {
    final separatorText = separator;
    if (separatorText == null || separatorText.isEmpty) return;

    final textPainter = TextPainter(
      text: TextSpan(style: textStyle, text: separatorText),
      textAlign: TextAlign.center,
      textDirection: textDirection,
    )..layout();

    final startY = mainHeight / 2 - textPainter.height / 2;
    for (final centerX in centerXs) {
      textPainter.paint(
        canvas,
        Offset(centerX - textPainter.width / 2, startY),
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PinDecoration &&
          runtimeType == other.runtimeType &&
          textStyle == other.textStyle &&
          obscureStyle == other.obscureStyle &&
          errorText == other.errorText &&
          errorTextStyle == other.errorTextStyle &&
          hintText == other.hintText &&
          hintTextStyle == other.hintTextStyle &&
          separator == other.separator &&
          baseBgColorBuilder == other.baseBgColorBuilder;

  @override
  int get hashCode =>
      textStyle.hashCode ^
      obscureStyle.hashCode ^
      errorText.hashCode ^
      errorTextStyle.hashCode ^
      hintText.hashCode ^
      hintTextStyle.hashCode ^
      separator.hashCode ^
      baseBgColorBuilder.hashCode;

  @override
  String toString() {
    return 'PinDecoration{textStyle: $textStyle, obscureStyle: $obscureStyle, errorText: $errorText, errorTextStyle: $errorTextStyle, hintText: $hintText, hintTextStyle: $hintTextStyle, separator: $separator, bgColorBuilder: $baseBgColorBuilder}';
  }
}

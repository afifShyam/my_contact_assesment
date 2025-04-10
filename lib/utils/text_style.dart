import 'package:flutter/material.dart'; // ✅ brings in correct TextStyle
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleShared {
  TextStyleShared._();

  static const TextStyleVariationBak textStyle = TextStyleVariationBak();
}

class TextStyleVariationBak {
  const TextStyleVariationBak();

  TextStyle get title => GoogleFonts.raleway().copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey[900],
      );

  TextStyle get subtitle => GoogleFonts.raleway().copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );

  TextStyle get bodyMedium => GoogleFonts.raleway().copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  TextStyle get bodySmall => GoogleFonts.raleway().copyWith(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  TextStyle get button => GoogleFonts.raleway().copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );
}

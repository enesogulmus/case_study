import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String txt;
  final Color? clr;
  final double? fontSZ;
  final FontWeight? fontWght;
  final double? lttrSpcng;
  final int? mxLns;
  final TextAlign? txtAlgn;
  final double? hght;
  final TextOverflow? vrflw;

  const CustomText({
    super.key,
    required this.txt,
    this.clr,
    this.fontSZ,
    this.fontWght,
    this.lttrSpcng,
    this.mxLns,
    this.txtAlgn,
    this.hght, this.vrflw,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      maxLines: mxLns,
      textAlign: txtAlgn ?? TextAlign.start,
      style: TextStyle(
        height: hght,
        overflow: vrflw,
        letterSpacing: lttrSpcng,
        color: clr ?? Colors.black,
        fontSize: fontSZ ?? 17,
        fontFamily: 'DM Sans',
        fontWeight: fontWght ?? FontWeight.w700,
      ),
    );
  }
}

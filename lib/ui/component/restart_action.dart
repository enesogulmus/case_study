import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../generated/assets.dart';
import 'custom_text.dart';

class RestartAction extends StatelessWidget {
  final Function() function;

  const RestartAction({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: function,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(Assets.assetsReload),
            const CustomText(
              txt: 'Beklenmedik bir hata oluştu, lütfen yeniden deneyin!',
              clr: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

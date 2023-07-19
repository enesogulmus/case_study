import 'package:case_study/generated/assets.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class SplashUI extends StatefulWidget {
  const SplashUI({super.key});

  @override
  State<SplashUI> createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeUI(),)),);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 0,left: 0,child: Image.asset(Assets.assetsSplashTop),),
          Image.asset(Assets.assetsSplashLogo),
          Positioned(bottom: 0,right:0,child: Image.asset(Assets.assetsSplashBottom),),
        ],
      ),
    );
  }
}

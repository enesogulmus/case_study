import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locator.dart';
import 'ui/splash.dart';
import 'viewModel/home/home_viewmodel.dart';
import 'viewModel/home/home_viewmodel_imp.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      const MyApp(),
    );
  });
}

final homeViewModelImp = ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModelImp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: SplashUI(),
      ),
    );
  }
}

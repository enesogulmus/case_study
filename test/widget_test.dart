// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:case_study/core/api/api_response.dart';
import 'package:case_study/core/model/get_most_popular.dart';
import 'package:case_study/ui/home.dart';
import 'package:case_study/ui/splash.dart';
import 'package:case_study/viewModel/home/home_viewmodel.dart';
import 'package:case_study/viewModel/home/home_viewmodel_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:case_study/main.dart';
import 'package:mockito/mockito.dart';

class MockHomeViewModel extends Mock implements HomeViewModel {}

void main() {
  final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModelImp());
  final mockHomeViewModelProvider = ChangeNotifierProvider<MockHomeViewModel>((ref) => MockHomeViewModel());
  final List<Result> result = [
    Result(
        publishedDate: DateTime(
          2023,
        ),
        section: '',
        title: '',
        resultAbstract: '')
  ];
  testWidgets('Test home screen', (WidgetTester tester) async {
    // HomeViewModel'i taklit eden bir mock oluşturun
    final mockHomeViewModel = MockHomeViewModel();

    // MyApp'i oluştur
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeViewModelProvider.overrideWithProvider(mockHomeViewModelProvider),
        ],
        child: const MyApp(),
      ),
    );

    // SplashUI'nin ekranda olduğunu doğrula
    expect(find.byType(SplashUI), findsOneWidget);

// mockHomeViewModel.getMostPopular metodu çağrıldığında bir yanıt döndürün
    when(mockHomeViewModel.getMostPopular()).thenAnswer((_) async {
     ApiResponse.completed(result);// Geçici bir örnek yanıt döndürme
    });

    // HomeUI'nin ekranda olduğunu doğrula
    await tester.pumpAndSettle();
    expect(find.byType(HomeUI), findsOneWidget);

    // HomeViewModel'in getMostPopular metodunun çağrıldığını doğrula
    verify(mockHomeViewModel.getMostPopular()).called(1);
  });

  test('Test quickSort', () {
    final homeViewModelImp = HomeViewModelImp();
    List<Result> list = [
      Result(
        publishedDate: DateTime(2023, 7, 12),
        section: '',
        title: '',
        resultAbstract: '',
      ),
      Result(
        publishedDate: DateTime(2023, 7, 14),
        section: '',
        title: '',
        resultAbstract: '',
      ),
      Result(
        publishedDate: DateTime(2023, 7, 10),
        section: '',
        title: '',
        resultAbstract: '',
      ),
    ];

    homeViewModelImp.quickSort(list, 0, list.length - 1);

    expect(list[0].publishedDate, DateTime(2023, 7, 10));
    expect(list[1].publishedDate, DateTime(2023, 7, 12));
    expect(list[2].publishedDate, DateTime(2023, 7, 14));
  });
}

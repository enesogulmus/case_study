import 'dart:ui';

import 'package:case_study/core/api/api_response.dart';
import 'package:case_study/core/extensions/status.dart';
import 'package:case_study/core/theme/colors.dart';
import 'package:case_study/ui/component/custom_text.dart';
import 'package:case_study/ui/component/restart_action.dart';
import 'package:case_study/ui/newsteller_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../core/model/get_most_popular.dart';
import '../generated/assets.dart';
import '../main.dart';
import '../viewModel/home/home_viewmodel.dart';

class HomeUI extends ConsumerStatefulWidget {
  const HomeUI({super.key});

  @override
  ConsumerState<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends ConsumerState<HomeUI> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late HomeViewModel viewModel;
  late List<Result> data;

  void quickSort(List<Result> list, int low, int high) {
    if (low < high) {
      int pivotIndex = partition(list, low, high);
      quickSort(list, low, pivotIndex - 1);
      quickSort(list, pivotIndex + 1, high);
    }
  }

  int partition(List<Result> list, int low, int high) {
    String pivot = list[high].publishedDate.toString();
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].publishedDate.toString().compareTo(pivot) <= 0) {
        i++;
        swap(list, i, j);
      }
    }

    swap(list, i + 1, high);
    return i + 1;
  }

  void swap(List<Result> list, int i, int j) {
    Result temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  Future<void> init() async {
    viewModel = ref.read(homeViewModelImp);
    await viewModel.getMostPopular().then(
      (value) {
        if (viewModel.getMostPopularResponse.isCompleted()) {
          data = viewModel.getMostPopularResponse.data.results;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(homeViewModelImp);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(Assets.assetsAppBarLogo),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              txt: 'Latest News',
            ),
            const SizedBox(
              height: 16,
            ),
            viewModel.getMostPopularResponse.isError()
                ? RestartAction(
                    function: () {
                      viewModel.getMostPopularResponse = ApiResponse.loading('loading');
                      init();
                    },
                  )
                : buildList(),
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    switch (viewModel.getMostPopularResponse.status) {
      case Status.completed:
        return Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            header: WaterDropHeader(
              waterDropColor: Clrs.accentColor,
            ),
            onRefresh: () => Future.delayed(
                const Duration(
                  milliseconds: 500,
                ),
                () => viewModel.refreshHome()),
            child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewstellerDetailUI(data: data[index]),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width / 5),
                              height: (MediaQuery.of(context).size.width / 5),
                              child: (data[index].media?.isNotEmpty ?? false)
                                  ? Image.network(
                                      data[index].media![0].mediaMetadata[0].url,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          // Yükleme tamamlandıysa, resmi göster
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Clrs.accentColor,
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          // Arkaplanı ayarlamak için bir Container kullanıyoruz
                                          color: Colors.grey,
                                        ),
                                        Positioned.fill(
                                          child: BackdropFilter(
                                            // Gerçek blurlu efekti sağlamak için BackdropFilter kullanıyoruz
                                            filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                                            child: Container(
                                              // Blurlu görüntüyü içeren konteyner
                                              color: Colors.transparent, // Arka planı şeffaf yapıyoruz
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  txt: data[index].section,
                                  clr: Clrs.accentColor,
                                  fontSZ: 10,
                                  hght: 2,
                                  lttrSpcng: -0.24,
                                  mxLns: 1,
                                ),
                                CustomText(
                                  txt: data[index].title,
                                  clr: Colors.black,
                                  mxLns: 2,
                                  hght: 2,
                                  vrflw: TextOverflow.ellipsis,
                                  fontSZ: 12,
                                  lttrSpcng: -0.24,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                itemCount: data.length),
          ),
        );
      default:
        return Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
            itemCount: 7, // Kaç tane shimmer gösterileceğini belirleyin
            itemBuilder: (context, index) => Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(right: 10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}

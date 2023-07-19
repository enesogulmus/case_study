import 'dart:ui';

import 'package:case_study/core/theme/colors.dart';
import 'package:case_study/ui/component/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../core/model/get_most_popular.dart';
import '../generated/assets.dart';

class NewstellerDetailUI extends ConsumerStatefulWidget {
  final Result data;

  const NewstellerDetailUI({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<NewstellerDetailUI> createState() => _NewstellerDetailUIState();
}

class _NewstellerDetailUIState extends ConsumerState<NewstellerDetailUI> {
  late Result data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(onTap: () => Navigator.of(context).pop(), child: SvgPicture.asset(Assets.assetsBack, fit: BoxFit.none)),
        title: Image.asset(
          Assets.assetsAppBarLogo,
        ),
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
            Align(alignment: Alignment.centerRight,child: CustomText(txt: DateFormat('yyyy-MM-dd').format(data.publishedDate).toString(),clr: Colors.grey,),),
            CustomText(
              txt: data.section,
              clr: Clrs.accentColor,
              fontSZ: 10,
              hght: 2,
              lttrSpcng: -0.24,
            ),
            CustomText(
              txt: data.title,
              clr: Colors.black,
              fontSZ: 14,
              hght: 2,
              lttrSpcng: -0.24,
            ),
            const SizedBox(
              height: 16,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                height: (MediaQuery.of(context).size.width - 60) * 0.66,
                child: (data.media?.isNotEmpty ?? false)
                    ? Image.network(
                        data.media![0].mediaMetadata[2].url,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
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
                            color: Colors.grey,
                          ),
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomText(
              txt: 'DESCRIPTIONS',
              clr: Clrs.accentColor,
              fontSZ: 10,
              lttrSpcng: -0.24,
              hght: 2,
            ),
            CustomText(
              txt: data.resultAbstract,
              clr: Colors.black,
              fontSZ: 13.5,
              lttrSpcng: -0.24,
              hght: 2,
            )
          ],
        ),
      ),
    );
  }
}

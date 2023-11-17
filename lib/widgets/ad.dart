import 'package:adivery/adivery_ads.dart';
import 'package:flutter/material.dart';
import 'package:wallmall/core/ad.dart';
import 'package:wallmall/widgets/loading.dart';

class AdWidget extends StatefulWidget {
  const AdWidget({
    super.key,
  });

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  bool loaded = false;
  NativeAd? nativeAd;

  @override
  void initState() {
    super.initState();

    print("new ad");

    nativeAd = ad.native(
      onLoad: () {
        setState(() {
          loaded = true;
        });

        print("Loaded");
      },
      onError: (String error) => print("Errored"),
    );

    nativeAd!.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return loaded == false && nativeAd == null
        ? const LoadingWidget(
            width: double.infinity,
            height: 100,
          )
        : InkWell(
            onTap: () {
              nativeAd!.recordClick();
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  if (nativeAd!.image != null)
                    Positioned(
                      child: nativeAd!.image!,
                    ),
                  if (nativeAd!.icon != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: nativeAd!.icon!,
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}

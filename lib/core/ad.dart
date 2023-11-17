import 'package:adivery/adivery.dart';
import 'package:adivery/adivery_ads.dart';

class _Ad {
  final String _appId = "e4361723-2c0c-427d-8529-1c59c5266676";
  final String _nativePositionId = "65f618f3-44fc-4962-a49d-4dc883ae900f";

  void init() {
    AdiveryPlugin.initialize(_appId);
  }

  NativeAd native({
    required Function onLoad,
    Function(String)? onError,
  }) {
    var ad = NativeAd(
      _nativePositionId,
      onAdLoaded: () => onLoad(),
      onError: onError,
    );

    return ad;
  }
}

// ignore: library_private_types_in_public_api
_Ad ad = _Ad();

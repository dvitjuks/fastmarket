import 'package:app/app/utils/image_cache_manager/image_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class CTCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit? fit;
  final PlaceholderWidgetBuilder? placeholder;
  final double? height;
  final double? width;

  CTCachedNetworkImage(
      {this.imageUrl, this.fit, this.placeholder, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final image = imageUrl;
    if (image != null)
      return CachedNetworkImage(
          imageUrl: image,
          fit: fit,
          height: height,
          width: width,
          placeholder: placeholder,
          cacheManager: OneYearImageCacheManager.instance);
    else
      return const SizedBox();
  }
}

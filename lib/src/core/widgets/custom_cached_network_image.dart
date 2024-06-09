import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.imageBuilder,
  });

  final String imageUrl;
  final ImageWidgetBuilder? imageBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.contain,
      imageUrl: imageUrl,
      imageBuilder: imageBuilder,
    );
  }
}

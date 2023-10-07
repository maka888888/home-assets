import 'package:flutter/material.dart';
import 'package:home_assets3/models/asset_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AssetGalleryScreen extends StatelessWidget {
  final AssetModel asset;
  const AssetGalleryScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(asset.images[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          //heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
        );
      },
      itemCount: asset.images.length,
      loadingBuilder: (context, event) => const Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
              // value: event == null
              //     ? 0
              //     : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
        ),
      ),
      //backgroundDecoration: widget.backgroundDecoration,
      //pageController: widget.pageController,
      //onPageChanged: onPageChanged,
    );
  }
}

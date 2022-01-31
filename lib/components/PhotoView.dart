// ignore_for_file: file_names, void_checks, always_use_package_imports

import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

import 'compackages.dart';

class PhotoViewPage extends StatelessWidget {
  final String? image;

  const PhotoViewPage({this.image});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
                child: PhotoView(
              enableRotation: true,
              minScale: 0.4,
              maxScale: 2.0,
              imageProvider: CachedNetworkImageProvider(
                image!,
                errorListener: () {
                  const Icon(Icons.error_outline, color: Colors.white);
                },
              ),
              tightMode: true,
              errorBuilder: (context, url, error) => const Icon(Icons.error_outline),
              loadingBuilder: (context, url) => Center(child: spinKit()),
            )),
            Positioned(
              right: 20.0,
              top: 20.0,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(CupertinoIcons.xmark_circle, color: Colors.white, size: 40)),
            ),
          ],
        ),
      ),
    );
  }
}

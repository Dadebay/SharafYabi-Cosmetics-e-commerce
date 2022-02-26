// ignore_for_file: file_names

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:video_player/video_player.dart';

class VideoPLayerMine extends StatefulWidget {
  final String? videoURL;

  const VideoPLayerMine({Key? key, this.videoURL}) : super(key: key);

  @override
  State<VideoPLayerMine> createState() => _VideoPLayerMineState();
}

class _VideoPLayerMineState extends State<VideoPLayerMine> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.videoURL!),
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(IconlyLight.arrowLeftCircle, color: Colors.white, size: 30),
            ),
          ),
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: FlickVideoPlayer(
                        flickVideoWithControls: FlickVideoWithControls(
                          controls: FlickPortraitControls(
                            progressBarSettings: FlickProgressBarSettings(),
                          ),
                        ),
                        preferredDeviceOrientation: [
                          DeviceOrientation.portraitDown,
                          DeviceOrientation.portraitUp,
                        ],
                        preferredDeviceOrientationFullscreen: [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
                        // flickVideoWithControlsFullscreen: ,
                        flickManager: flickManager),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

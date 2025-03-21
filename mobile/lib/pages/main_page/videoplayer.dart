import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerBlock extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerBlock({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerBlockState createState() => _VideoPlayerBlockState();
}

class _VideoPlayerBlockState extends State<VideoPlayerBlock> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Обновляем виджет после инициализации
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: false,
          looping: false,
        );
      });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoPlayerController.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    // Оборачиваем в ClipRRect для закругления углов
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Можно изменить радиус по необходимости
      child: AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}

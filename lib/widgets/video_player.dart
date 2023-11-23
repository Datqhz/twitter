import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/shared/loading.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  Video({required this.url});
  final String url;
  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;
  late int duration;
  bool _isMute = false;
  
  @override
  void initState() {
    this.initState();
    _controller = VideoPlayerController.asset(
      widget.url
    )..initialize();
  }

  bool isMute(){
    return _isMute;
  }

  void mute(){
    if(_isMute){
      _controller.setVolume(1);
    }else {
      _controller.setVolume(0);
    }
    _isMute = !_isMute;
  }
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

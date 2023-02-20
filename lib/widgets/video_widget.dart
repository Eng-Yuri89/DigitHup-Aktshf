import 'package:e_learning/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VideoWidget extends StatefulWidget {
  final int videoId;

  VideoWidget({required this.videoId});

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  var _disposed = false;
  var _isFullScreen = false;

  void _toggleFullscreen() async {
    if (_isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

  void _enterFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = true;
    });
  }

  void _exitFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = false;
    });
  }

  Widget _playView(BuildContext context) {
    return AspectRatio(
      aspectRatio: _isFullScreen ? 2 : 16.0 / 12.0,
      child: Stack(
        children: <Widget>[
          VimeoPlayer(
            videoId: '${widget.videoId}',
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: Container(
                color: Colors.black26,
                margin: const EdgeInsets.only(right: 5,bottom: 5),
                child: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              onPressed: _toggleFullscreen,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if(_isFullScreen == true){
            await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            setState(() {
              _isFullScreen = false;
            });
            print('print:_toggleFullscreen');
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: _isFullScreen
              ? null
              : const PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: PageAppBar(title: "Show Video"),
                ),
          body: _isFullScreen
              ? Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Center(child: _playView(context)),
                )
              : SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Center(child: _playView(context)),
                  ),
                ),
        ),
      ),
    );
  }
}

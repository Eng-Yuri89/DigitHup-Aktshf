import 'package:e_learning/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  double _controlAlpha = 1.0;
  void _toggleFullscreen() async {
    if (_isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

  void _onTapVideo() {
    debugPrint("_onTapVideo $_controlAlpha");
    setState(() {
      _controlAlpha = _controlAlpha > 0 ? 0 : 1;
    });
  }
  void _enterFullScreen() async {
    debugPrint("enterFullScreen");
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = true;
    });
  }
  Widget _controlView(BuildContext context) {
    return Column(
      children: <Widget>[
        _bottomUI()
      ],
    );
  }
  Widget _bottomUI() {
    return Row(
      children: <Widget>[
        SizedBox(width: 20),
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.yellow,
          icon: Icon(
            Icons.fullscreen,
            color: Colors.white,
          ),
          onPressed: _toggleFullscreen,
        ),
      ],
    );
  }

  void _exitFullScreen() async {
    debugPrint("exitFullScreen");
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = false;
    });
  }
  Widget _playView(BuildContext context) {
    // return VimeoPlayer(
    //   videoId: '${widget.videoId}',
    // );
    return AspectRatio(
      //aspectRatio: controller.value.aspectRatio,
      aspectRatio: 16.0 / 9.0,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: VimeoPlayer(
              videoId: '${widget.videoId}',
            ),
            onTap: _onTapVideo,
          ),
          _controlAlpha > 0
              ? AnimatedOpacity(
            opacity: _controlAlpha,
            duration: Duration(milliseconds: 250),
            child: _controlView(context),
          )
              : Container(),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _isFullScreen
            ? null
            : PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: PageAppBar(title: "Show Vidwo"),
        ),
        body:  _isFullScreen
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
    );



    // return Directionality(
    //   textDirection: TextDirection.rtl,
    //   // child: Column(
    //   //   children: [
    //   //     SizedBox(
    //   //       height: 300,
    //   //       child: VimeoVideoPlayer(
    //   //         vimeoPlayerModel: VimeoPlayerModel(
    //   //           url: "https://vimeo.com/${widget.videoId}",
    //   //           deviceOrientation: DeviceOrientation.portraitUp,
    //   //           systemUiOverlay: const [
    //   //             SystemUiOverlay.top,
    //   //             SystemUiOverlay.bottom,
    //   //           ],
    //   //         ),
    //   //       ),
    //   //     ),
    //   //   ],
    //   // ),
    //   child: Scaffold(
    //     appBar: const PreferredSize(
    //       preferredSize: Size.fromHeight(50),
    //       child: PageAppBar(title: "عرض فيديو"),
    //     ),
    //     body: Directionality(
    //       textDirection: TextDirection.ltr,
    //       // child: VimeoVideoPlayer(
    //       //   vimeoPlayerModel: VimeoPlayerModel(
    //       //     url: "https://vimeo.com/${widget.videoId}",
    //       //     deviceOrientation: DeviceOrientation.portraitUp,
    //       //     systemUiOverlay: const [
    //       //       SystemUiOverlay.top,
    //       //       SystemUiOverlay.bottom,
    //       //     ],
    //       //   ),
    //       // ),
    //       child: SizedBox(
    //         height: 300,
    //         child: VimeoPlayer(
    //           videoId: '${widget.videoId}',
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

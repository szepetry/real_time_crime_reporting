import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  VideoPlayerWidget({@required this.url});
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;
  String _url;

  @override
  void initState() {
    super.initState();
    _url = widget.url;
    _controller = VideoPlayerController.network(_url);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    // _controller.play();      //Uncomment to start on initState
    if (_url == "") _controller.play(); //Comment when above line is uncommented
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_controller),
            _PlayPauseOverlay(
              controller: _controller,
              url: _url,
            ),
            _url != ""
                ? VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay(
      {Key key, @required this.controller, @required this.url})
      : super(key: key);

  final VideoPlayerController controller;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying && url != ""
              ? SizedBox.shrink()
              : !controller.value.isPlaying
                  ? Container(
                      // This is when video isn't playable or string is empty.
                      color: Colors.black26,
                      child: Center(
                        child: Icon(
                          Icons.pause,
                          color: Colors.white,
                          size: 100.0,
                        ),
                      ),
                    )
                  : Container(
                      // This is when video isn't playable or string is empty.
                      color: Colors.black26,
                      child: Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                          size: 100.0,
                        ),
                      ),
                    ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying && url != ""
                ? controller.pause()
                : controller.play();
          },
        ),
      ],
    );
  }
}

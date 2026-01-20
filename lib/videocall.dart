import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const String appId = '';

class VideoCall extends StatefulWidget {
  final bool isBroadcaster;

  const VideoCall({super.key, required this.isBroadcaster});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall>
    with SingleTickerProviderStateMixin {

  final String channelName = '';
  final String rtcToken ='';

  late RtcEngineEx engine;

  bool _isJoined = false;
  bool _isMuted = false;
  bool _isFrontCamera = true;

  final List<int> _remoteUids = [];

  // Draggable position
  double _x = 20;
  double _y = 120;

  // For flip animation
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  // For ringing animation
  late Timer _ringingTimer;
  String _dots = '';

  // 🔥 New: timeout
  Timer? _timeoutTimer;
  bool _isTimeout = false;

  @override
  void initState() {
    super.initState();

    // Flip animation setup
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    // Ringing animation
    _ringingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isTimeout) return; // stop after timeout
      setState(() {
        if (_dots.length == 3) _dots = '';
        _dots += '.';
      });
    });

    _startTimeoutTimer();
    _initAgora();
  }

  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (_remoteUids.isEmpty) {
        setState(() {
          _isTimeout = true;
          engine.leaveChannel();
          engine.release();
        });
      }
    });
  }

  Future<void> _initAgora() async {
    await _checkPermissions();

    engine = createAgoraRtcEngineEx();
    await engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (_, __) {
        setState(() => _isJoined = true);
      },
      onUserJoined: (_, uid, __) {
        setState(() {
          if (!_remoteUids.contains(uid)) _remoteUids.add(uid);
        });
      },
      onUserOffline: (_, uid, __) {
        setState(() => _remoteUids.remove(uid));
      },
    ));

    await engine.setClientRole(
      role: widget.isBroadcaster
          ? ClientRoleType.clientRoleBroadcaster
          : ClientRoleType.clientRoleAudience,
    );

    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: rtcToken,
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(
        publishCameraTrack: widget.isBroadcaster,
        publishMicrophoneTrack: widget.isBroadcaster,
      ),
    );
  }

  Future<void> _checkPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  // ---------------- UI WIDGETS ----------------

  Widget _localView() {
    if (!_isJoined) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return GestureDetector(
      onDoubleTap: () => _switchCamera(),
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * 3.1416;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      ),
    );
  }

  Widget _remoteView(int uid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: channelName),
      ),
    );
  }

  Widget _ringingOverlay() {
    return Container(
      width: double.infinity,
      color: !_isJoined
          ? Colors.black
          : Colors.black.withOpacity(0.45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          const CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage('assets/user.png'),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isJoined ? 'Ringing$_dots' : 'Connecting$_dots',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // 🔥 Timeout UI
  Widget _timeoutView() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Glass blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // User info + error message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'User did not join. Please try again.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Cross button at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _draggableRemoteView() {
    if (_remoteUids.isEmpty) return const SizedBox.shrink();

    return Positioned(
      left: _x,
      top: _y,
      child: Draggable(
        feedback: _remoteContainer(),
        childWhenDragging: const SizedBox(),
        child: _remoteContainer(),
        onDragEnd: (d) {
          setState(() {
            _x = d.offset.dx;
            _y = d.offset.dy;
          });
        },
      ),
    );
  }

  Widget _remoteContainer() {
    return Container(
      height: 150,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _remoteView(_remoteUids.first),
      ),
    );
  }

  // ---------------- CONTROL BUTTONS ----------------

  Widget _onlyEndCall() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: _endCall,
          child: const Icon(Icons.call_end, color: Colors.white),
        ),
      ),
    );
  }

  Widget _fullControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              _isMuted = !_isMuted;
              engine.muteLocalAudioStream(_isMuted);
              setState(() {});
            },
            child: Icon(
              _isMuted ? Icons.mic_off : Icons.mic,
              color: Colors.black,
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => _switchCamera(),
            child: const Icon(Icons.cameraswitch, color: Colors.black),
          ),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: _endCall,
            child: const Icon(Icons.call_end, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _switchCamera() {
    _flipController.forward(from: 0);
    engine.switchCamera();
    _isFrontCamera = !_isFrontCamera;
  }

  Future<void> _endCall() async {
    try {
      await engine.leaveChannel();
      await engine.release();
    } catch (e) {
      log(e.toString());
    }
    if (mounted) Navigator.pop(context);
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isJoined) _localView(),
          if (_remoteUids.isEmpty && !_isTimeout) _ringingOverlay(),
          if (_remoteUids.isNotEmpty) _draggableRemoteView(),

          if (_isTimeout) _timeoutView(),

          if (!_isJoined && !_isTimeout) _onlyEndCall(),
          if (_isJoined && !_isTimeout) _fullControls(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ringingTimer.cancel();
    _timeoutTimer?.cancel();
    _flipController.dispose();
    engine.leaveChannel();
    engine.release();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:video_call/videocall.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // User Profile
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/user.png'),
            ),

            const SizedBox(height: 20),

            const Text(
              'John Doe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Online',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
            ),

            const Spacer(),

            // Call Button
            FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VideoCall(isBroadcaster: true),
                  ),
                );
              },
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

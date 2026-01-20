import 'package:flutter/material.dart';
import 'package:video_call/videocall.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              //==== Header ====
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              //==== User Profile ====
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/user.png'),
              ),
              const SizedBox(height: 25),
              //==== User Name ====
              const Text(
                'John Doe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              //==== User Status ====
              const Text(
                'Available • Last seen now',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              //==== Dummy Info Card ====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dummy Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Role: Developer\n'
                          '• Location: India\n'
                          '• Email: johndoe@example.com\n'
                          '• Phone: +91 99999 99999',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              //==== Video Call Button ====
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
                  Icons.video_call,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

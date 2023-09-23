// import 'package:flutter/material.dart';
// import 'package:record/record.dart';

// class CallRecorder extends StatefulWidget {
//   const CallRecorder({super.key});

//   @override
//   _CallRecorderState createState() => _CallRecorderState();
// }

// class _CallRecorderState extends State<CallRecorder> {
//   // Recording? recording;
//   var recording = Record();

//   Future<void> startRecording() async {
//     // recording = await Record.start();
//     recording = await Record.start();
//   }

//   void stopRecording() async {
//     await recording.stop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Call Recorder'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // if (recording != null) Text('Recording in progress...'),
//             // if (recording == null)
//             ElevatedButton(
//               onPressed: startRecording,
//               child: Text('Start Recording'),
//             ),
//             if (recording != null)
//               ElevatedButton(
//                 onPressed: stopRecording,
//                 child: Text('Stop Recording'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class CallRecorder extends StatefulWidget {
  const CallRecorder({super.key});

  @override
  State<CallRecorder> createState() => _CallRecorderState();
}

class _CallRecorderState extends State<CallRecorder> {
  late Record audioReord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    // TODO: implement initState
    audioReord = Record();
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    audioReord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioReord.hasPermission()) {
        await audioReord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print('error start recording $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioReord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      print('Error stopping record : $e');
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('error playing recording $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRecording) const Text('Recording in progress'),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: isRecording
                  ? Text('stop recording')
                  : Text('start recording'),
            ),
            SizedBox(
              height: 25,
            ),
            // ElevatedButton(onPressed: onPressed, child: Text('Play Recording')),
            if (!isRecording && audioPath != null)
              ElevatedButton(
                onPressed: playRecording,
                child: Text('play recording'),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToText extends StatefulWidget {
  const SpeechToText({super.key});

  @override
  State<SpeechToText> createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  var isListning = false;
  var text = "Hold the button and start speaking";
  stt.SpeechToText speechToText = stt.SpeechToText();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AvatarGlow(
            endRadius: 75,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            animate: isListning,
            glowColor: Colors.teal,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: GestureDetector(
              onTapDown: (details) async {
                if (!isListning) {
                  bool available = await speechToText.initialize();
                  if (available) {
                    setState(() {
                      isListning = true;
                      speechToText.listen(
                        onResult: (result) {
                          setState(() {
                            text = result.recognizedWords;
                          });
                        },
                      );
                    });
                  }
                }
              },
              onTapUp: (details) {
                setState(() {
                  isListning = false;
                  speechToText.stop();
                });
              },
              child: CircleAvatar(
                radius: 35,
                child: Icon(isListning ? Icons.mic : Icons.mic_none),
              ),
            ),
          ),
          appBar: AppBar(
            leading: Icon(Icons.sort_sharp),
            title: Text(
              'Speech To Text',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              text != "Hold the button and start speaking"
                  ? IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Text Coppied')));
                      },
                      icon: Icon(
                        Icons.copy,
                      ))
                  : Text(''),
            ],
          ),
          body: SingleChildScrollView(
            reverse: true,
            physics: BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.all(height * 0.02),
              // color: Colors.red,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                bottom: height / 7,
              ),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: height * 0.028,
                    color: isListning ? Colors.black87 : Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )),
    );
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'music player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  AudioPlayer audioPlayer=AudioPlayer();
  Duration _duration=Duration();
  Duration _position=Duration();
   bool isPlaying =false;
   String CurrentTime="00:00";
   String CompleteTime="00:00";
  @override
  void initState(){
    super.initState();
    audioPlayer.onAudioPositionChanged.listen((Duration duration){
      setState(() {
        CurrentTime=duration.toString().split(".")[0];
      });
    });
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        CompleteTime=duration.toString().split(".")[0];
      });
    });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.yellowAccent,
    body: Stack(
      children: <Widget>[
        Center(child: Image.asset('images/m1.png', fit: BoxFit.contain,),),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.7,
          height: 50,
          margin: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.7, left: MediaQuery
              .of(context)
              .size
              .width * 0.2,right:MediaQuery.of(context).size.width*0.1),

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(isPlaying  ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if(isPlaying){
                    audioPlayer.pause();
                    setState(() {
                      isPlaying=false;
                    });
                  }
                  else{
                    audioPlayer.resume();
                    setState(() {
                      isPlaying=true;
                    });
                  }
                },
              ),
              SizedBox(width: 16,),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  audioPlayer.stop();
                  setState(() {
                    isPlaying=false;
                  });
                },
              ),
              Text(CurrentTime,style:TextStyle(fontWeight:FontWeight.w900),),
              Text("|"),
              Text(CompleteTime,style:TextStyle(fontWeight:FontWeight.w400),),
            ],
          ),
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.7,
          height: 50,
          margin: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.8, left: MediaQuery
              .of(context)
              .size
              .width * 0.2,right:MediaQuery.of(context).size.width*0.1),

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50)
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
            Slider(
              activeColor: Colors.red,
              inactiveColor: Colors.green,
              value: _position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (double value){
              },
            )
            ]
          ),
        )
      ],
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.audiotrack),
      onPressed:()async {
        String filepath= await FilePicker.getFilePath();
        int status= await audioPlayer.play(filepath,isLocal:true);
        if(status==1){
          setState(() {
            isPlaying=true;
          });
        }
      },
    ),
  );
}
}


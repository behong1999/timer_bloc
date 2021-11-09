import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/bloc/timer_bloc.dart';

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer();

    AudioCache audioCache = AudioCache();

    void playing() async {
      audioPlayer = await audioCache.play('audios/morningMood.mp3');
    }

    void stopPlaying() {
      audioPlayer.stop();
    }

    playing();

    return FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          stopPlaying();
          BlocProvider.of<TimerBloc>(context).add(TimerReset());
          // Navigator.of(context).pop();
        },
        child: Text('Stop'));
  }
}

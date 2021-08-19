import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/bloc/timer_bloc.dart';
import 'package:timer/ticker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

int duration = 120;

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(duration);
    return BlocProvider(
      create: (_) => TimerBloc(
        ticker: Ticker(),
        duration: duration,
      ),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Flutter Timer',
          )),
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: TimerText()),
              ),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    // (duration / 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    void setTimer(BuildContext context) {
      final minuteController = TextEditingController();
      final secondController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Timer Setting',
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  decoration: new InputDecoration(labelText: "Minutes"),
                  keyboardType: TextInputType.number,
                  controller: minuteController,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: new InputDecoration(
                    labelText: "Seconds",
                  ),
                  keyboardType: TextInputType.number,
                  controller: secondController,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                if (minuteController.text == '') {
                  minuteController.text = '0';
                }
                if (secondController.text == '') {
                  secondController.text = '0';
                }
                duration = ((int.tryParse(minuteController.text)!.toInt() > 59)
                        ? 59 * 60
                        : int.tryParse(minuteController.text)!.toInt() * 60) +
                    ((int.tryParse(secondController.text)! > 59)
                        ? 59
                        : int.tryParse(secondController.text)!);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TimerPage()),
                  (Route<dynamic> route) =>
                      false, //* remove all the routes below the pushed route
                );
                print(duration);
              },
              icon: Icon(Icons.check),
            ),
            IconButton(
              color: Theme.of(context).errorColor,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        FlatButton(
            color: Theme.of(context).accentColor,
            onPressed: () => setTimer(context),
            shape: (RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.greenAccent))),
            child: Text('Set Timer')),
        Text(
          '$minutesStr:$secondsStr',
          style: Theme.of(context).textTheme.headline1,
        ),
      ],
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [
    //         Colors.blue.shade50,
    //         Colors.blue.shade500,
    //       ],
    //     ),
    //   ),
    // );
    return Container(
        color: Colors.white,
        child: WaveWidget(
          config: CustomConfig(
            colors: [
              //* The more colors here, the more waves will be
              Color(0xff2645e0).withOpacity(0.3),
              Color(0xff4479e1).withOpacity(0.3),
              Color(0xff85b0ed).withOpacity(0.3),
            ],
            //* durations of animations for each colors,
            //* make numbers equal to numbers of colors
            durations: [4000, 5000, 7000],

            //* height percentage for each colors.
            heightPercentages: [0.15, 0.2, 0.25],

            //* blur intensity for waves
            blur: MaskFilter.blur(BlurStyle.solid, 10),
          ),
          waveAmplitude: 10.00, //depth of curves
          waveFrequency: 3, //number of curves in waves
          backgroundColor: Color(0xffa5d5f2), //background colors
          size: Size(
            double.infinity,
            double.infinity,
          ),
        ));
  }
}

//* Actions is only rebuilt when the runtimeType of the TimerState changes
class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //* Rebuild the UI every time getting a new TimerState
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, current) => prev.runtimeType != current.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is TimerInitial) ...[
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                //* context.read<TimerBloc>() to access the TimerBloc instance
                onPressed: () => context
                    .read<TimerBloc>()
                    .add(TimerStarted(duration: state.duration)),
              ),
            ],
            if (state is TimerRunInProgress) ...[
              FloatingActionButton(
                child: Icon(Icons.pause),
                onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ],
            if (state is TimerRunPause) ...[
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context.read<TimerBloc>().add(TimerResumed()),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ],
            if (state is TimerRunComplete) ...[
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ]
          ],
        );
      },
    );
  }
}

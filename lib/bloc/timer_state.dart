part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  TimerState(this.duration);

  @override
  List<Object> get props => [/*this.*/ duration];
}

//* if the state is TimerInitial the user will be able to start the timer.
class TimerInitial extends TimerState {
  TimerInitial(int duration) : super(duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

//* if the state is TimerRunPause
//* the user will be able to resume the timer and reset the timer.
class TimerRunPause extends TimerState {
  TimerRunPause(int duration) : super(duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

//* if the state is TimerRunInProgress the user will be able to pause
//* and reset the timer as well as see the remaining duration.
class TimerRunInProgress extends TimerState {
  TimerRunInProgress(int duration) : super(duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

//* if the state is TimerRunComplete the user will be able to reset the timer.
class TimerRunComplete extends TimerState {
  TimerRunComplete() : super(0);
}

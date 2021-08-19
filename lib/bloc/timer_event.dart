part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  TimerEvent();

  @override
  List<Object> get props => [];
}

//* informs the TimerBloc that the timer should be started.
class TimerStarted extends TimerEvent {
  TimerStarted({required this.duration});
  final int duration;
}

class TimerPaused extends TimerEvent {
  TimerPaused();
}

class TimerResumed extends TimerEvent {
  TimerResumed();
}

class TimerReset extends TimerEvent {
  TimerReset();
}

class TimerChanged extends TimerEvent {
  TimerChanged({required this.duration});
  final int duration;
}

//* informs the TimerBloc that a tick has occurred and that it needs to update its state accordingly.
class TimerTicked extends TimerEvent {
  TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}

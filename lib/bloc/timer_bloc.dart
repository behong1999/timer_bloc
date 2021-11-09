import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  // static const int _duration = 150;
  final int duration;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker, required this.duration})
      //? Initialization
      : _ticker = ticker,
        super(TimerInitial(duration));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    } else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    }
  }

  //*
  //* TimerRunInProgress state with the start duration will be push
  //* once the TimerBloc receives a TimerStated event
  //*
  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.duration);

    //* Dellocate the memory
    _tickerSubscription?.cancel();

    //* Listen to the _ticker.tick stream
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
    //* On every tick we add a TimerTicked event with the remaining duration
  }

  //*
  //* If the tick’s duration is 0, timer has ended and it pushes a TimerRunComplete state.
  //*
  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    yield tick.duration > 0
        ? TimerRunInProgress(tick.duration)
        : TimerRunComplete();
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused pause) async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      yield TimerRunPause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed resume) async* {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  //* It won't notify any additional ticks and pushes a TimerInitial state wiith the original duration
  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    _tickerSubscription?.cancel();
    yield TimerInitial(duration);
  }

  //* Override to cancel the _tickerSubscription when the TimerBloc is closed
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}

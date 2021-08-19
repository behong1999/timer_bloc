//* The ticker will be our data source for the timer application.
//* It will expose a stream of ticks which we can subscribe and react to.
//* take() method creates the sub-stream for 'given number' of first events of original stream.
//* Listener listens to this sub-stream and print all elements.

class Ticker {
  // const Ticker();

  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

//NOTE: All Ticker class does is exposing a tick function
// which TAKES the number of ticks (seconds) we want
// and RETURNS a stream which emits the remaining seconds in every second.

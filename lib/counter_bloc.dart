import 'dart:async';

import 'package:bloc_pattern/counter_event.dart';
import 'package:hive/hive.dart';

class CounterBloc{
  int _counter = Hive.box('data').get(0);
  final _counterstateController = StreamController<int>.broadcast();
  StreamSink<int> get _intCounter => _counterstateController.sink;
  Stream<int> get counter => _counterstateController.stream;

  final _countereventController = StreamController<CounterEvent>.broadcast();
  Sink<CounterEvent> get counterEventSink => _countereventController.sink;

  CounterBloc(){
    _countereventController.stream.listen(_incrementinglocgic);
  }

  void _incrementinglocgic(CounterEvent event) {
    if(event is IncrementEvent){
      _counter++;
    }
    else {
      _counter--;
    }
    _intCounter.add(_counter);
  }
  void dispose(){
    _countereventController.close();
    _counterstateController.close();
  }
}
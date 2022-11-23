import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

EventTransformer<T> debounce<T>(Duration duration){
  return (event, mapper) => event.debounceTime(duration).flatMap(mapper);
}
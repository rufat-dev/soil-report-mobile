import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseState {
  final AsyncValue<String?>? checkState;

  const BaseState({this.checkState});
}
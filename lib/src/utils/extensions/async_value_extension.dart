import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueExtension on AsyncValue? {
  bool get isNullOrLoading => this?.isLoading ?? true;

}
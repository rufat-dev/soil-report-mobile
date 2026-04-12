import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'linked_account_success_controller.g.dart';

@riverpod
class LinkedAccountSuccessController extends _$LinkedAccountSuccessController
    with MockableControllerMixin<LinkedAccountSuccessState> {
  static const doneState = 'linked-account-success-done';

  @override
  LinkedAccountSuccessState build() {
    return const LinkedAccountSuccessState(
      fullName: '',
      pinCode: '',
      checkState: AsyncValue.data(null),
    );
  }

  @override
  LinkedAccountSuccessState get mockState => const LinkedAccountSuccessState(
        fullName: '',
        pinCode: '',
        checkState: AsyncValue.data(null),
      );

  @override
  LinkedAccountSuccessState get mockLoadingState => const LinkedAccountSuccessState(
        fullName: '',
        pinCode: '',
        checkState: AsyncValue.loading(),
      );

  void initialize({
    required String fullName,
    required String pinCode,
  }) {
    state = state.copyWith(
      fullName: fullName,
      pinCode: pinCode,
      checkState: const AsyncValue.data(null),
    );
  }

  void done() {
    state = state.copyWith(checkState: const AsyncValue.data(doneState));
  }
}

class LinkedAccountSuccessState extends BaseState {
  final String fullName;
  final String pinCode;

  const LinkedAccountSuccessState({
    required this.fullName,
    required this.pinCode,
    super.checkState,
  });

  LinkedAccountSuccessState copyWith({
    String? fullName,
    String? pinCode,
    AsyncValue<String?>? checkState,
  }) {
    return LinkedAccountSuccessState(
      fullName: fullName ?? this.fullName,
      pinCode: pinCode ?? this.pinCode,
      checkState: checkState ?? this.checkState,
    );
  }
}

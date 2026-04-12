import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_linked_account_controller.g.dart';

@riverpod
class AddLinkedAccountController extends _$AddLinkedAccountController
    with MockableControllerMixin<AddLinkedAccountState> {
  @override
  AddLinkedAccountState build() {
    return const AddLinkedAccountState(
      newFinCode: '',
      checkState: AsyncValue.data(null),
    );
  }

  @override
  AddLinkedAccountState get mockState => const AddLinkedAccountState(
        newFinCode: '',
        checkState: AsyncValue.data(null),
      );

  @override
  AddLinkedAccountState get mockLoadingState => const AddLinkedAccountState(
        newFinCode: '',
        checkState: AsyncValue.loading(),
      );

  void updateFinCode(String value) {
    state = state.copyWith(newFinCode: value);
  }

  Future<void> addAccountAsync(String finCode) async {
    state = state.copyWith(checkState: const AsyncValue.loading());

    if (!_isFinCodeValid(finCode)){
      state = state.copyWith(checkState: AsyncValue.error(SystemErrorException(sysMessage: 'AddPopup.InvalidFinCode'), StackTrace.current));
      return;
    }


    try {
      final trimmedCode = finCode.trim();
      state = state.copyWith(newFinCode: trimmedCode);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(checkState: const AsyncValue.data(null));
    } catch (e, stackTrace) {
      state = state.copyWith(checkState: AsyncValue.error(e, stackTrace));
    }
  }

  bool _isFinCodeValid(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && trimmed.length >= 6;
  }

}

class AddLinkedAccountState extends BaseState {
  final String newFinCode;

  const AddLinkedAccountState({
    required this.newFinCode,
    super.checkState,
  });

  AddLinkedAccountState copyWith({
    String? newFinCode,
     AsyncValue<String?>? checkState,
  }) {
    return AddLinkedAccountState(
      newFinCode: newFinCode ?? this.newFinCode,
      checkState: checkState ?? this.checkState,
    );
  }
}

import 'dart:async';
import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'linked_account_otp_controller.g.dart';

@riverpod
class LinkedAccountOtpController extends _$LinkedAccountOtpController
    with MockableControllerMixin<LinkedAccountOtpState> {
  static const _defaultSeconds = 60;
  Timer? _timer;

  @override
  LinkedAccountOtpState build() {
    ref.onDispose(() => _timer?.cancel());
    return const LinkedAccountOtpState(
      pinCode: '',
      phoneNumber: '',
      otpDigit1: '',
      otpDigit2: '',
      otpDigit3: '',
      otpDigit4: '',
      otpDigit5: '',
      otpDigit6: '',
      isResendEnabled: false,
      isConfirmEnabled: false,
      timerText: '01:00',
      remainingSeconds: _defaultSeconds,
      checkState: AsyncValue.data(null),
    );
  }

  @override
  LinkedAccountOtpState get mockState => const LinkedAccountOtpState(
        pinCode: '',
        phoneNumber: '',
        otpDigit1: '',
        otpDigit2: '',
        otpDigit3: '',
        otpDigit4: '',
        otpDigit5: '',
        otpDigit6: '',
        isResendEnabled: false,
        isConfirmEnabled: false,
        timerText: '01:00',
        remainingSeconds: _defaultSeconds,
        checkState: AsyncValue.data(null),
      );

  @override
  LinkedAccountOtpState get mockLoadingState => const LinkedAccountOtpState(
        pinCode: '',
        phoneNumber: '',
        otpDigit1: '',
        otpDigit2: '',
        otpDigit3: '',
        otpDigit4: '',
        otpDigit5: '',
        otpDigit6: '',
        isResendEnabled: false,
        isConfirmEnabled: false,
        timerText: '01:00',
        remainingSeconds: _defaultSeconds,
        checkState: AsyncValue.loading(),
      );

  void initialize({required String pinCode, String? phoneNumber}) {
    state = state.copyWith(
      pinCode: pinCode,
      phoneNumber: phoneNumber ?? '',
    );
    _startTimer();
  }

  void updateOtpDigit(int index, String value) {
    final digit = value.isEmpty ? '' : value[value.length - 1];
    var nextState = state;
    switch (index) {
      case 1:
        nextState = nextState.copyWith(otpDigit1: digit);
        break;
      case 2:
        nextState = nextState.copyWith(otpDigit2: digit);
        break;
      case 3:
        nextState = nextState.copyWith(otpDigit3: digit);
        break;
      case 4:
        nextState = nextState.copyWith(otpDigit4: digit);
        break;
      case 5:
        nextState = nextState.copyWith(otpDigit5: digit);
        break;
      case 6:
        nextState = nextState.copyWith(otpDigit6: digit);
        break;
    }

    state = nextState.copyWith(isConfirmEnabled: _isOtpComplete(nextState));
  }

  Future<void> confirmOtp() async {
    if (!state.isConfirmEnabled) return;

    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(checkState: AsyncValue.data(state.pinCode));
    } catch (e, stackTrace) {
      state = state.copyWith(checkState: AsyncValue.error(e, stackTrace));
    }
  }

  Future<void> resendOtp() async {
    if (!state.isResendEnabled) return;
    state = state.copyWith(isResendEnabled: false);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      _startTimer();
    } catch (e, stackTrace) {
      state = state.copyWith(checkState: AsyncValue.error(e, stackTrace));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: _defaultSeconds,
      isResendEnabled: false,
      timerText: _formatTimer(_defaultSeconds),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextSeconds = state.remainingSeconds - 1;
      if (nextSeconds <= 0) {
        timer.cancel();
        state = state.copyWith(
          remainingSeconds: 0,
          isResendEnabled: true,
          timerText: _formatTimer(0),
        );
      } else {
        state = state.copyWith(
          remainingSeconds: nextSeconds,
          timerText: _formatTimer(nextSeconds),
        );
      }
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool _isOtpComplete(LinkedAccountOtpState currentState) {
    return currentState.otpDigit1.isNotEmpty &&
        currentState.otpDigit2.isNotEmpty &&
        currentState.otpDigit3.isNotEmpty &&
        currentState.otpDigit4.isNotEmpty &&
        currentState.otpDigit5.isNotEmpty &&
        currentState.otpDigit6.isNotEmpty;
  }

}

class LinkedAccountOtpState extends BaseState {
  final String pinCode;
  final String phoneNumber;
  final String otpDigit1;
  final String otpDigit2;
  final String otpDigit3;
  final String otpDigit4;
  final String otpDigit5;
  final String otpDigit6;
  final bool isResendEnabled;
  final bool isConfirmEnabled;
  final String timerText;
  final int remainingSeconds;

  const LinkedAccountOtpState({
    required this.pinCode,
    required this.phoneNumber,
    required this.otpDigit1,
    required this.otpDigit2,
    required this.otpDigit3,
    required this.otpDigit4,
    required this.otpDigit5,
    required this.otpDigit6,
    required this.isResendEnabled,
    required this.isConfirmEnabled,
    required this.timerText,
    required this.remainingSeconds,
    super.checkState,
  });

  LinkedAccountOtpState copyWith({
    String? pinCode,
    String? phoneNumber,
    String? otpDigit1,
    String? otpDigit2,
    String? otpDigit3,
    String? otpDigit4,
    String? otpDigit5,
    String? otpDigit6,
    bool? isResendEnabled,
    bool? isConfirmEnabled,
    String? timerText,
    int? remainingSeconds,
    AsyncValue<String?>? checkState,
  }) {
    return LinkedAccountOtpState(
      pinCode: pinCode ?? this.pinCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpDigit1: otpDigit1 ?? this.otpDigit1,
      otpDigit2: otpDigit2 ?? this.otpDigit2,
      otpDigit3: otpDigit3 ?? this.otpDigit3,
      otpDigit4: otpDigit4 ?? this.otpDigit4,
      otpDigit5: otpDigit5 ?? this.otpDigit5,
      otpDigit6: otpDigit6 ?? this.otpDigit6,
      isResendEnabled: isResendEnabled ?? this.isResendEnabled,
      isConfirmEnabled: isConfirmEnabled ?? this.isConfirmEnabled,
      timerText: timerText ?? this.timerText,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      checkState: checkState ?? this.checkState,
    );
  }
}


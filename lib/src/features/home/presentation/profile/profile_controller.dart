import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/authentication/domain/user_model.dart';
import 'package:soilreport/src/features/authentication/domain/enums/client_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController
    with MockableControllerMixin<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState(
      user: UserModel.empty,
      email: '',
      phoneNumber: '',
      checkState: null,
    );
  }

  static const _mockUser = UserModel(
    'John', 'Doe', '', '+1234567890', 'MOCK_PIN',
    'John Doe', null, null, 'john.doe@example.com',
    false, ClientType.physicalPersonCode, '', '',
  );

  @override
  ProfileState get mockState => const ProfileState(
        user: _mockUser,
        email: 'john.doe@example.com',
        phoneNumber: '+1234567890',
        checkState: AsyncValue.data('user_loaded'),
      );

  @override
  ProfileState get mockLoadingState => ProfileState(
        user: UserModel.empty,
        email: '',
        phoneNumber: '',
        checkState: const AsyncValue.loading(),
      );

  Future<void> loadUserData() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    state = mockState;
  }

  Future<void> confirmEmail(String newEmail) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      email: newEmail,
      checkState: const AsyncValue.data('email_sent'),
    );
  }

  Future<void> confirmPhoneNumber(String newPhoneNumber) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      phoneNumber: newPhoneNumber,
      checkState: const AsyncValue.data('sms_sent'),
    );
  }

  Future<void> changeProfilePicture() async {
    // TODO: Implement profile picture change functionality
  }
}

class ProfileState extends BaseState {
  final UserModel user;
  final String email;
  final String phoneNumber;

  const ProfileState({
    super.checkState,
    required this.user,
    required this.email,
    required this.phoneNumber,
  });

  ProfileState copyWith({
    UserModel? user,
    String? email,
    String? phoneNumber,
    AsyncValue<String?>? checkState,
  }) {
    return ProfileState(
      user: user ?? this.user,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      checkState: checkState ?? this.checkState,
    );
  }
}

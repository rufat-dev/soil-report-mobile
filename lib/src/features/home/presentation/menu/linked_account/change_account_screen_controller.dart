import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/authentication/domain/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_account_screen_controller.g.dart';

@riverpod
class ChangeAccountScreenController extends _$ChangeAccountScreenController with MockableControllerMixin<ChangeAccountScreenState>{
  static const deleteAccountSuccessState = 'delete-account-success';
  static const changeProfileSuccessState = 'change-profile-success';

  @override
  ChangeAccountScreenState build() {
    return ChangeAccountScreenState(
      email: '',
      phoneNumber: '',
      user: UserModel.empty,
      connectedAccounts: const [],
      checkState: null,
      isChangingAccount: false,
    );
  }

  @override
  ChangeAccountScreenState get mockState => const ChangeAccountScreenState(
    user: UserModel.empty,
    email: '',
    phoneNumber: '',
    connectedAccounts: [
      ClientConnectionModel(
        fullName: 'Loading Loading LoadingName',
        pin: 'XXXXXXX',
        isAddedByOtherUser: false,
      ),
      ClientConnectionModel(
        fullName: 'Loading loLoading LoadingName',
        pin: 'XXXXXXX',
        isAddedByOtherUser: false,
      ),
      ClientConnectionModel(
        fullName: 'Loading Loading LoadingNamename',
        pin: 'XXXXXXX',
        isAddedByOtherUser: false,
      ),
    ],
    checkState: AsyncValue.loading(),
    isChangingAccount: false,
  );

  @override
  ChangeAccountScreenState get mockLoadingState => const ChangeAccountScreenState(
    user: UserModel.empty,
    email: '',
    phoneNumber: '',
    connectedAccounts: [
      ClientConnectionModel(
        fullName: 'Loading Loading LoadingName',
        pin: 'XXXXXXX',
        isAddedByOtherUser: false,
      ),
      ClientConnectionModel(
        fullName: 'Loading loLoading LoadingName',
        pin: 'XXXXXXX',
        isAddedByOtherUser: false,
      ),
      ClientConnectionModel(
        fullName: 'Loading Loading LoadingNamename',
        pin: 'XXXXXXX',
        isAddedByOtherUser: false,
      ),
    ],
    checkState: AsyncValue.loading(),
    isChangingAccount: false,
  );

  Future<void> loadChangeAccountScreen() async {
    await _loadConnectionsAsync();
  }

  Future<void> refreshConnections() async {
    await _loadConnectionsAsync();
  }

  Future<void> _loadConnectionsAsync() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final accounts = <ClientConnectionModel>[
        const ClientConnectionModel(fullName: 'Mock User One', pin: 'ABC1234', isAddedByOtherUser: false),
        const ClientConnectionModel(fullName: 'Mock User Two', pin: 'DEF5678', isAddedByOtherUser: true),
      ];
      state = state.copyWith(
        connectedAccounts: accounts,
        checkState: const AsyncValue.data(null),
      );
    } catch (e, stackTrace) {
      state = state.copyWith(checkState: AsyncValue.error(e, stackTrace));
    }
  }

  Future<void> removeLinkedAccount(ClientConnectionModel account) async {
    if (account.pin == null || account.pin!.isEmpty) return;
    state = state.copyWith(checkState: const AsyncValue.loading());

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await _loadConnectionsAsync();
      state = state.copyWith(checkState: const AsyncValue.data(deleteAccountSuccessState));
    } catch (_) {
      state = state.copyWith(checkState: const AsyncValue.data(null));
    }
  }

  Future<void> changeProfile(ClientConnectionModel account) async {
    if (account.pin == null || account.pin!.isEmpty || (account.isAddedByOtherUser ?? false)) return;

    state = state.copyWith(isChangingAccount: true);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(isChangingAccount: false, checkState: const AsyncValue.data(changeProfileSuccessState));
    } catch (e, stackTrace) {
      state = state.copyWith(isChangingAccount: false, checkState: AsyncValue.error(e, stackTrace));
    }
  }

}

class ChangeAccountScreenState extends BaseState {
  final UserModel user;
  final String email;
  final String phoneNumber;
  final List<ClientConnectionModel> connectedAccounts;
  final bool isChangingAccount;

  const ChangeAccountScreenState({
    required this.user,
    required this.email,
    required this.phoneNumber,
    required this.connectedAccounts,
    required this.isChangingAccount,
    super.checkState,
  });

  ChangeAccountScreenState copyWith({
    UserModel? user,
    String? email,
    String? phoneNumber,
    List<ClientConnectionModel>? connectedAccounts,
    AsyncValue<String?>? checkState,
    bool? isChangingAccount,
  }) {
    return ChangeAccountScreenState(
      user: user ?? this.user,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      connectedAccounts: connectedAccounts ?? this.connectedAccounts,
      checkState: checkState ?? this.checkState,
      isChangingAccount: isChangingAccount ?? this.isChangingAccount,
    );
  }
  static ChangeAccountScreenState get emptyState => ChangeAccountScreenState(
    user: UserModel.empty,
    email: '',
    phoneNumber: '',
    connectedAccounts: const [],
    checkState: const AsyncValue.data(null),
    isChangingAccount: false,
  );
}

class ClientConnectionModel {
  final String? pin;
  final String? fullName;
  final String? phoneNumber;
  final bool? isAddedByOtherUser;

  const ClientConnectionModel({
    this.pin,
    this.fullName,
    this.phoneNumber,
    this.isAddedByOtherUser,
  });

  ClientConnectionModel copyWith({
    String? pin,
    String? fullName,
    String? phoneNumber,
    bool? isAddedByOtherUser,
  }) {
    return ClientConnectionModel(
      pin: pin ?? this.pin,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAddedByOtherUser: isAddedByOtherUser ?? this.isAddedByOtherUser,
    );
  }
}
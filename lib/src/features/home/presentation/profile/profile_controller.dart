import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_lookup_response.dart';
import 'package:soilreport/src/features/authentication/domain/user_model.dart';
import 'package:soilreport/src/features/authentication/domain/enums/client_type.dart';
import 'package:soilreport/src/features/home/data/purchases_repository.dart';
import 'package:soilreport/src/features/home/domain/purchase_record_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController
    with MockableControllerMixin<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState(
      user: UserModel.empty,
      firebaseUser: null,
      purchases: [],
      purchasesError: null,
      checkState: null,
    );
  }

  static const _mockUser = UserModel(
    'John', 'Doe', '', '+1234567890', 'MOCK_PIN',
    'John Doe', null, null, 'john.doe@example.com',
    false, ClientType.physicalPersonCode, '', '',
  );

  @override
  ProfileState get mockState => ProfileState(
        user: _mockUser,
        firebaseUser: FirebaseUserRecord(
          localId: 'mock-local-id',
          email: 'john.doe@example.com',
          emailVerified: false,
          displayName: 'John Doe',
        ),
        purchases: [],
        purchasesError: null,
        checkState: AsyncValue.data('user_loaded'),
      );

  @override
  ProfileState get mockLoadingState => ProfileState(
        user: UserModel.empty,
        firebaseUser: null,
        purchases: const [],
        purchasesError: null,
        checkState: const AsyncValue.loading(),
      );

  Future<void> loadProfile() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      final auth = ref.read(authRepositoryProvider);
      final secureStorage = ref.read(secureStorageProvider);
      final purchasesRepo = ref.read(purchasesRepositoryProvider);
      final user = auth.currentUser ?? UserModel.empty;
      final token = secureStorage.currentTokens.accessToken;
      final firebaseUser =
          token == null ? null : await auth.lookupUser(token);
      List<PurchaseRecordModel> purchases = const [];
      String? purchasesError;
      try {
        purchases = await purchasesRepo.listPurchases(limit: 50, offset: 0);
      } catch (_) {
        purchasesError = 'Failed to load purchases';
      }
      state = state.copyWith(
        user: user,
        firebaseUser: firebaseUser,
        purchases: purchases,
        purchasesError: purchasesError,
        checkState: const AsyncValue.data('profile_loaded'),
      );
    } catch (_) {
      state = state.copyWith(
        checkState: const AsyncValue.data('profile_loaded'),
      );
    }
  }

  Future<void> sendEmailVerification() async {
    final auth = ref.read(authRepositoryProvider);
    final secureStorage = ref.read(secureStorageProvider);
    final token = secureStorage.currentTokens.accessToken;
    if (token == null || token.trim().isEmpty) {
      state = state.copyWith(
        checkState: AsyncValue.error('missing_token', StackTrace.current),
      );
      return;
    }
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      await auth.sendEmailVerification(token);
      state = state.copyWith(checkState: const AsyncValue.data('verification_sent'));
    } catch (e, st) {
      state = state.copyWith(checkState: AsyncValue.error(e, st));
    }
  }

  Future<void> refreshVerificationStatus() async {
    final auth = ref.read(authRepositoryProvider);
    final secureStorage = ref.read(secureStorageProvider);
    final token = secureStorage.currentTokens.accessToken;
    if (token == null || token.trim().isEmpty) {
      return;
    }
    try {
      final firebaseUser = await auth.lookupUser(token);
      state = state.copyWith(
        firebaseUser: firebaseUser,
        checkState: const AsyncValue.data('profile_loaded'),
      );
    } catch (_) {
      // Keep last-known verification status.
    }
  }

  Future<void> sendPasswordReset() async {
    final email = state.firebaseUser?.email ?? state.user.email;
    if (email == null || email.trim().isEmpty) {
      state = state.copyWith(
        checkState: AsyncValue.error('missing_email', StackTrace.current),
      );
      return;
    }
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      state = state.copyWith(checkState: const AsyncValue.data('password_reset_sent'));
    } catch (e, st) {
      state = state.copyWith(checkState: AsyncValue.error(e, st));
    }
  }
}

class ProfileState extends BaseState {
  final UserModel user;
  final FirebaseUserRecord? firebaseUser;
  final List<PurchaseRecordModel> purchases;
  final String? purchasesError;

  const ProfileState({
    super.checkState,
    required this.user,
    required this.firebaseUser,
    required this.purchases,
    required this.purchasesError,
  });

  String? get email => firebaseUser?.email ?? user.email;
  bool get isEmailVerified => firebaseUser?.emailVerified == true;
  String get displayName {
    if ((firebaseUser?.displayName?.trim().isNotEmpty ?? false)) {
      return firebaseUser!.displayName!.trim();
    }
    if ((user.fullName?.trim().isNotEmpty ?? false)) {
      return user.fullName!.trim();
    }
    if ((email?.trim().isNotEmpty ?? false)) {
      return email!.trim();
    }
    return 'Account';
  }

  ProfileState copyWith({
    UserModel? user,
    FirebaseUserRecord? firebaseUser,
    List<PurchaseRecordModel>? purchases,
    String? purchasesError,
    AsyncValue<String?>? checkState,
  }) {
    return ProfileState(
      user: user ?? this.user,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      purchases: purchases ?? this.purchases,
      purchasesError: purchasesError,
      checkState: checkState ?? this.checkState,
    );
  }
}

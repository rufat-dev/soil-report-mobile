import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_screen_controller.g.dart';

@riverpod
class DashboardScreenController extends _$DashboardScreenController
    with MockableControllerMixin<DashboardScreenState> {
  late final KeepAliveLink _keepAliveLink;

  @override
  DashboardScreenState build() {
    _keepAliveLink = ref.keepAlive();
    return DashboardScreenState(
      checkState: null,
      stories: [],
      bannerImage: null,
      bannerLink: null,
      isRealScope: false,
    );
  }

  @override
  DashboardScreenState get mockState => DashboardScreenState(
        checkState: const AsyncValue.data(null),
        stories: const [],
        bannerImage: '',
        bannerLink: '',
        isRealScope: true,
      );

  @override
  DashboardScreenState get mockLoadingState => DashboardScreenState(
        checkState: const AsyncValue.loading(),
        stories: const [],
        bannerImage: null,
        bannerLink: null,
        isRealScope: false,
      );

  Future<void> loadScreen({bool useCache = true}) async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      checkState: const AsyncValue.data(null),
      isRealScope: true,
    );
  }
}

class DashboardScreenState extends BaseState {
  final List<Object> stories;
  final String? bannerImage;
  final String? bannerLink;
  final bool isRealScope;

  const DashboardScreenState({
    super.checkState,
    required this.stories,
    this.bannerImage,
    this.bannerLink,
    required this.isRealScope,
  });

  DashboardScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<Object>? stories,
    String? bannerImage,
    String? bannerLink,
    bool? isRealScope,
  }) {
    return DashboardScreenState(
      checkState: checkState ?? this.checkState,
      stories: stories ?? this.stories,
      bannerImage: bannerImage ?? this.bannerImage,
      bannerLink: bannerLink ?? this.bannerLink,
      isRealScope: isRealScope ?? this.isRealScope,
    );
  }
}

import 'package:soilreport/src/core/services/connectivity_service.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/presentation/landing/landing_screen.dart';
import 'package:soilreport/src/features/authentication/presentation/loading/loading_page.dart';
import 'package:soilreport/src/features/home/presentation/menu/linked_account/change_account_screen.dart';
import 'package:soilreport/src/features/home/presentation/menu/linked_account/linked_account_otp_screen.dart';
import 'package:soilreport/src/features/home/presentation/menu/linked_account/linked_account_success_screen.dart';
import 'package:soilreport/src/features/home/presentation/device_add/add_device_screen.dart';
import 'package:soilreport/src/features/home/presentation/group_add/add_group_screen.dart';
import 'package:soilreport/src/features/home/presentation/menu/conditions_and_terms_screen.dart';
import 'package:soilreport/src/features/home/presentation/menu/menu_screen.dart';
import 'package:soilreport/src/features/home/presentation/menu/offers_screen.dart';
import 'package:soilreport/src/features/home/presentation/menu/security_policy_screen.dart';
import 'package:soilreport/src/features/home/presentation/notifications/notifications_screen.dart';
import 'package:soilreport/src/features/home/presentation/profile/profile_screen.dart';
import 'package:soilreport/src/routing/go_router_refresh_stream.dart';
import 'package:soilreport/src/routing/not_found_screen.dart';
import 'package:soilreport/src/widget_build_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/authentication/presentation/login/login_screen.dart';
import '../features/authentication/presentation/register/register_screen.dart';
import '../features/home/presentation/tabbed_screen/tabbed_screen.dart';
import '../features/authentication/presentation/auth_alert/auth_alert_screen.dart';
import '../features/authentication/domain/auth_alert_type.dart';

part 'app_router.g.dart';

enum AppRoute {
  loading,
  landing,
  login,
  register,
  widgetBuild,
  home,
  menu,
  profile,
  conditionsAndTerms,
  securityPolicy,
  offers,
  notifications,
  changeAccount,
  linkedAccountOtp,
  linkedAccountSuccess,
  authAlert,
  addDevice,
  addGroup,
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/loading',
    debugLogDiagnostics: false,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;

      if (isLoggedIn || path.contains('/loading')) {
        return state.uri.path;
      } else {
        if (path.contains('/auth')) {
          return state.uri.toString();
        } else {
          return '/auth/landing';
        }
      }
    },
    routes: [
      GoRoute(
        path: '/loading',
        name: AppRoute.loading.name,
        builder: (context, state) => const LoadingPage(),
        redirect: (context, state) {
          final connectivityStatus = ref
              .read(connectivityServiceProvider)
              .connectivityStatus;
          switch (connectivityStatus) {
            case ConnectivityStatus.hasServerConnection:
              break;
            case ConnectivityStatus.hasInternetConnection:
              return '/auth/alert?alertType=internalnetworkerror';
            case ConnectivityStatus.disconnected:
              return '/auth/alert?alertType=networkerror';
            default:
              return '/auth/alert?alertType=unknown';
          }
          final isLoggedIn = authRepository.currentUser != null;
          if (isLoggedIn) return '/home';
          return '/auth/landing';
        },
      ),
      GoRoute(
        path: '/widgetBuild',
        name: AppRoute.widgetBuild.name,
        builder: (context, state) => const WidgetBuildScreen(),
      ),
      GoRoute(
        path: '/auth',
        redirect: (context, state) {
          if (state.fullPath == '/auth') return '/auth/landing';
          return null;
        },
        routes: [
          GoRoute(
            path: '/landing',
            name: AppRoute.landing.name,
            builder: (context, state) {
              final error = state.uri.queryParameters['error'];
              return LandingScreen(showAuthError: error == 'auth_failed');
            },
          ),
          GoRoute(
            path: '/login',
            name: AppRoute.login.name,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/register',
            name: AppRoute.register.name,
            builder: (context, state) => RegisterScreen(),
          ),
          GoRoute(
            path: '/alert',
            name: AppRoute.authAlert.name,
            builder: (context, state) {
              final alertTypeParam =
                  state.uri.queryParameters['alertType'] ?? 'unknown';
              AuthAlertType alertType;
              switch (alertTypeParam.toLowerCase()) {
                case 'networkerror':
                  alertType = AuthAlertType.networkError;
                  break;
                case 'internalnetworkerror':
                  alertType = AuthAlertType.internalNetworkError;
                  break;
                default:
                  alertType = AuthAlertType.unknown;
              }
              return AuthAlertScreen(alertType: alertType);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const TabbedScreen(),
        routes: [
          GoRoute(
            path: 'menu',
            name: AppRoute.menu.name,
            builder: (context, state) => const MenuScreen(),
            routes: [
              GoRoute(
                path: 'conditionsAndTerms',
                name: AppRoute.conditionsAndTerms.name,
                builder: (context, state) => ConditionsAndTermsScreen(),
              ),
              GoRoute(
                path: 'changeAccount',
                name: AppRoute.changeAccount.name,
                builder: (context, state) => const ChangeAccountScreen(),
              ),
              GoRoute(
                path: 'linkedAccountOtp',
                name: AppRoute.linkedAccountOtp.name,
                builder: (context, state) {
                  if (state.extra is Map) {
                    final extra = state.extra! as Map;
                    final pinCode = extra['pinCode'] as String? ?? '';
                    final phoneNumber = extra['phoneNumber'] as String?;
                    return LinkedAccountOtpScreen(
                      pinCode: pinCode,
                      phoneNumber: phoneNumber,
                    );
                  }
                  throw SystemErrorException(
                    sysMessage: 'linked account otp params do not exist',
                  );
                },
              ),
              GoRoute(
                path: 'linkedAccountSuccess',
                name: AppRoute.linkedAccountSuccess.name,
                builder: (context, state) {
                  if (state.extra is Map) {
                    final extra = state.extra! as Map;
                    final pinCode = extra['pinCode'] as String? ?? '';
                    final fullName = extra['fullName'] as String? ?? '';
                    return LinkedAccountSuccessScreen(
                      fullName: fullName,
                      pinCode: pinCode,
                    );
                  }
                  throw SystemErrorException(
                    sysMessage: 'linked account success params do not exist',
                  );
                },
              ),
              GoRoute(
                path: 'securityPolicy',
                name: AppRoute.securityPolicy.name,
                builder: (context, state) => SecurityPolicyScreen(),
              ),
              GoRoute(
                path: 'offers',
                name: AppRoute.offers.name,
                builder: (context, state) => OffersScreen(),
              ),
              GoRoute(
                path: 'notifications',
                name: AppRoute.notifications.name,
                builder: (context, state) => const NotificationsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'profile',
            name: AppRoute.profile.name,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'addDevice',
            name: AppRoute.addDevice.name,
            builder: (context, state) => const AddDeviceScreen(),
          ),
          GoRoute(
            path: 'addGroup',
            name: AppRoute.addGroup.name,
            builder: (context, state) => const AddGroupScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}

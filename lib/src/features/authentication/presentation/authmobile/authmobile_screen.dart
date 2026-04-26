import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/presentation/loading/loading_page.dart';

class AuthMobileScreen extends ConsumerStatefulWidget {
  final String guid;
  
  const AuthMobileScreen({
    super.key,
    required this.guid,
  });

  @override
  ConsumerState<AuthMobileScreen> createState() => _AuthMobileScreenState();
}

class _AuthMobileScreenState extends ConsumerState<AuthMobileScreen> {
  @override
  void initState() {
    super.initState();
    _handleAuthorization();
  }

  Future<void> _handleAuthorization() async {
    if (widget.guid.isEmpty) {
      if (mounted) {
        context.go('/auth/landing?error=auth_failed');
      }
      return;
    }

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.getAccessTokenByGuidAsync(widget.guid);
      
      // Success - navigate directly to home
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      // Failure - navigate to landing with error parameter
      if (mounted) {
        context.go('/auth/landing?error=auth_failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while processing authorization
    return const LoadingPage();
  }
}

import 'package:soilreport/src/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class OtpDialog extends ConsumerStatefulWidget {
  const OtpDialog({
    super.key,
    required this.email,
    required this.phoneNumber,
    required this.pin,
    required this.isEmailVerifyOtp,
    required this.onOtpVerified,
  });

  final String email;
  final String phoneNumber;
  final String pin;
  final bool isEmailVerifyOtp;
  final VoidCallback onOtpVerified;

  @override
  ConsumerState<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends ConsumerState<OtpDialog> {
  late TextEditingController _otpController;
  Timer? _timer;
  int _counter = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _counter = 60;
    _isResendEnabled = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _counter--;
          if (_counter <= 0) {
            _isResendEnabled = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void _onOtpChanged(String value) {
    if (value.length == 6) {
      // Mock: accept any 6-digit code
      Navigator.of(context).pop();
      widget.onOtpVerified();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEmailVerifyOtp ? 'Email Verification' : 'Phone Verification',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.isEmailVerifyOtp ? widget.email : widget.phoneNumber,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Enter the 6-digit code sent to your ${widget.isEmailVerifyOtp ? 'email' : 'phone'}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _otpController,
                onChanged: _onOtpChanged,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      letterSpacing: 10,
                    ),
                decoration: InputDecoration(
                  hintText: '------',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme().orange),
                  ),
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Code expires in: $_counter seconds',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isResendEnabled ? _startTimer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme().orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  widget.isEmailVerifyOtp ? 'Resend Email' : 'Resend SMS',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> showOtpDialog<T>({
  required BuildContext context,
  required String email,
  required String phoneNumber,
  required String pin,
  required bool isEmailVerifyOtp,
  required VoidCallback onOtpVerified,
}) {
  return showDialog<T?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => OtpDialog(
      email: email,
      phoneNumber: phoneNumber,
      pin: pin,
      isEmailVerifyOtp: isEmailVerifyOtp,
      onOtpVerified: onOtpVerified,
    ),
  );
}

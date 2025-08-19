import 'package:fetchtrue/core/widgets/no_user_sign_widget.dart';
import 'package:fetchtrue/feature/profile/bloc/user/user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../repository/delete_user_service.dart';

class DeleteAccountScreen extends StatefulWidget {
  final String userId;
  const DeleteAccountScreen({super.key, required this.userId});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isConfirmed = false;
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    setState(() => _isLoading = true);

    try {
      final userSession = Provider.of<UserSession>(context, listen: false);

      await deleteUser(widget.userId);

      /// Reset state
      context.read<UserBloc>().add(ResetUser());
      await userSession.logout();

      if (context.mounted) {
        /// Navigate to AuthScreen after logout
         Navigator.pop(context, true);

        showCustomSnackBar(context, 'Account deleted successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, 'Failed: $e');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    if(widget.userId.isEmpty){
      return Scaffold(
        appBar: CustomAppBar(showBackButton: true,title: 'Delete Account',),

        body: SafeArea(child: NoUserSignWidget()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Delete Account', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              "Are you sure you want to delete your account?",
              style: textStyle18(context, color: CustomColor.redColor),
            ),
            const SizedBox(height: 16),
            Text(
              "Deleting your account is permanent and will erase all your data including profile, history, and preferences from our servers.",
              style: textStyle16(context, fontWeight: FontWeight.w400),
            ),
            const Spacer(),
            Column(
              children: [
                CheckboxListTile(
                  title: const Text("Yes, I want to delete my account."),
                  value: _isConfirmed,
                  onChanged: (value) => setState(() => _isConfirmed = value!),
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: _isConfirmed ? 1.0 : 0.5,
                  child: IgnorePointer(
                    ignoring: !_isConfirmed || _isLoading,
                    child: CustomButton(
                      label: _isLoading ? 'Deleting...' : 'Delete My Account',
                      isLoading: _isLoading,
                      onPressed: _handleDelete,
                      buttonColor: CustomColor.appColor,
                    ),
                  ),
                ),
              ],
            ),
            50.height,
          ],
        ),
      ),
    );
  }
}

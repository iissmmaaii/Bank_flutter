import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/account/presentation/bloc/accountuser_bloc.dart';

class UserAccountInfoWidget extends StatelessWidget {
  const UserAccountInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountuserBloc, AccountuserState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF4B5EAA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  state is AccountLoading
                      ? _buildLoadingIndicator()
                      : state is AccountLoaded
                      ? _buildUserInfo(context, state.account)
                      : state is AccountError
                      ? _buildError(state.message)
                      : _buildNoData(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4.0),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserAccount user) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1.0,
      child: ListView(
        children: [
          Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.person, '👤 الاسم', user.username),
                  const Divider(color: Colors.grey, thickness: 1),
                  _infoRow(
                    Icons.phone,
                    '📱 رقم الهاتف',
                    user.phoneNumber ?? 'غير متاح',
                  ),
                  const Divider(color: Colors.grey, thickness: 1),
                  _infoRow(
                    Icons.credit_card,
                    '💳 رقم البطاقة',
                    user.cardNumber ?? 'غير متاح',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNoData() {
    return const Center(
      child: Text(
        'لا توجد بيانات متاحة',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 30),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        value ?? 'غير متاح',
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}

import 'dart:ui';
import 'package:bankapp3/features/account/domain/entities/useraccount.dart';
import 'package:bankapp3/features/twofactorauthfeature/presentation/bloc/twofactorauthfeature_bloc.dart';
import 'package:bankapp3/features/twofactorauthfeature/presentation/pages/googleautpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bankapp3/features/account/presentation/bloc/accountuser_bloc.dart';

class UserAccountInfoWidget extends StatelessWidget {
  const UserAccountInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF6B7280)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<AccountuserBloc, AccountuserState>(
              builder: (context, state) {
                return state is AccountLoading
                    ? _buildLoadingIndicator()
                    : state is AccountLoaded
                    ? _buildUserInfo(context, state.account)
                    : state is AccountError
                    ? _buildError(state.message)
                    : _buildNoData();
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.2),
            selectedItemColor: const Color(0xFF1E3A8A),
            unselectedItemColor: Colors.white70,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: _AnimatedIcon(icon: Icons.security),
                label: 'تفعيل Google Authenticator',
              ),
              BottomNavigationBarItem(
                icon: _AnimatedIcon(icon: Icons.swap_horiz),
                label: 'تحويل مبلغ',
              ),
              BottomNavigationBarItem(
                icon: _AnimatedIcon(icon: Icons.add_circle),
                label: 'إضافة أموال',
              ),
              BottomNavigationBarItem(
                icon: _AnimatedIcon(icon: Icons.settings),
                label: 'تغيير إعدادات الحساب',
              ),
            ],
            onTap: (index) => _handleNavigation(context, index),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Setup2FAPage()),
        );
        break;
      case 1:
        _showSnackBar(context, 'جاري فتح صفحة تحويل الأموال...');
        break;
      case 2:
        _showSnackBar(context, 'جاري فتح صفحة إضافة الأموال...');
        break;
      case 3:
        _showSnackBar(context, 'جاري فتح صفحة إعدادات الحساب...');
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4.0),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserAccount user) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: 1.0,
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFE5E7EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-5, -5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.5),
                width: 2,
              ),
            ),
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
          fontFamily: 'Cairo',
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
        style: TextStyle(
          fontFamily: 'Cairo',
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 30),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        value ?? 'غير متاح',
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}

class _AnimatedIcon extends StatefulWidget {
  final IconData icon;

  const _AnimatedIcon({required this.icon});

  @override
  _AnimatedIconState createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: Icon(widget.icon, size: 28),
      ),
    );
  }
}

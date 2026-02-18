import 'package:flutter/material.dart';
import '../screens/signup_student.dart';
import '../screens/signup_landlord.dart';
import '../screens/login.dart';

/// RoleSelectorPage is the entry point where users choose between
/// signing up as a Student or Landlord, or logging in
class RoleSelectorPage extends StatelessWidget {
  const RoleSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo/Brand Header
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.apartment,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Title
                  const Text(
                    'Campus Housing',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Find or list affordable housing near campus',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 50),

                  // Two vertical blocks: Lister & Seeker
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      final cardA = _RoleCard(
                        icon: Icons.home,
                        title: 'Lister',
                        description:
                            'List a property — for landlords, managers, or anyone who wants to advertise housing',
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LandlordSignupPage(),
                            ),
                          );
                        },
                      );

                      final cardB = _RoleCard(
                        icon: Icons.search,
                        title: 'Seeker',
                        description:
                            'Find housing — students, staff, families, and community members welcome',
                        color: Colors.indigo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StudentSignupPage(),
                            ),
                          );
                        },
                      );

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(child: cardA),
                            const SizedBox(width: 20),
                            Expanded(child: cardB),
                          ],
                        );
                      }

                      return Column(
                        children: [cardA, const SizedBox(height: 20), cardB],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Login Link
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A reusable card widget for role selection with gradient backgrounds
class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
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
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.05),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withValues(alpha: 0.2),
                    widget.color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Icon container
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.color,
                            widget.color.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(widget.icon, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // CTA Text
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              color: widget.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: widget.color,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

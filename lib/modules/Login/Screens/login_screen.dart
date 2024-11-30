import 'package:flutter/material.dart';
import 'package:DentaCarts/core/widgets/animated_form.dart';
import 'package:DentaCarts/core/widgets/illustration.dart';
import 'package:DentaCarts/core/widgets/tab_selector.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isExistingUser = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  void toggleForm(bool existing) {
    setState(() {
      isExistingUser = existing;
      existing
          ? _animationController.reverse()
          : _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  const Illustration(),
                  const SizedBox(height: 20),
                  TabSelector(
                    isExistingUser: isExistingUser,
                    onToggle: toggleForm,
                  ),
                  const SizedBox(height: 20),
                  AnimatedForm(
                    isExistingUser: isExistingUser,
                    animation: _animation,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

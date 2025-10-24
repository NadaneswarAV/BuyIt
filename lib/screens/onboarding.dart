import 'package:flutter/material.dart';
import '../widgets/rounded_button.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final mq = MediaQuery.of(ctx);
              final isCompact = mq.orientation == Orientation.landscape || constraints.maxHeight < 650;
              final topGap = isCompact ? 24.0 : 80.0;
              final bottomGap = isCompact ? 24.0 : 100.0;
              final logoH = isCompact ? 100.0 : 150.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Skip >",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: topGap),

                        // ✅ Logo + tagline
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/logo1.png',
                              height: logoH,
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "Why wait in line,\nwhen you can just BUY IT?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: bottomGap),

                        // ✅ Buttons section
                        Column(
                          children: [
                            RoundedButton(
                              text: "LET’S GET STARTED",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                "I already have an account",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

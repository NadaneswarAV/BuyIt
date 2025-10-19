import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/onboarding1.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Request edge-to-edge mode so the app can draw behind system bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // Set transparent system bars so background is visible behind them
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const BuyitApp());
}
 
class BuyitApp extends StatelessWidget {
  const BuyitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // full-screen background: place a green color behind the image so
          // any transparent/rounded areas in the image don't show black.
          Positioned.fill(
            child: Container(color: Colors.green.shade700),
          ),
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/Onboarding2.png',
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //     height: double.infinity,
          //   ),
          // ),
          // subtle overlay for contrast
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.25))),
          // The app UI sits on top; scaffolds are transparent to let the
          // background show through.
          Positioned.fill(
            child: MaterialApp(
              title: 'Buyit',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: const Color(0xFF1B1C4A),
                scaffoldBackgroundColor: Colors.transparent,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
                ),
                fontFamily: 'Poppins',
              ),
              home: const Onboarding1(),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundInspector extends StatelessWidget {
  const BackgroundInspector({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final padding = mq.padding;
    final viewInsets = mq.viewInsets;
    // show a small translucent box with values
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('window: ${WidgetsBinding.instance.window.physicalSize.width} x ${WidgetsBinding.instance.window.physicalSize.height} (physical)'),
            Text('size: ${size.width.toStringAsFixed(1)} x ${size.height.toStringAsFixed(1)}'),
            Text('padding: L${padding.left.toStringAsFixed(1)} T${padding.top.toStringAsFixed(1)} R${padding.right.toStringAsFixed(1)} B${padding.bottom.toStringAsFixed(1)}'),
            Text('insets: ${viewInsets.bottom.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}
 

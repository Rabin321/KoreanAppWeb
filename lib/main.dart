import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:korean_app_web/presentation/auth/loginscreen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBmeZUSxp9cIXtohDj2vQQx2hTG5JNnil0",
      authDomain: "korean-app-a4615.firebaseapp.com",
      projectId: "korean-app-a4615",
      storageBucket: "korean-app-a4615.appspot.com",
      messagingSenderId: "1041137681162",
      appId: "1:1041137681162:android:709679076acdde9dc9f0f3",
    ));
  } else {
    await Firebase.initializeApp();
  }
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: Sizer(
        // for responsiveness - package
        builder: (context, orientation, deviceType) => const MaterialApp(
          debugShowCheckedModeBanner: false,
          // home: WebLoginScreen(),
          home: LoginPage(),
        ),
      ),
    );
  }
}

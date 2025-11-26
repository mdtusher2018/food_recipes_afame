import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_recipes_afame/keys.dart';
import 'package:food_recipes_afame/localization/app_translation.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/view/Onboarding/onboarding_view.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();
  // Load translation files before app runs
  await AppTranslation.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AFAME',

      // 🔥 Localization implemented
      translations: AppTranslation(),
      locale: const Locale('fr', 'FR'), // Primary language (French)
      fallbackLocale: const Locale('fr', 'FR'),

      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto', // optional, change as per your font
      ),
      home: OnboardingView(),
    );
  }
}
//https://chatgpt.com/c/6835418a-2d78-8010-be54-fc28236e5515

//frokprint------https://chatgpt.com/c/685ca802-6080-8010-b81a-e26fb65b766e

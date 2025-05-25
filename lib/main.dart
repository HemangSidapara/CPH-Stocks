import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Localization/localization.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([]);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          localizationsDelegates: [FlutterQuillLocalizations.delegate],
          translations: Localization(),
          locale: getString(AppConstance.languageCode) != null && getString(AppConstance.languageCode) != '' && getString(AppConstance.languageCountryCode) != null && getString(AppConstance.languageCountryCode) != '' ? Locale(getString(AppConstance.languageCode) ?? Get.deviceLocale?.languageCode ?? 'en', getString(AppConstance.languageCountryCode)) : Get.deviceLocale,
          fallbackLocale: const Locale('en', 'IN'),
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.SECONDARY_COLOR,
            primaryColor: AppColors.PRIMARY_COLOR,
            textTheme: GoogleFonts.nunitoSansTextTheme(),
            datePickerTheme: DatePickerThemeData(headerBackgroundColor: AppColors.SECONDARY_COLOR),
            useMaterial3: true,
          ),
          initialRoute: Routes.splashScreen,
          defaultTransition: Transition.downToUp,
          getPages: AppPages.pages,
        );
      },
    );
  }
}

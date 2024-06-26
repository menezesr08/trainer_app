import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:trainer_app/routing/app_router.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: "assets/.env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  static const primaryColor = Colors.indigo;

  @override
  ConsumerState<MyApp> createState() => _ConsumerMyAppState();
}

class _ConsumerMyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      theme: FlexThemeData.light(
        scheme: FlexScheme.materialBaseline,
        usedColors: 7,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 4,
        appBarStyle: FlexAppBarStyle.background,
        bottomAppBarElevation: 1.0,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          blendTextTheme: true,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          thickBorderWidth: 2.0,
          elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorBackgroundAlpha: 12,
          inputDecoratorRadius: 8.0,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          appBarScrolledUnderElevation: 8.0,
          drawerElevation: 1.0,
          drawerWidth: 290.0,
          bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondary,
          bottomNavigationBarMutedUnselectedIcon: false,
          navigationBarSelectedLabelSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationBarSelectedIconSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationBarIndicatorOpacity: 1.00,
          navigationBarElevation: 1.0,
          navigationBarHeight: 72.0,
          navigationRailSelectedLabelSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationRailSelectedIconSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationRailIndicatorOpacity: 1.00,
        ),
        useMaterial3ErrorColors: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colors: FlexColor
            .schemes[FlexScheme.materialBaseline]!.light.defaultError
            .toDark(40, false),
        usedColors: 7,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 10,
        appBarStyle: FlexAppBarStyle.background,
        bottomAppBarElevation: 2.0,
        subThemesData: const FlexSubThemesData(
          cardElevation: 4,
          blendOnLevel: 20,
          blendTextTheme: true,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          thickBorderWidth: 2.0,
          elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorBackgroundAlpha: 48,
          inputDecoratorRadius: 8.0,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          drawerElevation: 1.0,
          drawerWidth: 290.0,
          bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondary,
          bottomNavigationBarMutedUnselectedIcon: false,
          navigationBarSelectedLabelSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationBarSelectedIconSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationBarIndicatorOpacity: 1.00,
          navigationBarElevation: 1.0,
          navigationBarHeight: 72.0,
          navigationRailSelectedLabelSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationRailSelectedIconSchemeColor:
              SchemeColor.onSecondaryContainer,
          navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationRailIndicatorOpacity: 1.00,
        ),
        useMaterial3ErrorColors: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,

        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

      debugShowCheckedModeBanner: false,
    );
  }
}

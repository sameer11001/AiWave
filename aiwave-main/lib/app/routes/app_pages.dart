import 'package:get/get.dart';

import '../modules/auth/bindings/register_binding.dart';
import '../modules/auth/bindings/signin_binding.dart';
import '../modules/auth/bindings/signup_binding.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/signin_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/aysel_wave/bindings/aysel_wave_binding.dart';
import '../modules/aysel_wave/views/aysel_wave_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/on_boarding/bindings/on_boarding_binding.dart';
import '../modules/on_boarding/views/on_boarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/selected_lang/bindings/selected_lang_binding.dart';
import '../modules/selected_lang/views/selected_lang_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/wave_player/bindings/wave_player_binding.dart';
import '../modules/wave_player/views/wave_player_view.dart';
import '../modules/wave_status/bindings/wave_status_binding.dart';
import '../modules/wave_status/views/wave_status_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.SELECTED_LANG,
      page: () => const SelectedLangView(),
      binding: SelectedLangBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.WAVE_STATUS,
      page: () => const WaveStatusView(),
      binding: WaveStatusBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.WAVE_PLAYER,
      page: () => const WavePlayerView(),
      binding: WavePlayerBinding(),
    ),
    GetPage(
      name: _Paths.AYSEL_WAVE,
      page: () => const AyselWaveView(),
      binding: AyselWaveBinding(),
    ),
  ];
}

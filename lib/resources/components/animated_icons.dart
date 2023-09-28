import 'package:chat_app/resources/app_paths.dart';
import 'package:lottie/lottie.dart';

class LottieIcons {
  static LottieBuilder email = Lottie.asset(
    AnimationPath.email,
    height: 20,
  );
  static LottieBuilder lock = Lottie.asset(AnimationPath.lock, height: 20);
  static LottieBuilder person = Lottie.asset(AnimationPath.person, height: 20);
  static LottieBuilder info = Lottie.asset(AnimationPath.info, height: 20);
  static LottieBuilder phone = Lottie.asset(AnimationPath.phone, height: 20);
  static LottieBuilder persontwo =
      Lottie.asset(AnimationPath.personTwo, height: 20);
  static LottieBuilder add = Lottie.asset(AnimationPath.add, height: 40);
}

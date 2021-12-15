import 'package:app/app/theme/icons_provider.dart';

extension MaterialIconMapping on String {
  String parseMaterialByIcon() {
    switch (this) {
      case 'eyes':
        return IconsProvider.EYES;
      case 'cloud':
        return IconsProvider.CLOUD;
      case 'hook':
        return IconsProvider.HOOK;
      case 'button':
        return IconsProvider.BUTTON;
      case 'nose':
        return IconsProvider.NOSE;
      case 'needle':
        return IconsProvider.NEEDLE;
      default:
        return IconsProvider.CLOUD; // TODO what to return here?
    }
  }
}

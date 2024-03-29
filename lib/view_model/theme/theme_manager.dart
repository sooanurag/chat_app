import 'package:chat_app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  get themeMode => _themeMode;
  toogleTheme({required bool isDark}) {
    _themeMode = (isDark) ? _themeMode = ThemeMode.dark : ThemeMode.light;
    (isDark)
        ? setColorPallet(pallet: AppColors.blackGreenDark)
        : setColorPallet(pallet: AppColors.defaultGreenYellow);
    notifyListeners();
  }

  Color _primary = AppColors.defaultGreenYellow[0];
  Color _onPrimary = AppColors.defaultGreenYellow[1];
  Color _onPrimaryLight = AppColors.defaultGreenYellow[2];
  Color _primaryNegative = AppColors.defaultGreenYellow[3];
  Color _primaryNegativeDark = AppColors.defaultGreenYellow[4];
  final Color _selectionColor = AppColors.selection;

  get selectionColor => _selectionColor;
  get primary => _primary;
  get onprimary => _onPrimary;
  get onprimaryLight => _onPrimaryLight;
  get primaryNegative => _primaryNegative;
  get primaryNegativeDark => _primaryNegativeDark;
  void setColorPallet({required List<Color> pallet}) {
    _primary = pallet[0];
    _onPrimary = pallet[1];
    _onPrimaryLight = pallet[2];
    _primaryNegative = pallet[3];
    _primaryNegativeDark = pallet[4];
    notifyListeners();
  }
}

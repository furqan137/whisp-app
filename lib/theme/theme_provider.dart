import 'package:flutter/material.dart';

/// Available Chat Themes
enum ChatTheme { Blue, Purple, Green, Red, Orange }

class ThemeProvider extends ChangeNotifier {
  // ───────────────────────────────────────────────────────────────
  // APP THEME (LIGHT / DARK)
  // ───────────────────────────────────────────────────────────────
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────
  // CHAT THEME COLORS
  // ───────────────────────────────────────────────────────────────
  ChatTheme _chatTheme = ChatTheme.Blue;
  ChatTheme get chatTheme => _chatTheme;

  void setChatTheme(ChatTheme theme) {
    _chatTheme = theme;
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────
  // GRADIENT COLORS
  // ───────────────────────────────────────────────────────────────
  static const Map<ChatTheme, List<Color>> _chatGradientColors = {
    ChatTheme.Blue: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ChatTheme.Purple: [Color(0xFF8A2387), Color(0xFFE94057)],
    ChatTheme.Green: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ChatTheme.Red: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    ChatTheme.Orange: [Color(0xFFF7971E), Color(0xFFFFD200)],
  };

  // ───────────────────────────────────────────────────────────────
  // ACCENT COLORS
  // ───────────────────────────────────────────────────────────────
  static const Map<ChatTheme, Color> _accentColors = {
    ChatTheme.Blue: Color(0xFF00F2FE),
    ChatTheme.Purple: Color(0xFFE94057),
    ChatTheme.Green: Color(0xFF38EF7D),
    ChatTheme.Red: Color(0xFFFF416C),
    ChatTheme.Orange: Color(0xFFFFD200),
  };

  // ───────────────────────────────────────────────────────────────
  // CHAT BACKGROUND COLORS
  // ───────────────────────────────────────────────────────────────
  static const Map<ChatTheme, Color> _chatBackgroundColors = {
    ChatTheme.Blue: Color(0xFFE7F3FF),
    ChatTheme.Purple: Color(0xFFF5E6FF),
    ChatTheme.Green: Color(0xFFE9FFF3),
    ChatTheme.Red: Color(0xFFFFE8E8),
    ChatTheme.Orange: Color(0xFFFFF4E3),
  };

  /// Chat screen background
  Color get chatBackground => _chatBackgroundColors[_chatTheme]!;

  // ───────────────────────────────────────────────────────────────
  // BUBBLE GRADIENT AND COLORS
  // ───────────────────────────────────────────────────────────────
  Gradient get chatGradient {
    final colors = _chatGradientColors[_chatTheme]!;
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Color get accentColor => _accentColors[_chatTheme]!;
  Color get myBubbleFallbackColor => _chatGradientColors[_chatTheme]!.first;
  Color get myBubbleTextColor => Colors.white;

  Color othersBubbleBackground(bool isDark) =>
      isDark ? Colors.white12 : Colors.grey.shade200;

  Color othersBubbleTextColor(bool isDark) =>
      isDark ? Colors.white : Colors.black87;

  // ----------------------------------------------------------------
  // NEW → CHAT APP BAR COLOR (Matches Chat Theme)
  // ----------------------------------------------------------------
  Color chatAppBarColor(bool isDark) {
    if (isDark) return const Color(0xFF0C1220); // dark app bar
    return _chatGradientColors[_chatTheme]!.first; // use theme color
  }

  // Gradient preview helper
  Gradient chatGradientFor(ChatTheme theme, BuildContext context) {
    final colors = _chatGradientColors[theme]!;
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Theme names (settings UI)
  String getThemeName(ChatTheme theme) {
    switch (theme) {
      case ChatTheme.Blue:
        return "Ocean Blue";
      case ChatTheme.Purple:
        return "Royal Purple";
      case ChatTheme.Green:
        return "Fresh Green";
      case ChatTheme.Red:
        return "Energy Red";
      case ChatTheme.Orange:
        return "Sunset Orange";
    }
  }
}

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
  // CHAT THEME (COLOR PACKS)
  // ───────────────────────────────────────────────────────────────
  ChatTheme _chatTheme = ChatTheme.Blue;
  ChatTheme get chatTheme => _chatTheme;

  void setChatTheme(ChatTheme theme) {
    _chatTheme = theme;
    notifyListeners();
  }

  // ───────────────────────────────────────────────────────────────
  // GRADIENT COLORS FOR BUBBLES
  // ───────────────────────────────────────────────────────────────
  static const Map<ChatTheme, List<Color>> _chatGradientColors = {
    ChatTheme.Blue: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ChatTheme.Purple: [Color(0xFF8A2387), Color(0xFFE94057)],
    ChatTheme.Green: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ChatTheme.Red: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    ChatTheme.Orange: [Color(0xFFF7971E), Color(0xFFFFD200)],
  };

  // ───────────────────────────────────────────────────────────────
  // ACCENT COLORS (SWITCHES, ICONS)
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
  // GETTERS – BUBBLE COLORS & GRADIENTS
  // ───────────────────────────────────────────────────────────────

  /// Gradient for **my outgoing** bubble
  Gradient get chatGradient {
    final colors = _chatGradientColors[_chatTheme]!;
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Accent color (switches, borders, highlights)
  Color get accentColor => _accentColors[_chatTheme]!;

  /// Fallback solid color for my bubble (if gradient not supported)
  Color get myBubbleFallbackColor => _chatGradientColors[_chatTheme]!.first;

  /// My message text color (always white)
  Color get myBubbleTextColor => Colors.white;

  /// Other person's bubble background
  Color othersBubbleBackground(bool isDark) =>
      isDark ? Colors.white12 : Colors.grey.shade200;

  /// Other person's text color
  Color othersBubbleTextColor(bool isDark) =>
      isDark ? Colors.white : Colors.black87;

  /// Get selected theme gradient (for preview)
  Gradient chatGradientFor(ChatTheme theme, BuildContext context) {
    final colors = _chatGradientColors[theme]!;
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // ───────────────────────────────────────────────────────────────
  // THEME NAMES (USED IN SETTINGS UI)
  // ───────────────────────────────────────────────────────────────
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

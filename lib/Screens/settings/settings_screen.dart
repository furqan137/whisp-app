import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final isDark = provider.isDarkMode;

    final bgColor = isDark ? const Color(0xff090F21) : const Color(0xffFFE6EF);

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        title: const Text(
          "Themes",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- APPEARANCE ----------
            Text(
              "Appearance",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),
            _appearanceCard(provider, isDark),

            const SizedBox(height: 25),

            // ---------- CHAT THEMES GRID ----------
            Text(
              "Chat Themes",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ChatTheme.values.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (context, index) {
                final t = ChatTheme.values[index];
                return _themePreviewCard(
                  provider: provider,
                  theme: t,
                  isSelected: provider.chatTheme == t,
                );
              },
            ),

            const SizedBox(height: 30),

            // ---------- RESET BUTTON ----------
            Center(
              child: TextButton(
                onPressed: () => provider.setChatTheme(ChatTheme.Blue),
                child: const Text(
                  "Reset to Default",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // APPEARANCE CARD
  // =====================================================================
  Widget _appearanceCard(ThemeProvider provider, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111A2E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Dark Mode",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Switch(
            value: provider.isDarkMode,
            activeColor: provider.accentColor,
            onChanged: provider.toggleTheme,
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // THEME PREVIEW CARD — MODERN + COLORED
  // =====================================================================
  Widget _themePreviewCard({
    required ThemeProvider provider,
    required ChatTheme theme,
    required bool isSelected,
  }) {
    final gradient = provider.chatGradientFor(theme, context);

    // Light tint based on theme color
    final tintedBg = provider.chatBackground;

    return GestureDetector(
      onTap: () => provider.setChatTheme(theme),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: tintedBg,                          // 🔥 Card background tinted
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? provider.accentColor : Colors.white.withOpacity(0.3),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: provider.accentColor.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const SizedBox(height: 6),

            Text(
              provider.getThemeName(theme),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 14),

            // ------------------ CHAT PREVIEW ------------------
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left bubble
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: provider.othersBubbleBackground(false),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("Hello 👋"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Right bubble
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Hi ✨",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ------------------ THEME NAME ------------------
            Text(
              theme.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: provider.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

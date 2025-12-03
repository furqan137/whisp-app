import 'package:flutter/material.dart';
import 'help_support_screen.dart';
import 'report_bug_screen.dart';
import '../privacy_policy_screen.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xff090F21) : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black87;
    final tileColor = isDark ? const Color(0xFF111A2E) : Colors.white;

    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "About App",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [

            // ---------------------------------------------------------
            // App Icon / Logo Section
            // ---------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFC107), Color(0xFFFF5722)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 14,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Icon(Icons.apps, size: 80, color: Colors.white),
            ),

            const SizedBox(height: 25),

            Text(
              "Secure Chat App",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 35),

            // ---------------------------------------------------------
            // APP DETAILS CARD
            // ---------------------------------------------------------
            _infoCard(
              context,
              title: "Version",
              value: "1.0.0",
              tileColor: tileColor,
              textColor: textColor,
            ),
            _infoCard(
              context,
              title: "Developer",
              value: "Furqan Zafar",
              tileColor: tileColor,
              textColor: textColor,
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // HELP & SUPPORT
            // ---------------------------------------------------------
            _navTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              context: context,
              tileColor: tileColor,
              textColor: textColor,
              screen: const HelpSupportScreen(),
            ),

            _navTile(
              icon: Icons.bug_report_outlined,
              title: "Report a Bug",
              context: context,
              tileColor: tileColor,
              textColor: textColor,
              screen: const ReportBugScreen(),
            ),

            const SizedBox(height: 40),

            // ---------------------------------------------------------
            // PRIVACY POLICY BUTTON
            // ---------------------------------------------------------
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.blueAccent : Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),


            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // INFO CARD WIDGET (VERSION, DEVELOPER)
  // ---------------------------------------------------------
  Widget _infoCard(BuildContext context,
      {required String title,
        required String value,
        required Color tileColor,
        required Color textColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // NAVIGATION TILE WIDGET
  // ---------------------------------------------------------
  Widget _navTile({
    required IconData icon,
    required String title,
    required BuildContext context,
    required Color tileColor,
    required Color textColor,
    required Widget screen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(title,
            style:
            TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 18),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}

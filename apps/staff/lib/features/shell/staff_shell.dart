import 'package:material_ui/material_ui.dart';
import 'package:smartbarber_staff/l10n/generated/app_localizations.dart';

/// Bottom-navigation shell: Today, Queue, Customers, POS, Me.
class StaffShell extends StatelessWidget {
  const new({required this.currentIndex, required this.onSelect, required this.child, super.key});

  final int currentIndex;
  final ValueChanged<int> onSelect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onSelect,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.today_outlined), selectedIcon: const Icon(Icons.today_rounded), label: l.tabToday),
          NavigationDestination(icon: const Icon(Icons.groups_outlined), selectedIcon: const Icon(Icons.groups_rounded), label: l.tabQueue),
          NavigationDestination(icon: const Icon(Icons.badge_outlined), selectedIcon: const Icon(Icons.badge_rounded), label: l.tabCustomers),
          NavigationDestination(icon: const Icon(Icons.point_of_sale_outlined), selectedIcon: const Icon(Icons.point_of_sale_rounded), label: l.tabPos),
          NavigationDestination(icon: const Icon(Icons.person_outline_rounded), selectedIcon: const Icon(Icons.person_rounded), label: l.tabMe),
        ],
      ),
    );
  }
}

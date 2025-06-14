import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_view.dart';
import 'map_view.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(tabIndexProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: const [
          HomeView(),
          MapView(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: theme.copyWith(
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              return theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: states.contains(WidgetState.selected)
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onPrimary.withOpacity(0.7),
              );
            }),
          ),
        ),
        child: NavigationBar(
          selectedIndex: tabIndex,
          onDestinationSelected: (index) {
            ref.read(tabIndexProvider.notifier).state = index;
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.list_alt, size: 28),
              selectedIcon: Icon(Icons.list_alt, size: 28, color: theme.colorScheme.onPrimary),
              label: 'List',
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined, size: 28),
              selectedIcon: Icon(Icons.map_outlined, size: 28, color: theme.colorScheme.onPrimary),
              label: 'Map',
            ),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 400),
          backgroundColor: theme.colorScheme.primary,
          indicatorColor: theme.colorScheme.primaryContainer,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          height: 70,
        ),
      ),
    );
  }
}
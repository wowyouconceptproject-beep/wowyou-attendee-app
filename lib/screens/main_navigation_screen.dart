import "package:flutter/material.dart";

import "home_screen.dart";
import "search/search_screen.dart";
import "my_events_screen.dart";
import "tickets_screen.dart";
import "settings/settings_screen.dart";

class MainNavigationScreen
    extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
  });

  @override
  State<MainNavigationScreen>
      createState() =>
          _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  /*
  |--------------------------------------------------------------------------
  | Init
  |--------------------------------------------------------------------------
  */

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomeScreen(),

      const SearchScreen(),

      MyEventsScreen(
        onDiscover: () {
          _selectTab(0);
        },
      ),

      const TicketsScreen(),

      const SettingsScreen(),
    ];
  }

  /*
  |--------------------------------------------------------------------------
  | Select Tab
  |--------------------------------------------------------------------------
  */

  void _selectTab(
    int index,
  ) {
    if (_currentIndex ==
        index) {
      return;
    }

    setState(() {
      _currentIndex =
          index;
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Build
  |--------------------------------------------------------------------------
  */

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body:
          IndexedStack(
        index:
            _currentIndex,

        children:
            _pages,
      ),

      bottomNavigationBar:
          NavigationBar(
        selectedIndex:
            _currentIndex,

        onDestinationSelected:
            _selectTab,

        destinations:
            const [
          NavigationDestination(
            icon:
                Icon(
              Icons.home_outlined,
            ),

            selectedIcon:
                Icon(
              Icons.home,
            ),

            label:
                "Home",
          ),

          NavigationDestination(
            icon:
                Icon(
              Icons.search_outlined,
            ),

            selectedIcon:
                Icon(
              Icons.search,
            ),

            label:
                "Search",
          ),

          NavigationDestination(
            icon:
                Icon(
              Icons.event_outlined,
            ),

            selectedIcon:
                Icon(
              Icons.event,
            ),

            label:
                "Events",
          ),

          NavigationDestination(
            icon:
                Icon(
              Icons
                  .confirmation_number_outlined,
            ),

            selectedIcon:
                Icon(
              Icons
                  .confirmation_number,
            ),

            label:
                "Tickets",
          ),

          NavigationDestination(
            icon:
                Icon(
              Icons.settings_outlined,
            ),

            selectedIcon:
                Icon(
              Icons.settings,
            ),

            label:
                "Settings",
          ),
        ],
      ),
    );
  }
}
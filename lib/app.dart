import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "providers/auth_provider.dart";
import "providers/favorites_provider.dart";
import "screens/create_itinerary_screen.dart";
import "screens/destination_detail_screen.dart";
import "screens/home_screen.dart";
import "screens/itineraries_screen.dart";
import "screens/itinerary_detail_screen.dart";
import "screens/login_screen.dart";
import "screens/map_screen.dart";
import "screens/profile_screen.dart";
import "screens/register_screen.dart";
import "screens/saved_destinations_screen.dart";
import "utils/theme.dart";

class GlobetrotterApp extends StatelessWidget {
  const GlobetrotterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..load(),
        ),
      ],
      child: MaterialApp(
        title: "GlobeTrotter Cameroon",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: "/login",
        routes: {
          "/login": (_) => const LoginScreen(),
          "/register": (_) => const RegisterScreen(),
          "/saved": (_) => const SavedDestinationsScreen(),
          "/destination_detail": (_) => const DestinationDetailScreen(),
          "/home": (_) => const HomeScreen(),
          "/map": (_) => const MapScreen(),
          "/itineraries": (_) => const ItinerariesScreen(),
          "/create_itinerary": (_) => const CreateItineraryScreen(),
          "/itinerary_detail": (_) => const ItineraryDetailScreen(),
          "/profile": (_) => const ProfileScreen(),
        },
      ),
    );
  }
}

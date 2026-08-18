import "package:flutter/material.dart";

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = <Locale>[
    Locale("en"),
    Locale("fr"),
    Locale("cpe"),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale("en"));
  }

  String _text(String key) {
    final language = _catalog[locale.languageCode] ?? _catalog["en"]!;
    return language[key] ?? _catalog["en"]![key] ?? key;
  }

  String _replace(String key, String token, String value) =>
      _text(key).replaceAll("{$token}", value);

  String get appTitle => _text("appTitle");
  String get brand => _text("brand");
  String get language => _text("language");
  String get english => _text("english");
  String get french => _text("french");
  String get pidgin => _text("pidgin");
  String get navDestinations => _text("navDestinations");
  String get navRecommendations => _text("navRecommendations");
  String get navFavorites => _text("navFavorites");
  String get navMap => _text("navMap");
  String get navItineraries => _text("navItineraries");
  String get navProfile => _text("navProfile");
  String hello(String name) => _replace("hello", "name", name);

  String get destinationsHeading => _text("destinationsHeading");
  String get destinationsSubtitle => _text("destinationsSubtitle");
  String get searchPlacesHint => _text("searchPlacesHint");
  String get placesReading => _text("placesReading");
  String placesFound(int count) => _replace("placesFound", "count", "$count");
  String get destinationsErrorTitle => _text("destinationsErrorTitle");
  String get destinationsEmptyTitle => _text("destinationsEmptyTitle");
  String get destinationsEmptyMessage => _text("destinationsEmptyMessage");
  String get mapShortcut => _text("mapShortcut");
  String get savedShortcut => _text("savedShortcut");
  String get filterTooltip => _text("filterTooltip");
  String get sortLabel => _text("sortLabel");
  String get recommendationsHeading => _text("recommendationsHeading");
  String get recommendationsSubtitle => _text("recommendationsSubtitle");
  String get recommendationsLoading => _text("recommendationsLoading");
  String get recommendationsErrorTitle => _text("recommendationsErrorTitle");
  String get journeyAwaits => _text("journeyAwaits");
  String get recommendationsEmptyMessage =>
      _text("recommendationsEmptyMessage");
  String get tunePreferences => _text("tunePreferences");
  String get recommendationsNoSignals => _text("recommendationsNoSignals");
  String get recommendationsRefreshed => _text("recommendationsRefreshed");
  String get editPreferences => _text("editPreferences");

  String get favoritesTitle => _text("favoritesTitle");
  String get refreshSavedPlaces => _text("refreshSavedPlaces");
  String get savedLoading => _text("savedLoading");
  String get savedErrorTitle => _text("savedErrorTitle");
  String get savedEmptyTitle => _text("savedEmptyTitle");
  String get savedEmptyMessage => _text("savedEmptyMessage");
  String get exploreDestinations => _text("exploreDestinations");

  String get loginTopline => _text("loginTopline");
  String get loginEyebrow => _text("loginEyebrow");
  String get loginTitle => _text("loginTitle");
  String get loginSubtitle => _text("loginSubtitle");
  String get username => _text("username");
  String get usernameHint => _text("usernameHint");
  String get enterUsername => _text("enterUsername");
  String get password => _text("password");
  String get passwordHint => _text("passwordHint");
  String get enterPassword => _text("enterPassword");
  String get showPassword => _text("showPassword");
  String get hidePassword => _text("hidePassword");
  String get continueExploring => _text("continueExploring");
  String get signingIn => _text("signingIn");
  String get newToGlobetrotter => _text("newToGlobetrotter");
  String get createTravelAccount => _text("createTravelAccount");
  String get loginFooter => _text("loginFooter");

  String get registerTopline => _text("registerTopline");
  String get registerEyebrow => _text("registerEyebrow");
  String get registerTitle => _text("registerTitle");
  String get registerSubtitle => _text("registerSubtitle");
  String get registerUsernameHint => _text("registerUsernameHint");
  String get chooseUsername => _text("chooseUsername");
  String get newPasswordHint => _text("newPasswordHint");
  String get choosePassword => _text("choosePassword");
  String get createAccount => _text("createAccount");
  String get creatingAccount => _text("creatingAccount");
  String get alreadyHaveAccount => _text("alreadyHaveAccount");
  String get returnToSignIn => _text("returnToSignIn");
  String get registerFooter => _text("registerFooter");

  String get mapHeading => _text("mapHeading");
  String get mapSubtitle => _text("mapSubtitle");
  String get mapLoading => _text("mapLoading");
  String get mapErrorTitle => _text("mapErrorTitle");
  String get noMappedPlaces => _text("noMappedPlaces");
  String get noMappedPlacesMessage => _text("noMappedPlacesMessage");
  String get myTrips => _text("myTrips");
  String get itineraryHeading => _text("itineraryHeading");
  String get itinerarySubtitle => _text("itinerarySubtitle");
  String get itineraryLoading => _text("itineraryLoading");
  String get itineraryErrorTitle => _text("itineraryErrorTitle");
  String get itineraryEmptyTitle => _text("itineraryEmptyTitle");
  String get itineraryEmptyMessage => _text("itineraryEmptyMessage");
  String get planNewTrip => _text("planNewTrip");
  String get profileTitle => _text("profileTitle");
  String get backToLogin => _text("backToLogin");
  String get useAtLeastThreeCharacters => _text("useAtLeastThreeCharacters");
  String get useAtLeastEightCharacters => _text("useAtLeastEightCharacters");
  String get onTheMap => _text("onTheMap");
  String get mapStartingPoint => _text("mapStartingPoint");
  String get mapsConfigurationTitle => _text("mapsConfigurationTitle");
  String get mapsConfigurationMessage => _text("mapsConfigurationMessage");
  String get mapsConfigurationHint => _text("mapsConfigurationHint");
  String get whyGo => _text("whyGo");
  String get fieldNotes => _text("fieldNotes");
  String get savePlaceMessage => _text("savePlaceMessage");

  static const _catalog = <String, Map<String, String>>{
    "en": {
      "appTitle": "GlobeTrotter Cameroon",
      "brand": "GLOBETROTTER / CAMEROON",
      "language": "Language",
      "english": "English",
      "french": "Français",
      "pidgin": "Cameroonian Pidgin English",
      "navDestinations": "Destinations",
      "navRecommendations": "Recommendations",
      "navFavorites": "Favorites",
      "navMap": "Map",
      "navItineraries": "Itineraries",
      "navProfile": "Profile",
      "hello": "Hello, {name}",
      "destinationsHeading": "Find your next field note",
      "destinationsSubtitle":
          "From quiet coastlines to mountain air, start with a place that pulls you in.",
      "searchPlacesHint": "Search places, regions, or moods",
      "placesReading": "Reading the guide…",
      "placesFound": "{count} places found",
      "destinationsErrorTitle": "We lost the trail.",
      "destinationsEmptyTitle": "No places on this path yet.",
      "destinationsEmptyMessage":
          "Try another search or loosen your filters to keep exploring.",
      "mapShortcut": "Open destination map",
      "savedShortcut": "Open saved places",
      "filterTooltip": "Filter by region and budget",
      "sortLabel": "Recommended",
      "recommendationsHeading": "A route shaped for you",
      "recommendationsSubtitle":
          "Picked from the things you want to feel more of.",
      "recommendationsLoading": "Reading your travel signals…",
      "recommendationsErrorTitle": "Your compass needs a reset.",
      "journeyAwaits": "Your journey awaits.",
      "recommendationsEmptyMessage":
          "Add a few interests to your profile and we’ll shape a more personal path.",
      "tunePreferences": "Tune my preferences",
      "recommendationsNoSignals": "No signals selected yet",
      "recommendationsRefreshed": "Recommendations refreshed",
      "editPreferences": "Edit",
      "favoritesTitle": "Saved places",
      "refreshSavedPlaces": "Refresh saved places",
      "savedLoading": "Gathering your saved places…",
      "savedErrorTitle": "Your saved map went quiet.",
      "savedEmptyTitle": "Keep a few places close.",
      "savedEmptyMessage":
          "Tap the heart on any destination to build your own shortlist.",
      "exploreDestinations": "Explore destinations",
      "loginTopline": "A more personal way to see Cameroon.",
      "loginEyebrow": "WELCOME BACK",
      "loginTitle": "Pick up where your journey left off.",
      "loginSubtitle":
          "Sign in to discover thoughtful routes, local favorites, and trips worth remembering.",
      "username": "Username",
      "usernameHint": "Your traveller name",
      "enterUsername": "Enter your username",
      "password": "Password",
      "passwordHint": "Your password",
      "enterPassword": "Enter your password",
      "showPassword": "Show password",
      "hidePassword": "Hide password",
      "continueExploring": "Continue exploring",
      "signingIn": "Signing in…",
      "newToGlobetrotter": "NEW TO GLOBETROTTER?",
      "createTravelAccount": "Create your travel account",
      "loginFooter": "Your plans stay yours. Your next adventure starts here.",
      "registerTopline": "Start with a better map.",
      "registerEyebrow": "CREATE YOUR ACCOUNT",
      "registerTitle": "Make room for more detours.",
      "registerSubtitle":
          "Save places that spark something, then turn them into a trip that feels like yours.",
      "registerUsernameHint": "What should we call you?",
      "chooseUsername": "Choose a username",
      "newPasswordHint": "Keep it memorable and private",
      "choosePassword": "Choose a password",
      "createAccount": "Create account",
      "creatingAccount": "Creating your account…",
      "alreadyHaveAccount": "ALREADY HAVE AN ACCOUNT?",
      "returnToSignIn": "Return to sign in",
      "registerFooter": "Create once. Keep exploring at your own pace.",
      "mapHeading": "Plan by place",
      "mapSubtitle": "Explore every mapped destination in Cameroon.",
      "mapLoading": "Unfolding the map…",
      "mapErrorTitle": "The map lost its trail.",
      "noMappedPlaces": "No mapped places yet.",
      "noMappedPlacesMessage":
          "Add coordinates to destinations to bring them onto the map.",
      "myTrips": "My trips",
      "itineraryHeading": "Your journeys",
      "itinerarySubtitle": "Keep the good ideas in one place.",
      "itineraryLoading": "Gathering your routes…",
      "itineraryErrorTitle": "Your map went quiet.",
      "itineraryEmptyTitle": "Your first trip is still unwritten.",
      "itineraryEmptyMessage":
          "Save the places you love, then turn them into a route with room for detours.",
      "planNewTrip": "Plan a new trip",
      "profileTitle": "Profile",
      "backToLogin": "Back to login",
      "useAtLeastThreeCharacters": "Use at least 3 characters",
      "useAtLeastEightCharacters": "Use at least 8 characters",
      "onTheMap": "On the map",
      "mapStartingPoint": "A starting point for your field notes.",
      "mapsConfigurationTitle": "Google Maps is not configured",
      "mapsConfigurationMessage":
          "Add a local Google Maps API key, then rebuild the app to see the live map.",
      "mapsConfigurationHint":
          "The destination data and route are ready; only the map key is missing.",
      "whyGo": "Why go",
      "fieldNotes": "Field notes",
      "savePlaceMessage":
          "Save this place to keep it close while you shape your next trip.",
    },
    "fr": {
      "appTitle": "GlobeTrotter Cameroun",
      "brand": "GLOBETROTTER / CAMEROUN",
      "language": "Langue",
      "english": "English",
      "french": "Français",
      "pidgin": "Pidgin camerounais",
      "navDestinations": "Destinations",
      "navRecommendations": "Recommandations",
      "navFavorites": "Favoris",
      "navMap": "Carte",
      "navItineraries": "Itinéraires",
      "navProfile": "Profil",
      "hello": "Bonjour, {name}",
      "destinationsHeading": "Trouvez votre prochaine escapade",
      "destinationsSubtitle":
          "Des côtes tranquilles à l’air des montagnes, commencez par un lieu qui vous attire.",
      "searchPlacesHint": "Rechercher un lieu, une région ou une ambiance",
      "placesReading": "Lecture du guide…",
      "placesFound": "{count} lieux trouvés",
      "destinationsErrorTitle": "Nous avons perdu la piste.",
      "destinationsEmptyTitle": "Aucun lieu sur ce chemin pour le moment.",
      "destinationsEmptyMessage":
          "Essayez une autre recherche ou élargissez vos filtres.",
      "mapShortcut": "Ouvrir la carte des destinations",
      "savedShortcut": "Ouvrir les lieux enregistrés",
      "filterTooltip": "Filtrer par région et budget",
      "sortLabel": "Recommandé",
      "recommendationsHeading": "Un itinéraire pensé pour vous",
      "recommendationsSubtitle":
          "Choisi selon les expériences que vous souhaitez vivre.",
      "recommendationsLoading": "Lecture de vos préférences…",
      "recommendationsErrorTitle": "Votre boussole doit être réinitialisée.",
      "journeyAwaits": "Votre voyage vous attend.",
      "recommendationsEmptyMessage":
          "Ajoutez quelques centres d’intérêt pour créer un parcours plus personnel.",
      "tunePreferences": "Régler mes préférences",
      "recommendationsNoSignals": "Aucune préférence sélectionnée",
      "recommendationsRefreshed": "Recommandations actualisées",
      "editPreferences": "Modifier",
      "favoritesTitle": "Lieux enregistrés",
      "refreshSavedPlaces": "Actualiser les lieux enregistrés",
      "savedLoading": "Récupération de vos lieux…",
      "savedErrorTitle":
          "Vos lieux enregistrés sont momentanément indisponibles.",
      "savedEmptyTitle": "Gardez quelques lieux près de vous.",
      "savedEmptyMessage":
          "Touchez le cœur d’une destination pour créer votre sélection.",
      "exploreDestinations": "Explorer les destinations",
      "loginTopline": "Une façon plus personnelle de découvrir le Cameroun.",
      "loginEyebrow": "BON RETOUR",
      "loginTitle": "Reprenez votre voyage là où vous l’avez laissé.",
      "loginSubtitle":
          "Connectez-vous pour découvrir des itinéraires soignés, des coups de cœur locaux et des voyages mémorables.",
      "username": "Nom d’utilisateur",
      "usernameHint": "Votre nom de voyageur",
      "enterUsername": "Entrez votre nom d’utilisateur",
      "password": "Mot de passe",
      "passwordHint": "Votre mot de passe",
      "enterPassword": "Entrez votre mot de passe",
      "showPassword": "Afficher le mot de passe",
      "hidePassword": "Masquer le mot de passe",
      "continueExploring": "Continuer l’exploration",
      "signingIn": "Connexion…",
      "newToGlobetrotter": "NOUVEAU SUR GLOBETROTTER ?",
      "createTravelAccount": "Créer votre compte voyage",
      "loginFooter":
          "Vos projets restent à vous. La prochaine aventure commence ici.",
      "registerTopline": "Commencez avec une meilleure carte.",
      "registerEyebrow": "CRÉER VOTRE COMPTE",
      "registerTitle": "Faites place à de nouveaux détours.",
      "registerSubtitle":
          "Enregistrez les lieux qui vous inspirent et transformez-les en un voyage qui vous ressemble.",
      "registerUsernameHint": "Comment devons-nous vous appeler ?",
      "chooseUsername": "Choisissez un nom d’utilisateur",
      "newPasswordHint": "Facile à retenir et privé",
      "choosePassword": "Choisissez un mot de passe",
      "createAccount": "Créer le compte",
      "creatingAccount": "Création de votre compte…",
      "alreadyHaveAccount": "VOUS AVEZ DÉJÀ UN COMPTE ?",
      "returnToSignIn": "Retour à la connexion",
      "registerFooter": "Créez une fois. Continuez à explorer à votre rythme.",
      "mapHeading": "Planifier par lieu",
      "mapSubtitle": "Explorez chaque destination camerounaise cartographiée.",
      "mapLoading": "Ouverture de la carte…",
      "mapErrorTitle": "La carte a perdu sa piste.",
      "noMappedPlaces": "Aucun lieu cartographié pour le moment.",
      "noMappedPlacesMessage":
          "Ajoutez des coordonnées aux destinations pour les afficher sur la carte.",
      "myTrips": "Mes voyages",
      "itineraryHeading": "Vos voyages",
      "itinerarySubtitle": "Gardez vos bonnes idées au même endroit.",
      "itineraryLoading": "Récupération de vos itinéraires…",
      "itineraryErrorTitle": "Votre carte est silencieuse.",
      "itineraryEmptyTitle": "Votre premier voyage reste à écrire.",
      "itineraryEmptyMessage":
          "Enregistrez vos lieux préférés et transformez-les en itinéraire.",
      "planNewTrip": "Planifier un voyage",
      "profileTitle": "Profil",
      "backToLogin": "Retour à la connexion",
      "useAtLeastThreeCharacters": "Utilisez au moins 3 caractères",
      "useAtLeastEightCharacters": "Utilisez au moins 8 caractères",
      "onTheMap": "Sur la carte",
      "mapStartingPoint": "Un point de départ pour vos notes.",
      "mapsConfigurationTitle": "Google Maps n’est pas configuré",
      "mapsConfigurationMessage":
          "Ajoutez une clé Google Maps locale, puis reconstruisez l’application pour voir la carte.",
      "mapsConfigurationHint":
          "Les destinations et l’itinéraire sont prêts ; il manque seulement la clé.",
      "whyGo": "Pourquoi y aller",
      "fieldNotes": "Notes de terrain",
      "savePlaceMessage":
          "Enregistrez ce lieu pour le garder près de vous pendant votre prochain voyage.",
    },
    "cpe": {
      "appTitle": "GlobeTrotter Cameroon",
      "brand": "GLOBETROTTER / CAMEROON",
      "language": "Language",
      "english": "English",
      "french": "French",
      "pidgin": "Cameroonian Pidgin",
      "navDestinations": "Wetin You Fit Visit",
      "navRecommendations": "Wetin Fit Match You",
      "navFavorites": "My Favorites",
      "navMap": "Map",
      "navItineraries": "My Trips",
      "navProfile": "My Profile",
      "hello": "How you dey, {name}",
      "destinationsHeading": "Find where you fit go next",
      "destinationsSubtitle":
          "From quiet beach to mountain breeze, start with place wey call you.",
      "searchPlacesHint": "Find place, region, or kind vibe",
      "placesReading": "We dey read the guide…",
      "placesFound": "{count} places don show",
      "destinationsErrorTitle": "We lose the trail.",
      "destinationsEmptyTitle": "No place for this path yet.",
      "destinationsEmptyMessage":
          "Try another search or make your filters loose small.",
      "mapShortcut": "Open destination map",
      "savedShortcut": "Open saved places",
      "filterTooltip": "Filter by region and budget",
      "sortLabel": "Recommended",
      "recommendationsHeading": "Route wey fit you",
      "recommendationsSubtitle": "We pick am from the things you like feel.",
      "recommendationsLoading": "We dey read your travel signals…",
      "recommendationsErrorTitle": "Your compass need reset.",
      "journeyAwaits": "Your journey dey wait.",
      "recommendationsEmptyMessage":
          "Add some interests for your profile make we shape better path.",
      "tunePreferences": "Tune my preferences",
      "recommendationsNoSignals": "You never choose signal yet",
      "recommendationsRefreshed": "Recommendations don refresh",
      "editPreferences": "Edit",
      "favoritesTitle": "Places wey you save",
      "refreshSavedPlaces": "Refresh saved places",
      "savedLoading": "We dey gather your saved places…",
      "savedErrorTitle": "Your saved map no dey respond now.",
      "savedEmptyTitle": "Keep some places close.",
      "savedEmptyMessage":
          "Tap heart for any place to build your own shortlist.",
      "exploreDestinations": "Explore places",
      "loginTopline": "See Cameroon in your own way.",
      "loginEyebrow": "WELCOME BACK",
      "loginTitle": "Continue from where your journey stop.",
      "loginSubtitle":
          "Sign in for better routes, local favorites, and trips wey worth remember.",
      "username": "Username",
      "usernameHint": "Your traveller name",
      "enterUsername": "Enter your username",
      "password": "Password",
      "passwordHint": "Your password",
      "enterPassword": "Enter your password",
      "showPassword": "Show password",
      "hidePassword": "Hide password",
      "continueExploring": "Continue dey explore",
      "signingIn": "We dey sign you in…",
      "newToGlobetrotter": "NEW TO GLOBETROTTER?",
      "createTravelAccount": "Create your travel account",
      "loginFooter": "Your plans na your own. The next adventure start here.",
      "registerTopline": "Start with better map.",
      "registerEyebrow": "CREATE YOUR ACCOUNT",
      "registerTitle": "Make space for more detours.",
      "registerSubtitle":
          "Save places wey spark you, then turn them to trip wey feel like your own.",
      "registerUsernameHint": "Wetin we go call you?",
      "chooseUsername": "Choose username",
      "newPasswordHint": "Make am easy remember and private",
      "choosePassword": "Choose password",
      "createAccount": "Create account",
      "creatingAccount": "We dey create your account…",
      "alreadyHaveAccount": "YOU GET ACCOUNT ALREADY?",
      "returnToSignIn": "Go back sign in",
      "registerFooter": "Create once. Keep exploring for your own pace.",
      "mapHeading": "Plan by place",
      "mapSubtitle": "Explore all Cameroon places we don map.",
      "mapLoading": "We dey open the map…",
      "mapErrorTitle": "The map lose its trail.",
      "noMappedPlaces": "No mapped place yet.",
      "noMappedPlacesMessage": "Add coordinates make places show for the map.",
      "myTrips": "My trips",
      "itineraryHeading": "Your journeys",
      "itinerarySubtitle": "Keep the good ideas for one place.",
      "itineraryLoading": "We dey gather your routes…",
      "itineraryErrorTitle": "Your map go quiet.",
      "itineraryEmptyTitle": "Your first trip never write yet.",
      "itineraryEmptyMessage":
          "Save places wey you like, then turn them to route with detours.",
      "planNewTrip": "Plan new trip",
      "profileTitle": "My Profile",
      "backToLogin": "Go back login",
      "useAtLeastThreeCharacters": "Use at least 3 characters",
      "useAtLeastEightCharacters": "Use at least 8 characters",
      "onTheMap": "For the map",
      "mapStartingPoint": "Starting point for your field notes.",
      "mapsConfigurationTitle": "Google Maps never set up",
      "mapsConfigurationMessage":
          "Add local Google Maps key, then rebuild make the live map show.",
      "mapsConfigurationHint":
          "The places and route ready; na only the map key remain.",
      "whyGo": "Why you go",
      "fieldNotes": "Field notes",
      "savePlaceMessage":
          "Save this place make e stay close as you plan your next trip.",
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
        (supported) => supported.languageCode == locale.languageCode,
      );

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(
        AppLocalizations.supportedLocales.firstWhere(
          (supported) => supported.languageCode == locale.languageCode,
          orElse: () => const Locale("en"),
        ),
      );

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

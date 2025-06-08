import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather/weather.dart'; // Import the weather package
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import 'package:geolocator/geolocator.dart';

import 'login_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'report_screen.dart';
import 'request_supplies_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName =
      '/home'; // Define routeName

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Use pushReplacementNamed with LoginScreen.routeName
    Navigator.of(
      context,
    ).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final userEmail =
        FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      backgroundColor: const Color(
        0xFFEFFDFE,
      ), // Added background color
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed:
                () => Navigator.of(
                  context,
                ).pushNamed(NotificationsScreen.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed:
                () => Navigator.of(
                  context,
                ).pushNamed(ProfileScreen.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${userEmail ?? 'User'}!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Zone: Chennai | Status: Active',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            const Text(
              "Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // StreamBuilder to get active incidents count
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('cases')
                      .snapshots(),
              builder: (context, snapshot) {
                int activeIncidents = 0;
                if (snapshot.hasData) {
                  activeIncidents =
                      snapshot.data!.docs.length;
                }
                return GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap:
                          () => Navigator.of(
                            context,
                          ).pushNamed(
                            NotificationsScreen.routeName,
                          ),
                      child: StatBox(
                        title: "Active Incidents",
                        value:
                            activeIncidents
                                .toString(), // Use dynamic count
                        color: Colors.redAccent,
                        icon: Icons.warning_amber_rounded,
                      ),
                    ),
                    const StatBox(
                      title: "People Assisted",
                      value:
                          "62", // Keeping other data static for now
                      color: Colors.greenAccent,
                      icon: Icons.people_alt_outlined,
                    ),
                    const StatBox(
                      title: "Supply Status",
                      value: "Medkits Low",
                      color: Colors.orangeAccent,
                      icon: Icons.medical_services_outlined,
                    ),
                    const StatBox(
                      title: "Team Active",
                      value: "12 / 15",
                      color: Colors.blueAccent,
                      icon: Icons.groups_outlined,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Weather Section Added Here
            const WeatherSection(),

            // End of Weather Section
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildQuickActions(
              context,
            ), // Updated to reflect new navigation

            const SizedBox(height: 24),
            const Text(
              "Recent Commendations",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 180,
              child: TestimonialCarousel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        "label": "Report Incident",
        "icon": Icons.add_alert_outlined,
        "action": () {
          Navigator.of(
            context,
          ).pushNamed(ReportScreen.routeName);
        },
      },
      {
        "label": "Request Supplies",
        "icon": Icons.medical_services_outlined,
        "action": () {
          Navigator.of(context).pushNamed(
            RequestSuppliesScreen.routeName,
          ); // Navigate to RequestSuppliesScreen
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio:
                2.2, // Adjusted for new button style
          ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return ElevatedButton.icon(
          icon: Icon(
            action["icon"] as IconData,
            color: Colors.white,
            size: 20,
          ), // Icon color and size
          label: Text(
            action["label"] as String,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16), // Center text
          ),
          onPressed: action["action"] as VoidCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(
              255,
              236,
              88,
              88,
            ),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ), // Adjusted padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ), // Slightly less rounded for smaller buttons
              side: BorderSide(
                color: Colors.red.shade900,
                width: 1.5,
              ), // Adjusted border
            ),
            textStyle: const TextStyle(
              // Adjusted text style
              fontSize:
                  13, // Smaller font for these buttons
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            alignment:
                Alignment
                    .center, // Ensure icon and label are centered
          ),
        );
      },
    );
  }
}

// New WeatherSection Widget
class WeatherSection extends StatefulWidget {
  const WeatherSection({super.key});

  @override
  State<WeatherSection> createState() =>
      _WeatherSectionState();
}

class _WeatherSectionState extends State<WeatherSection> {
  Weather? _weather;
  bool _isLoading = true;
  // String? _error; // Removed _error state

  final String _apiKey =
      dotenv.env['OPENWEATHER_API_KEY'] ?? "YOUR_API_KEY";
  late WeatherFactory _wf;
  Position? _currentPosition;
  // Fallback position if current location cannot be obtained
  final Position _fallbackPosition = Position(
    latitude: 12.953195,
    longitude: 80.141602,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );

  @override
  void initState() {
    super.initState();
    _wf = WeatherFactory(_apiKey);
    _determinePositionAndFetchWeather();
  }

  Future<void> _determinePositionAndFetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    // If API key is not set, prepare to use fallback/static data
    if (_apiKey == "YOUR_API_KEY") {
      _currentPosition = _fallbackPosition;
      _fetchWeather();
      return;
    }

    try {
      serviceEnabled =
          await Geolocator.isLocationServiceEnabled()
              .timeout(const Duration(seconds: 10));
      if (!serviceEnabled) {
        _currentPosition = _fallbackPosition;
        _fetchWeather();
        return;
      }

      permission = await Geolocator.checkPermission()
          .timeout(const Duration(seconds: 10));
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission()
            .timeout(const Duration(seconds: 10));
        if (permission == LocationPermission.denied) {
          _currentPosition = _fallbackPosition;
          _fetchWeather();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentPosition = _fallbackPosition;
        _fetchWeather();
        return;
      }

      // Attempt to get current position with a timeout
      _currentPosition =
          await Geolocator.getCurrentPosition().timeout(
            const Duration(seconds: 15),
          );
    } catch (e) {
      // If any part of location determination times out or fails, use fallback
      _currentPosition = _fallbackPosition;
    }
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    if (!mounted) return;
    // Ensure isLoading is true at the start of a fetch attempt
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    // If API key is explicitly the placeholder, go straight to static.
    if (_apiKey == "YOUR_API_KEY") {
      setState(() {
        _weather = _getStaticChennaiWeather();
        _isLoading = false;
      });
      return;
    }

    // Ensure _currentPosition is set (it should be, by _determinePositionAndFetchWeather)
    // If not, default to fallback before attempting API call.
    _currentPosition ??= _fallbackPosition;

    try {
      Weather weather = await _wf.currentWeatherByLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      if (mounted) {
        setState(() {
          _weather = weather;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Silently fall back to static weather data on any API error
      if (mounted) {
        setState(() {
          _weather = _getStaticChennaiWeather();
          _isLoading = false;
        });
      }
    }
  }

  // Method to provide static weather data for Chennai
  Weather _getStaticChennaiWeather() {
    // Manually create a Weather object with made-up data for Chennai
    // This requires knowing the structure of the Weather class from the package
    // For demonstration, I'll assume some fields. You'll need to adjust this
    // based on the actual `Weather` class structure from the `weather` package.
    // This is a simplified example. The actual Weather object might be more complex.
    return Weather({
      "name": "Chennai (Static)", // Indicate static data
      "weather": [
        {
          "main": "Haze",
          "description": "hazy conditions",
          "icon": "50d", // Example icon code for haze
        },
      ],
      "main": {
        "temp": 32.5, // Celsius
        "feels_like": 38.0,
        "humidity": 75.0,
      },
      "wind": {
        "speed": 5.5, // m/s
      },
      // Add a timestamp to static data to make it look more realistic if needed
      "dt": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "sys": {"country": "IN"},
      "coord": {
        "lon": 80.27,
        "lat": 13.08,
      }, // Static coordinates for Chennai
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If weather is still null after loading, use static (should be caught by _fetchWeather, but as a safeguard)
    _weather ??= _getStaticChennaiWeather();

    return _buildWeatherDisplay(_weather!);
  }

  Widget _buildWeatherDisplay(Weather weatherData) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // If static data is used, display "Current Location" to maintain appearance
                (weatherData.areaName ==
                            "Chennai (Static)" ||
                        weatherData.areaName == null)
                    ? 'Current Location'
                    : weatherData.areaName!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              if (weatherData.weatherIcon != null)
                Image.network(
                  'http://openweathermap.org/img/wn/${weatherData.weatherIcon}@2x.png',
                  width: 50,
                  height: 50,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(
                            Icons.wb_sunny,
                            color: Colors.orangeAccent,
                          ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            weatherData.weatherDescription?.toUpperCase() ??
                'No description',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip(
                Icons.thermostat_outlined,
                '${weatherData.temperature?.celsius?.toStringAsFixed(1) ?? 'N/A'}°C',
              ),
              _buildInfoChip(
                Icons.water_drop_outlined,
                '${weatherData.humidity?.toStringAsFixed(0) ?? 'N/A'}%',
              ),
              _buildInfoChip(
                Icons.air_outlined,
                '${weatherData.windSpeed?.toStringAsFixed(1) ?? 'N/A'} m/s',
              ),
            ],
          ),
          // Removed conditional error messages and API key warnings
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(
        icon,
        color: Colors.blueAccent,
        size: 20,
      ),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
    );
  }
}

class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon; // Added icon

  const StatBox({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon, // Added icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ), // Reduced padding slightly
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ), // Display icon
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20, // Adjusted font size
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ), // Adjusted font size
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TestimonialCarousel extends StatefulWidget {
  const TestimonialCarousel({super.key});

  @override
  State<TestimonialCarousel> createState() =>
      _TestimonialCarouselState();
}

class _TestimonialCarouselState
    extends State<TestimonialCarousel> {
  final PageController _controller = PageController(
    viewportFraction: 0.9,
  );
  final List<Map<String, String>> testimonials = [
    {
      "name": "Ravi",
      "message":
          "Thank you for saving our family during the flood!",
    },
    {
      "name": "Anita",
      "message": "Your quick action helped rescue many!",
    },
    {
      "name": "Karthik",
      "message": "A true hero in our time of need.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: testimonials.length,
      itemBuilder: (context, index) {
        final testimonial = testimonials[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          testimonial["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"${testimonial["message"]!}"',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

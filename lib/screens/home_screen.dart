import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather/weather.dart'; // Import the weather package
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv

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
      appBar: AppBar(
        title: const Text('Welcome Rescuer'),
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
              'Zone: Sector Alpha | Status: Active',
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
            const WeatherSection(
              lat: 12.9516,
              lon: 80.1462,
            ),

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
  final double lat;
  final double lon;
  const WeatherSection({
    super.key,
    required this.lat,
    required this.lon,
  });

  @override
  State<WeatherSection> createState() =>
      _WeatherSectionState();
}

class _WeatherSectionState extends State<WeatherSection> {
  Weather? _weather;
  bool _isLoading = true;
  String? _error;
  // IMPORTANT: Replace "YOUR_API_KEY" with your actual OpenWeatherMap API key
  final String _apiKey =
      dotenv.env['OPENWEATHER_API_KEY'] ?? "YOUR_API_KEY";
  late WeatherFactory _wf;

  @override
  void initState() {
    super.initState();
    if (_apiKey == "YOUR_API_KEY") {
      // Avoid API call if key is not set, use static data
      setState(() {
        _isLoading = false;
        _error =
            "API Key not set. Displaying static Chennai weather."; // Inform user
        _weather =
            _getStaticChennaiWeather(); // Load static data
      });
      return;
    }
    _wf = WeatherFactory(_apiKey);
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      Weather weather = await _wf.currentWeatherByLocation(
        widget.lat,
        widget.lon,
      );
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error =
            "Failed to fetch weather. Displaying static Chennai weather. Details: ${e.toString()}";
        _weather =
            _getStaticChennaiWeather(); // Load static data on error
        _isLoading = false;
      });
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
      "name": "Chennai",
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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _weather == null) {
      // Show loading only if no weather data yet
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If there's an error message, display it but still try to show static weather if available
    if (_error != null && _weather == null) {
      // Only show error if no weather data at all
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Displaying static weather data for Chennai.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // If weather data (either fetched or static) is available, display it
    if (_weather == null) {
      // Fallback if weather is still null for some reason
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Weather data currently unavailable.",
          ),
        ),
      );
    }

    // Displaying the error message above the weather widget if it exists
    return Column(
      children: [
        if (_error != null &&
            _apiKey ==
                "YOUR_API_KEY") // Show API key error prominently
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 16,
              right: 16,
            ),
            child: Text(
              _error!,
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade300,
                Colors.blue.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
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
                    _weather?.areaName ??
                        'Chennai', // Default to Chennai if areaName is null
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_weather?.weatherIcon != null)
                    Image.network(
                      "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@2x.png",
                      width: 50,
                      height: 50,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(
                                Icons.cloud_off,
                                size: 30,
                                color: Colors.white70,
                              ),
                    )
                  else // Fallback icon if weatherIcon is null (e.g. for static data)
                    const Icon(
                      Icons.wb_sunny_outlined,
                      size: 30,
                      color: Colors.white70,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "${_weather?.temperature?.celsius?.toStringAsFixed(0) ?? '32'}°C", // Static fallback
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _weather?.weatherDescription
                        ?.toUpperCase() ??
                    "HAZE", // Static fallback
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(
                    "Humidity",
                    "${_weather?.humidity?.toStringAsFixed(0) ?? '75'}%",
                    Icons.water_drop_outlined,
                    context,
                  ),
                  _buildWeatherDetail(
                    "Wind",
                    "${_weather?.windSpeed?.toStringAsFixed(1) ?? '5.5'} m/s",
                    Icons.air_outlined,
                    context,
                  ),
                  _buildWeatherDetail(
                    "Feels Like",
                    "${_weather?.tempFeelsLike?.celsius?.toStringAsFixed(0) ?? '38'}°C",
                    Icons.thermostat_outlined,
                    context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Colors.white70),
        ),
      ],
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

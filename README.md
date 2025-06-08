# ResQLink Mobile App

ResQLink is a Flutter-based mobile application designed for first responders to report incidents, request supplies, and manage emergency situations efficiently.

## Features

_(You can list key features of your application here)_

- Incident Reporting
- Supply Requests
- Real-time Notifications
- User Authentication
- Profile Management
- Weather Information

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- **Flutter SDK**: Ensure you have the Flutter SDK installed. For installation instructions, refer to the [official Flutter documentation](https://flutter.dev/docs/get-started/install).
- **IDE**: An IDE like Android Studio, IntelliJ IDEA, or VS Code with the Flutter and Dart plugins.
- **Firebase Account**: This project uses Firebase for backend services like authentication and database. You will need a Firebase project.

### Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/Pronoy513/ResQLink-Flutter.git
    cd ResQLink-Flutter
    ```

2.  **Create the `.env` file:**
    This project uses an `.env` file to store API keys. This file is gitignored for security.
    Create a file named `.env` in the root directory of the project:

    ```
    c:\Users\prono\OneDrive\Desktop\ResQLink\ResQ Flutter\resqlink-mobile-app-project-idx\.env
    ```

    Add your OpenWeatherMap API key to this file:

    ```properties
    OPENWEATHER_API_KEY=your_actual_openweather_api_key
    ```

    Replace `your_actual_openweather_api_key` with your valid API key.

3.  **Firebase Setup:**
    This project is configured to use Firebase. The necessary Firebase configuration file ([`lib/firebase_options.dart`](lib/firebase_options.dart)) is included in the repository.

    - Ensure you have a Firebase project created at [https://console.firebase.google.com/](https://console.firebase.google.com/).
    - The existing `firebase_options.dart` is configured for the project ID `resqlink-mobile-app`. If you are using a different Firebase project, you will need to configure your app with Firebase. Follow the [FlutterFire CLI documentation](https://firebase.google.com/docs/flutter/setup?platform=ios#flutterfire-cli) to add your Flutter app to your Firebase project and generate a new `firebase_options.dart` file.
    - For Android, ensure you have the `google-services.json` file from your Firebase project settings placed in the `android/app/` directory if it's not already configured via `firebase_options.dart` or if you encounter issues.
    - For iOS, ensure you have the `GoogleService-Info.plist` file from your Firebase project settings placed in the `ios/Runner/` directory if needed.

4.  **Install dependencies:**
    Navigate to the project directory in your terminal and run:

    ```bash
    flutter pub get
    ```

5.  **Run the application:**
    You can run the application on an emulator, simulator, or a physical device.
    ```bash
    flutter run
    ```
    To run on a specific device, use `flutter run -d <deviceId>`. You can list available devices with `flutter devices`.

## Project Structure

_(Briefly describe the main directories and their purpose, e.g., `lib/screens`, `lib/widgets`, `lib/services`)_

## Dependencies

Key dependencies used in this project include:

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `flutter_dotenv`
- `weather`
- `lottie`
- `maps_launcher`
- _(Add any other important dependencies)_

(Refer to the [`pubspec.yaml`](pubspec.yaml) file for a full list of dependencies.)

## Contributing

_(If you are open to contributions, add guidelines here)_

## License

_(Specify the license for your project, e.g., MIT License)_

---

Remember to replace placeholders like `your_actual_openweather_api_key` and fill in sections like "Features", "Project Structure", "Contributing", and "License" with your specific project details.

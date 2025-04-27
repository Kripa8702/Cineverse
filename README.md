# Cineverse
A Flutter app that displays Popular, Top Rated, and Upcoming movies with beautiful UI, pagination, and offline caching using Hive database.

## Features
- Fetch movies by Popular, Top Rated, Upcoming categories
- Infinite scroll with pagination
- Offline access to previously fetched movies (Hive caching)
- Toggle between Grid and ListView
- Searching and Filtering functionality
- Smooth PageView navigation between categories
- Responsive UI with clean code structure

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### 2. Install dependencies
```bash
flutter pub get
``` 

### 3. Generate Hive Type Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
``` 

### 4. Run the app
```bash
flutter run
``` 

## Tech Stack
- Flutter

- Dio (for network requests)

- Hive (for local database caching)

- Cubit (for state management)

- PageView + TabBar (for navigation)

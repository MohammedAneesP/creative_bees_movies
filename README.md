# Creative Movie App

A Flutter application that displays popular movies using the TMDB API,
with infinite scrolling and detailed movie views.

## Features
- Popular movies list
- Infinite scroll pagination
- Movie detail screen
- Error handling with retry
- Pull to refresh
- Cached images

## Tech Stack
- Flutter
- Provider
- HTTP
- TMDB API

## Architecture
- UI → Controller → Repository
- Provider for state management
- Clean separation of concerns

## How to Run
1. Clone the repo
2. Create a `.env` file
3. Add TMDB API key
4. Run `flutter pub get`
5. Run the app

## Known Issues
- On some Android devices, TMDB detail endpoint may intermittently fail
  with a SocketException (errno 104). This is handled gracefully with retry UI.

## Screens
- Home (Popular Movies)
- Movie Detail


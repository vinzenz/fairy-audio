# Fairy Audio

A kid-friendly Spotify player built with Flutter, designed with a "Dark Luxe Teen Minimalism" aesthetic.

## Features

- **Audio Only**: No video distractions.
- **Bilingual**: Supports English and Czech.
- **Dual Mode Search**: Toggle between "Music" (Tracks) and "Stories" (Audiobooks/Episodes).
- **Parent Mode**: Placeholder for future restrictions.
- **Design**: High-contrast dark theme with neon accents (`#8b5cf6`, `#ff7a45`).

## Prerequisites

1. **Spotify Premium Account**: Required for the App Remote SDK to stream full tracks.
2. **Spotify Developer App**: You need a Client ID.
3. **Android Device**: The Spotify App Remote SDK currently targets Android.

## Setup Instructions

1. **Spotify Dashboard**:
   - Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/).
   - Create a new app.
   - Edit Settings:
     - **Redirect URI**: Add `com.fairy.audio://callback`
     - **Package Name**: `com.fairy.audio`
     - **SHA1 Fingerprint**: You will need to add the SHA1 of your signing key. For debug:
       ```bash
       # Mac/Linux
       keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android
       ```

2. **Environment Variables**:
   - Copy `.env.example` to `.env`.
   - Paste your **Client ID** and **Redirect URI** into `.env`.

3. **Run**:
   - Ensure the main Spotify App is installed and logged in on your Android device.
   - Run the Flutter app:
     ```bash
     flutter run
     ```

## Architecture

- **State Management**: `Provider` (`PlayerProvider`, `SearchProvider`).
- **Services**:
  - `AuthService`: Handles App Remote connection.
  - `SpotifyApiService`: Handles Web API data fetching (Search, Recommendations).
- **Theme**: Centralized in `lib/theme.dart`.

## Note on "Stories"
The "Stories" toggle filters Spotify search results for `audiobook` and `episode`. Audiobook availability varies by Spotify market region.

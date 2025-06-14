# Hackathon Hub - Flutter Web App

A modern hackathon management platform with white-label organization support and liquid glass UX design.

## Features

- 🏢 **White-label Support**: Multi-organization branding (IITH, IITB, Stanford, MIT, Google)
- 🎨 **Liquid Glass UX**: Modern glassmorphism design with translucent effects
- 📱 **Responsive Design**: Works on desktop, tablet, and mobile
- 💾 **Data Persistence**: Local storage with SharedPreferences
- 🚀 **Event Management**: Create, join, and manage hackathon events
- 👥 **Team Management**: Form and manage hackathon teams
- 📝 **Submission System**: Upload and manage project submissions
- ⭐ **Judging System**: Evaluate and score submissions

## Quick Start

### Local Development

```bash
# Clone the repository
git clone <your-repo-url>
cd hackathon

# Get dependencies
flutter pub get

# Run the app
flutter run -d chrome
```

### Web Deployment

#### Option 1: Vercel (Recommended)

1. **Install Vercel CLI** (if not already installed):

   ```bash
   npm i -g vercel
   ```

2. **Build the app**:

   ```bash
   ./build_web.sh
   # OR manually:
   flutter build web --release --base-href / -O 4
   ```

3. **Deploy to Vercel**:

   ```bash
   # Login to Vercel
   vercel login

   # Deploy from the build/web directory
   cd build/web
   vercel --prod
   ```

4. **Set up automatic deployments** (optional):
   - Connect your GitHub repository to Vercel
   - Vercel will automatically deploy on git push

#### Option 2: Netlify

1. **Build the app**:

   ```bash
   ./build_web.sh
   ```

2. **Deploy to Netlify**:
   - Go to [netlify.com](https://netlify.com)
   - Drag and drop the `build/web` folder
   - Or use Netlify CLI:
     ```bash
     npm install -g netlify-cli
     netlify login
     cd build/web
     netlify deploy --prod
     ```

#### Option 3: GitHub Pages

1. **Build the app**:

   ```bash
   flutter build web --release --base-href /your-repo-name/
   ```

2. **Push to gh-pages branch**:
   ```bash
   # Copy build files to gh-pages branch
   git checkout -b gh-pages
   cp -r build/web/* .
   git add .
   git commit -m "Deploy to GitHub Pages"
   git push origin gh-pages
   ```

## White-label Organizations

The app supports multiple organizations via URL parameters:

- Default: `https://your-app.vercel.app/`
- IITH: `https://your-app.vercel.app/?org=iith`
- IITB: `https://your-app.vercel.app/?org=iitb`
- Stanford: `https://your-app.vercel.app/?org=stanford`
- MIT: `https://your-app.vercel.app/?org=mit`
- Google: `https://your-app.vercel.app/?org=google`

## Build Configuration

- **Optimization Level**: O4 (maximum optimization)
- **Tree Shaking**: Enabled for icons and fonts
- **Base HREF**: / (root directory)
- **PWA**: Offline-first caching strategy

## Tech Stack

- **Flutter 3.8.1+**: Cross-platform UI framework
- **Dart**: Programming language
- **Riverpod**: State management
- **GoRouter**: Navigation and routing
- **SharedPreferences**: Local data persistence
- **Material 3**: Design system

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── pages/                    # UI pages
├── providers/                # State management
├── services/                 # Business logic
└── widgets/                  # Reusable components
    └── glass/               # Liquid glass components
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

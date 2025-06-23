# 📱 Retinal Tracker App — SIT AI Hackathon 🚧

**Retinal Tracker** is a personal mobile app designed to help users monitor their eye health by tracking retinal scan data over time. This project is **currently under development** — features are not complete yet for the AI Hackathon.

## Project Goals

- Provide older-friendly UI for tracking retinal health
- Upload and analyze retinal scans
- Show percent decline and average eye health trends
- Allow users to monitor their eye health progress over time

---

## 🏗 Current Status

✅ Basic UI screens implemented: Landing, Register, Login, Home  
✅ Percent circular indicator and line chart integrated  
✅ Upload / camera feature
✅ Data storage, backend, authentication in Firebase
✅ Graph display data from Firebase
✅ Learn more page (except the instruction page)

---

## 🚀 Getting Started (Local Development & Branching Workflow)

### Prerequisites

- Flutter SDK installed (3.x recommended)
- Git installed
- Android emulator or real device

### Running the project

```bash
# Clone the repo
git clone https://github.com/ZuhairahZainal/flutter-retinal-app.git
cd retinalapp

# Install dependencies
flutter pub get

# Run the app (on current branch)
flutter run
```

### Working with branches (IMPORTANT)

To keep our `main` branch stable, please **always work on your own branch**:

```bash
# Checkout main branch first and pull latest changes
git checkout main
git pull origin main

# Create your feature branch
git checkout -b your-branch-name

# Do your work...

# Add and commit your changes
git add .
git commit -m "Your commit message"

# Push your branch to GitHub
git push origin your-branch-name

# Then open a Pull Request (PR) to merge into main branch
```

👉 **Do not commit directly to main branch.**  

---

## 🗂 Project Structure

```plaintext
/lib
  graph.dart                 # Page for detail graph display
  homepage.dart              # HomePage with charts and progress
  landing.dart               # Landing screen with Login/Register
  login.dart                 # LoginPage
  main.dart                  # App entry point
  profile.dart               # User profile + settings (if needed)
  register.dart              # RegisterPage
  
/assets
  (app images)
/README.md                   # This file 
```
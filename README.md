![cover](https://github.com/user-attachments/assets/dedc5e14-5e6f-499f-93a7-ad6ff11f622e)

# StoryPad 📝

First journal with Material 3 design! StoryPad is a minimalist design application to write stories, journals, notes, diaries, todo, etc. We offer a variety of features that you can expect for your daily usage.

<!-- [![App Store](https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/us/app/spooky/id1629372753?platform=iphone) -->

[![Play Store](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=com.tc.writestory)

## Installation

Before getting started, ensure you have the following tools:

- Java: 21 [(LTS)](https://www.oracle.com/java/technologies/java-se-support-roadmap.html) (for Android)
- Ruby: 3.3.5 (for IOS)
- Flutter: 3.27.4

If you're using asdf, refer to this [guide](asdf.md). Otherwise, you can install above versions manually with fvm, rvm, rbenv or others.

## Setup

For easy setup and running, the GoogleService-Info.plist, google-services.json, and Dart defines are provided directly in this repo. Simply run the project with:

```s
flutter run --flavor community --dart-define-from-file=env/community.json --target=lib/main_community.dart
```

## Overview

StoryPad is designed with simplicity in mind, both in its UI and codebase. We aimed to keep the code understandable while staying true to Flutter's principles.

1. State Management
   StoryPad uses Provider and Stateful widgets to manage its state, distinctly organized into three levels to avoid confusion:

   - Global State: Managed by [ProviderScope](lib/provider_scope.dart), disposed when the app closes.
   - View State: Managed by [ViewModelProvider](lib/widgets/view/view_model_provider.dart), disposed when the page closes.
   - Widget State: Managed by Stateful widgets, where the widget itself controls its own state and is disposed when removed from the tree.

2. MVVM Pattern
   StoryPad leverages the MVVM (Model-View-ViewModel) pattern while each view is composed of three to four key files:

   - Model (optional): Represents the data structure, e.g., StoryDbModel.
   - View: Constructs the view model and builds the UI content, e.g., EditStoryView.
   - ViewContent: Displays the actual UI, keeping the visual layout separate from business logic, e.g., EditStoryContent.
   - ViewModel: Manages business logic, provides data & operations to the view, keeping the UI free from unnecessary logic, e.g., EditStoryViewModel.

3. Local Database
   StoryPad uses ObjectBox as the local database solution for persistent data storage. ObjectBox provides fast, efficient, and scalable database operations with rich search capabilities, making it ideal for mobile apps that require high-performance data handling.

## Learn & Contribute

Feel free to clone the StoryPad repository and explore the code. It’s a great resource for learning how to build efficient, maintainable mobile apps with Flutter. You can also contribute improvements or new features, helping enhance the project for everyone.

## License

StoryPad is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

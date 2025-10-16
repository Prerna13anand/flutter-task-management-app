Task Management App for Gig Workers

A simple and clean task management app built with Flutter. This project allows users to manage their daily tasks with features like authentication, task creation, editing, deletion, and filtering.


Login & Sign-Up Screen

Main Task List Screen

Features Checklist

This project successfully implements all the required features:

User Authentication

✅ User Registration & Login (Firebase Authentication with email/password).

✅ Displays clear error messages for invalid credentials.

Task Management

✅ Create, View, Update, and Delete tasks.

✅ Tasks are stored securely on a per-user basis in Firestore.

✅ Each task includes a title, description, due date, and priority (Low, Medium, High).

✅ Feature to mark tasks as complete/incomplete.

Task Filtering & Sorting

✅ Tasks are sorted by due date (from Firestore).

✅ Tasks are secondarily sorted by priority (High > Medium > Low).

✅ Users can filter tasks by status (All, Completed, Incomplete).

✅ Users can filter tasks by priority.

User Interface

✅ Clean, responsive, and visually appealing UI based on Material Design principles.

✅ A consistent and intuitive user experience.

Technical Details

State Management: BLoC (Business Logic Component)

Architecture: Clean Architecture (separating Presentation, Domain, and Data layers)

Backend & Database: Firebase Authentication & Cloud Firestore

Core Language: Dart

Framework: Flutter

How to Run This Project

Prerequisites

Flutter SDK installed.

A Firebase account.

Setup Instructions

Clone the repository:

git clone <your-repository-url>
cd task_management_app


Set up your own Firebase Project:

This project requires a Firebase backend. Create a new project in the Firebase Console.

Enable Authentication (with the Email/Password provider) and Firestore Database (in test mode initially).

Install the FlutterFire CLI: dart pub global activate flutterfire_cli

Configure the app to connect to your Firebase project by running:

flutterfire configure


Install dependencies:

flutter pub get


Run the app:

flutter run


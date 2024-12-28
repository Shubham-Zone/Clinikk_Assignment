# Clinikk Assignment

Simple Flutter application for tracking tasks and fetching posts from an API.

## Features

- **Task Tracker:**
  - Add tasks with title and description.
  - Mark tasks as completed.
  - Edit existing tasks.
  - Delete tasks.
  - View a list of tasks.
  
- **API Integration:**
  - Fetch posts from a sample API.
  - Filter posts by user ID.
  - Display post title and body.

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/Shubham-Zone/Clinikk_Assignment.git
   ```

2. Navigate to the project directory:
   ```
   cd Clinikk_Assignment
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Build APK

To build an APK for your app, use the following command:
```
flutter build apk --split-per-abi
```
This will generate APKs for different ABIs (Application Binary Interface) and optimize your APK size for various device architectures.

## Usage

- **Task Tracker:**
  - Add a new task by tapping the "+" button.
  - Tap on a task to mark it as completed.
  - Long press on a task to edit or delete it.

- **API Fetching:**
  - The app fetches posts from a sample API and displays the post title and body.
  - Use the search functionality to filter posts by user ID.

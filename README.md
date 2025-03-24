# CipherSchools-Flutter-Assignment

A expense tracker app built with Flutter. This application allows users to add and manage their income and expense transactions, visualize their financial data with colorful charts, and securely sign in with Google.

## Features

- **User Authentication**  
  - Login/signup using Google Authentication.
  - New users are prompted to choose an account; returning users are auto-signed in.
  - User details are stored in Cloud Firestore and locally via SharedPreferences.

- **Expense Tracker**  
  - Add income and expense transactions with amount, category, date, and type (income/expense).
  - Swipe-to-delete functionality to remove transactions.
  - Transactions are stored locally using SQLite (via the SQFlite package) and are linked to each authenticated user, ensuring personalized data.

- **Data Visualization**  
  - Grouped bar chart using [fl_chart](https://pub.dev/packages/fl_chart) that displays both income (in green) and expenses (in red) by category.
  - A colorful, intuitive chart provides an at-a-glance overview of your financial health.

- **State Management**  
  - Global state management using Provider.
  - Local widget state managed via ValueNotifier (instead of using setState) for a reactive UI experience.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Git](https://git-scm.com/downloads)
- A configured [Firebase project](https://firebase.google.com/) with:
  - Firebase Authentication (Google Sign-In enabled)
  - Cloud Firestore

### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/your-username/CipherSchools-Flutter-Assignment.git
   cd CipherSchools-Flutter-Assignment


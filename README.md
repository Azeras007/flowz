# 🚀 AREA

Welcome to the AREA project, an application designed to automate tasks similar to Zapier. This guide will help you get started quickly.

## ⚡ Quickstart

### Prerequisites

Make sure you have the following installed on your machine:

- [Swift](https://www.swift.org/) >= 16
- [Alamofire](https://github.com/Alamofire/Alamofire) and [Lottie](https://lottiefiles.com/fr/)

### Installation

1. **Clone the repository:**

    ```sh
    git clone
    ```

2. **On Xcode:**

    ```sh
    - Open Existing project...

    - Search the repository and choose area-development.xcodeproj
    ```

3. **Install necessary Packages dependencies:**

    ```sh
    select File > Add Package Dependency and enter its repository URL. 

    - Lottie and Alamofire
    ```

4. **Change Team and Bundle ID:**

    ```sh
    Go on the project
        -> Targets
         -> Signing & Capabilities
            Change the actual "Team" and "Bundle Id" to yours
    ```

### Starting the Server

To start the development server, run:

```sh
Cmd + R
```

# 📚 AREA Mobile Documentation

## 📂 Project Structure

The application architecture is organized into several modules to facilitate managing each feature. Below is the current structure of the project:

```
area-development/
├── Actions/
│   ├── ActionFormView.swift
│   ├── ActionsSelectionView.swift
│   ├── ActionsStructure.swift
│   ├── SubServicesActionsView.swift
├── Area/
│   ├── AreaListView.swift
│   ├── AreaLogsView.swift
│   ├── AreaStructure.swift
│   ├── ConfirmateAreaView.swift
│   ├── CreateArea.swift
├── Auth/
│   ├── AppSelectionView.swift
│   ├── GetStartedView.swift
│   ├── LoginView.swift
│   ├── RegisterView.swift
├── Dashboard/
│   ├── ConnectedServicesView.swift
│   ├── DashboardView.swift
│   ├── StatisticsView.swift
├── Keychain/
│   ├── KeychainHelper.swift
├── Listeners/
│   ├── ListenersStructure.swift
│   ├── SubServicesTriggerView.swift
│   ├── TriggerFormView.swift
│   ├── TriggerSelectionView.swift
├── Preview Content/
│   ├── PreviewAssets.xcassets
├── AppDelegate.swift
├── area_developmentApp.swift
├── Assets.xcassets
├── ContentView.swift
├── CreateView.swift
├── CustomNavBar.swift
├── LoadingView.swift
├── LottieView.swift
├── MainView.swift
├── ProfileView.swift
├── area-developmentTests/
├── area-developmentUlTests/
├── notification/
└── Frameworks/

```

## 🗂 Key Directories and Files

- **area-development/**: Contains the core code of the application, divided into several modules.
  - **Actions/**: Handles action-related views and structures.
    - **ActionFormView.swift**: View for creating and editing actions.
    - **ActionsSelectionView.swift**: View for selecting actions.
    - **ActionsStructure.swift**: Structure handling action logic.
    - **SubServicesActionsView.swift**: View for managing sub-services related to actions.
  
  - **Area/**: Manages the views and structure for the "Areas" in the app.
    - **AreaListView.swift**: View displaying the list of areas.
    - **AreaLogsView.swift**: View for logging activities related to areas.
    - **AreaStructure.swift**: Structure managing area logic.
    - **ConfirmateAreaView.swift**: View for confirming area creation.
    - **CreateArea.swift**: View for creating a new area.
  
  - **Auth/**: Handles authentication-related views.
    - **AppSelectionView.swift**: View for selecting the app for authentication.
    - **GetStartedView.swift**: Onboarding view for new users.
    - **LoginView.swift**: View for user login.
    - **RegisterView.swift**: View for user registration.
  
  - **Dashboard/**: Manages the main dashboard and statistics views.
    - **ConnectedServicesView.swift**: View for managing connected services.
    - **DashboardView.swift**: Main dashboard view for users.
    - **StatisticsView.swift**: View displaying user statistics.
  
  - **Keychain/**: Contains helpers for secure management of credentials.
    - **KeychainHelper.swift**: Manages secure storage of sensitive data using the keychain.
  
  - **Listeners/**: Handles trigger-related views and structures.
    - **ListenersStructure.swift**: Structure managing the logic for listeners.
    - **SubServicesTriggerView.swift**: View for handling sub-service triggers.
    - **TriggerFormView.swift**: View for creating and editing triggers.
    - **TriggerSelectionView.swift**: View for selecting triggers.

- **Preview Content/**: Contains assets for previewing SwiftUI components.
  - **PreviewAssets.xcassets**: Assets used during development for preview purposes.

- **AppDelegate.swift**: The main app delegate file responsible for app lifecycle management.
- **area_developmentApp.swift**: Main entry point of the app, setting up the root of the SwiftUI app.
  
- **Assets.xcassets**: Contains images and other visual assets used throughout the app.

- **ContentView.swift**: The main view that serves as the entry point for the app's UI.
- **CreateView.swift**: View for creating various items within the app.
- **CustomNavBar.swift**: Custom navigation bar used throughout the app.
- **LoadingView.swift**: View displaying loading indicators.
- **LottieView.swift**: View handling Lottie animations.
- **MainView.swift**: Primary view displayed after login.
- **ProfileView.swift**: View managing user profile information.

- **Tests/**: Contains unit and UI tests.
  - **area-developmentTests/**: Unit tests for testing app components.
  - **area-developmentUlTests/**: UI tests for testing user interface interactions.
  
- **notification/**: Contains resources and logic for managing app notifications.
  
- **Frameworks/**: Third-party frameworks and libraries integrated into the project.


## 🔐 Authentication and Security
Authentication is handled via OAuth to securely interact with third-party services and the backend API.

## 🎨 UI Design
The app uses SwiftUI for the user interface, making the views responsive and optimized for modern iOS devices.

## 💡 Key Features
- OAuth-based authentication
- Area and automation management
- Push notifications for new automations
- Real-time synchronization with the backend

### 📧 Support
For any questions or support requests 🥱gl.


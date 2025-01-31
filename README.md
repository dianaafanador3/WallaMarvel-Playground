# 📱 WallaMarvel

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![Swift](https://img.shields.io/badge/swift-5.0-orange.svg)
![Xcode](https://img.shields.io/badge/Xcode-16-blue.svg)

This app allows users to browse a list of Marvel heroes and view detailed information 
for each hero using data from the Marvel API.

---

## 📌 Table of Contents
- [📖 Overview](#-overview)
- [🚀 Features](#-features)
- [🛠 Architecture](#-architecture)
- [🏗 Project Structure](#-project-structure)
- [🔬 Testing](#-testing)
- [🛠 Future Improvements](#-future-improvements)
- [👨‍💻 Author](#-author)
- [🦸🏽‍♀️ Attribution](#-attribution)

---

## 📖 Overview
Edit the WallaMarvel App to include the following goals

### Goals

Must (These points are mandatory)
-  Show Hero Detail. In your list of superheroes, if one user taps one of them we
want to show a new screen. We want to navigate to a new screen showing the
information about the superhero.
You can show whatever you want: basic information about the superhero,
comics, series, etc. (whatever you think it’s relevant to know about the
selected superhero).
To do that, you will need to create new HTTP requests (there are some
endpoints in Marvel’s API, check the documentation)
- Pagination. In your list of superheroes, if you reach the bottom of the view
(UITableView) we want to execute another HTTP request to extract the
following superheroes. We want to be able to list all of them in our app.

Should (Nice to have)
- Search bar. In our list of superheroes we would like to filter them, so adding a
search bar on top of the UITableView will solve the problem. The idea is, that
we want to start writing the name of the superhero and showing the
coincidences in the list.

### Comments

- Used SwiftUI for the detail view
- Migrated from MVP architecture to MVVM
- Use Combine to subscribe to changes from the API Client
- Removed Cocoapods and Kingfisher

---

## 🚀 Features
- ✅ List View: Displays a paginated list of Marvel heroes with names and thumbnails.
- ✅ Search Functionality: Users can search for heroes by name.
- ✅ Detail View: Shows detailed information about a selected hero, including comics, series, events, and stories.
- ✅ Uses **MVVM + UseCase** architecture
- ✅ Mix of UIKit and SwiftUI.

---

## 🛠 Architecture
Describe the **architectural pattern** used in the project (e.g., MVVM + Use Case + Repository + DataSource).

```markdown
 ┌──────────────────┐
 │    **View (UI)**     │  → Displays UI, interacts with ViewModel
 └──────────────────┘
          ↓
 ┌──────────────────┐
 │  **ViewModel (VM)**  │  → Calls UseCase, updates UI state
 └──────────────────┘
          ↓
 ┌──────────────────┐
 │   **UseCase Layer**  │  → Encapsulates business logic
 └──────────────────┘
          ↓
 ┌──────────────────┐
 │ **DataSource Layer** │  → Handles API & local storage if needed
 └──────────────────┘
```
---

## 📲 Run
### **Requirements**
- Minimium deployment: iOS 13

### **Steps**
1. Clone the repository:
   ```bash
   git clone https://github.com/dianaafanador3/WallaMarvel-Playground.git
   ```
2. Open `WallaMarvel.xcodeproj` in Xcode.
3. Add private and public key
4. Run the project:
   - Select a simulator or device.
   - Click **Run** (`⌘R`).

---

## 🏗 Project Structure
```
📂 ProjectName
├── 📂 List Heroes
│   ├── Model/
│   ├── Views/
│   ├── ViewModels/
│
├── 📂 Detail Heroe
│   ├── Model/
│   ├── Views/
│   ├── ViewModels/
│
├── 📂 Domain (Business Logic)
│   ├── UseCases/
│   ├── Repositories
│
├── 📂 Data (Networking & Persistence)
│   ├── API
│
├── 📂 WallaMarvelTests
│
└── AppDelegate..swift
└── SceneDelegate.md
└── README.md
```

---

## 🔬 Testing
### **Unit Testing**
- **Test Use Cases**
- **Test ViewModel**
- **Mock API Responses**
- **Mock Use Cases Responses**

---

## 🛠 Future Improvements
- [ ] Handle the API has no more data
- [ ] Add Persistence layer for offline support
- [ ] Use Async await for async operations (iOS 15+)
- [ ] Migrate List View to SwiftUI
- [ ] Test Views
- [ ] Test Repository
- [ ] Add UI Test

---

## 👨‍💻 Author
**Diana Perez Afanador**  
- [Github](https://github.com/dianaafanador3)

---

## 🦸🏽‍♀️ Attributions
Data provided by Marvel. © 2014 Marvel

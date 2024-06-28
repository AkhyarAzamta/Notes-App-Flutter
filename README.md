
# Notes App Flutter

Project Praktikum Matakuliah: Mobile Programming


## Installation

Clone My Project
   ```bash
  git clone https://github.com/AkhyarAzamta/Notes-App-Flutter.git
``` 
## Setup Backend
Change Directory to Backend
   ```bash
cd backend
``` 
```bash
npm install
  ```
  Don't forget to Setup Environment Variables (.env)
  Connect to Database
  ```bash
  # Example
  DATABASE_URL="mysql://USERNAME:PASWWORD@localhost:3306/notes-api-2"
JWT_KEY="123"
  ```
  Using Password
```bash
DATABASE_URL="mysql://root:toor@localhost:3306/notes-api-2"
JWT_KEY="123"
  ```
  No Password
```bash
DATABASE_URL="mysql://root:@localhost:3306/notes-api-2"
JWT_KEY="123"
```
Run Backend
```bash
npm run dev
  ```

## Setup Frontend  
Change Directory to Frontend
   ```bash
cd frontend
``` 
```bash
flutter pub get
  ```
Run Frontend
```bash
flutter run
  ```

## Tech Stack

[NodeJS](https://nodejs.org/), [Flutter](https://flutter.dev/)


## Demo

[Coming Soon](#)


# INVENTARIS BUKU FATIMART

- **Nama:** Fatimah Nurmawati
- **NIM:** H1D023019
- **Shift Baru:** C
- **Shift Asal:** C

## Video Demo Aplikasi
| Demo Apk      |
|--------------------------|
|![demo](assets/demo.gif)|

## Deskripsi Aplikasi
Aplikasi mobile berbasis Flutter yang terhubung dengan REST API CodeIgniter 4 untuk mengelola inventaris buku. Aplikasi ini memungkinkan pengguna untuk melakukan operasi CRUD pada data buku dengan fitur autentikasi.

## Struktur Proyek
```
PROYEK_RESPONSI_2/
├── responsi_2_mobile_paket_3_H1D023019/     # Flutter Application
│   ├── lib/
│   │   ├── screens/        # Halaman aplikasi
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── book_list_screen.dart
│   │   │   ├── add_book_screen.dart
│   │   │   └── edit_book_screen.dart
│   │   ├── services/       # API Service
│   │   │   └── api_service.dart
│   │   ├── models/         # Data Model
│   │   │   ├── user_model.dart
│   │   │   └── book_model.dart
│   │   ├── utils/          # Utilities
│   │   │   └── shared_prefs.dart
│   │   ├── theme/          # Tema Warna
│   │   │   └── app_theme.dart
│   │   └── main.dart       # Entry Point
│   ├── pubspec.yaml        # Dependencies
│   └── README.md
│
├── responsi_api_ci4/                        # Backend API
│   ├── app/
│   │   ├── Config/
│   │   │   ├── App.php
│   │   │   ├── Database.php
│   │   │   ├── Filters.php
│   │   │   └── Routes.php
│   │   ├── Controllers/
│   │   │   ├── AuthController.php
│   │   │   └── BookController.php
│   │   ├── Models/
│   │   │   ├── UserModel.php
│   │   │   └── BookModel.php
│   │   ├── Filters/
│   │   │   └── CorsFilter.php
│   │   └── Helpers/
│   ├── public/
│   │   └── index.php
│   ├── .env                # Environment Configuration
│   └── composer.json
│
└── README.md            # Dokumentasi Utama 
```

## Spesifikasi API

### Base URL
```
http://192.168.56.1:8080/api
```
Development: http://localhost:8080/api

#### 1. Register - `POST /register` 
**Request :** 
```json
{
    "name": "Nama Lengkap",
    "email": "email@example.com",
    "password": "password123"
}
```

**Response:**
```json
{
    "status": 201,
    "message": "Registrasi berhasil",
    "token": "abc123def456...",
    "user": {
        "id": 1,
        "name": "Nama Lengkap",
        "email": "email@example.com"
    }
}
```

#### 2. Login - `POST /login`
**Request :** 
```json
{
    "email": "email@example.com",
    "password": "password123"
}
```

**Response:**
```json
{
    "status": 200,
    "message": "Login berhasil",
    "token": "xyz789uvw012...",
    "user": {
        "id": 1,
        "name": "Nama Lengkap",
        "email": "email@example.com"
    }
}
```

#### 3. GET BOOKS - `GET /books`
**Headers :** 
```json
Authorization: Bearer [token]
```

**Response:**
```json
{
    "status": 200,
    "data": [
        {
            "id": 1,
            "judul": "Flutter untuk Pemula",
            "harga": 75000,
            "jumlah": 10,
            "tanggal_masuk": "2024-12-01",
            "volume": 1,
            "penulis": "Budi Santoso",
            "penerbit": "Penerbit Informatika",
            "user_id": 1,
            "created_at": "2024-12-06 10:30:00"
        }
    ]
}
```

#### 4. Add Book - `POST /books`
**Headers :** 
```json
Authorization: Bearer [token]
Content-Type: application/json
```

**Request :** 
```json
{
    "judul": "Judul Buku",
    "harga": 80000,
    "jumlah": 15,
    "tanggal_masuk": "2024-12-06",
    "volume": 1,
    "penulis": "Nama Penulis",
    "penerbit": "Nama Penerbit"
}
```

**Response:**
```json
{
    "status": 201,
    "message": "Buku berhasil ditambahkan"
}
```

#### 5. Update Books - `PUT /books/:id`
**Headers :** 
```json
Authorization: Bearer [token]
Content-Type: application/json
```

**Request :** 
```json
{
    "judul": "Judul Updated",
    "harga": 85000,
    "jumlah": 20
}
```

**Response:**
```json
{
    "status": 200,
    "message": "Buku berhasil diupdate"
}
```

#### 6. Delete Books - `DELETE /books/:id`
**Headers :** 
```json
Authorization: Bearer [token]
```

**Response:**
```json
{
    "status": 200,
    "message": "Buku berhasil dihapus"
}
```

### PENJELASAN KODE FLUTTER
#### 1. `main.dart` - Entry Point
```dart
FutureBuilder<String?>(
  future: SharedPrefs.getToken(),
  builder: (context, snapshot) {
    return token != null ? HomeScreen() : LoginScreen();
  },
)
```

**Penjelasan :** Mengecek apakah user sudah login dengan melihat token di SharedPreferences.

#### 2. `login_screen.dart` - Halaman Login
```dart
void _login() async {

  if (_formKey.currentState!.validate()) {

    final response = await ApiService.login(email, password);
    
    if (response['status'] == 200) {
      await SharedPrefs.saveToken(response['token']);
      await SharedPrefs.saveUserData(user['name'], user['email']);
      
      Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
```

**Penjelasan :** Meng-handle proses login dengan validasi, API call, dan penyimpanan token.

#### 3. `register_screen.dart` - Halaman Registrasi
```dart
void _register() async {

  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password tidak sama')));
    return;
  }
  
  final response = await ApiService.register(name, email, password);
  
  if (response['status'] == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registrasi berhasil! Silakan login')));
    
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
```

**Penjelasan :** Meng-handle registrasi dengan validasi password dan redirect ke login setelah sukses.

#### 4. `home_screen.dart` - Dashboard
```dart
void _logout() async {
  await SharedPrefs.clearAll();
  
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (route) => false,
  );
}
```

**Penjelasan :** Menampilkan dashboard dengan menu dan handle logout.

#### 5. `book_list_screen.dart` - Daftar Buku
```dart
Future<void> _loadBooks() async {
  final token = await SharedPrefs.getToken();
 
  final books = await ApiService.getBooks(token!);
  
  setState(() {
    _books = books;
    _isLoading = false;
  });
}

void _deleteBook(int id) async {
  final confirmed = await showDialog<bool>(...);
  
  if (confirmed == true) {
    final success = await ApiService.deleteBook(token!, id);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Buku berhasil dihapus')));

      await _loadBooks();
    }
  }
}
```

**Penjelasan :** Menampilkan daftar buku dengan CRUD operations.

#### 6. `api_service.dart` - Services API
```dart
class ApiService {
  static const String baseUrl = 'http://192.168.56.1:8080/api';
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    
    return jsonDecode(response.body);
  }
}
```

**Penjelasan :** Centralized service untuk semua API calls.

#### 7. `shared_prefs.dart` - Local Storage
```dart
class SharedPrefs {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }
  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }
  
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
```

**Penjelasan :** Meng-handle penyimpanan data lokal (token, user data).

#### 8. `app_theme.dart` - Tema Warna Coklat
```dart
class AppTheme {
  static const Color primaryBrown = Color(0xFF8B4513); 
  static const Color accentBrown = Color(0xFFD2691E); 
  
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryBrown,
      appBarTheme: AppBarTheme(backgroundColor: primaryBrown),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: primaryBrown),
      ),
    );
  }
}
```

**Penjelasan :** Mendefinisikan tema warna coklat sesuai instruksi.

### STRUKTUR DATABASE
#### Tabel `users`
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    api_token VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabel `books`
```sql
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    judul VARCHAR(255),
    harga INT,
    jumlah INT,
    tanggal_masuk DATE,
    volume INT,
    penulis VARCHAR(100),
    penerbit VARCHAR(100),
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### CARA MENJALANKAN APK
#### 1. Backend (CI4)
```bash
cd backend
cp env .env

php spark migrate
php spark serve --host 0.0.0.0 --port 8080
```

#### 2. Frontend (Flutter)
```bash
cd mobile
flutter pub get
flutter run -d chrome  # Untuk web
```

### DEPENDENCIES FLUTTER
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0      
  shared_preferences: ^2.2.2  
  intl: ^0.18.1        
```



































































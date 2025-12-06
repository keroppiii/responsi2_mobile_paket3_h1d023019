# INVENTARIS BUKU FATIMART

- **Nama:** Fatimah Nurmawati
- **NIM:** H1D023019
- **Shift Baru:** C
- **Shift Asal:** C

## Video Demo Aplikasi
![Demo Video - Inventaris Buku H1D023019]()**

## Deskripsi Aplikasi
Aplikasi mobile berbasis Flutter yang terhubung dengan REST API CodeIgniter 4 untuk mengelola inventaris buku. Aplikasi ini memungkinkan pengguna untuk melakukan operasi CRUD pada data buku dengan fitur autentikasi.

## Struktur Proyek
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








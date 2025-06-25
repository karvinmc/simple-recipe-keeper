# Simple Recipe Keeper

Aplikasi Flutter untuk menyimpan dan mengatur resep masakan pribadi dengan autentikasi dan penyimpanan cloud.

## Fitur Utama

- Autentikasi Pengguna - Sign up, sign in, sign out menggunakan Supabase Auth.
- Cloud Database - Penyimpanan resep di Supabase Database.
- Session Persistence - Login otomatis menggunakan SharedPreferences.
- Get Started Screen - Halaman welcome yang hanya muncul sekali saat instalasi pertama.
- CRUD Resep - Tambah, lihat, dan hapus resep.
- Data Security - Setiap user hanya bisa akses resep mereka sendiri.

## Teknologi yang Digunakan

- Flutter - Framework UI cross-platform.
- Supabase - Backend-as-a-Service untuk auth dan database.
- Provider - State management.
- SharedPreferences - Local storage untuk session.

## Langkah Install dan Build

### Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- VS Code
- Akun Supabase

### Setup Database

Buat akun Supabase dan database baru.
Di SQL Editor, jalankan query berikut:

```sql
-- Tabel untuk resep
CREATE TABLE recipes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  ingredients TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS (Row Level Security)
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;

-- Policy untuk user hanya bisa akses data mereka sendiri
CREATE POLICY "Users can only access their own recipes" ON recipes
  FOR ALL USING (auth.uid() = user_id);
```

### Setup Project

Clone repository ini:

```bash
git clone https://github.com/karvinmc/simple-recipe-keeper.git
cd simple-recipe-keeper
```

Instal dependencies:
```bash
flutter pub get
```

Update file `lib/utils/constants.dart` dengan kredensial Supabase anda:
```dart
class Constants {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

## Kredensial Testing

Untuk testing, anda bisa membuat akun baru dengan register atau menggunakan kredensial berikut:
- Email: `user@example.com`
- Password: `userpassword`

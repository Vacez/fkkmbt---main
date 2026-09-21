-- =============================================
-- SUPABASE / POSTGRESQL SCHEMA FOR FKKMBT
-- Copy & Paste script ini ke SQL Editor di Supabase
-- =============================================

-- 1. ENUM TYPES
CREATE TYPE role_type AS ENUM ('admin', 'warga');
CREATE TYPE jenis_kelamin_type AS ENUM ('L', 'P');
CREATE TYPE tipe_organisasi_type AS ENUM ('FKKMBT', 'FKKMMBT');
CREATE TYPE tipe_file_type AS ENUM ('gambar', 'video');
CREATE TYPE status_iuran_type AS ENUM ('aktif', 'nonaktif');
CREATE TYPE status_pembayaran_type AS ENUM ('pending', 'disetujui', 'ditolak');

-- 2. TABLE STRUCTURES

-- Users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role role_type NOT NULL DEFAULT 'warga',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admins
CREATE TABLE admins (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  nama_lengkap VARCHAR(100) NOT NULL,
  jabatan VARCHAR(50) DEFAULT 'Pengurus'
);

-- Warga
CREATE TABLE warga (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  nama_lengkap VARCHAR(100) NOT NULL,
  blok VARCHAR(5) NOT NULL,
  no_rumah VARCHAR(10) NOT NULL,
  no_hp VARCHAR(20) DEFAULT NULL,
  foto_profil VARCHAR(255) DEFAULT 'default.png',
  jenis_kelamin jenis_kelamin_type DEFAULT 'L'
);

-- Organisasi
CREATE TABLE organisasi (
  id SERIAL PRIMARY KEY,
  nama_organisasi VARCHAR(100) NOT NULL,
  deskripsi TEXT DEFAULT NULL
);

-- Struktur Organisasi
CREATE TABLE struktur_organisasi (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  jabatan VARCHAR(100) NOT NULL,
  foto VARCHAR(255) DEFAULT NULL,
  level INT DEFAULT 99,
  tipe_organisasi tipe_organisasi_type DEFAULT 'FKKMBT',
  jenis_kelamin jenis_kelamin_type DEFAULT 'L',
  kontak VARCHAR(20) DEFAULT NULL
);

-- Kegiatan
CREATE TABLE kegiatan (
  id SERIAL PRIMARY KEY,
  organisasi_id INT NOT NULL REFERENCES organisasi(id) ON DELETE CASCADE,
  judul VARCHAR(200) NOT NULL,
  deskripsi TEXT NOT NULL,
  tanggal DATE NOT NULL,
  foto VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kegiatan Galeri
CREATE TABLE kegiatan_galeri (
  id SERIAL PRIMARY KEY,
  kegiatan_id INT NOT NULL REFERENCES kegiatan(id) ON DELETE CASCADE,
  file VARCHAR(255) NOT NULL,
  tipe_file tipe_file_type DEFAULT 'gambar'
);

-- Iuran Master
CREATE TABLE iuran_master (
  id SERIAL PRIMARY KEY,
  nama_iuran VARCHAR(100) NOT NULL,
  keterangan TEXT DEFAULT NULL,
  nominal NUMERIC(10,2) NOT NULL,
  jatuh_tempo DATE NOT NULL,
  status status_iuran_type DEFAULT 'aktif'
);

-- Pembayaran Iuran
CREATE TABLE pembayaran_iuran (
  id SERIAL PRIMARY KEY,
  warga_id INT NOT NULL REFERENCES warga(id) ON DELETE CASCADE,
  iuran_id INT NOT NULL REFERENCES iuran_master(id) ON DELETE CASCADE,
  tgl_bayar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  bukti_transfer VARCHAR(255) NOT NULL,
  status status_pembayaran_type DEFAULT 'pending',
  catatan_admin TEXT DEFAULT NULL
);

-- 3. INITIAL SEED DATA

INSERT INTO users (username, password, role) VALUES
('StaffFkkmbt', '$2y$10$idnRrPUEEFhiLM73CvtyL.zLKTniEHxAPL5cWfBHJjsjwrzV1SlX6', 'admin'),
('aceva', '$2y$10$nBJSb70nMl2.Z1C1IZpFU.baV5ZehWg6e4mtydVHo0zzK8UKSs0bi', 'warga');

INSERT INTO admins (user_id, nama_lengkap, jabatan) VALUES
(1, 'Staff FKKMBT', 'Administrator');

INSERT INTO warga (user_id, nama_lengkap, blok, no_rumah, no_hp, jenis_kelamin) VALUES
(2, 'Aceva Arie Sadewa', 'J', '4', '087786720942', 'L');

INSERT INTO organisasi (nama_organisasi, deskripsi) VALUES
('FKKMBT', 'Forum Komunikasi Koordinasi Masyarakat Bukit Tiara'),
('PKK', 'Pemberdayaan Kesejahteraan Keluarga'),
('Karang Taruna', 'Organisasi Pemuda Perumahan Bukit Tiara'),
('Posyandu', 'Pos Pelayanan Terpadu Kesehatan Ibu dan Anak'),
('Remaja Masjid', 'Organisasi Remaja Islam Bukit Tiara');

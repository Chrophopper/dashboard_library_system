-- ============================================
-- SCHEMA DATABASE SISTEM PERPUSTAKAAN DIGITAL
-- ============================================

-- Tabel Kategori Buku
CREATE TABLE IF NOT EXISTS categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Tabel Rak/Lokasi Buku
CREATE TABLE IF NOT EXISTS shelves (
    shelf_id INTEGER PRIMARY KEY AUTOINCREMENT,
    shelf_code VARCHAR(20) NOT NULL UNIQUE,
    floor INTEGER NOT NULL,
    capacity INTEGER NOT NULL,
    description TEXT
);

-- Tabel Buku
CREATE TABLE IF NOT EXISTS books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    year_published INTEGER,
    isbn VARCHAR(20) UNIQUE,
    stock INTEGER NOT NULL DEFAULT 0,
    category_id INTEGER,
    shelf_id INTEGER,
    media_type VARCHAR(20) DEFAULT 'Book',
    issue_number VARCHAR(50),
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (shelf_id) REFERENCES shelves(shelf_id) ON DELETE SET NULL
);

-- Tabel Anggota/Member
CREATE TABLE IF NOT EXISTS members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    registration_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Aktif' CHECK(status IN ('Aktif', 'Non-Aktif'))
);

-- Tabel Petugas Perpustakaan
CREATE TABLE IF NOT EXISTS staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    phone VARCHAR(20)
);

-- Tabel Transaksi Peminjaman
CREATE TABLE IF NOT EXISTS borrowing_transactions (
    borrowing_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Dipinjam' CHECK(status IN ('Dipinjam', 'Dikembalikan')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

-- Tabel Transaksi Pengembalian
CREATE TABLE IF NOT EXISTS return_transactions (
    return_id INTEGER PRIMARY KEY AUTOINCREMENT,
    borrowing_id INTEGER NOT NULL UNIQUE,
    return_date DATE NOT NULL,
    days_late INTEGER DEFAULT 0,
    fine DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (borrowing_id) REFERENCES borrowing_transactions(borrowing_id) ON DELETE CASCADE
);

-- Tabel Transaksi Perpanjangan
CREATE TABLE IF NOT EXISTS extension_transactions (
    extension_id INTEGER PRIMARY KEY AUTOINCREMENT,
    borrowing_id INTEGER NOT NULL,
    extension_date DATE NOT NULL,
    extension_count INTEGER DEFAULT 1,
    FOREIGN KEY (borrowing_id) REFERENCES borrowing_transactions(borrowing_id) ON DELETE CASCADE
);

-- ============================================
-- DATA AWAL (SEED DATA)
-- ============================================

-- Insert Kategori
INSERT INTO categories (category_name, description) VALUES
('Fiksi', 'Buku cerita fiksi dan novel'),
('Non-Fiksi', 'Buku berdasarkan fakta dan kenyataan'),
('Sains', 'Buku tentang ilmu pengetahuan'),
('Teknologi', 'Buku tentang teknologi dan komputer'),
('Sastra', 'Buku sastra dan puisi'),
('Sejarah', 'Buku tentang sejarah'),
('Biografi', 'Buku biografi tokoh');

-- Insert Rak
INSERT INTO shelves (shelf_code, floor, capacity, description) VALUES
('A1', 1, 100, 'Rak Fiksi Lantai 1'),
('A2', 1, 100, 'Rak Non-Fiksi Lantai 1'),
('B1', 2, 150, 'Rak Sains Lantai 2'),
('B2', 2, 150, 'Rak Teknologi Lantai 2'),
('C1', 3, 120, 'Rak Sastra Lantai 3');

-- Insert Petugas (Password: admin123)
INSERT INTO staff (name, username, password, position, phone) VALUES
('Admin Perpustakaan', 'admin', 'admin123', 'Kepala Perpustakaan', '081234567890'),
('Petugas 1', 'petugas1', 'petugas123', 'Staf Perpustakaan', '081234567891');

-- Insert Buku Sample
INSERT INTO books (title, author, publisher, year_published, isbn, stock, category_id, shelf_id, media_type) VALUES
('Laskar Pelangi', 'Andrea Hirata', 'Bentang Pustaka', 2005, '978-979-3062-79-2', 5, 1, 1, 'Book'),
('Bumi Manusia', 'Pramoedya Ananta Toer', 'Hasta Mitra', 1980, '978-979-461-001-1', 3, 5, 5, 'Book'),
('Sapiens', 'Yuval Noah Harari', 'Gramedia', 2015, '978-602-03-2218-2', 4, 2, 2, 'Book'),
('Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, '978-0-13-235088-4', 2, 4, 4, 'Book'),
('National Geographic', 'Various', 'National Geographic', 2024, 'MAG-2024-01', 10, 3, 3, 'Magazine');

-- Insert Anggota Sample
INSERT INTO members (name, address, phone, email, registration_date, status) VALUES
('John Doe', 'Jl. Merdeka No. 123', '081234567892', 'john@email.com', '2024-01-01', 'Aktif'),
('Jane Smith', 'Jl. Sudirman No. 456', '081234567893', 'jane@email.com', '2024-01-15', 'Aktif'),
('Bob Wilson', 'Jl. Gatot Subroto No. 789', '081234567894', 'bob@email.com', '2024-02-01', 'Aktif');

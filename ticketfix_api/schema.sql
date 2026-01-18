-- Database: ticketfix_db

CREATE DATABASE IF NOT EXISTS ticketfix_db;
USE ticketfix_db;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: movies
CREATE TABLE IF NOT EXISTS movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(255),
    poster_url VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: schedules
CREATE TABLE IF NOT EXISTS schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    studio_name VARCHAR(100) NOT NULL,
    start_time DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);

-- Table: orders
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    schedule_id INT NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    seats VARCHAR(255) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(id)
);

-- Insert Dummy Data for Movies
INSERT INTO movies (title, genre, poster_url, description) VALUES 
('Avengers: End Game', 'Action, Sci-Fi', 'https://example.com/avengers.jpg', 'The Avengers take a final stand against Thanos.'),
('Dilan 1990', 'Romance', 'https://example.com/dilan.jpg', 'High school romance in Bandung.'),
('Pengabdi Setan', 'Horror', 'https://example.com/pengabdi_setan.jpg', 'A family is haunted by their mother\'s death.');

-- Insert Dummy Data for Schedules
INSERT INTO schedules (movie_id, studio_name, start_time, price) VALUES 
(1, 'Studio 1', '2026-02-01 14:00:00', 50000),
(1, 'Studio 1', '2026-02-01 19:00:00', 50000),
(2, 'Studio 2', '2026-02-01 15:00:00', 35000),
(3, 'Studio 3', '2026-02-01 20:00:00', 40000);

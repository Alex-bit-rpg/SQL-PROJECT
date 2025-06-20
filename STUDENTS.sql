-- Database: Library Management System

-- Create the database if it doesn't exist
-- CREATE DATABASE IF NOT EXISTS library_db;
-- USE library_db;

-- 1. Authors Table
-- Stores information about the authors of the books.
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(100),
    birth_date DATE,
    CONSTRAINT UQ_AuthorName UNIQUE (first_name, last_name) -- Ensure unique author names
);

-- 2. Publishers Table
-- Stores information about the publishers of the books.
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL UNIQUE, -- Publisher names must be unique
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(255) UNIQUE -- Email addresses must be unique
);

-- 3. Books Table
-- Stores information about the books available in the library.
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE, -- ISBN must be unique
    publication_year INT,
    publisher_id INT NOT NULL,
    genre VARCHAR(100),
    total_copies INT NOT NULL DEFAULT 0 CHECK (total_copies >= 0),
    available_copies INT NOT NULL DEFAULT 0 CHECK (available_copies >= 0 AND available_copies <= total_copies),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT -- Do not allow deleting a publisher if books are associated with it
);

-- 4. Book_Authors Table (Junction Table)
-- Manages the Many-to-Many relationship between Books and Authors.
-- A book can have multiple authors, and an author can write multiple books.
CREATE TABLE Book_Authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id), -- Composite Primary Key
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE, -- If a book is deleted, remove its author associations
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE -- If an author is deleted, remove their book associations
);

-- 5. Members Table
-- Stores information about the library members.
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(255) UNIQUE NOT NULL, -- Email must be unique and not null for identification
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Loans Table
-- Records the details of books borrowed by members.
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL, -- Due date is mandatory
    return_date TIMESTAMP NULL, -- Null until the book is returned
    fine_amount DECIMAL(10, 2) DEFAULT 0.00 CHECK (fine_amount >= 0),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, -- Do not allow deleting a book if it has active loans
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT -- Do not allow deleting a member if they have active loans
);

-- Indexes for performance optimization
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_books_isbn ON Books(isbn);
CREATE INDEX idx_members_email ON Members(email);
CREATE INDEX idx_loans_book_id ON Loans(book_id);
CREATE INDEX idx_loans_member_id ON Loans(member_id);

INSERT INTO Departments (department_name, head_of_department, phone_number) VALUES
('Computer Science', 'Dr. Alice Smith', '555-1234'),
('Mathematics', 'Prof. Bob Johnson', '555-5678'),
('Physics', 'Dr. Carol Davis', '555-9012');

INSERT INTO Instructors (first_name, last_name, email, phone_number, department_id, hire_date) VALUES
('Charlie', 'Brown', 'charlie.brown@university.edu', '555-1001', 1, '2020-08-15'), -- Computer Science
('Diana', 'Prince', 'diana.prince@university.edu', '555-2002', 2, '2018-03-01'),   -- Mathematics
('Edward', 'Norton', 'edward.norton@university.edu', '555-3003', 1, '2021-01-10'), -- Computer Science
('Fiona', 'Apple', 'fiona.apple@university.edu', '555-4004', 3, '2019-07-20');   -- Physics

INSERT INTO Students (first_name, last_name, date_of_birth, email, phone_number, address) VALUES
('Grace', 'Hopper', '2004-01-20', 'grace.h@example.com', '555-5001', '101 Tech Way'),
('Harry', 'Potter', '2003-09-15', 'harry.p@example.com', '555-5002', '4 Privet Drive'),
('Ivy', 'Leaf', '2005-03-05', 'ivy.l@example.com', '555-5003', '202 Green St');

INSERT INTO Courses (course_code, course_name, credits, department_id, instructor_id) VALUES
('CS101', 'Introduction to Programming', 3, 1, 1), -- Taught by Charlie Brown (department_id 1)
('MA201', 'Calculus I', 4, 2, 2),                  -- Taught by Diana Prince (department_id 2)
('CS205', 'Data Structures', 3, 1, 3),              -- Taught by Edward Norton (department_id 1)
('PH101', 'Introductory Physics', 3, 3, 4);          -- Taught by Fiona Apple (department_id 3)

INSERT INTO Enrollments (student_id, course_id, grade) VALUES
(1, 1, 'A'),   -- Grace Hopper in CS101
(1, 2, 'B+'),  -- Grace Hopper in MA201
(2, 1, 'C'),   -- Harry Potter in CS101
(3, 4, 'A-'),  -- Ivy Leaf in PH101
(2, 3, NULL);  -- Harry Potter in CS205 (grade not yet assigned

-- Find students born after a certain date
SELECT * FROM Students WHERE date_of_birth > '2004-01-01';

-- Find courses taught by a specific instructor (assuming you know instructor_id)
SELECT course_name FROM Courses WHERE instructor_id = 1;

-- List students alphabetically by last name
SELECT * FROM Students ORDER BY last_name ASC, first_name ASC;

-- List enrollments by grade, highest first
SELECT * FROM Enrollments ORDER BY grade DESC;

SELECT
    S.first_name,
    S.last_name,
    C.course_name,
    E.grade
FROM
    Students S
JOIN
    Enrollments E ON S.student_id = E.student_id
JOIN
    Courses C ON E.course_id = C.course_id;
    
SELECT
    I.first_name,
    I.last_name,
    D.department_name
FROM
    Instructors I
JOIN
    Departments D ON I.department_id = D.department_id;
    
SELECT
    C.course_name,
    C.course_code
FROM
    Courses C
JOIN
    Departments D ON C.department_id = D.department_id
WHERE
    D.department_name = 'Computer Science';
    

PROJECT TITLE: STUDENT RECORDS MANAGEMENT SYSTEM DATABASE

DESCRIPTION OF WHAT PROJECT DOES
The Student Records Management System (SRMS) is a relational database designed to efficiently manage core academic information within an educational institution. It provides a structured way to store and organize data related to students, the courses they take, the instructors who teach them, the academic departments that offer these courses, and the enrollments of students in specific courses.

This system is built using MySQL and allows for:

Centralized Student Data: Maintaining comprehensive records for each student, including personal details and enrollment dates.

Course Catalog Management: Keeping track of all courses offered, their unique codes, credits, and the department responsible for them.

Instructor Information: Storing details about faculty members, their contact information, and their departmental affiliations.

Enrollment Tracking: Recording which students are registered for which courses, including their enrollment dates and assigned grades.

Relationship Management: Establishing clear connections between students, courses, instructors, and departments through well-defined foreign keys, ensuring data integrity and consistency across the system.

How to Run/Setup the Project (Import SQL)
To set up and run this database project, you will need a MySQL server installed and accessible on your system.

1. Save the SQL Schema:

Copy the entire SQL schema provided in the student_records_database.sql file (which will be provided below this README) into a plain text editor (e.g., Notepad, VS Code, Sublime Text).

Save this file with a .sql extension (e.g., student_records_schema.sql) in a location you can easily access (e.g., your "Documents" folder).

2. Access MySQL Command Client:

Open your terminal or command prompt (CMD, PowerShell on Windows; Terminal on macOS/Linux).

Connect to your MySQL server using your MySQL username. You will be prompted to enter your password:

mysql -u your_username -p

Replace your_username with your actual MySQL username.

3. Create and Select the Database:

Once you are at the MySQL prompt (mysql>), create a new database for the system:

CREATE DATABASE IF NOT EXISTS student_records_db;

Then, switch to using this new database:

USE student_records_db;

4. Import the SQL Schema:

With the student_records_db selected, execute the SQL schema file. Replace /path/to/your/student_records_schema.sql with the actual path to the file you saved in Step 1:

SOURCE /path/to/your/student_records_schema.sql;

MySQL will process the file, creating all the necessary tables and applying constraints as defined in the schema.

5. Insert Sample Data (Optional but Recommended):

To test the database and see data in action, you can insert sample records. Sample INSERT statements were provided in previous conversations, ensuring the correct order to avoid foreign key errors. You can execute these statements directly at the mysql> prompt or save them to another .sql file and SOURCE it.

Entity-Relationship Diagram (ERD)
Below is a textual representation of the database's Entity-Relationship Diagram (ERD) using Mermaid syntax. Many Markdown renderers (like GitHub) can display this as a graphical diagram.

erDiagram
    Departments {
        INT department_id PK
        VARCHAR department_name UNIQUE
        VARCHAR head_of_department
        VARCHAR phone_number
    }

    Instructors {
        INT instructor_id PK
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email UNIQUE
        VARCHAR phone_number
        INT department_id FK
        DATE hire_date
    }

    Students {
        INT student_id PK
        VARCHAR first_name
        VARCHAR last_name
        DATE date_of_birth
        VARCHAR email UNIQUE
        VARCHAR phone_number
        VARCHAR address
        TIMESTAMP enrollment_date
    }

    Courses {
        INT course_id PK
        VARCHAR course_code UNIQUE
        VARCHAR course_name
        INT credits
        INT department_id FK
        INT instructor_id FK
    }

    Enrollments {
        INT enrollment_id PK
        INT student_id FK
        INT course_id FK
        TIMESTAMP enrollment_date
        VARCHAR grade
        UNIQUE (student_id, course_id)
    }

    Departments ||--o{ Instructors : "has"
    Departments ||--o{ Courses : "offers"
    Instructors ||--o{ Courses : "teaches"
    Students ||--o{ Enrollments : "enrolls in"
    Courses ||--o{ Enrollments : "has"

    
    ![database sql](https://github.com/user-attachments/assets/7fa1caf0-0d95-41a4-9a54-5ef498b06af8)



ERD Explanation:


Entities (Tables): Departments, Instructors, Students, Courses, Enrollments.

Primary Key (PK): Uniquely identifies each record within a table.

Foreign Key (FK): Establishes a link to the primary key of another table, defining relationships.

Relationships:

Departments (1) -- M (Instructors): One department can have many instructors.

Departments (1) -- M (Courses): One department can offer many courses.

Instructors (1) -- M (Courses): One instructor can teach many courses.

Students (M) -- M (Courses) via Enrollments: This is a many-to-many relationship managed by the Enrollments junction table. A student can enroll in multiple courses, and a course can have many students. The Enrollments table records the student_id, course_id, and the grade for each unique student-course pairing.

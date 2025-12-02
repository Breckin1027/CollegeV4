````markdown
# 🎓 College Database — `af25ayder1_collegev2`

A comprehensive **MySQL relational database** schema designed to model a college environment — including students, employees, courses, departments, and enrollments.  
Developed and structured using **MySQL Workbench Forward Engineering**.

---

## 📚 Table of Contents

1. [Overview](#-overview)  
2. [Database Entities](#-database-entities)  
   - [Core Tables](#core-tables)  
   - [Lookup Tables](#lookup-tables)  
   - [Relationship Tables](#relationship-tables)  
3. [Relationships Summary](#-relationships-summary)  
4. [Setup Instructions](#️-setup-instructions)  
5. [Design Features](#-design-features)  
6. [Views](#-views)  
   - [student_grade](#1-student_grade-view)  
   - [section_data](#2-section_data-view)  
   - [student_in_section](#3-student_in_section-view)  
   - [building_info](#4-building_info-view)  
   - [filled_room_info](#5-filled_room_info-view)  
   - [active_employees](#6-active_employees-view)  
   - [department_courses](#7-department_courses-view)  
   - [student_enrollment_summary](#8-student_enrollment_summary-view)  
7. [Example Usage](#-example-usage)  
8. [Dependencies](#-dependencies)  
9. [License](#-license)  
10. [Authors](#-authors)

---

## 📘 Overview

The `af25ayder1_collegev2` schema models a college’s academic and administrative data.  
It captures relationships between departments, students, employees, and courses while maintaining data integrity through **foreign key constraints** and **audit tracking**.

This schema supports:
- Student enrollment and grade tracking  
- Course and department management  
- Employee assignment and scheduling  
- Room and building organization 

Below are the exported diagrams from MySQL Workbench. Click the images to view the full-size versions.

![EER_Diagram](assets/EER_Diagram.png)

EER Diagram EER Diagram — shows tables and relationships.

![Catalog_Tree](assets/Catalog_Tree.png)

Catalog Tree Catalog Tree — shows the list of tables in the generated schema.
---

## 🧩 Database Entities

### Core Tables

| Table | Description |
|--------|--------------|
| **department** | Stores academic department information. |
| **course** | Contains all courses offered by the college. |
| **user** | Base user table shared by students and employees. |
| **student** | Contains student-specific data linked to a user. |
| **employee** | Contains employee-specific data linked to a user and role. |
| **semester** | Defines academic terms (e.g., Fall 2025). |
| **section** | Represents a specific course offering with instructor, room, and schedule. |
| **building** | Represents physical college buildings. |
| **room** | Represents rooms located in buildings, with capacity tracking. |

---

### Lookup Tables

| Table | Description |
|--------|--------------|
| **lookup_grade** | Defines grade letters (A–F) and their point values. |
| **lookup_employee_role** | Lists employee roles (e.g., Professor, TA, Admin) and security levels. |

---

### Relationship Tables

| Table | Description |
|--------|--------------|
| **course_has_department** | Links courses to one or more departments. |
| **employee_has_department** | Links employees to one or more departments. |
| **student_has_section** | Links students to the course sections they are enrolled in. |
| **enrollment** | Tracks student enrollments per semester and their grades. |

---

## 🔗 Relationships Summary

- A **department** can offer multiple **courses** and employ several **employees**.  
- A **course** can belong to one or more **departments** and have multiple **sections**.  
- Each **section** is taught by one **employee**, associated with a **course**, **room**, and **semester**.  
- A **student** can enroll in multiple **sections**, with grades tracked via **enrollment**.  
- Both **students** and **employees** inherit their base information from the **user** table.

---

## ⚙️️ Setup Instructions

### Requirements
- **MySQL Server 8.0+**  
- **MySQL Workbench**

### Installation Steps
1. Open **MySQL Workbench**.  
2. Create a new connection to your MySQL server.  
3. Open the SQL script file (e.g., `af25ayder1_collegev2.sql`).  
4. Execute the script to create all database tables and relationships.  
5. Run the **View Creation Scripts** (see below).  
6. Verify the schema and views under the **Schemas** tab in Workbench.

---

## 🧠 Design Features

- **Referential Integrity:** Enforced via `FOREIGN KEY` constraints.  
- **Audit Fields:** `audit_user_id` and `audit_timestamp` track data modifications.  
- **Normalization:** Reduces redundancy and ensures scalable design.  
- **Restrictive Deletes:** Prevents accidental data loss via `ON DELETE RESTRICT`.  
- **Cascading Updates:** Maintains referential consistency.

---

## 👁️ Views

### 1. `student_grade` View

**Purpose:** Displays student grades per course and semester.  

```sql
CREATE OR REPLACE VIEW student_grade AS
SELECT DISTINCT 
    student.student_id, 
    CONCAT(user.lname, ', ', user.fname) AS student_name, 
    course.name AS course_name, 
    section.section_id, 
    lookup_grade.grade_letter, 
    semester.season
FROM user 
JOIN student ON user.user_id = student.user_user_id
JOIN enrollment ON enrollment.student_id = student.student_id
JOIN semester ON enrollment.semester_id = semester.semester_id
JOIN section ON semester.semester_id = section.semester_id
JOIN course ON section.course_id = course.course_id
JOIN lookup_grade ON enrollment.lookup_grade_id = lookup_grade.lookup_grade_id;
````

---

### 2. `section_data` View

**Purpose:** Provides detailed information for each section, including department, course, instructor, schedule, and delivery method.

```sql
CREATE OR REPLACE VIEW section_data AS
SELECT 
    section.section_id, 
    department.name AS department_name, 
    course.name AS course_name, 
    CONCAT(user.lname, ', ', user.fname) AS instructor, 
    section.days, 
    section.times, 
    section.delivery_method, 
    course.credit_hours, 
    semester.season
FROM section 
JOIN course ON course.course_id = section.course_id 
JOIN course_has_department ON course_has_department.course_id = course.course_id
JOIN department ON course_has_department.department_id = department.department_id
JOIN employee ON section.employee_id = employee.employee_id
JOIN user ON user.user_id = employee.user_user_id
JOIN semester ON section.semester_id = semester.semester_id
ORDER BY section.section_id;
```

---

### 3. `student_in_section` View

**Purpose:** Displays students enrolled in each section with their grades, instructors, and schedule.

```sql
CREATE OR REPLACE VIEW student_in_section AS
SELECT 
    section_data.section_id, 
    student_grade.student_name, 
    student_grade.grade_letter, 
    section_data.course_name, 
    section_data.instructor, 
    section_data.days, 
    section_data.times, 
    section_data.season
FROM student_grade 
JOIN section_data ON student_grade.section_id = section_data.section_id;
```

---

### 4. `building_info` View

**Purpose:** Combines building and room information.

```sql
CREATE OR REPLACE VIEW building_info AS
SELECT 
    building.building_id, 
    room.room_id, 
    building.name AS building_name, 
    room.name AS room_name, 
    room.capacity
FROM building 
JOIN room ON building.building_id = room.building_id;
```

---

### 5. `filled_room_info` View

**Purpose:** Displays active students in each section occupying a room.

```sql
CREATE OR REPLACE VIEW filled_room_info AS
SELECT 
    building_info.building_name, 
    building_info.room_name, 
    course.name AS course_name, 
    section.days, 
    section.times, 
    COUNT(student.student_id) AS student_count, 
    building_info.capacity, 
    semester.season
FROM building_info
JOIN section ON building_info.room_id = section.room_id
JOIN semester ON semester.semester_id = section.semester_id
JOIN enrollment ON semester.semester_id = enrollment.semester_id
JOIN student ON enrollment.student_id = student.student_id
JOIN course ON section.course_id = course.course_id
GROUP BY section.section_id;
```

---

### 6. `active_employees` View

**Purpose:** Displays all currently active employees with their department and role information.

```sql
CREATE OR REPLACE VIEW active_employees AS
SELECT
    e.employee_id,
    CONCAT(u.fname, ' ', u.lname) AS employee_name,
    ler.employee_role_name AS role_name,
    d.name AS department_name,
    e.start_date
FROM employee e
JOIN user u ON u.user_id = e.user_user_id
JOIN lookup_employee_role ler ON ler.lookup_employee_role_id = e.lookup_employee_role_id
JOIN employee_has_department ehd ON ehd.employee_employee_id = e.employee_id
JOIN department d ON d.department_id = ehd.department_department_id
WHERE e.end_date IS NULL;
```

---

### 7. `department_courses` View

**Purpose:** Displays all courses offered by each department, including credit hours and active status.

```sql
CREATE OR REPLACE VIEW department_courses AS
SELECT
    d.department_id,
    d.name AS department_name,
    c.course_id,
    c.name AS course_name,
    c.credit_hours,
    c.is_active
FROM department d
JOIN course_has_department chd ON chd.department_id = d.department_id
JOIN course c ON c.course_id = chd.course_id;
```

---

### 8. `student_enrollment_summary` View

**Purpose:** Summarizes the number of enrollments each student has per semester.

```sql
CREATE OR REPLACE VIEW student_enrollment_summary AS
SELECT
    s.student_id,
    CONCAT(u.fname, ' ', u.lname) AS student_name,
    sem.season AS semester,
    COUNT(e.enrollment_id) AS total_enrollments
FROM student s
JOIN user u ON u.user_id = s.user_user_id
JOIN enrollment e ON e.student_id = s.student_id
JOIN semester sem ON sem.semester_id = e.semester_id
GROUP BY s.student_id, sem.season;
```

---

## 🧾 Example Usage

| Query                                                             | Description                                      |
| ----------------------------------------------------------------- | ------------------------------------------------ |
| `SELECT * FROM student_grade ORDER BY student_name;`              | View all student grades.                         |
| `SELECT * FROM section_data ORDER BY instructor;`                 | View all section details.                        |
| `SELECT * FROM student_in_section WHERE section_id = 1;`          | View students enrolled in a specific section.    |
| `SELECT * FROM building_info;`                                    | View all rooms and buildings.                    |
| `SELECT * FROM filled_room_info;`                                 | View room occupancy and student counts.          |
| `SELECT * FROM active_employees ORDER BY employee_name;`          | View all currently active employees.             |
| `SELECT * FROM department_courses ORDER BY department_name;`      | View all courses offered by each department.     |
| `SELECT * FROM student_enrollment_summary ORDER BY student_name;` | View total enrollments per student per semester. |

---

## 🧩 Dependencies

| Dependency          | Version | Purpose                           |
| ------------------- | ------- | --------------------------------- |
| **MySQL Server**    | 8.0+    | Database engine                   |
| **MySQL Workbench** | Latest  | Schema modeling and SQL execution |

---

## 📄 License

This database schema is provided for **educational and demonstration purposes**.
You may use, modify, or expand upon it for non-commercial academic projects.

---

## 👤 Authors

* [Ayden Riddle](https://github.com/ayridd03)
* [Breckin Lukehart](https://github.com/Breckin1027)

---
````markdown
# 📚 College Database Schema (af25nicot1_college_V2)

This repository contains the MySQL relational database schema for a college information system.  
The system manages users, employees, departments, students, courses, enrollment, grades, buildings, rooms, and more.

All tables are audit-ready and track creation and modification details using:
- `created`, `created_userid`
- `updated`, `updated_userid`

---

## 📌 Features

✔ Centralized **User Profile** table  
✔ Automatic **audit timestamps and user tracking**  
✔ Support for **students, employees, instructors, and roles**  
✔ Management of **classes, semesters, courses, enrollment, grades**  
✔ Building → Room → Section scheduling structure  
✔ Constraints to maintain **data consistency**

---

## 🗂 Database Overview


| Table | Purpose |
|-------|---------|
| `user` | Stores personal data such as name, DOB, contact info, SSN |
| `employee` | Links users to college employment roles & departments |
| `department` | Academic or administrative departments |
| `role` | Job roles (e.g., Professor, Admin, Advisor) |
| `student` | Stores student-specific data such as admission & GPA |
| `status` | Defines students' academic status (active, probation, etc.) |
| `building` | Campus buildings |
| `room` | Rooms located inside buildings |
| `semester` | Term + academic year tracking |
| `course` | Course catalog entries |
| `section` | Course offerings per semester & instructor |
| `enrollment` | Links students to sections |
| `grade_type` | Categories (Assignment, Test, Final Exam, etc.) |
| `grade` | Student grade records |
| `section_room` | Assigns rooms to scheduled course sections |

---

## 🔐 Audit Fields

Nearly every table includes:

| Field | Purpose |
|-------|---------|
| `created` | Timestamp of row creation |
| `created_userid` | App user who performed the creation |
| `updated` | Timestamp of last modification |
| `updated_userid` | App user who performed the update |

> ⚠ These fields are expected to be handled by triggers in a full implementation. They are **not automatically populated except by default behavior for `created` & `updated`.**

---

## 🧱 Entity Relationships

### 👥 Users & Employees
- A user becomes an employee when linked via `employee.user_id`
- Employees must belong to a `department` and have a `role`

### 🎓 Users & Students
- A user becomes a student when inserted into the `student` table
- Students reference a `status` (Active, Graduated, Probation, etc.)

### 🏫 Buildings, Rooms, & Classes
- A building has many rooms  
- A section (class) can be assigned to rooms via `section_room`

### 📚 Classes, Enrollment, & Grades
- A section belongs to a semester & course, and is taught by an employee (instructor)
- Students enroll in sections via `enrollment`
- Grades link back to `enrollment` and a `grade_type`

---

## 💾 Installation Instructions

1. Open **MySQL Workbench**
2. Create a new connection
3. Copy/paste the SQL file into a new query tab
4. Execute the script  
   > ⚠ Triggers should be added *after* tables are created
5. Start populating data using INSERT statements or a UI/front-end

---

## 📎 Notes & Limitations

- The schema assumes users who act on rows are represented by numeric user accounts (`created_userid`).  
- Timezone defaults follow server settings.
- SSNs are stored as `INT` — in production, consider storing as **encrypted CHAR(11)**.

---

## 🔮 Future Improvements (Optional)

✨ Add data encryption for sensitive fields (SSN)  
✨ Add cascade options for student deletion (restricted for safety)  
✨ Add full change-log auditing tables  
✨ Enforce standardized phone/email formats via triggers

---

## 📄 License

This schema may be used for educational and instructional purposes. Modify freely when used in school projects or academic systems.

---

### 📌 Extras Available on Request

If you would like, the following can also be generated:

🧾 **Triggers for audits**  
🧼 **Data standardization triggers (names, phone, SSN)**  
📊 **Entity Relationship Diagram (image or PDF)**  

# University Database User & Audit Management

This document provides an overview of the database structures, triggers, functions, and stored procedures used to maintain user accounts and audit tracking for campus-related operations.

---

## 📌 Core Concepts

To ensure data integrity, this system automatically manages:

- Unique campus-level user IDs
- Generated campus email addresses
- Insert and update audit fields
- Automated tracking of who created/modified records

These features are handled through a combination of **BEFORE triggers**, **stored procedures**, and **utility functions**.

---

## 🏛️ Audit Fields

The following fields are automatically populated or updated for users:

| Field | Description |
|--------|-------------|
| `created_by` | User ID who created the record |
| `created_at` | Timestamp the record was created |
| `modified_by` | User ID who last modified the record |
| `modified_at` | Timestamp of last modification |
| `campus_id` | Generated unique identifier for a campus user |
| `campus_email` | Auto-generated email based on campus info |

---

## ⚙️ Triggers

### 🟦 `campus_id_before_insert`
Automatically generates:
- A unique `campus_id` using a prefix based on the user’s name
- A `campus_email` tied to that ID
- Normalizes name formatting (capitalizes first/last name)
- Sets initial audit values: `created`, `updated`, `created_userid`, `updated_userid`

### 🟨 `campus_id_before_update`
Automatically:
- Regenerates `campus_id` and `campus_email` if a name change alters the prefix pattern
- Normalizes name formatting
- Updates audit fields (`updated`, `updated_userid`)

### 🟥 `campus_id_after_insert`
Logs creation of a user’s campus identity to `audit_campus_id`, recording:
- New campus ID and email
- Which account created the record
- When it occurred

### 🟧 `campus_id_after_update`
Logs changes when a campus ID or email is updated, storing:
- Previous and updated values for ID and email
- Who made the change and when
- Preserves campus ID history over time

### 🗑️ `campus_id_after_delete`
Stores a historical archive of a deleted user’s campus identity in `audit_campus_id`, including:
- Final campus ID and email values before deletion
- Who performed the delete and when

---

## 🧮 Functions

| Function Name | Purpose |
|---------------|---------|
| **`fn_get_next_user_suffix(base_id)`** | Determines the next numeric suffix to append to a user ID by reading existing values. |
| **`fn_generate_campus_email(campus_name, domain)`** | Generates a standardized email format for a campus user. |

---

## 🔧 Stored Procedures

| Procedure Name | Purpose |
|----------------|---------|
| **`sp_insert_user_with_audit`** | Inserts a new campus user and ensures audit fields are set automatically. |
| **`sp_update_user_with_audit`** | Updates an existing user while ensuring audit fields remain consistent. |

---

## 🧠 How It Works Together

When a user is inserted:
1. The **insert procedure** runs.
2. The **BEFORE INSERT trigger** generates IDs and email fields.
3. Audit fields (`created_by`, `created_at`) are set automatically.

When a user is updated:
1. The **update procedure** runs.
2. The **BEFORE UPDATE trigger** updates audit tracking.
3. Campus ID and email are **not overwritten**.

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
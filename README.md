
# Online Course Log Analyzer

## 📌 Overview

This project is a **Shell Script Log Analyzer** for online teaching platforms (Zoom and Microsoft Teams).
It processes log files (`logs.csv`) containing student attendance and session information, and provides useful analytics for instructors, administrators, and students.

The script is **menu-based**, making it easy to use directly from the terminal.

---

## 📂 File Structure

* `project.sh` → Main shell script with menu and all functions.
* `logs.csv` → Input log file with attendance data.
* `CS101.csv`, `CS102.csv`, ... → Registration files for each course (list of enrolled students).
* `README.md` → Documentation file (this file).

---

## 📑 Log File Format

Each line in `logs.csv` is **comma-separated** and has the following fields:

1. Tool (Zoom/Teams)
2. StudentID
3. FirstName
4. LastName
5. InstructorID
6. CourseID
7. StartTime
8. Length (minutes)
9. SessionID
10. StudentBeginTime
11. StudentLeaveTime

---

## ▶️ How to Run

1. Make the script executable:

   ```bash
   chmod +x project.sh
   ```

2. Run the script:

   ```bash
   ./project.sh
   ```

3. Use the menu to select the desired analysis. Example:

   ```
   1. Number of sessions per course
   2. Average attendance per course
   3. List of absent students per course
   4. List of late arrivals per session
   5. List of students leaving early
   6. Average attendance time per student per course
   7. Average number of attendances per instructor
   8. Most frequently used tool
   9. Exit
   ```

---

## 🛠 Features Implemented

### Task 1 — Number of sessions per course

Counts unique sessions (by SessionID) for a course.

### Task 2 — Average attendance per course

Computes the average number of students who attended sessions of a course.

### Task 3 — List of absent students per course

Compares registered students (from `CourseID.csv`) with attendance records.

### Task 4 — List of late arrivals per session

Shows students who joined **X minutes or more** after the scheduled start.

### Task 5 — List of students leaving early

Shows students who left **Y minutes or more** before the scheduled end.

### Task 6 — Average attendance time per student per course

Calculates average minutes attended for each student in a course.

### Task 7 — Average number of attendances per instructor

Computes average student attendance per session across all courses for each instructor.

### Task 8 — Most frequently used tool

Finds whether Zoom or Teams is used more in the logs.

---

## 🧪 Testing Example (Dummy Data)

Given the provided `logs.csv`:

* **CS101** → 2 sessions, average attendance = 3.00
* **CS102** → 2 sessions, average attendance = 2.00
* Absentees: CS101 → Mona Yousef (1006), CS102 → Huda Saleh (1007)
* Most used tool = Zoom




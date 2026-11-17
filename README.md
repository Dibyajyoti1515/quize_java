# QuizTrack — Online Examination & Assessment Platform

[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-blue.svg)](https://jakarta.ee/)
[![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-10.1+-yellow.svg)](https://tomcat.apache.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15%20--%2017-blue.svg)](https://www.postgresql.org/)
[![Maven](https://img.shields.io/badge/Apache%20Maven-3.9+-red.svg)](https://maven.apache.org/)

QuizTrack is a production-ready, full-stack online examination and proctoring platform designed for academic institutions. It features three specialized roles (**ADMIN**, **TEACHER**, **STUDENT**), live proctoring telemetry, timed examination engines with automatic answer persistence, question bank matrix management, dynamic result analytics, and cryptographically verified certificates.

---

## Table of Contents
1. [Key Features](#key-features)
2. [Technology Stack](#technology-stack)
3. [Prerequisites](#prerequisites)
4. [Step-by-Step Setup Guide](#step-by-step-setup-guide)
   - [Step 1: Database Setup (PostgreSQL)](#step-1-database-setup-postgresql)
   - [Step 2: Database Connection Configuration](#step-2-database-connection-configuration)
   - [Step 3: Build the Project with Maven](#step-3-build-the-project-with-maven)
   - [Step 4: Deploy and Run on Apache Tomcat 10.1+](#step-4-deploy-and-run-on-apache-tomcat-101)
5. [Demo User Accounts](#demo-user-accounts)
6. [One-Click Demo Sandbox Links](#one-click-demo-sandbox-links)
7. [Running Automated Tests](#running-automated-tests)
8. [Project Architecture](#project-architecture)
9. [Troubleshooting & FAQs](#troubleshooting--faqs)

---

## Key Features

- **Role-Based Architecture:**
  - **Admin:** System settings, account lifecycle, user provisioning, global audit telemetry.
  - **Teacher:** Quiz architect, item bank matrix, live proctoring command center, attempt grading.
  - **Student:** Timed distraction-free exam engine, autosave, immediate performance scorecards, verified certificate generator, cohort leaderboard.
- **Exam Integrity & Proctoring:**
  - Real-time tab switch and fullscreen exit telemetry.
  - Integrity index calculation and live teacher flagging.
- **Dynamic Question Builder:**
  - Supports Single Choice (MCQ), Multi-Correct Choices, and True/False questions.
  - Departmental Question Bank item reuse via `quiz_questions` join table.
  - Formula rendering support (KaTeX & Markdown notation).
- **Security:**
  - Session-based authentication with BCrypt password hashing.
  - Comprehensive Cross-Site Request Forgery (CSRF) token validation across all state mutations.
  - Role-based authorization filters and prepared statements preventing SQL injection.

---

## Technology Stack

| Layer | Technology |
|---|---|
| **Language & SDK** | Java 21 (LTS) |
| **Build & Dependency Management** | Apache Maven 3.9+ |
| **Servlet Specification** | Jakarta Servlet 6.0, JSP 3.1, JSTL 3.0 |
| **Application Server** | **Apache Tomcat 10.1+** (*Note: Tomcat 9 is incompatible due to `jakarta.*` namespace*) |
| **Database** | PostgreSQL 15, 16, or 17 |
| **Connection Pooling** | HikariCP 5.1 |
| **Security & Auth** | jBCrypt 0.4, HTTP Session, CSRF Protection |
| **Frontend** | JSP, Tailwind CSS (via CDN), Google Fonts (Inter, Plus Jakarta Sans, JetBrains Mono) |
| **Testing** | JUnit 5 Platform (107 integration and unit tests) |

---

## Prerequisites

Before starting, ensure the following software is installed on your machine and available in your system `PATH`:

1. **Java Development Kit (JDK) 21 or higher:**
   ```bash
   java -version
   ```
2. **Apache Maven 3.9+:**
   ```bash
   mvn -version
   ```
3. **PostgreSQL 15, 16, or 17:**
   ```bash
   psql --version
   ```
4. **Apache Tomcat 10.1+:**
   - Download the "Core" zip/tar.gz for **Tomcat 10.1.x** from [tomcat.apache.org](https://tomcat.apache.org/download-10.cgi).
   - *Important:* Do **not** use Tomcat 9 or older because QuizTrack runs on the modern **Jakarta EE 10** (`jakarta.servlet.*`) namespace.

---

## Step-by-Step Setup Guide

### Step 1: Database Setup (PostgreSQL)

1. Open your terminal or command prompt.
2. Connect to PostgreSQL and create the database `quiztrack_db`:
   ```bash
   # On Windows / macOS / Linux:
   createdb -U postgres quiztrack_db
   ```
   *(Or inside psql: `CREATE DATABASE quiztrack_db;`)*

3. Populate the database schema and seed data using the provided SQL scripts:
   ```bash
   # 1. Run Schema (creates all tables and constraints)
   psql -U postgres -d quiztrack_db -f database/schema.sql

   # 2. Run Seed Data (inserts default roles, subjects, demo users, and questions)
   psql -U postgres -d quiztrack_db -f database/seed_data.sql
   ```

---

### Step 2: Database Connection Configuration

QuizTrack checks database credentials in two ways:
1. **Environment Variables (Recommended):**
   - Windows PowerShell:
     ```powershell
     $env:QUIZTRACK_DB_URL="jdbc:postgresql://localhost:5432/quiztrack_db"
     $env:QUIZTRACK_DB_USER="postgres"
     $env:QUIZTRACK_DB_PASSWORD="your_postgres_password"
     ```
   - Linux / macOS:
     ```bash
     export QUIZTRACK_DB_URL="jdbc:postgresql://localhost:5432/quiztrack_db"
     export QUIZTRACK_DB_USER="postgres"
     export QUIZTRACK_DB_PASSWORD="your_postgres_password"
     ```

2. **Or edit `src/main/resources/db.properties` directly:**
   ```properties
   db.url=jdbc:postgresql://localhost:5432/quiztrack_db
   db.user=postgres
   db.password=your_postgres_password
   db.pool.maxPoolSize=10
   db.pool.minIdle=2
   db.pool.idleTimeout=300000
   db.pool.connectionTimeout=20000
   ```

---

### Step 3: Build the Project with Maven

Navigate to the project root directory (where `pom.xml` is located) and execute:

```bash
mvn clean package
```

Upon a successful build, the deployable WAR archive will be generated at:
```
target/quiztrack.war
```

*(Optional: To build without running the full test suite, run: `mvn clean package -DskipTests`)*

---

### Step 4: Deploy and Run on Apache Tomcat 10.1+

1. Copy the generated `target/quiztrack.war` file into your Tomcat's `webapps/` directory:
   - **Windows Command / PowerShell:**
     ```powershell
     Copy-Item "target\quiztrack.war" -Destination "<TOMCAT_HOME>\webapps\quiztrack.war" -Force
     ```
   - **Linux / macOS:**
     ```bash
     cp target/quiztrack.war <TOMCAT_HOME>/webapps/quiztrack.war
     ```

2. Start the Apache Tomcat server:
   - **Windows:**
     ```cmd
     <TOMCAT_HOME>\bin\catalina.bat run
     ```
   - **Linux / macOS:**
     ```bash
     <TOMCAT_HOME>/bin/catalina.sh run
     ```

3. Open your web browser and navigate to:
   ```
   http://localhost:8080/quiztrack/
   ```

---

## Demo User Accounts

All seeded accounts share the default development password: **`password123`**

| Role | Username / Identifier | Password | Name / Description |
|---|---|---|---|
| **ADMIN** | `admin` | `password123` | System Administrator |
| **TEACHER** | `ronald.vance` | `password123` | Dr. Ronald Vance (Lead Faculty) |
| **TEACHER** | `clara.oswald` | `password123` | Dr. Clara Oswald (Faculty) |
| **STUDENT** | `CS-2022-041` | `password123` | Alex Mercer (Enrolled Student) |
| **STUDENT** | `CS-2022-042` | `password123` | Beatrice Chen (Enrolled Student) |
| **STUDENT** | `CS-2022-043` | `password123` | Cyrus Vance (Enrolled Student) |

---

## One-Click Demo Sandbox Links

For instant local evaluation without manually typing credentials, use the built-in demo shortcuts:

- **Admin Portal Demo:** [http://localhost:8080/quiztrack/auth/demo?role=admin](http://localhost:8080/quiztrack/auth/demo?role=admin)
- **Teacher Dashboard Demo:** [http://localhost:8080/quiztrack/auth/demo?role=teacher](http://localhost:8080/quiztrack/auth/demo?role=teacher)
- **Student Exam Portal Demo:** [http://localhost:8080/quiztrack/auth/demo?role=student](http://localhost:8080/quiztrack/auth/demo?role=student)

---

## Running Automated Tests

QuizTrack includes a comprehensive automated test suite of **107 tests** across all architectural layers.

To run the complete test suite against your local PostgreSQL instance:

```bash
mvn test
```

### Test Coverage Highlights:
- `AdminManagementTest`: User creation, activation/deactivation, password resets, role protections.
- `AuthServiceTest`: Login, BCrypt authentication, account lockouts, CSRF prevention.
- `DatabaseConnectionTest`: HikariCP connection pool health and PostgreSQL transaction checks.
- `TeacherQuizCreationTest`: 22 tests covering multi-step quiz creation, date window checks, question builder, option variations (MCQ, Multi-Correct, True/False), and join table question reuse.
- `TeacherLiveProctoringTest`: Proctoring telemetry, live event feeds, and student flag actions.
- `StudentExamEngineTest`: Timed attempt initialization, answer autosaving, and exam submission.
- `StudentExamResultsTest`: Score calculation, topic mastery breakdown, and review authorization.
- `StudentLeaderboardTest`: Cohort rankings, tie-breakers, and verified certificate validation.

---

## Project Architecture

QuizTrack strictly adheres to the standard **Model-View-Controller (MVC)** design pattern:

```
QuizTrack/
├── database/
│   ├── schema.sql                         # Full PostgreSQL schema with tables, FKs, and indexes
│   ├── seed_data.sql                      # Seeded users, subjects, quizzes, and questions
│   └── migrations/                        # Incremental database migrations
├── src/
│   ├── main/
│   │   ├── java/com/quiztrack/
│   │   │   ├── controller/                # Jakarta HttpServlets (@WebServlet)
│   │   │   │   ├── admin/                 # Admin Dashboard, Users, System Settings
│   │   │   │   ├── auth/                  # Login, Logout, Demo, Register
│   │   │   │   ├── certificate/           # Certificate verification and download
│   │   │   │   ├── student/               # Exam Engine, Results, Leaderboard
│   │   │   │   └── teacher/               # Quiz Creator, Builder, Proctoring
│   │   │   ├── dao/ + dao/impl/           # Pure JDBC DAOs with HikariCP & PreparedStatements
│   │   │   ├── filter/                    # Authentication, Role Authorization, CharacterEncoding, NoCache
│   │   │   ├── model/                     # POJO models and DTOs
│   │   │   ├── service/ + service/impl/   # Business validation and transaction workflows
│   │   │   └── util/                      # DatabaseConnection, PasswordHasher, SystemSettingsHelper
│   │   ├── resources/
│   │   │   └── db.properties              # Database connection properties
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml                # Web application configuration
│   │       │   └── views/                 # JSPs organized by role (admin, teacher, student, auth)
│   │       └── static/                    # Images, icons, and client assets
│   └── test/
│       └── java/com/quiztrack/            # JUnit 5 integration & unit test suites
└── pom.xml                                # Maven build descriptor
```

---

## Troubleshooting & FAQs

### 1. `java.lang.ClassNotFoundException: jakarta.servlet.http.HttpServlet` or 404 / 500 errors on Tomcat startup
- **Cause:** You are likely running on Tomcat 9 or older.
- **Solution:** Download and deploy to **Apache Tomcat 10.1 or higher**. Tomcat 9 uses the legacy `javax.servlet` packages, whereas Jakarta EE 10 uses `jakarta.servlet`.

### 2. Database connection failure (`Connection refused` or `FATAL: password authentication failed`)
- **Solution:** Verify PostgreSQL is running on port `5432`. Verify your password in `db.properties` or set the `QUIZTRACK_DB_PASSWORD` environment variable to your actual PostgreSQL password.

### 3. Account temporarily locked out
- **Cause:** Security settings lock an account after 5 failed login attempts within 15 minutes.
- **Solution:** Wait for the lockout duration or reset the lockout counter directly in PostgreSQL:
  ```sql
  DELETE FROM activity_logs WHERE event_type = 'LOGIN_FAILED';
  ```

---

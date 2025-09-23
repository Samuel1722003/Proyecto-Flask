CREATE DATABASE IF NOT EXISTS proyecto;

USE proyecto;

-- Tablas de contenido
CREATE TABLE areas (
  area_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE project_types (
  project_type_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE participant_types (
  participant_type_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE financing_types (
  financing_type_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE audience_types (
  audience_type_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active TINYINT(1) DEFAULT 1
);

CREATE TABLE profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(75) NOT NULL,
    area_id INT NULL,
    project_type_id INT NULL,
    participant_type_id INT NULL,
    financing_type_id INT NULL,
    financing_amount DECIMAL(14,2) NULL,
    audience_type_id INT NULL,
    title VARCHAR(300) NULL,
    wants_patent TINYINT(1) DEFAULT 0,
    notes TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    is_active TINYINT(1) DEFAULT 1,

    CONSTRAINT fk_profiles_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_profiles_area FOREIGN KEY (area_id) REFERENCES areas(area_id),
    CONSTRAINT fk_profiles_project_type FOREIGN KEY (project_type_id) REFERENCES project_types(project_type_id),
    CONSTRAINT fk_profiles_participant_type FOREIGN KEY (participant_type_id) REFERENCES participant_types(participant_type_id),
    CONSTRAINT fk_profiles_financing_type FOREIGN KEY (financing_type_id) REFERENCES financing_types(financing_type_id),
    CONSTRAINT fk_profiles_audience_type FOREIGN KEY (audience_type_id) REFERENCES audience_types(audience_type_id)
);

-- Tablas 1-a-N para objetivos, keywords, criterios

CREATE TABLE profile_objectives (
    profile_objective_id INT AUTO_INCREMENT PRIMARY KEY,
    profile_id INT NOT NULL,
    objective_type ENUM('general', 'especifico') NOT NULL,
    description TEXT NOT NULL,
  CONSTRAINT fk_obj_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE
);

CREATE TABLE profile_keywords (
  profile_keyword_id INT AUTO_INCREMENT PRIMARY KEY,
  profile_id INT NOT NULL,
  keyword VARCHAR(150) NOT NULL,
  CONSTRAINT fk_kw_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE
);

CREATE TABLE profile_criteria (
  profile_criteria_id INT AUTO_INCREMENT PRIMARY KEY,
  profile_id INT NOT NULL,
  description TEXT NOT NULL,
  CONSTRAINT fk_criteria_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE
);

CREATE TABLE projects (
  project_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  profile_id INT NULL,
  title VARCHAR(300) NOT NULL,
  summary TEXT,
  status VARCHAR(50) DEFAULT 'borrador', -- borrador, enviado, aceptado, archivado, entre otros.
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL,

  CONSTRAINT fk_proj_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_proj_profile FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE SET NULL
);

-- Índices
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_profiles_user ON profiles(user_id);
CREATE INDEX idx_projects_user ON projects(user_id);
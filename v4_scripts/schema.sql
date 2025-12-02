-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema af25nicot1_college_V2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema af25nicot1_college_V2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `af25nicot1_college_V2` DEFAULT CHARACTER SET utf8 ;
USE `af25nicot1_college_V2` ;

-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`user` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `dob` DATE NOT NULL COMMENT 'Date of birth',
  `address` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(255) NULL,
  `ssn` INT NULL,
  `university_id` INT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_first_name` (`first_name` ASC) VISIBLE,
  INDEX `user_last_name` (`last_name` ASC) VISIBLE,
  UNIQUE INDEX `ssn_UNIQUE` (`ssn` ASC) VISIBLE,
  UNIQUE INDEX `university_id_UNIQUE` (`university_id` ASC) VISIBLE,
  INDEX `user_email` (`email` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`department`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`department` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`department` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `dep_name` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`role` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`role` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`employee` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`employee` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `department_id` INT NOT NULL,
  `role_id` INT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_employee_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_employee_department1_idx` (`department_id` ASC) VISIBLE,
  INDEX `fk_employee_role1_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_employee_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `af25nicot1_college_V2`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_employee_department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `af25nicot1_college_V2`.`department` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_employee_role1`
    FOREIGN KEY (`role_id`)
    REFERENCES `af25nicot1_college_V2`.`role` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`building`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`building` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`building` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `building_supervisor` INT NOT NULL,
  `campus` VARCHAR(255) NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_building_employee1_idx` (`building_supervisor` ASC) VISIBLE,
  INDEX `building_name` (`name` ASC) VISIBLE,
  CONSTRAINT `fk_building_employee1`
    FOREIGN KEY (`building_supervisor`)
    REFERENCES `af25nicot1_college_V2`.`employee` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`room` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`room` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `building` INT NOT NULL,
  `capacity` INT NULL,
  `description` TEXT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_room_building1_idx` (`building` ASC) VISIBLE,
  INDEX `room_name` (`name` ASC) VISIBLE,
  INDEX `building_name` (`building` ASC) VISIBLE,
  CONSTRAINT `fk_room_building1`
    FOREIGN KEY (`building`)
    REFERENCES `af25nicot1_college_V2`.`building` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`status` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`status` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `label_UNIQUE` (`label` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`student` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`student` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `admission_date` DATE NULL,
  `gpa` DECIMAL NULL,
  `status` INT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  INDEX `fk_student_status1_idx` (`status` ASC) VISIBLE,
  CONSTRAINT `fk_student_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `af25nicot1_college_V2`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_student_status1`
    FOREIGN KEY (`status`)
    REFERENCES `af25nicot1_college_V2`.`status` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '	';


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`semester`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`semester` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`semester` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `term` VARCHAR(255) NOT NULL,
  `year` INT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `term_year` (`term` ASC, `year` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`course` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`course` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `active` TINYINT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`section`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`section` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`section` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `semester_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `instructor_id` INT NOT NULL,
  `dow` VARCHAR(7) NOT NULL,
  `start_time` TIME NULL,
  `end_time` TIME NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_section_semester1_idx` (`semester_id` ASC) VISIBLE,
  INDEX `fk_section_course1_idx` (`course_id` ASC) VISIBLE,
  INDEX `fk_section_employee1_idx` (`instructor_id` ASC) VISIBLE,
  CONSTRAINT `fk_section_semester1`
    FOREIGN KEY (`semester_id`)
    REFERENCES `af25nicot1_college_V2`.`semester` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_section_course1`
    FOREIGN KEY (`course_id`)
    REFERENCES `af25nicot1_college_V2`.`course` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_section_employee1`
    FOREIGN KEY (`instructor_id`)
    REFERENCES `af25nicot1_college_V2`.`employee` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`enrollment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`enrollment` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`enrollment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `section_id` INT NOT NULL,
  `created` TIMESTAMP NOT NULL,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_enrollment_student1_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_enrollment_section1_idx` (`section_id` ASC) VISIBLE,
  CONSTRAINT `fk_enrollment_student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `af25nicot1_college_V2`.`student` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_enrollment_section1`
    FOREIGN KEY (`section_id`)
    REFERENCES `af25nicot1_college_V2`.`section` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`grade_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`grade_type` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`grade_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `label_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`grade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`grade` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`grade` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `letter` VARCHAR(1) NOT NULL,
  `enrollment_id` INT NOT NULL,
  `type` INT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  INDEX `fk_grade_enrollment1_idx` (`enrollment_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  INDEX `fk_grade_grade_type1_idx` (`type` ASC) VISIBLE,
  CONSTRAINT `fk_grade_enrollment1`
    FOREIGN KEY (`enrollment_id`)
    REFERENCES `af25nicot1_college_V2`.`enrollment` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_grade_grade_type1`
    FOREIGN KEY (`type`)
    REFERENCES `af25nicot1_college_V2`.`grade_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `af25nicot1_college_V2`.`section_room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `af25nicot1_college_V2`.`section_room` ;

CREATE TABLE IF NOT EXISTS `af25nicot1_college_V2`.`section_room` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `room_id` INT NOT NULL,
  `section_id` INT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_userid` INT NOT NULL,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_userid` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_section_room_room1_idx` (`room_id` ASC) VISIBLE,
  INDEX `fk_section_room_section1_idx` (`section_id` ASC) VISIBLE,
  CONSTRAINT `fk_section_room_room1`
    FOREIGN KEY (`room_id`)
    REFERENCES `af25nicot1_college_V2`.`room` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_section_room_section1`
    FOREIGN KEY (`section_id`)
    REFERENCES `af25nicot1_college_V2`.`section` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Факультет`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Факультет` (
  `id` TINYINT(1) NOT NULL AUTO_INCREMENT,
  `Название` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Кафедра`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Кафедра` (
  `id` TINYINT(1) NOT NULL AUTO_INCREMENT,
  `Название` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Специальность`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Специальность` (
  `id` TINYINT(1) NOT NULL AUTO_INCREMENT,
  `Шифр` VARCHAR(20) NOT NULL,
  `Название` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Профиль`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Профиль` (
  `id` TINYINT(1) NOT NULL AUTO_INCREMENT,
  `Название` VARCHAR(30) NOT NULL,
  `Факультет_id` TINYINT(1) NOT NULL,
  `Специальность_id` TINYINT(1) NOT NULL,
  `Кафедра_id` TINYINT(1) NOT NULL,
  INDEX `fk_Профиль_Факультет_idx` (`Факультет_id` ASC) VISIBLE,
  INDEX `fk_Профиль_Специальность1_idx` (`Специальность_id` ASC) VISIBLE,
  INDEX `fk_Профиль_Кафедра1_idx` (`Кафедра_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Профиль_Факультет`
    FOREIGN KEY (`Факультет_id`)
    REFERENCES `mydb`.`Факультет` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Профиль_Специальность1`
    FOREIGN KEY (`Специальность_id`)
    REFERENCES `mydb`.`Специальность` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Профиль_Кафедра1`
    FOREIGN KEY (`Кафедра_id`)
    REFERENCES `mydb`.`Кафедра` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Учебный_план`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Учебный_план` (
  `Год_поступления` INT NOT NULL AUTO_INCREMENT,
  `Профиль_id` TINYINT(1) NOT NULL,
  PRIMARY KEY (`Год_поступления`, `Профиль_id`),
  INDEX `fk_Учебный_план_Профиль1_idx` (`Профиль_id` ASC) VISIBLE,
  CONSTRAINT `fk_Учебный_план_Профиль1`
    FOREIGN KEY (`Профиль_id`)
    REFERENCES `mydb`.`Профиль` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Тип_занятия`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Тип_занятия` (
  `id` TINYINT(1) NOT NULL AUTO_INCREMENT,
  `Название` VARCHAR(20) NOT NULL,
  `Длительность` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Дисциплина`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Дисциплина` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Название` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`План_дисциплин`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`План_дисциплин` (
  `id` SMALLINT(1) NOT NULL AUTO_INCREMENT,
  `Тип_занятия_id` TINYINT(1) NOT NULL,
  `Дисциплина_id` INT NOT NULL,
  `Учебный_план_Год_поступления` INT NOT NULL,
  `Учебный_план_Профиль_id` TINYINT(1) NOT NULL,
  `Запланированно_часов` SMALLINT(1) NOT NULL,
  `Номер_семестра` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_План_дисциплины_Тип_занятия1_idx` (`Тип_занятия_id` ASC) VISIBLE,
  INDEX `fk_План_дисциплины_Дисциплина1_idx` (`Дисциплина_id` ASC) VISIBLE,
  INDEX `fk_План_дисциплины_Учебный_план1_idx` (`Учебный_план_Год_поступления` ASC, `Учебный_план_Профиль_id` ASC) VISIBLE,
  CONSTRAINT `fk_План_дисциплины_Тип_занятия1`
    FOREIGN KEY (`Тип_занятия_id`)
    REFERENCES `mydb`.`Тип_занятия` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_План_дисциплины_Дисциплина1`
    FOREIGN KEY (`Дисциплина_id`)
    REFERENCES `mydb`.`Дисциплина` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_План_дисциплины_Учебный_план1`
    FOREIGN KEY (`Учебный_план_Год_поступления` , `Учебный_план_Профиль_id`)
    REFERENCES `mydb`.`Учебный_план` (`Год_поступления` , `Профиль_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Студент`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Студент` (
  `Зачетка` INT NOT NULL,
  `Имя` CHAR(20) NOT NULL,
  `Фамилия` CHAR(30) NOT NULL,
  `Отчество` CHAR(30) NULL,
  `Дата_рождения` DATE NOT NULL,
  `Адрес` VARCHAR(100) NULL,
  `Номер_телефона` VARCHAR(11) NULL,
  `Группа_id` SMALLINT(1) NOT NULL,
  `Год_поступления` SMALLINT(1) NOT NULL,
  PRIMARY KEY (`Зачетка`),
  INDEX `fk_Студент_Группа1_idx` (`Группа_id` ASC) VISIBLE,
  CONSTRAINT `fk_Студент_Группа1`
    FOREIGN KEY (`Группа_id`)
    REFERENCES `mydb`.`Группа` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Группа`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Группа` (
  `id` SMALLINT(1) NOT NULL AUTO_INCREMENT,
  `Шифр` VARCHAR(30) NOT NULL,
  `Староста_зачетка` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Группа_Студент1_idx` (`Староста_зачетка` ASC) VISIBLE,
  CONSTRAINT `fk_Группа_Студент1`
    FOREIGN KEY (`Староста_зачетка`)
    REFERENCES `mydb`.`Студент` (`Зачетка`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Преподаватель`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Преподаватель` (
  `id` SMALLINT(1) NOT NULL AUTO_INCREMENT,
  `Имя` CHAR(20) NOT NULL,
  `Фамилия` CHAR(30) NOT NULL,
  `Отчество` CHAR(30) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Занятие`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Занятие` (
  `План_дисциплин_id` SMALLINT(1) NOT NULL,
  `Преподаватель_id` SMALLINT(1) NOT NULL,
  `Дата` DATE NOT NULL,
  `Номер_пары` TINYINT(1) NOT NULL,
  `Группа_id` SMALLINT(1) NOT NULL,
  `Тема` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`План_дисциплин_id`, `Преподаватель_id`, `Дата`, `Номер_пары`, `Группа_id`),
  INDEX `fk_План_занятий_Преподаватель1_idx` (`Преподаватель_id` ASC) VISIBLE,
  INDEX `fk_План_занятий_Группа1_idx` (`Группа_id` ASC) VISIBLE,
  CONSTRAINT `fk_План_занятий_План_дисциплин1`
    FOREIGN KEY (`План_дисциплин_id`)
    REFERENCES `mydb`.`План_дисциплин` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_План_занятий_Преподаватель1`
    FOREIGN KEY (`Преподаватель_id`)
    REFERENCES `mydb`.`Преподаватель` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_План_занятий_Группа1`
    FOREIGN KEY (`Группа_id`)
    REFERENCES `mydb`.`Группа` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Посещаемость`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Посещаемость` (
  `Студент_Зачетка` INT NOT NULL,
  `Занятие_Дата` DATE NOT NULL,
  `Занятие_Номер_пары` TINYINT(1) NOT NULL,
  `Занятие_Группа_id` SMALLINT(1) NOT NULL,
  PRIMARY KEY (`Студент_Зачетка`, `Занятие_Дата`, `Занятие_Номер_пары`, `Занятие_Группа_id`),
  INDEX `fk_Посещаемость_Студент1_idx` (`Студент_Зачетка` ASC) VISIBLE,
  INDEX `fk_Посещаемость_Занятие1_idx` (`Занятие_Дата` ASC, `Занятие_Номер_пары` ASC, `Занятие_Группа_id` ASC) VISIBLE,
  CONSTRAINT `fk_Посещаемость_Студент1`
    FOREIGN KEY (`Студент_Зачетка`)
    REFERENCES `mydb`.`Студент` (`Зачетка`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Посещаемость_Занятие1`
    FOREIGN KEY (`Занятие_Дата` , `Занятие_Номер_пары` , `Занятие_Группа_id`)
    REFERENCES `mydb`.`Занятие` (`Дата` , `Номер_пары` , `Группа_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

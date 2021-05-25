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
-- Table `mydb`.`Way`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Way` (
  `num_way` INT NOT NULL,
  `title_way` VARCHAR(45) NULL,
  PRIMARY KEY (`num_way`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Station`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Station` (
  `num_st` INT NOT NULL,
  `title_st` VARCHAR(45) NULL,
  `distance` SMALLINT(1) NULL,
  PRIMARY KEY (`num_st`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bus` (
  `num_bus` VARCHAR(8) NOT NULL,
  `model` VARCHAR(45) NULL,
  `count_places` TINYINT(1) NULL,
  PRIMARY KEY (`num_bus`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rays`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Rays` (
  `num_bus` VARCHAR(8) NOT NULL,
  `num_way` INT NOT NULL,
  `time_hour` TINYINT(1) NOT NULL,
  `time_min` TINYINT(1) NOT NULL,
  INDEX `fk_Rays_Bus1_idx` (`num_bus` ASC) VISIBLE,
  PRIMARY KEY (`time_hour`, `time_min`, `num_way`),
  CONSTRAINT `fk_Rays_Bus1`
    FOREIGN KEY (`num_bus`)
    REFERENCES `mydb`.`Bus` (`num_bus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rays_Way1`
    FOREIGN KEY (`num_way`)
    REFERENCES `mydb`.`Way` (`num_way`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ticket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ticket` (
  `place` INT NOT NULL,
  `num_st` INT NULL,
  `time_hour` TINYINT(1) NOT NULL,
  `time_min` TINYINT(1) NOT NULL,
  `num_way` INT NOT NULL,
  PRIMARY KEY (`place`, `time_hour`, `time_min`, `num_way`),
  INDEX `fk_Ticket_Station1_idx` (`num_st` ASC) VISIBLE,
  INDEX `fk_Ticket_Rays1_idx` (`time_hour` ASC, `time_min` ASC, `num_way` ASC) VISIBLE,
  CONSTRAINT `fk_Ticket_Station1`
    FOREIGN KEY (`num_st`)
    REFERENCES `mydb`.`Station` (`num_st`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ticket_Rays1`
    FOREIGN KEY (`time_hour` , `time_min` , `num_way`)
    REFERENCES `mydb`.`Rays` (`time_hour` , `time_min` , `num_way`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Station_Way`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Station_Way` (
  `num_st` INT NOT NULL,
  `num_way` INT NOT NULL,
  PRIMARY KEY (`num_st`, `num_way`),
  INDEX `fk_Station_has_Way_Way1_idx` (`num_way` ASC) VISIBLE,
  INDEX `fk_Station_has_Way_Station_idx` (`num_st` ASC) VISIBLE,
  CONSTRAINT `fk_Station_has_Way_Station`
    FOREIGN KEY (`num_st`)
    REFERENCES `mydb`.`Station` (`num_st`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Station_has_Way_Way1`
    FOREIGN KEY (`num_way`)
    REFERENCES `mydb`.`Way` (`num_way`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

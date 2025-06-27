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
-- Table `mydb`.`Team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Team` (
  `Team_ID` INT NOT NULL,
  `Team_name` VARCHAR(100) NULL,
  `Team_stadium` VARCHAR(150) NULL,
  `Team_city` VARCHAR(100) NULL,
  PRIMARY KEY (`Team_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Match`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Match` (
  `Match_ID` INT NOT NULL,
  `Match_Date` DATE NULL,
  `Host_team_ID` INT NULL,
  `Guest_team_ID` INT NULL,
  `Stadium` VARCHAR(150) NULL,
  `Final_result` INT NULL,
  PRIMARY KEY (`Match_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Player_match_participation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Player_match_participation` (
  `idPlayer_match_participation_ID` INT NOT NULL,
  `Match_ID` INT NULL,
  `Goals_scored` INT NULL,
  `Yellow_cards` INT NULL,
  `Red_card` INT NULL,
  PRIMARY KEY (`idPlayer_match_participation_ID`),
  INDEX `Match_ID_idx` (`Match_ID` ASC) VISIBLE,
  CONSTRAINT `Match_ID`
    FOREIGN KEY (`Match_ID`)
    REFERENCES `mydb`.`Match` (`Match_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Players` (
  `Player_ID` INT NOT NULL,
  `Player_Name` VARCHAR(100) NULL,
  `Team_ID` INT NULL,
  `Player_DoB` DATE NULL,
  `PlayerShirt NO` INT NULL,
  `Players start year` DATE NULL,
  PRIMARY KEY (`Player_ID`),
  INDEX `Team/ID_idx` (`Team_ID` ASC) VISIBLE,
  CONSTRAINT `Team/ID`
    FOREIGN KEY (`Team_ID`)
    REFERENCES `mydb`.`Team` (`Team_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Player_id`
    FOREIGN KEY (`Player_ID`)
    REFERENCES `mydb`.`Player_match_participation` (`idPlayer_match_participation_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Referees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Referees` (
  `Referee_ID` INT NOT NULL,
  `Referee_name` VARCHAR(150) NULL,
  `Referee_DOB` DATE NULL,
  `Years of experience` INT NULL,
  PRIMARY KEY (`Referee_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Match_referee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Match_referee` (
  `Match_ID,referee_ID` INT NOT NULL,
  `Match_referee_ID` INT NULL,
  `Role` VARCHAR(45) NULL,
  `Referee_ID` INT NULL,
  `Match_ID` INT NULL,
  PRIMARY KEY (`Match_ID,referee_ID`),
  INDEX `Referee_id_idx` (`Referee_ID` ASC) VISIBLE,
  INDEX `Match_ID_idx` (`Match_ID` ASC) VISIBLE,
  CONSTRAINT `Referee_id`
    FOREIGN KEY (`Referee_ID`)
    REFERENCES `mydb`.`Referees` (`Referee_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Match_ID`
    FOREIGN KEY (`Match_ID`)
    REFERENCES `mydb`.`Match` (`Match_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Substitution`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Substitution` (
  `Substitution_ID` INT NOT NULL,
  `Player_out_ID` INT NULL,
  `Player_in_ID` INT NULL,
  `Substitution_TIME` VARCHAR(45) NULL,
  `Match_ID` INT NULL,
  PRIMARY KEY (`Substitution_ID`),
  INDEX `Match_ID_idx` (`Match_ID` ASC) VISIBLE,
  CONSTRAINT `Match_ID`
    FOREIGN KEY (`Match_ID`)
    REFERENCES `mydb`.`Match` (`Match_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

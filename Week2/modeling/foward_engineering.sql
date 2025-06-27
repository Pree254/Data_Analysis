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
-- Table `mydb`.`Product_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Product_table` (
  `Product_ID` INT NOT NULL,
  `Product_Name` VARCHAR(45) NULL,
  `Product_Quantity` INT NULL,
  PRIMARY KEY (`Product_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Component_Table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Component_Table` (
  `Product_ID` INT NOT NULL,
  `Supplier_name` VARCHAR(45) NULL,
  `Component_ID` INT NULL,
  `Product_name` VARCHAR(45) NULL,
  `Component_desc` VARCHAR(45) NULL,
  PRIMARY KEY (`Product_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Supplier` (
  `Supplier_ID` INT NOT NULL,
  `Supplier_Name` VARCHAR(70) NULL,
  `Supplier_Location` VARCHAR(80) NULL,
  PRIMARY KEY (`Supplier_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Product_Component`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Product_Component` (
  `Product_Component_ID` INT NOT NULL,
  `Product_ID` INT NULL,
  `Component_ID` INT NULL,
  `Quantity` INT NULL,
  PRIMARY KEY (`Product_Component_ID`),
  INDEX `Product_ID_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `Component_ID_idx` (`Component_ID` ASC) VISIBLE,
  CONSTRAINT `Product_ID`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `mydb`.`Product_table` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Component_ID`
    FOREIGN KEY (`Component_ID`)
    REFERENCES `mydb`.`Component_Table` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Component_supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Component_supplier` (
  `Component_supplier_ID` INT NOT NULL,
  `Component_ID` INT NULL,
  `Quantity` INT NULL,
  `Price` INT NULL,
  PRIMARY KEY (`Component_supplier_ID`),
  INDEX `Component_ID_idx` (`Component_ID` ASC) VISIBLE,
  CONSTRAINT `Component_ID`
    FOREIGN KEY (`Component_ID`)
    REFERENCES `mydb`.`Component_Table` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Supplier_ID`
    FOREIGN KEY (`Component_supplier_ID`)
    REFERENCES `mydb`.`Supplier` (`Supplier_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema gestioneTreni2025
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `gestioneTreni2025` ;

CREATE SCHEMA IF NOT EXISTS `gestioneTreni2025` DEFAULT CHARACTER SET utf8 ;
USE `gestioneTreni2025` ;

-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`CompagniaFerroviaria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`CompagniaFerroviaria` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`CompagniaFerroviaria` (
  `idCompagnia` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `nazionalita` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `descrizione` TINYTEXT NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCompagnia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Treno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Treno` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Treno` (
  `idTreno` INT NOT NULL AUTO_INCREMENT,
  `codiceTreno` VARCHAR(45) NOT NULL,
  `posti` INT NOT NULL,
  `modello` VARCHAR(45) NOT NULL,
  `descrizione` TINYTEXT NOT NULL,
  `produttore` VARCHAR(45) NOT NULL,
  `idCompagnia` INT NOT NULL,
  PRIMARY KEY (`idTreno`),
  UNIQUE INDEX `idTreno_UNIQUE` (`idTreno` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  CONSTRAINT `fk_Treno_Compagnia`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `gestioneTreni2025`.`CompagniaFerroviaria` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Stazione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Stazione` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Stazione` (
  `idStazione` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `citta` VARCHAR(45) NOT NULL,
  `regione` VARCHAR(45) NOT NULL,
  `coordinate` GEOMETRY NULL,
  PRIMARY KEY (`idStazione`),
  UNIQUE INDEX `idStazione_UNIQUE` (`idStazione` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Passeggero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Passeggero` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Passeggero` (
  `codiceFiscale` VARCHAR(16) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `dataNascita` DATE NOT NULL,
  `nazionalita` VARCHAR(45) NOT NULL,
  `documentoIdentita` MEDIUMBLOB NULL,
  `sesso` TINYINT NULL COMMENT '0 per maschio, 1 per femmina',
  PRIMARY KEY (`codiceFiscale`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `telefono_UNIQUE` (`telefono` ASC) VISIBLE,
  UNIQUE INDEX `codiceFiscale_UNIQUE` (`codiceFiscale` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Corsa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Corsa` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Corsa` (
  `idCorsa` INT NOT NULL AUTO_INCREMENT,
  `idStazionePartenza` INT NOT NULL,
  `idStazioneArrivo` INT NOT NULL,
  `idTreno` INT NOT NULL,
  `dataOraPartenza` DATETIME NOT NULL,
  `dataOraArrivo` DATETIME NOT NULL,
  `ritardoMinuti` INT NULL DEFAULT 0,
  `cancellata` TINYINT NULL DEFAULT 0,
  PRIMARY KEY (`idCorsa`),
  INDEX `idStazionePartenza_idx` (`idStazionePartenza` ASC) VISIBLE,
  INDEX `idStazioneArrivo_idx` (`idStazioneArrivo` ASC) VISIBLE,
  INDEX `idTreno_idx` (`idTreno` ASC) VISIBLE,
  CONSTRAINT `fk_Corsa_StazionePartenza`
    FOREIGN KEY (`idStazionePartenza`)
    REFERENCES `gestioneTreni2025`.`Stazione` (`idStazione`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Corsa_StazioneArrivo`
    FOREIGN KEY (`idStazioneArrivo`)
    REFERENCES `gestioneTreni2025`.`Stazione` (`idStazione`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Corsa_Treno`
    FOREIGN KEY (`idTreno`)
    REFERENCES `gestioneTreni2025`.`Treno` (`idTreno`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Biglietto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Biglietto` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Biglietto` (
  `idBiglietto` INT NOT NULL AUTO_INCREMENT,
  `check_in` TINYINT NOT NULL DEFAULT 0,
  `prezzo` DECIMAL(10,2) NOT NULL,
  `classe` VARCHAR(25) NOT NULL,
  `numeroCarrozza` INT NOT NULL,
  `posto` VARCHAR(4) NOT NULL,
  `dataAcquisto` DATETIME NOT NULL,
  `assicurazione` TINYINT NULL DEFAULT 0,
  `codiceFiscalePasseggero` VARCHAR(16) NOT NULL,
  `idCorsa` INT NOT NULL,
  PRIMARY KEY (`idBiglietto`),
  UNIQUE INDEX `idBiglietto_UNIQUE` (`idBiglietto` ASC) VISIBLE,
  INDEX `idCorsa_idx` (`idCorsa` ASC) VISIBLE,
  INDEX `codiceFiscalePasseggero_idx` (`codiceFiscalePasseggero` ASC) VISIBLE,
  CONSTRAINT `fk_Biglietto_Passeggero`
    FOREIGN KEY (`codiceFiscalePasseggero`)
    REFERENCES `gestioneTreni2025`.`Passeggero` (`codiceFiscale`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Biglietto_Corsa`
    FOREIGN KEY (`idCorsa`)
    REFERENCES `gestioneTreni2025`.`Corsa` (`idCorsa`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Ruolo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Ruolo` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Ruolo` (
  `nomeRuolo` VARCHAR(45) NOT NULL,
  `descrizione` VARCHAR(100) NOT NULL,
  `ral` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`nomeRuolo`),
  UNIQUE INDEX `nomeRuolo_UNIQUE` (`nomeRuolo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Personale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Personale` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Personale` (
  `codiceFiscale` VARCHAR(16) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `dataNascita` DATE NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `sesso` TINYINT NULL,
  `idCompagnia` INT NOT NULL,
  `nomeRuolo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codiceFiscale`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `telefono_UNIQUE` (`telefono` ASC) VISIBLE,
  INDEX `idCompagnia_idx` (`idCompagnia` ASC) VISIBLE,
  INDEX `nomeRuolo_idx` (`nomeRuolo` ASC) VISIBLE,
  CONSTRAINT `fk_Personale_Compagnia`
    FOREIGN KEY (`idCompagnia`)
    REFERENCES `gestioneTreni2025`.`CompagniaFerroviaria` (`idCompagnia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Personale_Ruolo`
    FOREIGN KEY (`nomeRuolo`)
    REFERENCES `gestioneTreni2025`.`Ruolo` (`nomeRuolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `gestioneTreni2025`.`Turno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gestioneTreni2025`.`Turno` ;

CREATE TABLE IF NOT EXISTS `gestioneTreni2025`.`Turno` (
  `codiceFiscalePersonale` VARCHAR(16) NOT NULL,
  `idTreno` INT NOT NULL,
  `inizioTurno` DATETIME NOT NULL,
  `fineTurno` DATETIME NOT NULL,
  PRIMARY KEY (`codiceFiscalePersonale`, `idTreno`, `inizioTurno`),
  INDEX `idTreno_idx` (`idTreno` ASC) VISIBLE,
  CONSTRAINT `fk_Turno_Treno`
    FOREIGN KEY (`idTreno`)
    REFERENCES `gestioneTreni2025`.`Treno` (`idTreno`),
  CONSTRAINT `fk_Turno_Personale`
    FOREIGN KEY (`codiceFiscalePersonale`)
    REFERENCES `gestioneTreni2025`.`Personale` (`codiceFiscale`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
DROP SCHEMA IF EXISTS `school_db` ;

CREATE SCHEMA IF NOT EXISTS `school_db` DEFAULT CHARACTER SET utf8 ;
USE `school_db` ;

CREATE TABLE IF NOT EXISTS `community` (  `community_area_number` TINYINT NOT NULL AUTO_INCREMENT,
  `community_area_name` VARCHAR(45) NULL,
  PRIMARY KEY (`community_area_number`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `geographic_area` (
  `geographic_area_number` TINYINT NOT NULL AUTO_INCREMENT,
  `geographic_area_name` VARCHAR(45) NULL,
  PRIMARY KEY (`geographic_area_number`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `address` (
  `cps_unit` SMALLINT NOT NULL,
  `street_number` SMALLINT NULL,
  `street_direction` CHAR(1) NULL,
  `street_name` VARCHAR(45) NULL,
  `city` VARCHAR(15) NOT NULL,
  `state` VARCHAR(15) NOT NULL,
  `zip` INT NULL,
  `ward` TINYINT NOT NULL,
  `community_area_number` TINYINT NOT NULL,
  `geographic_area_number` TINYINT NOT NULL,
  `il_senat_district` TINYINT NOT NULL,
  `il_rep_district` TINYINT NOT NULL,
  `us_congressional_district` TINYINT NOT NULL,
  `cook_county_district` TINYINT NULL,
  `census_block` BIGINT NULL,
  `latitude` FLOAT NULL,
  `longtitude` FLOAT NULL,
  PRIMARY KEY (`cps_unit`),
  CONSTRAINT `fk_address_community1`
    FOREIGN KEY (`community_area_number`)
    REFERENCES `community` (`community_area_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_address_geographic_area1`
    FOREIGN KEY (`geographic_area_number`)
    REFERENCES `geographic_area` (`geographic_area_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `governance` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(15) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `school_category` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(10) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `charter_type` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `school_type` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `school_type_name` VARCHAR(20) NULL,
  `subtype1` VARCHAR(20) NULL,
  `s_type_name` VARCHAR(20) NULL,
  `subtype2` VARCHAR(20) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `schools` (
  `cps_unit` SMALLINT NOT NULL,
  `school_id` INT NULL,
  `school_name` VARCHAR(80) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `ISBE_name` VARCHAR(60) NULL,
  `ISBE_id` VARCHAR(25) NULL,
  `oracle_id` MEDIUMINT NULL,
  `class` TINYINT(1) NULL,
  `school_category_id` TINYINT NOT NULL,
  `governance_id` TINYINT NOT NULL,
  `charter_type_id` TINYINT NULL,
  `school_type_id` TINYINT NOT NULL,
  PRIMARY KEY (`cps_unit`),
  CONSTRAINT `fk_schools_address`
    FOREIGN KEY (`cps_unit`)
    REFERENCES `address` (`cps_unit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_schools_governance1`
    FOREIGN KEY (`governance_id`)
    REFERENCES `governance` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_schools_school_category1`
    FOREIGN KEY (`school_category_id`)
    REFERENCES `school_category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_schools_charter_type1`
    FOREIGN KEY (`charter_type_id`)
    REFERENCES `charter_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_schools_school_type1`
    FOREIGN KEY (`school_type_id`)
    REFERENCES `school_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `program_types` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `school_program_type` (
  `cps_unit` SMALLINT NOT NULL,
  `program_types_id` TINYINT NOT NULL,
  PRIMARY KEY (`cps_unit`, `program_types_id`),
  CONSTRAINT `fk_school_program_type_schools1`
    FOREIGN KEY (`cps_unit`)
    REFERENCES `schools` (`cps_unit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_school_program_type_program_types1`
    FOREIGN KEY (`program_types_id`)
    REFERENCES `program_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `grades` (
  `cps_unit` SMALLINT NOT NULL,
  `from` CHAR(4) NOT NULL,
  `upto` CHAR(4) NULL,
  `grade_type` CHAR(1) NULL,
  PRIMARY KEY (`cps_unit`, `from`),
  CONSTRAINT `fk_grades_schools1`
    FOREIGN KEY (`cps_unit`)
    REFERENCES `schools` (`cps_unit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `NCES` (
  `cps_unit` SMALLINT NOT NULL,
  `school_identifier` MEDIUMINT NULL,
  `school_state_identifier` TINYINT NULL,
  `school_district_identifier` MEDIUMINT NULL,
  PRIMARY KEY (`cps_unit`),
  CONSTRAINT `fk_NCES_schools1`
    FOREIGN KEY (`cps_unit`)
    REFERENCES `schools` (`cps_unit`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Data for table `community`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `community` (`community_area_number`, `community_area_name`) VALUES (1, 'Rogers Park');
COMMIT;


-- -----------------------------------------------------
-- Data for table `geographic_area`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `geographic_area` (`geographic_area_number`, `geographic_area_name`) VALUES (1, 'Loop');
COMMIT;


-- -----------------------------------------------------
-- Data for table `address`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `address` (`cps_unit`, `street_number`, `street_direction`, `street_name`, `city`, `state`, `zip`, `ward`, `community_area_number`, `geographic_area_number`, `il_senat_district`, `il_rep_district`, `us_congressional_district`, `cook_county_district`, `census_block`, `latitude`, `longtitude`) VALUES (1010, 2100, 'E', '87th St', 'Chicago', 'IL', 60617, 8, 45, 12, 17, 33, 2, 4, 170314503003005, 41.84596533, -87.68554722);
COMMIT;


-- -----------------------------------------------------
-- Data for table `governance`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `governance` (`id`, `name`) VALUES (1, 'Charter');
INSERT INTO `governance` (`id`, `name`) VALUES (2, 'District');
INSERT INTO `governance` (`id`, `name`) VALUES (3, 'Contract');

COMMIT;


-- -----------------------------------------------------
-- Data for table `school_category`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `school_category` (`id`, `name`) VALUES (1, 'ES');
INSERT INTO `school_category` (`id`, `name`) VALUES (2, 'MS');
INSERT INTO `school_category` (`id`, `name`) VALUES (3, 'HS');

COMMIT;


-- -----------------------------------------------------
-- Data for table `charter_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `charter_type` (`id`, `name`) VALUES (1, 'Original Replicating Charters');
INSERT INTO `charter_type` (`id`, `name`) VALUES (2, 'Non-replicating  Charters Multi-charter');
INSERT INTO `charter_type` (`id`, `name`) VALUES (3, 'Non-replicating Charters');
INSERT INTO `charter_type` (`id`, `name`) VALUES (4, 'Replicating Alternative Charter');

COMMIT;


-- -----------------------------------------------------
-- Data for table `school_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `school_type` (`id`, `school_type_name`, `subtype1`, `s_type_name`, `subtype2`) VALUES (1, 'Regular', NULL, 'District', 'non-alternative');
COMMIT;


-- -----------------------------------------------------
-- Data for table `schools`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `schools` (`cps_unit`, `school_id`, `school_name`, `full_name`, `ISBE_name`, `ISBE_id`, `oracle_id`, `class`, `school_category_id`, `governance_id`, `charter_type_id`, `school_type_id`) VALUES (1010, 609674, 'Chicago Vocational HS', 'Chicago Vocational Career Academy High School', 'Chicago Vocational Career Acad HS', '150162990250526', 53011, 0, 3, 2, NULL, 1);
COMMIT;


-- -----------------------------------------------------
-- Data for table `program_types`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `program_types` (`id`, `name`) VALUES (1, 'NA');
INSERT INTO `program_types` (`id`, `name`) VALUES (2, 'Military');
COMMIT;


-- -----------------------------------------------------
-- Data for table `school_program_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `school_program_type` (`cps_unit`, `program_types_id`) VALUES (1010, 7);
COMMIT;


-- -----------------------------------------------------
-- Data for table `grades`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `grades` (`cps_unit`, `from`, `upto`, `grade_type`) VALUES (1010, '9th', '12th', 'A');
INSERT INTO `grades` (`cps_unit`, `from`, `upto`, `grade_type`) VALUES (1010, 'HS', 'HS', 'G');
COMMIT;


-- -----------------------------------------------------
-- Data for table `NCES`
-- -----------------------------------------------------
START TRANSACTION;
USE `school_db`;
INSERT INTO `NCES` (`cps_unit`, `school_identifier`, `school_state_identifier`, `school_district_identifier`) VALUES (1010, 943, 17, 9930);
COMMIT;
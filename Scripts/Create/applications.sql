-- --------------------------------------------------------
-- Host:                         
-- Server version:               5.6.21-log - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             8.3.0.4694
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for app_smalltest_20141110
CREATE DATABASE IF NOT EXISTS `app_smalltest_20141110` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `app_smalltest_20141110`;


-- Dumping structure for table app_smalltest_20141110.application
CREATE TABLE IF NOT EXISTS `application` (
  `id` varchar(36) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `number` varchar(64) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `abstract` text,
  `title` text,
  `granted` tinyint(1) DEFAULT NULL,
  `num_claims` int(11) DEFAULT NULL,
  `filename` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pat_idx1` (`type`,`number`),
  KEY `pat_idx2` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.application_assignee
CREATE TABLE IF NOT EXISTS `application_assignee` (
  `application_id` varchar(20) DEFAULT NULL,
  `assignee_id` varchar(36) DEFAULT NULL,
  KEY `application_id` (`application_id`),
  KEY `assignee_id` (`assignee_id`),
  CONSTRAINT `application_assignee_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`),
  CONSTRAINT `application_assignee_ibfk_2` FOREIGN KEY (`assignee_id`) REFERENCES `assignee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.application_inventor
CREATE TABLE IF NOT EXISTS `application_inventor` (
  `application_id` varchar(20) DEFAULT NULL,
  `inventor_id` varchar(36) DEFAULT NULL,
  KEY `application_id` (`application_id`),
  KEY `inventor_id` (`inventor_id`),
  CONSTRAINT `application_inventor_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`),
  CONSTRAINT `application_inventor_ibfk_2` FOREIGN KEY (`inventor_id`) REFERENCES `inventor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.assignee
CREATE TABLE IF NOT EXISTS `assignee` (
  `id` varchar(36) NOT NULL,
  `type` varchar(10) DEFAULT NULL,
  `name_first` varchar(64) DEFAULT NULL,
  `name_last` varchar(64) DEFAULT NULL,
  `organization` varchar(256) DEFAULT NULL,
  `residence` varchar(10) DEFAULT NULL,
  `nationality` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.claim
CREATE TABLE IF NOT EXISTS `claim` (
  `uuid` varchar(36) NOT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  `text` text,
  `dependent` int(11) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `application_id` (`application_id`),
  KEY `ix_claim_sequence` (`sequence`),
  CONSTRAINT `claim_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.inventor
CREATE TABLE IF NOT EXISTS `inventor` (
  `id` varchar(36) NOT NULL,
  `name_first` varchar(64) DEFAULT NULL,
  `name_last` varchar(64) DEFAULT NULL,
  `nationality` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.location
CREATE TABLE IF NOT EXISTS `location` (
  `id` varchar(128) NOT NULL,
  `city` varchar(128) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `country` varchar(10) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dloc_idx2` (`city`,`state`,`country`),
  KEY `ix_location_country` (`country`),
  KEY `dloc_idx1` (`latitude`,`longitude`),
  KEY `ix_location_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.location_assignee
CREATE TABLE IF NOT EXISTS `location_assignee` (
  `location_id` varchar(128) DEFAULT NULL,
  `assignee_id` varchar(36) DEFAULT NULL,
  KEY `location_id` (`location_id`),
  KEY `assignee_id` (`assignee_id`),
  CONSTRAINT `location_assignee_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `location_assignee_ibfk_2` FOREIGN KEY (`assignee_id`) REFERENCES `assignee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.location_inventor
CREATE TABLE IF NOT EXISTS `location_inventor` (
  `location_id` varchar(128) DEFAULT NULL,
  `inventor_id` varchar(36) DEFAULT NULL,
  KEY `location_id` (`location_id`),
  KEY `inventor_id` (`inventor_id`),
  CONSTRAINT `location_inventor_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `location_inventor_ibfk_2` FOREIGN KEY (`inventor_id`) REFERENCES `inventor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.mainclass
CREATE TABLE IF NOT EXISTS `mainclass` (
  `id` varchar(20) NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `text` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.mainclass_current
CREATE TABLE IF NOT EXISTS `mainclass_current` (
  `id` varchar(20) NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `text` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.rawassignee
CREATE TABLE IF NOT EXISTS `rawassignee` (
  `uuid` varchar(36) NOT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  `assignee_id` varchar(36) DEFAULT NULL,
  `rawlocation_id` varchar(128) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `name_first` varchar(64) DEFAULT NULL,
  `name_last` varchar(64) DEFAULT NULL,
  `organization` varchar(256) DEFAULT NULL,
  `residence` varchar(10) DEFAULT NULL,
  `nationality` varchar(10) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `application_id` (`application_id`),
  KEY `assignee_id` (`assignee_id`),
  KEY `rawlocation_id` (`rawlocation_id`),
  KEY `ix_rawassignee_sequence` (`sequence`),
  CONSTRAINT `rawassignee_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`),
  CONSTRAINT `rawassignee_ibfk_2` FOREIGN KEY (`assignee_id`) REFERENCES `assignee` (`id`),
  CONSTRAINT `rawassignee_ibfk_3` FOREIGN KEY (`rawlocation_id`) REFERENCES `rawlocation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.rawinventor
CREATE TABLE IF NOT EXISTS `rawinventor` (
  `uuid` varchar(36) NOT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  `inventor_id` varchar(36) DEFAULT NULL,
  `rawlocation_id` varchar(128) DEFAULT NULL,
  `name_first` varchar(64) DEFAULT NULL,
  `name_last` varchar(64) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `application_id` (`application_id`),
  KEY `inventor_id` (`inventor_id`),
  KEY `rawlocation_id` (`rawlocation_id`),
  KEY `ix_rawinventor_sequence` (`sequence`),
  CONSTRAINT `rawinventor_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`),
  CONSTRAINT `rawinventor_ibfk_2` FOREIGN KEY (`inventor_id`) REFERENCES `inventor` (`id`),
  CONSTRAINT `rawinventor_ibfk_3` FOREIGN KEY (`rawlocation_id`) REFERENCES `rawlocation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.rawlocation
CREATE TABLE IF NOT EXISTS `rawlocation` (
  `id` varchar(128) NOT NULL,
  `location_id` varchar(128) DEFAULT NULL,
  `city` varchar(128) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `country` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `location_id` (`location_id`),
  KEY `loc_idx1` (`city`,`state`,`country`),
  KEY `ix_rawlocation_state` (`state`),
  KEY `ix_rawlocation_country` (`country`),
  CONSTRAINT `rawlocation_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.subclass
CREATE TABLE IF NOT EXISTS `subclass` (
  `id` varchar(20) NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `text` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.subclass_current
CREATE TABLE IF NOT EXISTS `subclass_current` (
  `id` varchar(20) NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `text` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.temporary_update
CREATE TABLE IF NOT EXISTS `temporary_update` (
  `pk` varchar(36) NOT NULL,
  `update` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  KEY `ix_temporary_update_update` (`update`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.uspc
CREATE TABLE IF NOT EXISTS `uspc` (
  `uuid` varchar(36) NOT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  `mainclass_id` varchar(20) DEFAULT NULL,
  `subclass_id` varchar(20) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `application_id` (`application_id`),
  KEY `mainclass_id` (`mainclass_id`),
  KEY `subclass_id` (`subclass_id`),
  KEY `ix_uspc_sequence` (`sequence`),
  CONSTRAINT `uspc_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`),
  CONSTRAINT `uspc_ibfk_2` FOREIGN KEY (`mainclass_id`) REFERENCES `mainclass` (`id`),
  CONSTRAINT `uspc_ibfk_3` FOREIGN KEY (`subclass_id`) REFERENCES `subclass` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table app_smalltest_20141110.uspc_current
CREATE TABLE IF NOT EXISTS `uspc_current` (
  `uuid` varchar(36) NOT NULL,
  `application_id` varchar(20) DEFAULT NULL,
  `mainclass_id` varchar(20) DEFAULT NULL,
  `subclass_id` varchar(20) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `application_id` (`application_id`),
  KEY `mainclass_id` (`mainclass_id`),
  KEY `subclass_id` (`subclass_id`),
  KEY `ix_uspc_current_sequence` (`sequence`),
  CONSTRAINT `uspc_current_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`),
  CONSTRAINT `uspc_current_ibfk_2` FOREIGN KEY (`mainclass_id`) REFERENCES `mainclass_current` (`id`),
  CONSTRAINT `uspc_current_ibfk_3` FOREIGN KEY (`subclass_id`) REFERENCES `subclass_current` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

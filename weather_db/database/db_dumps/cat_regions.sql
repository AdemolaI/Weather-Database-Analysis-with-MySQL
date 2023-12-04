CREATE DATABASE IF NOT EXISTS `weather_db`; 
USE weather_db; 

 -- MySQL dump 10.18  Distrib 10.3.27-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 10.1.10.23    Database: weather_db
-- ------------------------------------------------------
-- Server version	10.1.37-MariaDB-0+deb9u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cat_regions`
--

DROP TABLE IF EXISTS `cat_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_regions` (
  `RegionID` int(11) NOT NULL,
  `RegionCode` varchar(45) DEFAULT NULL,
  `Region` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`RegionID`)
) ENGINE=Aria DEFAULT CHARSET=utf8 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_regions`
--
-- WHERE:  1 limit 10000

LOCK TABLES `cat_regions` WRITE;
/*!40000 ALTER TABLE `cat_regions` DISABLE KEYS */;
INSERT INTO `cat_regions` VALUES (500,'os','Orkney & Shetland'),(501,'he','Highland & Eilean Siar'),(502,'gr','Grampian'),(503,'st','Tayside, Central & Fife'),(504,'ta','Strathclyde'),(505,'dg','Dumfries, Galloway, Lothian & Border'),(506,'ni','Northern Ireland'),(507,'nw','Northeast England'),(508,'ne','Northwest England'),(509,'yh','Yorkshire & the Humber'),(510,'wm','West Midlands'),(511,'em','East Midlands'),(512,'ee','East of England'),(513,'sw','SouthWest Englad'),(514,'se','London & Southeast England'),(515,'uk','UK'),(516,'wl','Wales');
/*!40000 ALTER TABLE `cat_regions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-27 16:20:04

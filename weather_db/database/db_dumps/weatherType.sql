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
-- Table structure for table `weatherType`
--

DROP TABLE IF EXISTS `weatherType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weatherType` (
  `weatherTypeID` varchar(5) DEFAULT NULL,
  `weatherType` varchar(45) DEFAULT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`)
) ENGINE=Aria AUTO_INCREMENT=34 DEFAULT CHARSET=latin1 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weatherType`
--
-- WHERE:  1 limit 10000

LOCK TABLES `weatherType` WRITE;
/*!40000 ALTER TABLE `weatherType` DISABLE KEYS */;
INSERT INTO `weatherType` VALUES ('0','Clear night',1),('1','Sunny day',2),('2','Partly cloudy (night)',3),('3','Partly cloudy (day)',4),('4','Not used',5),('5','Mist',6),('6','Fog',7),('7','Cloudy',8),('8','Overcast',9),('9','Light rain shower (night)',10),('10','Light rain shower (day)',11),('11','Drizzle',12),('12','Light rain',13),('13','Heavy rain shower (night)',14),('14','Heavy rain shower (day)',15),('15','Heavy rain',16),('16','Sleet shower (night)',17),('17','Sleet shower (day)',18),('18','Sleet',19),('19','Hail shower (night)',20),('20','Hail shower (day)',21),('21','Hail',22),('22','Light snow shower (night)',23),('23','Light snow shower (day)',24),('24','Light snow',25),('25','Heavy snow shower (night)',26),('26','Heavy snow shower (day)',27),('27','Heavy snow',28),('28','Thunder shower (night)',29),('29','Thunder shower (day)',30),('30','Thunder',31),('NA','Not available',32),('NUL','NotAvailable',33);
/*!40000 ALTER TABLE `weatherType` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-27 16:20:24

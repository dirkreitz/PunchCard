-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 24. Feb 2020 um 16:39
-- Server-Version: 10.4.11-MariaDB
-- PHP-Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `punchclock`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `devicetable`
--

CREATE TABLE `devicetable` (
  `ID` int(16) NOT NULL,
  `device` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `devicetable`
--

INSERT INTO `devicetable` (`ID`, `device`) VALUES
(1, 'grfskdfsk'),
(4, 'h9inaaa'),
(5, 'h9inaaasta'),
(6, 'h9inaaastast'),
(7, 'h9inaaastasta'),
(8, 'h9inaaastastas'),
(3, 'h9inmo');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `timetable`
--

CREATE TABLE `timetable` (
  `ID` int(16) NOT NULL,
  `name` varchar(128) NOT NULL,
  `deviceID` int(16) NOT NULL,
  `checkin_type` int(4) NOT NULL,
  `UNIX_TIMESTAMP` timestamp NOT NULL DEFAULT current_timestamp(),
  `punch_method` varchar(32) NOT NULL,
  `confirmed` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `timetable`
--

INSERT INTO `timetable` (`ID`, `name`, `deviceID`, `checkin_type`, `UNIX_TIMESTAMP`, `punch_method`, `confirmed`) VALUES
(1, 'Hans', 1, 0, '2020-02-04 09:42:26', '', 0),
(2, 'Hans', 1, 1, '2020-02-04 09:45:32', '', 0),
(3, 'Hans', 1, 0, '2020-02-10 10:51:01', '', 0),
(4, 'Yanissaria', 8, 0, '2020-02-10 15:18:44', '', 0),
(5, 'Yanissaria', 8, 1, '2020-02-10 15:19:02', '', 0),
(6, 'Yanissaria', 8, 0, '2020-02-11 10:01:28', '', 0),
(7, 'Yanissaria', 8, 1, '2020-02-11 10:06:24', '', 0),
(8, 'Yanissaria', 8, 0, '2020-02-11 10:07:23', '', 0),
(9, 'Yanissaria', 8, 1, '2020-02-11 10:08:11', '', 0),
(10, 'Yanissaria', 8, 0, '2020-02-11 10:11:45', '', 0),
(11, 'Yanissaria', 8, 1, '2020-02-11 10:13:08', '', 0),
(12, 'Yanissaria', 8, 0, '2020-02-11 10:17:18', '', 0),
(13, 'Yanissaria', 8, 1, '2020-02-11 10:17:21', '', 0),
(14, 'Yanissaria', 8, 0, '2020-02-11 10:17:22', '', 0),
(15, 'Yanissaria', 8, 1, '2020-02-11 10:17:23', '', 0),
(16, 'Yanissaria', 8, 0, '2020-02-12 14:54:02', '', 0),
(17, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(18, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(19, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(20, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(21, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(22, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(23, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(24, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(25, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(26, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(27, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(28, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(29, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(30, 'Yanissaria', 8, 1, '0000-00-00 00:00:00', '', 0),
(31, 'Yanissaria', 8, 1, '2020-02-13 09:19:55', '', 0),
(32, 'Yanissaria', 8, 0, '2020-02-13 09:21:28', '', 0),
(33, 'Yanissaria', 8, 1, '2020-02-13 09:26:09', '', 0),
(34, 'Yanissaria', 8, 0, '2020-02-13 09:29:54', '', 0),
(35, 'Yanissaria', 8, 1, '2020-02-13 09:31:20', '', 0),
(36, 'Yanissaria', 8, 0, '2020-02-13 09:35:28', '', 0),
(37, 'Yanissaria', 8, 1, '2020-02-13 09:38:19', '', 0),
(38, 'Yanissaria', 8, 0, '2020-02-13 09:40:17', '', 0),
(39, 'Yanissaria', 8, 1, '2020-02-13 09:43:55', '', 0),
(40, 'Yanissaria', 8, 0, '2020-02-13 06:47:27', '', 0),
(41, 'Yanissaria', 8, 0, '2020-02-13 10:01:05', '', 0),
(42, 'Yanissaria', 8, 1, '2020-02-17 10:12:14', 'Regular', 0),
(43, 'Yanissaria', 8, 0, '2020-02-17 10:12:16', 'Regular', 0),
(44, 'Yanissaria', 8, 1, '2020-02-17 09:32:26', 'Manual', 0),
(45, 'Yanissaria', 8, 1, '2020-02-17 09:32:28', 'Manual', 0);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `devicetable`
--
ALTER TABLE `devicetable`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `device` (`device`);

--
-- Indizes für die Tabelle `timetable`
--
ALTER TABLE `timetable`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `appID` (`deviceID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `devicetable`
--
ALTER TABLE `devicetable`
  MODIFY `ID` int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT für Tabelle `timetable`
--
ALTER TABLE `timetable`
  MODIFY `ID` int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `timetable`
--
ALTER TABLE `timetable`
  ADD CONSTRAINT `fk_appID` FOREIGN KEY (`deviceID`) REFERENCES `devicetable` (`ID`),
  ADD CONSTRAINT `fk_name` FOREIGN KEY (`deviceID`) REFERENCES `devicetable` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

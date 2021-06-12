-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2021 at 09:46 PM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vodafone`
--

-- --------------------------------------------------------

--
-- Table structure for table `adqueue`
--

CREATE TABLE `adqueue` (
  `id` mediumint(9) NOT NULL,
  `adId` bigint(11) NOT NULL,
  `clientId` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `adqueue`
--

INSERT INTO `adqueue` (`id`, `adId`, `clientId`) VALUES
(39, 7, 56),
(40, 12, 59);

-- --------------------------------------------------------

--
-- Table structure for table `ads`
--

CREATE TABLE `ads` (
  `id` bigint(20) NOT NULL,
  `adTitle` varchar(255) NOT NULL,
  `adContent` varchar(255) NOT NULL,
  `adFromDate` datetime NOT NULL,
  `adToDate` datetime NOT NULL,
  `itemid` int(11) NOT NULL,
  `class` varchar(10) NOT NULL,
  `imageName` varchar(255) NOT NULL DEFAULT 'DefaultItemImage.jpg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ads`
--

INSERT INTO `ads` (`id`, `adTitle`, `adContent`, `adFromDate`, `adToDate`, `itemid`, `class`, `imageName`) VALUES
(7, 'Sale 15%', 'Enjoy our 15% discount on Iphone 7 from 10000 to 8500', '2021-04-20 00:00:00', '2021-04-21 00:00:00', 2, 'Gold', 'download.jpg'),
(12, 'Iphone 11 with best price', 'Enjoy Iphone 11 with special price 15000', '2021-04-20 00:00:00', '2021-04-21 00:00:00', 5, 'Platinum', 'iphone11.jpg'),
(13, 'lenovo laptop', 'discount on lenovo lap top', '2021-04-20 00:00:00', '2021-04-21 00:00:00', 4, 'Platinum', 'lenovo.jpg'),
(14, 'OPPO F11 mobile', 'Buy the whole new Oppo F11 mobile for only 7500 ', '2021-04-20 00:00:00', '2021-04-21 00:00:00', 6, 'Silver', 'oppo11.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` bigint(20) NOT NULL,
  `itemid` int(20) NOT NULL,
  `orderid` bigint(20) NOT NULL,
  `count` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `itemid`, `orderid`, `count`) VALUES
(2, 2, 3, 1),
(3, 7, 4, 1),
(4, 7, 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `mobileNumber` varchar(20) NOT NULL,
  `billingAccount` varchar(255) NOT NULL,
  `nationalId` varchar(255) NOT NULL,
  `lastLogInTime` datetime DEFAULT NULL,
  `class` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`id`, `name`, `mobileNumber`, `billingAccount`, `nationalId`, `lastLogInTime`, `class`) VALUES
(56, 'Ziad Khaled', '01176523445', '', '01018081875', '2021-06-10 21:16:09', 'Gold'),
(59, 'Zeiad Hossam', '01022555978', '01293802198', '139274823792', '2021-06-10 21:16:21', 'Platinum'),
(62, 'ziad diab', '01192883746', '01293802198', '139274823792', NULL, 'Gold');

-- --------------------------------------------------------

--
-- Table structure for table `client_images`
--

CREATE TABLE `client_images` (
  `id` bigint(20) NOT NULL,
  `imagePath` varchar(255) NOT NULL,
  `clientId` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `itemTypeid` smallint(6) NOT NULL,
  `price` double NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `itemTypeid`, `price`, `name`) VALUES
(2, 3, 5000, 'iphone7'),
(4, 4, 7000, 'lenovo'),
(5, 3, 15000, 'Iphone 11'),
(6, 3, 8000, 'Oppo F11'),
(7, 5, 1000, 'mouse'),
(8, 5, 7000, 'cup'),
(9, 5, 10000, 'bottle');

-- --------------------------------------------------------

--
-- Table structure for table `item_type`
--

CREATE TABLE `item_type` (
  `id` smallint(6) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item_type`
--

INSERT INTO `item_type` (`id`, `type`) VALUES
(3, 'Mobiles'),
(4, 'Laptops'),
(5, 'Extras');

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE `message` (
  `id` bigint(20) NOT NULL,
  `messageContent` varchar(255) NOT NULL,
  `messageTitle` varchar(255) NOT NULL,
  `messageType` varchar(255) NOT NULL,
  `clientId` bigint(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` bigint(20) NOT NULL,
  `notificationTitle` varchar(255) NOT NULL,
  `notificationContent` varchar(255) NOT NULL,
  `notificationType` varchar(255) NOT NULL,
  `staffId` int(11) NOT NULL,
  `clientId` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL,
  `totalPrice` double NOT NULL,
  `date` datetime NOT NULL,
  `paymentid` tinyint(4) NOT NULL,
  `clientid` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `totalPrice`, `date`, `paymentid`, `clientid`) VALUES
(3, 5000, '2021-06-10 15:00:00', 0, 59),
(4, 1000, '2021-06-10 20:50:54', 0, 59),
(5, 1000, '2021-06-10 21:00:03', 0, 59);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id` tinyint(4) NOT NULL,
  `name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`id`, `name`) VALUES
(0, 'not specified');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT 0,
  `username` varchar(255) NOT NULL,
  `password` varchar(300) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `name`, `isAdmin`, `username`, `password`, `email`) VALUES
(2, 'hossam', 1, 'admin2', '21232f297a57a5a743894a0e4a801fc3', 'hossam@gmail.com'),
(3, 'Zeiadddd', 0, 'Aboelzoz99', '21232f297a57a5a743894a0e4a801fc3', 'zeiadzikry@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adqueue`
--
ALTER TABLE `adqueue`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clientId` (`clientId`);

--
-- Indexes for table `ads`
--
ALTER TABLE `ads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `itemid` (`itemid`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `itemid` (`itemid`),
  ADD KEY `orderid` (`orderid`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `client_images`
--
ALTER TABLE `client_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clientId` (`clientId`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `itemTypeid` (`itemTypeid`);

--
-- Indexes for table `item_type`
--
ALTER TABLE `item_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clientId` (`clientId`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `staffId` (`staffId`),
  ADD KEY `clientId` (`clientId`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clientid` (`clientid`),
  ADD KEY `paymentid` (`paymentid`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adqueue`
--
ALTER TABLE `adqueue`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `ads`
--
ALTER TABLE `ads`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `client_images`
--
ALTER TABLE `client_images`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `item_type`
--
ALTER TABLE `item_type`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `adqueue`
--
ALTER TABLE `adqueue`
  ADD CONSTRAINT `adqueue_ibfk_1` FOREIGN KEY (`clientId`) REFERENCES `client` (`id`);

--
-- Constraints for table `ads`
--
ALTER TABLE `ads`
  ADD CONSTRAINT `ads_ibfk_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`id`);

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`itemid`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`orderid`) REFERENCES `orders` (`id`);

--
-- Constraints for table `client_images`
--
ALTER TABLE `client_images`
  ADD CONSTRAINT `client_images_ibfk_1` FOREIGN KEY (`clientId`) REFERENCES `client` (`id`);

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`itemTypeid`) REFERENCES `item_type` (`id`);

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`clientId`) REFERENCES `client` (`id`);

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`staffId`) REFERENCES `staff` (`id`),
  ADD CONSTRAINT `notification_ibfk_2` FOREIGN KEY (`clientId`) REFERENCES `client` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`clientid`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`paymentid`) REFERENCES `payment` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

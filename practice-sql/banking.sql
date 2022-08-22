--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;

CREATE TABLE `customers` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `full_name` varchar(255) NOT NULL COLLATE utf8mb4_unicode_ci,
    `email` varchar(50) NOT NULL UNIQUE COLLATE utf8mb4_unicode_ci,
    `phone` varchar(255) DEFAULT NULL COLLATE utf8mb4_unicode_ci,
    `address` varchar(255) DEFAULT NULL COLLATE utf8mb4_unicode_ci,
    `balance` decimal(12,0) DEFAULT NULL,
    `created_at` datetime DEFAULT NULL,
    `created_by` bigint(20) DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `updated_by` bigint(20) DEFAULT NULL,
    `deleted` tinyint(1) DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `deposits`
--

DROP TABLE IF EXISTS `deposits`;

CREATE TABLE `deposits` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `created_at` datetime DEFAULT NULL,
    `created_by` bigint(20) DEFAULT NULL,
    `deleted` tinyint(1) DEFAULT '0',
    `updated_at` datetime DEFAULT NULL,
    `updated_by` bigint(20) DEFAULT NULL,
    `customer_id` bigint(20) DEFAULT NULL,
    `transaction_amount` decimal(12,0) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `FK_CustomerDeposit` (`customer_id`),
    CONSTRAINT `FK_CustomerDeposit` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `withdraws`
--

DROP TABLE IF EXISTS `withdraws`;

CREATE TABLE `withdraws` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `created_at` datetime DEFAULT NULL,
    `created_by` bigint(20) DEFAULT NULL,
    `deleted` tinyint(1) DEFAULT '0',
    `updated_at` datetime DEFAULT NULL,
    `updated_by` bigint(20) DEFAULT NULL,
    `customer_id` bigint(20) DEFAULT NULL,
    `transaction_amount` decimal(12,0) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `FK_CustomerWithdraw` (`customer_id`),
    CONSTRAINT `FK_CustomerWithdraw` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `transfers`
--

DROP TABLE IF EXISTS `transfers`;

CREATE TABLE `transfers` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `created_at` datetime DEFAULT NULL,
    `created_by` bigint(20) DEFAULT NULL,
    `deleted` tinyint(1) DEFAULT '0',
    `updated_at` datetime DEFAULT NULL,
    `updated_by` bigint(20) DEFAULT NULL,
    `fees` int(11) NOT NULL,
    `fees_amount` decimal(12,0) NOT NULL,
    `transaction_amount` decimal(12,0) NOT NULL,
    `transfer_amount` decimal(12,0) NOT NULL,
    `recipient_id` bigint(20) DEFAULT NULL,
    `sender_id` bigint(20) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `FK_RecipientTransfer` (`recipient_id`),
    KEY `FK_SenderTransfer` (`sender_id`),
    CONSTRAINT `FK_RecipientTransfer` FOREIGN KEY (`recipient_id`) REFERENCES `customers` (`id`),
    CONSTRAINT `FK_SenderTransfer` FOREIGN KEY (`sender_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
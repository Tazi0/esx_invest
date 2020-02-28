USE `essentialmode`;

CREATE TABLE `invest` (
  `identifier` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `amount` int(10) NOT NULL,
  `job` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
COMMIT;

ALTER TABLE `jobs` ADD `investRate` FLOAT(3) NOT NULL DEFAULT '0' AFTER `label`;
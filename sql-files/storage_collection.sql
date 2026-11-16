-- ลบตารางเก่าทิ้งก่อน (ถ้ามี) เพื่อป้องกัน Error
DROP TABLE IF EXISTS `storage_collection`;

-- สร้างตารางพร้อมกำหนด Index และ Auto Increment ในคำสั่งเดียว
CREATE TABLE `storage_collection` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `nameid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `amount` smallint(11) UNSIGNED NOT NULL DEFAULT 0,
  `equip` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `identify` smallint(6) UNSIGNED NOT NULL DEFAULT 0,
  `refine` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `attribute` tinyint(4) UNSIGNED NOT NULL DEFAULT 0,
  `card0` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `card1` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `card2` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `card3` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `option_id0` smallint(5) NOT NULL DEFAULT 0,
  `option_val0` smallint(5) NOT NULL DEFAULT 0,
  `option_parm0` tinyint(3) NOT NULL DEFAULT 0,
  `option_id1` smallint(5) NOT NULL DEFAULT 0,
  `option_val1` smallint(5) NOT NULL DEFAULT 0,
  `option_parm1` tinyint(3) NOT NULL DEFAULT 0,
  `option_id2` smallint(5) NOT NULL DEFAULT 0,
  `option_val2` smallint(5) NOT NULL DEFAULT 0,
  `option_parm2` tinyint(3) NOT NULL DEFAULT 0,
  `option_id3` smallint(5) NOT NULL DEFAULT 0,
  `option_val3` smallint(5) NOT NULL DEFAULT 0,
  `option_parm3` tinyint(3) NOT NULL DEFAULT 0,
  `option_id4` smallint(5) NOT NULL DEFAULT 0,
  `option_val4` smallint(5) NOT NULL DEFAULT 0,
  `option_parm4` tinyint(3) NOT NULL DEFAULT 0,
  `expire_time` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `bound` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `unique_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `enchantgrade` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1;
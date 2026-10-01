-- 1. ตารางเก็บค่าการตั้งค่าหลัก
CREATE TABLE IF NOT EXISTS `aa_common_config` (
  `char_id` int(11) unsigned NOT NULL,
  `stopmelee` tinyint(1) NOT NULL DEFAULT 0,
  `pickup_item_config` int(10) unsigned NOT NULL DEFAULT 0,
  `aggressive_behavior` tinyint(1) NOT NULL DEFAULT 0,
  `autositregen_conf` tinyint(1) NOT NULL DEFAULT 0,
  `autositregen_maxhp` smallint(5) unsigned NOT NULL DEFAULT 0,
  `autositregen_minhp` smallint(5) unsigned NOT NULL DEFAULT 0,
  `autositregen_maxsp` smallint(5) unsigned NOT NULL DEFAULT 0,
  `autositregen_minsp` smallint(5) unsigned NOT NULL DEFAULT 0,
  `tp_use_teleport` tinyint(1) NOT NULL DEFAULT 0,
  `tp_use_flywing` tinyint(1) NOT NULL DEFAULT 0,
  `tp_min_hp` smallint(5) unsigned NOT NULL DEFAULT 0,
  `tp_delay_nomobmeet` int(10) unsigned NOT NULL DEFAULT 0,
  `skill_rate` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. ตารางเก็บรายการไอเทม
CREATE TABLE IF NOT EXISTS `aa_items` (
  `char_id` int(11) unsigned NOT NULL,
  `type` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `min_hp` smallint(5) unsigned NOT NULL DEFAULT 0,
  `min_sp` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`char_id`,`type`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. ตารางเก็บรายการมอนสเตอร์
CREATE TABLE IF NOT EXISTS `aa_mobs` (
  `char_id` int(11) unsigned NOT NULL,
  `mob_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`char_id`,`mob_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. ตารางเก็บรายการสกิล
CREATE TABLE IF NOT EXISTS `aa_skills` (
  `char_id` int(11) unsigned NOT NULL,
  `type` smallint(5) unsigned NOT NULL,
  `skill_id` smallint(5) unsigned NOT NULL,
  `skill_lv` smallint(5) unsigned NOT NULL DEFAULT 0,
  `min_hp` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`char_id`,`type`,`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1. สร้างตารางสำหรับเก็บข้อมูล Combo Slots (กรณีระบบต้องการเซฟแยกช่อง)
CREATE TABLE IF NOT EXISTS `aa_combo_slots` (
  `char_id` INT(11) UNSIGNED NOT NULL,
  `slot_index` INT(1) NOT NULL DEFAULT 0,
  `skill_id` INT(11) DEFAULT 0,
  `skill_lv` INT(11) DEFAULT 0,
  `delay_ms` INT(11) DEFAULT 0,
  `is_active` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`char_id`, `slot_index`)
) ENGINE=MyISAM;

-- 2. เพิ่มคอลัมน์ combo_enabled ในตารางการตั้งค่าหลัก (ถ้ายังไม่มี)
ALTER TABLE `aa_common_config` ADD COLUMN IF NOT EXISTS `combo_enabled` TINYINT(1) DEFAULT 0;

-- 3. หากตาราง aa_common_config ยังไม่มี (อาจารย์อาจต้องสร้างไว้ด้วยเพื่อความชัวร์)
CREATE TABLE IF NOT EXISTS `aa_common_config` (
  `char_id` INT(11) UNSIGNED NOT NULL,
  `stopmelee` TINYINT(1) DEFAULT 0,
  `pickup_item_config` INT(11) DEFAULT 0,
  `aggressive_behavior` INT(11) DEFAULT 0,
  `autositregen_conf` INT(11) DEFAULT 0,
  `autositregen_maxhp` INT(11) DEFAULT 0,
  `autositregen_minhp` INT(11) DEFAULT 0,
  `autositregen_maxsp` INT(11) DEFAULT 0,
  `autositregen_minsp` INT(11) DEFAULT 0,
  `tp_use_teleport` INT(11) DEFAULT 0,
  `tp_use_flywing` INT(11) DEFAULT 0,
  `tp_min_hp` INT(11) DEFAULT 0,
  `tp_delay_nomobmeet` INT(11) DEFAULT 0,
  `skill_rate` INT(11) DEFAULT 25,
  `combo_enabled` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`char_id`)
) ENGINE=MyISAM;
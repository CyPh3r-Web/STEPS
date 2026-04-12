-- STEPS Database Backup
-- Date: April 11, 2026 05:11:09 AM
-- Database: u177927810_steps_db

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_activity_created` (`created_at`),
  KEY `idx_activity_action` (`action`),
  CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=220 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('1', '6', 'logout', 'User logged out', '::1', '2026-03-22 11:14:25');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('2', '4', 'login', 'User logged in', '::1', '2026-03-22 11:14:32');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('3', '4', 'logout', 'User logged out', '::1', '2026-03-22 11:17:05');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('4', '1', 'login', 'User logged in', '::1', '2026-03-23 07:58:54');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('5', '1', 'logout', 'User logged out', '::1', '2026-03-23 07:59:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('6', '4', 'login', 'User logged in', '::1', '2026-03-23 07:59:55');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('7', '4', 'logout', 'User logged out', '::1', '2026-03-23 08:00:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('8', '1', 'login', 'User logged in', '::1', '2026-03-23 08:00:51');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('9', '1', 'logout', 'User logged out', '::1', '2026-03-23 08:00:59');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('10', '5', 'login', 'User logged in', '::1', '2026-03-23 08:01:06');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('11', '5', 'login', 'User logged in', '::1', '2026-03-27 05:02:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('12', '1', 'login', 'User logged in', '49.149.212.221', '2026-04-02 01:51:17');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('13', '1', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 01:55:44');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('14', '4', 'login', 'User logged in', '49.149.212.221', '2026-04-02 01:55:55');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('15', '1', 'login', 'User logged in', '49.149.212.221', '2026-04-02 02:56:54');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('16', '1', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 03:04:05');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('17', '4', 'login', 'User logged in', '49.149.212.221', '2026-04-02 03:04:15');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('18', '1', 'login', 'User logged in', '49.149.212.221', '2026-04-02 03:06:39');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('19', '4', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 03:07:05');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('20', '5', 'login', 'User logged in', '49.149.212.221', '2026-04-02 03:07:15');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('21', '1', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 03:12:12');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('22', '5', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 03:29:23');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('23', '4', 'login', 'User logged in', '49.149.212.221', '2026-04-02 03:29:31');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('24', '4', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 03:44:34');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('25', '1', 'login', 'User logged in', '49.149.212.221', '2026-04-02 03:44:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('26', '1', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 03:57:08');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('27', '4', 'login', 'User logged in', '49.149.212.221', '2026-04-02 03:57:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('28', '4', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 04:59:33');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('29', '1', 'login', 'User logged in', '49.149.212.221', '2026-04-02 04:59:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('30', '1', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 04:59:50');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('31', '4', 'login', 'User logged in', '49.149.212.221', '2026-04-02 05:00:28');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('32', '1', 'login', 'User logged in', '49.149.212.221', '2026-04-02 06:28:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('33', '1', 'logout', 'User logged out', '49.149.212.221', '2026-04-02 06:28:51');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('34', '4', 'login', 'User logged in', '49.149.212.221', '2026-04-02 06:29:08');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('35', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-03 10:52:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('36', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-03 10:54:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('37', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-03 12:23:57');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('38', '1', 'logout', 'User logged out', '158.62.67.41', '2026-04-03 12:25:00');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('39', '5', 'login', 'User logged in', '158.62.67.41', '2026-04-03 12:25:06');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('40', '5', 'logout', 'User logged out', '158.62.67.41', '2026-04-03 12:26:21');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('41', '1', 'login', 'User logged in', '49.149.212.221', '2026-04-04 07:38:38');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('42', '1', 'backup', 'Created backup: steps_backup_2026-04-04_07-38-56.sql', '49.149.212.221', '2026-04-04 07:38:56');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('43', '1', 'logout', 'User logged out', '49.149.212.221', '2026-04-04 07:39:17');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('44', '4', 'login', 'User logged in', '49.149.212.221', '2026-04-04 07:39:27');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('45', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:43:32');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('46', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:45:38');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('47', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:45:46');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('48', '1', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:46:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('49', '5', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:46:50');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('50', '5', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:48:23');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('51', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:48:31');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('52', '1', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:51:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('53', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:51:57');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('54', '1', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:52:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('55', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:52:23');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('56', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:53:42');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('57', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:53:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('58', '1', 'support_ticket_update', 'Ticket #1 updated', '158.62.67.41', '2026-04-04 09:54:17');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('59', '1', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:54:42');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('60', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:54:45');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('61', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:55:50');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('62', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:55:55');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('63', '1', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 09:58:06');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('64', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-04 09:58:08');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('65', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 10:01:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('66', '5', 'login', 'User logged in', '158.62.67.41', '2026-04-04 10:01:26');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('67', '5', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 10:02:27');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('68', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-04 10:02:29');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('69', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 10:04:23');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('70', '5', 'login', 'User logged in', '158.62.67.41', '2026-04-04 12:33:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('71', '5', 'logout', 'User logged out', '158.62.67.41', '2026-04-04 12:41:10');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('72', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-04 12:41:12');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('73', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-05 00:39:44');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('74', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-05 13:18:03');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('75', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-05 13:24:32');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('76', '5', 'login', 'User logged in', '158.62.67.41', '2026-04-05 13:24:39');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('77', '1', 'login', 'User logged in', '103.49.146.86', '2026-04-06 08:55:42');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('78', '1', 'logout', 'User logged out', '103.49.146.86', '2026-04-06 08:55:53');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('79', '4', 'login', 'User logged in', '103.49.146.86', '2026-04-06 08:56:00');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('80', '4', 'logout', 'User logged out', '103.49.146.86', '2026-04-06 08:56:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('81', '5', 'login', 'User logged in', '103.49.146.86', '2026-04-06 08:56:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('82', '5', 'logout', 'User logged out', '103.49.146.86', '2026-04-06 08:57:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('83', '4', 'login', 'User logged in', '180.190.45.243', '2026-04-06 10:50:05');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('84', '4', 'logout', 'User logged out', '180.190.45.243', '2026-04-06 10:50:23');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('85', '5', 'login', 'User logged in', '180.190.45.243', '2026-04-06 10:50:44');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('86', '4', 'login', 'User logged in', '2001:fd8:2c85:50dd:5d84:971d:1f63:a518', '2026-04-09 02:16:05');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('87', '4', 'logout', 'User logged out', '2001:fd8:2c85:50dd:5d84:971d:1f63:a518', '2026-04-09 02:16:32');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('88', '4', 'login', 'User logged in', '143.44.185.25', '2026-04-09 02:17:58');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('89', '4', 'login', 'User logged in', '143.44.185.25', '2026-04-09 02:30:00');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('90', '4', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 02:32:44');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('91', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 02:32:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('92', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 02:35:44');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('93', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 02:36:55');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('94', '4', 'login', 'User logged in', '143.44.185.25', '2026-04-09 02:37:01');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('95', '4', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 02:37:45');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('96', '4', 'login', 'User logged in', '143.44.185.25', '2026-04-09 02:37:51');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('97', '1', 'support_ticket_update', 'Ticket #2 updated', '143.44.185.25', '2026-04-09 02:53:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('98', '1', 'support_ticket_update', 'Ticket #2 updated', '143.44.185.25', '2026-04-09 02:54:01');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('99', '1', 'support_ticket_update', 'Ticket #3 updated', '143.44.185.25', '2026-04-09 03:10:09');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('100', '1', 'support_ticket_update', 'Ticket #3 updated', '143.44.185.25', '2026-04-09 03:10:12');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('101', '1', 'support_ticket_update', 'Ticket #3 updated', '143.44.185.25', '2026-04-09 03:10:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('102', '1', 'support_ticket_update', 'Ticket #9 updated', '143.44.185.25', '2026-04-09 03:11:42');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('103', '1', 'support_ticket_update', 'Ticket #9 updated', '143.44.185.25', '2026-04-09 03:12:04');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('104', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:00');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('105', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:03');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('106', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:05');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('107', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:07');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('108', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:07');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('109', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:09');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('110', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:15');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('111', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('112', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:17');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('113', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:18');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('114', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('115', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:22');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('116', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:24');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('117', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:27');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('118', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:29');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('119', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:31');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('120', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:33');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('121', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:35');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('122', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('123', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:39');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('124', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('125', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:43');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('126', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:45');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('127', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:47');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('128', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:49');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('129', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:51');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('130', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:20:53');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('131', '4', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 03:28:33');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('132', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 03:28:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('133', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 03:28:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('134', '4', 'login', 'User logged in', '143.44.185.25', '2026-04-09 03:28:56');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('135', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:29:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('136', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:29:30');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('137', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:34:08');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('138', '1', 'support_ticket_update', 'Ticket #1 updated', '143.44.185.25', '2026-04-09 03:36:27');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('139', '4', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 04:05:47');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('140', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 04:05:52');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('141', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 04:08:34');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('142', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 04:08:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('143', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 04:09:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('144', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 04:09:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('145', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 04:12:04');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('146', '4', 'login', 'User logged in', '158.62.67.41', '2026-04-09 10:05:02');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('147', '4', 'logout', 'User logged out', '158.62.67.41', '2026-04-09 10:06:33');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('148', '5', 'login', 'User logged in', '158.62.67.41', '2026-04-09 10:06:39');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('149', '5', 'logout', 'User logged out', '158.62.67.41', '2026-04-09 10:07:40');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('150', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-09 10:08:01');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('151', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-09 10:15:35');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('152', '1', 'logout', 'User logged out', '158.62.67.41', '2026-04-09 10:22:39');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('153', '12', 'login', 'User logged in', '158.62.67.41', '2026-04-09 10:22:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('154', '12', 'password_change', 'User changed password', '158.62.67.41', '2026-04-09 10:23:33');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('155', '12', 'logout', 'User logged out', '158.62.67.41', '2026-04-09 10:27:00');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('156', '1', 'login', 'User logged in', '158.62.67.41', '2026-04-09 10:27:06');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('157', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 10:32:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('158', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 10:33:11');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('159', '15', 'login', 'User logged in', '143.44.185.25', '2026-04-09 10:33:17');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('160', '15', 'bulk_import', 'Bulk import: 2 inserted, 1 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-09 10:50:14');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('161', '15', 'bulk_import', 'Bulk import: 3 inserted, 0 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-09 10:51:48');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('162', '15', 'bulk_import', 'Bulk import: 3 inserted, 0 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-09 11:00:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('163', '15', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 11:10:35');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('164', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 11:10:41');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('165', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 11:21:49');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('166', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 11:22:29');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('167', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 11:22:38');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('168', '13', 'login', 'User logged in', '143.44.185.25', '2026-04-09 11:22:45');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('169', '13', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 11:23:12');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('170', '4', 'login', 'User logged in', '143.44.185.25', '2026-04-09 11:25:36');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('171', '4', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 11:26:28');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('172', '1', 'login', 'User logged in', '143.44.185.25', '2026-04-09 11:26:34');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('173', '1', 'backup', 'Created backup: steps_backup_2026-04-09_11-26-50.sql', '143.44.185.25', '2026-04-09 11:26:50');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('174', '1', 'logout', 'User logged out', '143.44.185.25', '2026-04-09 11:32:40');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('175', '1', 'login', 'User logged in', '110.54.207.88', '2026-04-09 13:30:17');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('176', '1', 'logout', 'User logged out', '110.54.207.88', '2026-04-09 13:31:20');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('177', '11', 'login', 'User logged in', '110.54.207.88', '2026-04-09 13:31:34');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('178', '12', 'login', 'User logged in', '110.54.207.88', '2026-04-09 23:34:03');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('179', '4', 'login', 'User logged in', '143.44.185.25', '2026-04-10 01:15:33');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('180', '15', 'login', 'User logged in', '143.44.185.25', '2026-04-10 03:06:13');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('181', '15', 'bulk_import', 'Bulk import: 3 inserted, 0 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-10 03:07:27');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('182', '15', 'bulk_import', 'Bulk import: 3 inserted, 0 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-10 03:11:52');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('183', '15', 'bulk_import', 'Bulk import: 3 inserted, 0 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-10 03:18:35');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('184', '15', 'bulk_import', 'Bulk import: 0 inserted, 3 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-10 03:23:26');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('185', '15', 'bulk_import', 'Bulk import: 3 inserted, 0 skipped from student_import_template (1).csv', '143.44.185.25', '2026-04-10 03:24:29');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('186', '5', 'login', 'User logged in', '110.54.207.88', '2026-04-10 14:35:44');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('187', '5', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 14:39:09');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('188', '4', 'login', 'User logged in', '110.54.207.88', '2026-04-10 14:39:12');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('189', '4', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 14:48:36');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('190', '5', 'login', 'User logged in', '110.54.207.88', '2026-04-10 14:48:45');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('191', '5', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 14:51:35');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('192', '4', 'login', 'User logged in', '110.54.207.88', '2026-04-10 14:51:37');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('193', '4', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:26:46');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('194', '1', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:26:53');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('195', '1', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:27:31');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('196', '12', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:27:54');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('197', '12', 'bulk_import', 'Bulk import: 10 inserted, 0 skipped from ABM-12.csv', '110.54.207.88', '2026-04-10 15:43:14');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('198', '12', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:43:38');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('199', '11', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:43:46');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('200', '11', 'password_change', 'User changed password', '110.54.207.88', '2026-04-10 15:44:11');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('201', '11', 'bulk_import', 'Bulk import: 0 inserted, 10 skipped from TVL-ICT-11.csv', '110.54.207.88', '2026-04-10 15:44:40');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('202', '11', 'bulk_import', 'Bulk import: 4 inserted, 6 skipped from HUMSS-11.csv', '110.54.207.88', '2026-04-10 15:45:16');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('203', '11', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:46:13');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('204', '13', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:46:26');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('205', '13', 'password_change', 'User changed password', '110.54.207.88', '2026-04-10 15:47:13');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('206', '13', 'bulk_import', 'Bulk import: 8 inserted, 9 skipped from G10-AZURITE.csv', '110.54.207.88', '2026-04-10 15:47:49');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('207', '13', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:48:57');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('208', '1', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:49:07');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('209', '1', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:51:04');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('210', '12', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:51:28');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('211', '12', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:51:40');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('212', '11', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:51:51');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('213', '11', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:52:08');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('214', '1', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:52:13');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('215', '1', 'logout', 'User logged out', '110.54.207.88', '2026-04-10 15:55:06');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('216', '12', 'login', 'User logged in', '110.54.207.88', '2026-04-10 15:55:21');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('217', '15', 'login', 'User logged in', '180.190.47.228', '2026-04-11 05:10:03');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('218', '15', 'logout', 'User logged out', '180.190.47.228', '2026-04-11 05:10:51');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`) VALUES ('219', '1', 'login', 'User logged in', '180.190.47.228', '2026-04-11 05:10:54');

DROP TABLE IF EXISTS `backup_logs`;
CREATE TABLE `backup_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `backup_file` varchar(255) NOT NULL,
  `file_size` varchar(50) DEFAULT NULL,
  `backup_type` enum('full','partial') NOT NULL DEFAULT 'full',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `backup_logs_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `backup_logs` (`id`, `backup_file`, `file_size`, `backup_type`, `created_by`, `created_at`) VALUES ('1', 'steps_backup_2026-04-04_07-38-56.sql', '123.77 KB', 'full', '1', '2026-04-04 07:38:56');
INSERT INTO `backup_logs` (`id`, `backup_file`, `file_size`, `backup_type`, `created_by`, `created_at`) VALUES ('2', 'steps_backup_2026-04-09_11-26-50.sql', '175.04 KB', 'full', '1', '2026-04-09 11:26:50');

DROP TABLE IF EXISTS `career_recommendations`;
CREATE TABLE `career_recommendations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `recommendation_type` enum('strand','course') NOT NULL DEFAULT 'strand',
  `top_strand_1` varchar(100) DEFAULT NULL,
  `top_strand_2` varchar(100) DEFAULT NULL,
  `top_strand_3` varchar(100) DEFAULT NULL,
  `top_course_1` varchar(150) DEFAULT NULL,
  `top_course_2` varchar(150) DEFAULT NULL,
  `top_course_3` varchar(150) DEFAULT NULL,
  `recommended_strand` varchar(100) DEFAULT NULL,
  `recommended_courses` text DEFAULT NULL,
  `employability_score` decimal(5,2) DEFAULT NULL,
  `employability_level` enum('low','moderate','high','very_high') NOT NULL DEFAULT 'moderate',
  `strand_match` tinyint(1) DEFAULT 1,
  `mismatch_remarks` text DEFAULT NULL,
  `career_pathways` text DEFAULT NULL,
  `score_breakdown` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`score_breakdown`)),
  `generated_by` int(11) DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_career_rec` (`student_id`,`recommendation_type`,`school_year`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `career_recommendations_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `career_recommendations_ibfk_2` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('4', '9', 'strand', 'Science, Technology, Engineering and Mathematics', 'Humanities and Social Sciences', 'Arts and Design Track', NULL, NULL, NULL, 'Science, Technology, Engineering and Mathematics', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"n_trees\": 37, \"algorithm\": \"random_forest_v1\", \"analytics\": [\"Academic competency (Q4 average)\", \"Skills assessment (text vs strand keywords)\", \"Student interests / hobbies\", \"Technical skill level (self-rated)\", \"Entrance examination score\", \"Career preference (text vs strand keywords)\"], \"q4_average\": 87.375, \"top_strands\": [{\"score\": 45.95, \"votes\": 17, \"strand_id\": 1, \"strand_code\": \"STEM\", \"strand_name\": \"Science, Technology, Engineering and Mathematics\"}, {\"score\": 29.73, \"votes\": 11, \"strand_id\": 3, \"strand_code\": \"HUMSS\", \"strand_name\": \"Humanities and Social Sciences\"}, {\"score\": 10.81, \"votes\": 4, \"strand_id\": 9, \"strand_code\": \"ARTS\", \"strand_name\": \"Arts and Design Track\"}], \"first_choice\": \"STEM\", \"generated_at\": \"2026-03-23 08:15:11\", \"strand_votes\": {\"ABM\": 1, \"GAS\": 2, \"ARTS\": 4, \"STEM\": 17, \"HUMSS\": 11, \"TVL-ICT\": 2}, \"entrance_exam\": \"88.50\", \"feature_vector\": {\"entrance_exam\": 88.5, \"work_immersion\": 0, \"student_interest\": 70, \"career_preference\": 58, \"skills_assessment\": 70, \"academic_competency\": 87.375, \"technical_skill_level\": 82}, \"input_process_output\": {\"input\": [\"Academic grades (Q4, per subject)\", \"Skills assessment\", \"Interest (hobbies)\", \"Entrance exam score\", \"Career preference\", \"Technical skill level\"], \"output\": \"Top 3 SHS strands by vote count (tie-break by aggregate score).\", \"process\": \"Build 0–100 feature vector. Run 37 trees; each tree uses a random subset of features with jittered strand affinity weights; each tree predicts one strand; majority vote ranks Top 3.\"}, \"first_choice_mismatch\": false, \"recommendation_explanation\": \"The Random Forest combines the learner profile with Q4 academic performance. Each of 37 trees casts one vote; vote totals rank strands. Rank 1 (Science, Technology, Engineering and Mathematics) received the most tree votes (17 votes), meaning the weighted mix of academic competency, skills, interests, technical level, entrance exam, and career preference most closely matches that strand. Stronger Q4 averages and closer alignment between career preference text and strand keywords increase votes toward academic tracks (e.g. STEM, HUMSS); technical interests and skills boost TVL strands.\"}', '5', '2025-2026', '2026-03-23 08:15:11', '2026-03-23 08:15:11');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('5', '10', 'strand', 'Science, Technology, Engineering and Mathematics', 'Humanities and Social Sciences', 'General Academic Strand', NULL, NULL, NULL, 'Science, Technology, Engineering and Mathematics', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"n_trees\": 37, \"algorithm\": \"random_forest_v1\", \"analytics\": [\"Academic competency (Q4 average)\", \"Skills assessment (text vs strand keywords)\", \"Student interests / hobbies\", \"Technical skill level (self-rated)\", \"Entrance examination score\", \"Career preference (text vs strand keywords)\"], \"q4_average\": 85.5, \"top_strands\": [{\"score\": 32.43, \"votes\": 12, \"strand_id\": 1, \"strand_code\": \"STEM\", \"strand_name\": \"Science, Technology, Engineering and Mathematics\"}, {\"score\": 29.73, \"votes\": 11, \"strand_id\": 3, \"strand_code\": \"HUMSS\", \"strand_name\": \"Humanities and Social Sciences\"}, {\"score\": 18.92, \"votes\": 7, \"strand_id\": 4, \"strand_code\": \"GAS\", \"strand_name\": \"General Academic Strand\"}], \"first_choice\": \"TVL - Cookery\", \"generated_at\": \"2026-03-23 08:15:27\", \"strand_votes\": {\"ABM\": 2, \"GAS\": 7, \"ARTS\": 5, \"STEM\": 12, \"HUMSS\": 11}, \"entrance_exam\": \"76.00\", \"feature_vector\": {\"entrance_exam\": 76, \"work_immersion\": 0, \"student_interest\": 64, \"career_preference\": 58, \"skills_assessment\": 64, \"academic_competency\": 85.5, \"technical_skill_level\": 62}, \"input_process_output\": {\"input\": [\"Academic grades (Q4, per subject)\", \"Skills assessment\", \"Interest (hobbies)\", \"Entrance exam score\", \"Career preference\", \"Technical skill level\"], \"output\": \"Top 3 SHS strands by vote count (tie-break by aggregate score).\", \"process\": \"Build 0–100 feature vector. Run 37 trees; each tree uses a random subset of features with jittered strand affinity weights; each tree predicts one strand; majority vote ranks Top 3.\"}, \"first_choice_mismatch\": true, \"recommendation_explanation\": \"The Random Forest combines the learner profile with Q4 academic performance. Each of 37 trees casts one vote; vote totals rank strands. Rank 1 (Science, Technology, Engineering and Mathematics) received the most tree votes (12 votes), meaning the weighted mix of academic competency, skills, interests, technical level, entrance exam, and career preference most closely matches that strand. Stronger Q4 averages and closer alignment between career preference text and strand keywords increase votes toward academic tracks (e.g. STEM, HUMSS); technical interests and skills boost TVL strands.\"}', '5', '2025-2026', '2026-03-23 08:15:27', '2026-03-23 08:15:27');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('6', '11', 'strand', 'Science, Technology, Engineering and Mathematics', 'Humanities and Social Sciences', 'Accountancy, Business and Management', NULL, NULL, NULL, 'Science, Technology, Engineering and Mathematics', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"algorithm\":\"random_forest_v1\",\"n_trees\":37,\"feature_vector\":{\"academic_competency\":88.25,\"work_immersion\":0,\"skills_assessment\":58,\"student_interest\":64,\"technical_skill_level\":82,\"entrance_exam\":85,\"career_preference\":58},\"strand_votes\":{\"STEM\":16,\"HUMSS\":12,\"ABM\":3,\"ARTS\":3,\"TVL-ICT\":2,\"GAS\":1},\"top_strands\":[{\"strand_id\":1,\"strand_code\":\"STEM\",\"strand_name\":\"Science, Technology, Engineering and Mathematics\",\"votes\":16,\"score\":43.24},{\"strand_id\":3,\"strand_code\":\"HUMSS\",\"strand_name\":\"Humanities and Social Sciences\",\"votes\":12,\"score\":32.43},{\"strand_id\":2,\"strand_code\":\"ABM\",\"strand_name\":\"Accountancy, Business and Management\",\"votes\":3,\"score\":8.11}],\"first_choice\":\"HUMSS\",\"first_choice_mismatch\":false,\"recommendation_explanation\":\"The Random Forest combines the learner profile with Q4 academic performance. Each of 37 trees casts one vote; vote totals rank strands. Rank 1 (Science, Technology, Engineering and Mathematics) received the most tree votes (16 votes), meaning the weighted mix of academic competency, skills, interests, technical level, entrance exam, and career preference most closely matches that strand. Stronger Q4 averages and closer alignment between career preference text and strand keywords increase votes toward academic tracks (e.g. STEM, HUMSS); technical interests and skills boost TVL strands.\",\"analytics\":[\"Academic competency (Q4 average)\",\"Skills assessment (text vs strand keywords)\",\"Student interests \\/ hobbies\",\"Technical skill level (self-rated)\",\"Entrance examination score\",\"Career preference (text vs strand keywords)\"],\"input_process_output\":{\"input\":[\"Academic grades (Q4, per subject)\",\"Skills assessment\",\"Interest (hobbies)\",\"Entrance exam score\",\"Career preference\",\"Technical skill level\"],\"process\":\"Build 0\\u2013100 feature vector. Run 37 trees; each tree uses a random subset of features with jittered strand affinity weights; each tree predicts one strand; majority vote ranks Top 3.\",\"output\":\"Top 3 SHS strands by vote count (tie-break by aggregate score).\"},\"q4_average\":88.25,\"entrance_exam\":\"85.00\",\"generated_at\":\"2026-04-03 12:25:47\"}', '5', '2025-2026', '2026-04-03 12:25:47', '2026-04-03 12:25:47');
INSERT INTO `career_recommendations` (`id`, `student_id`, `recommendation_type`, `top_strand_1`, `top_strand_2`, `top_strand_3`, `top_course_1`, `top_course_2`, `top_course_3`, `recommended_strand`, `recommended_courses`, `employability_score`, `employability_level`, `strand_match`, `mismatch_remarks`, `career_pathways`, `score_breakdown`, `generated_by`, `school_year`, `created_at`, `updated_at`) VALUES ('7', '13', 'strand', 'Science, Technology, Engineering and Mathematics', 'Arts and Design Track', 'Humanities and Social Sciences', NULL, NULL, NULL, 'Science, Technology, Engineering and Mathematics', NULL, NULL, 'moderate', '1', NULL, NULL, '{\"algorithm\":\"random_forest_v1\",\"n_trees\":37,\"feature_vector\":{\"academic_competency\":86.25,\"work_immersion\":0,\"skills_assessment\":52,\"student_interest\":58,\"technical_skill_level\":82,\"entrance_exam\":79.5,\"career_preference\":64},\"strand_votes\":{\"STEM\":24,\"ARTS\":5,\"HUMSS\":3,\"ABM\":3,\"TVL-ICT\":2},\"top_strands\":[{\"strand_id\":1,\"strand_code\":\"STEM\",\"strand_name\":\"Science, Technology, Engineering and Mathematics\",\"votes\":24,\"score\":64.86},{\"strand_id\":9,\"strand_code\":\"ARTS\",\"strand_name\":\"Arts and Design Track\",\"votes\":5,\"score\":13.51},{\"strand_id\":3,\"strand_code\":\"HUMSS\",\"strand_name\":\"Humanities and Social Sciences\",\"votes\":3,\"score\":8.11}],\"first_choice\":\"ABM\",\"first_choice_mismatch\":true,\"recommendation_explanation\":\"The Random Forest combines the learner profile with Q4 academic performance. Each of 37 trees casts one vote; vote totals rank strands. Rank 1 (Science, Technology, Engineering and Mathematics) received the most tree votes (24 votes), meaning the weighted mix of academic competency, skills, interests, technical level, entrance exam, and career preference most closely matches that strand. Stronger Q4 averages and closer alignment between career preference text and strand keywords increase votes toward academic tracks (e.g. STEM, HUMSS); technical interests and skills boost TVL strands.\",\"analytics\":[\"Academic competency (Q4 average)\",\"Skills assessment (text vs strand keywords)\",\"Student interests \\/ hobbies\",\"Technical skill level (self-rated)\",\"Entrance examination score\",\"Career preference (text vs strand keywords)\"],\"input_process_output\":{\"input\":[\"Academic grades (Q4, per subject)\",\"Skills assessment\",\"Interest (hobbies)\",\"Entrance exam score\",\"Career preference\",\"Technical skill level\"],\"process\":\"Build 0\\u2013100 feature vector. Run 37 trees; each tree uses a random subset of features with jittered strand affinity weights; each tree predicts one strand; majority vote ranks Top 3.\",\"output\":\"Top 3 SHS strands by vote count (tie-break by aggregate score).\"},\"q4_average\":86.25,\"entrance_exam\":\"79.50\",\"generated_at\":\"2026-04-06 08:57:22\"}', '5', '2025-2026', '2026-04-06 08:57:22', '2026-04-06 08:57:22');

DROP TABLE IF EXISTS `competency_records`;
CREATE TABLE `competency_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `average_grade` decimal(5,2) NOT NULL,
  `competency_level` enum('weak','at_risk','proficient') NOT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_competency` (`student_id`,`subject_id`,`school_year`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `competency_records_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `competency_records_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `diagnostic_reports`;
CREATE TABLE `diagnostic_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `report_type` enum('individual','section','class_performance','competency') NOT NULL,
  `report_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`report_data`)),
  `generated_by` int(11) DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `section_id` (`section_id`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `diagnostic_reports_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `diagnostic_reports_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `diagnostic_reports_ibfk_3` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('1', '15', NULL, 'individual', '{\"student_name\":\"Javidec Monsion\",\"avg_grade\":\"98.000000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-04 09:58:19');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('2', '15', NULL, 'individual', '{\"student_name\":\"Javidec Monsion\",\"avg_grade\":\"98.000000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-04 10:02:41');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('3', NULL, '11', 'section', '{\"section\":\"Rizal\",\"total_students\":1,\"date\":\"2026-04-05 13:24:10\"}', '4', '2025-2026', '2026-04-05 13:24:10');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('4', NULL, '1', 'section', '{\"section\":\"Ruby\",\"total_students\":3,\"date\":\"2026-04-09 03:37:32\"}', '4', '2025-2026', '2026-04-09 03:37:32');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('5', '1', NULL, 'individual', '{\"student_name\":\"Juan Dela Cruz\",\"avg_grade\":\"88.375000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:38:03');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('6', '2', NULL, 'individual', '{\"student_name\":\"Maria Garcia\",\"avg_grade\":\"77.875000\",\"competency\":{\"level\":\"at_risk\",\"label\":\"Needs Reinforcement\",\"color\":\"amber\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:39:19');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('7', '2', NULL, 'individual', '{\"student_name\":\"Maria Garcia\",\"avg_grade\":\"77.875000\",\"competency\":{\"level\":\"at_risk\",\"label\":\"Needs Reinforcement\",\"color\":\"amber\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:45:28');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('8', '1', NULL, 'individual', '{\"student_name\":\"Juan Dela Cruz\",\"avg_grade\":\"88.375000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:46:03');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('9', '1', NULL, 'individual', '{\"student_name\":\"Juan Dela Cruz\",\"avg_grade\":\"88.375000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:46:55');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('10', '1', NULL, 'individual', '{\"student_name\":\"Juan Dela Cruz\",\"avg_grade\":\"88.375000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:48:35');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('11', '1', NULL, 'individual', '{\"student_name\":\"Juan Dela Cruz\",\"avg_grade\":\"88.375000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:48:44');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('12', '1', NULL, 'individual', '{\"student_name\":\"Juan Dela Cruz\",\"avg_grade\":\"88.375000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:50:47');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('13', '1', NULL, 'individual', '{\"student_name\":\"Juan Dela Cruz\",\"avg_grade\":\"88.375000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":null}', '4', '2025-2026', '2026-04-09 03:53:50');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('14', NULL, '1', 'section', '{\"section\":\"Ruby\",\"total_students\":3,\"date\":\"2026-04-09 03:55:57\"}', '4', '2025-2026', '2026-04-09 03:55:57');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('15', NULL, '1', 'section', '{\"section\":\"Ruby\",\"total_students\":3,\"date\":\"2026-04-09 03:58:40\"}', '4', '2025-2026', '2026-04-09 03:58:40');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('16', NULL, '3', 'section', '{\"section\":\"Sardonyx\",\"total_students\":2,\"date\":\"2026-04-09 03:59:05\"}', '4', '2025-2026', '2026-04-09 03:59:05');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('17', NULL, '1', 'section', '{\"section\":\"Ruby\",\"total_students\":3,\"date\":\"2026-04-09 04:00:17\"}', '4', '2025-2026', '2026-04-09 04:00:17');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('18', NULL, '6', 'section', '{\"section\":\"Section A\",\"total_students\":1,\"date\":\"2026-04-09 04:00:23\"}', '4', '2025-2026', '2026-04-09 04:00:23');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('19', NULL, '6', 'section', '{\"section\":\"Section A\",\"total_students\":1,\"date\":\"2026-04-09 04:00:55\"}', '4', '2025-2026', '2026-04-09 04:00:55');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('20', NULL, '5', 'section', '{\"section\":\"Section B\",\"total_students\":0,\"date\":\"2026-04-09 04:01:00\"}', '4', '2025-2026', '2026-04-09 04:01:00');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('21', NULL, '7', 'section', '{\"section\":\"Section C\",\"total_students\":0,\"date\":\"2026-04-09 04:01:04\"}', '4', '2025-2026', '2026-04-09 04:01:04');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('22', NULL, '8', 'section', '{\"section\":\"Section D\",\"total_students\":0,\"date\":\"2026-04-09 04:01:08\"}', '4', '2025-2026', '2026-04-09 04:01:08');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('23', NULL, '9', 'section', '{\"section\":\"Section E\",\"total_students\":0,\"date\":\"2026-04-09 04:01:13\"}', '4', '2025-2026', '2026-04-09 04:01:13');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('24', NULL, '10', 'section', '{\"section\":\"Section F\",\"total_students\":1,\"date\":\"2026-04-09 04:01:17\"}', '4', '2025-2026', '2026-04-09 04:01:17');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('25', NULL, '10', 'section', '{\"section\":\"Section F\",\"total_students\":1,\"date\":\"2026-04-09 04:01:38\"}', '4', '2025-2026', '2026-04-09 04:01:38');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('26', NULL, '12', 'section', '{\"section\":\"Section H\",\"total_students\":1,\"date\":\"2026-04-09 04:02:04\"}', '4', '2025-2026', '2026-04-09 04:02:04');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('27', NULL, '11', 'section', '{\"section\":\"Section G\",\"total_students\":1,\"date\":\"2026-04-09 04:02:10\"}', '4', '2025-2026', '2026-04-09 04:02:10');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('28', NULL, '11', 'section', '{\"section\":\"Section G\",\"total_students\":1,\"date\":\"2026-04-09 04:02:37\"}', '4', '2025-2026', '2026-04-09 04:02:37');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('29', NULL, '10', 'section', '{\"section\":\"Section F\",\"total_students\":1,\"date\":\"2026-04-09 04:02:42\"}', '4', '2025-2026', '2026-04-09 04:02:42');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('30', NULL, '12', 'section', '{\"section\":\"Section H\",\"total_students\":1,\"date\":\"2026-04-09 04:02:48\"}', '4', '2025-2026', '2026-04-09 04:02:48');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('31', NULL, '12', 'section', '{\"section\":\"Section H\",\"total_students\":1,\"date\":\"2026-04-09 04:03:04\"}', '4', '2025-2026', '2026-04-09 04:03:04');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('32', NULL, '13', 'section', '{\"section\":\"Section I\",\"total_students\":1,\"date\":\"2026-04-09 04:03:10\"}', '4', '2025-2026', '2026-04-09 04:03:10');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('33', NULL, '13', 'section', '{\"section\":\"Section I\",\"total_students\":1,\"date\":\"2026-04-09 04:03:26\"}', '4', '2025-2026', '2026-04-09 04:03:26');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('34', NULL, '14', 'section', '{\"section\":\"Section A\",\"total_students\":2,\"date\":\"2026-04-09 04:03:32\"}', '4', '2025-2026', '2026-04-09 04:03:32');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('35', NULL, '14', 'section', '{\"section\":\"Section A\",\"total_students\":2,\"date\":\"2026-04-09 04:03:51\"}', '4', '2025-2026', '2026-04-09 04:03:51');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('36', NULL, '14', 'section', '{\"section\":\"Section A\",\"total_students\":2,\"date\":\"2026-04-09 04:04:07\"}', '4', '2025-2026', '2026-04-09 04:04:07');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('37', NULL, '15', 'section', '{\"section\":\"Section B\",\"total_students\":0,\"date\":\"2026-04-09 04:04:13\"}', '4', '2025-2026', '2026-04-09 04:04:13');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('38', NULL, '16', 'section', '{\"section\":\"Section C\",\"total_students\":0,\"date\":\"2026-04-09 04:04:17\"}', '4', '2025-2026', '2026-04-09 04:04:17');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('39', NULL, '17', 'section', '{\"section\":\"Section D\",\"total_students\":0,\"date\":\"2026-04-09 04:04:22\"}', '4', '2025-2026', '2026-04-09 04:04:22');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('40', NULL, '18', 'section', '{\"section\":\"Section E\",\"total_students\":0,\"date\":\"2026-04-09 04:04:26\"}', '4', '2025-2026', '2026-04-09 04:04:26');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('41', NULL, '19', 'section', '{\"section\":\"Section F\",\"total_students\":0,\"date\":\"2026-04-09 04:04:32\"}', '4', '2025-2026', '2026-04-09 04:04:32');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('42', NULL, '20', 'section', '{\"section\":\"Section G\",\"total_students\":0,\"date\":\"2026-04-09 04:04:36\"}', '4', '2025-2026', '2026-04-09 04:04:36');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('43', NULL, '21', 'section', '{\"section\":\"Section H\",\"total_students\":0,\"date\":\"2026-04-09 04:04:40\"}', '4', '2025-2026', '2026-04-09 04:04:40');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('44', NULL, '22', 'section', '{\"section\":\"Section I\",\"total_students\":0,\"date\":\"2026-04-09 04:04:45\"}', '4', '2025-2026', '2026-04-09 04:04:45');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('45', '13', NULL, 'individual', '{\"student_name\":\"Nathan Buenaventura\",\"avg_grade\":\"84.750000\",\"competency\":{\"level\":\"proficient\",\"label\":\"Meets Expectations\",\"color\":\"emerald\"},\"career_recommendation\":\"Science, Technology, Engineering and Mathematics\"}', '4', '2025-2026', '2026-04-09 04:05:14');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('48', NULL, '23', 'class_performance', '{\"section\":\"23\",\"type\":\"class_performance\",\"date\":\"2026-04-09\"}', '15', '2025-2026', '2026-04-09 11:10:05');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('49', NULL, '2', 'section', '{\"section\":\"Emerald\",\"total_students\":0,\"date\":\"2026-04-10 14:44:31\"}', '4', '2025-2026', '2026-04-10 14:44:31');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('50', NULL, '1', 'section', '{\"section\":\"Ruby\",\"total_students\":0,\"date\":\"2026-04-10 14:44:40\"}', '4', '2025-2026', '2026-04-10 14:44:40');
INSERT INTO `diagnostic_reports` (`id`, `student_id`, `section_id`, `report_type`, `report_data`, `generated_by`, `school_year`, `created_at`) VALUES ('51', NULL, '10', 'section', '{\"section\":\"Section F\",\"total_students\":1,\"date\":\"2026-04-10 14:44:48\"}', '4', '2025-2026', '2026-04-10 14:44:48');

DROP TABLE IF EXISTS `grade_subject_remarks`;
CREATE TABLE `grade_subject_remarks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `school_year` varchar(20) NOT NULL,
  `learning_gaps` text DEFAULT NULL COMMENT 'What are the learning gaps?',
  `reinforcement_reason` text DEFAULT NULL COMMENT 'Why does the status need reinforcement?',
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_grade_subject_remark` (`student_id`,`subject_id`,`school_year`),
  KEY `subject_id` (`subject_id`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `grade_subject_remarks_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grade_subject_remarks_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grade_subject_remarks_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `grade_subject_remarks` (`id`, `student_id`, `subject_id`, `school_year`, `learning_gaps`, `reinforcement_reason`, `updated_by`, `created_at`, `updated_at`) VALUES ('1', '7', '1', '2025-2026', 'he doesn\'t know how to read', 'Need to retake the subject', '4', '2026-03-22 11:16:49', '2026-03-22 11:16:49');

DROP TABLE IF EXISTS `grades`;
CREATE TABLE `grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `quarter` enum('Q1','Q2','Q3','Q4') NOT NULL,
  `grade` decimal(5,2) NOT NULL,
  `school_year` varchar(20) NOT NULL,
  `encoded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_grade` (`student_id`,`subject_id`,`quarter`,`school_year`),
  KEY `subject_id` (`subject_id`),
  KEY `encoded_by` (`encoded_by`),
  CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grades_ibfk_3` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('1', '1', '4', 'Q1', '88.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('2', '1', '4', 'Q2', '90.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('3', '1', '21', 'Q1', '85.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('4', '1', '21', 'Q2', '87.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('5', '1', '23', 'Q1', '92.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('6', '1', '23', 'Q2', '91.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('7', '1', '1', 'Q1', '86.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('8', '1', '1', 'Q2', '88.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('9', '2', '4', 'Q1', '78.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('10', '2', '4', 'Q2', '76.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('11', '2', '21', 'Q1', '74.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('12', '2', '21', 'Q2', '73.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('13', '2', '23', 'Q1', '80.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('14', '2', '23', 'Q2', '79.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('15', '2', '1', 'Q1', '82.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('16', '2', '1', 'Q2', '81.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('17', '3', '4', 'Q1', '72.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('18', '3', '4', 'Q2', '70.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('19', '3', '21', 'Q1', '68.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('20', '3', '21', 'Q2', '71.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('21', '3', '23', 'Q1', '74.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('22', '3', '23', 'Q2', '73.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('23', '3', '1', 'Q1', '75.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('24', '3', '1', 'Q2', '76.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('25', '4', '30', 'Q1', '89.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('26', '4', '30', 'Q2', '91.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('27', '4', '33', 'Q1', '87.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('28', '4', '33', 'Q2', '90.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('29', '4', '1', 'Q1', '85.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('30', '4', '1', 'Q2', '88.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('31', '5', '30', 'Q1', '76.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('32', '5', '30', 'Q2', '78.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('33', '5', '33', 'Q1', '74.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('34', '5', '33', 'Q2', '77.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('35', '5', '1', 'Q1', '79.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('36', '5', '1', 'Q2', '80.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('37', '6', '38', 'Q1', '90.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('38', '6', '38', 'Q2', '92.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('39', '6', '39', 'Q1', '88.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('40', '6', '39', 'Q2', '91.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('41', '6', '1', 'Q1', '93.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('42', '6', '1', 'Q2', '94.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('43', '7', '38', 'Q1', '77.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('44', '7', '38', 'Q2', '75.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('45', '7', '39', 'Q1', '79.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('46', '7', '39', 'Q2', '78.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('47', '7', '1', 'Q1', '76.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('48', '7', '1', 'Q2', '77.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('49', '8', '4', 'Q1', '95.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('50', '8', '4', 'Q2', '96.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('51', '8', '21', 'Q1', '93.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('52', '8', '21', 'Q2', '94.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('53', '8', '23', 'Q1', '91.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('54', '8', '23', 'Q2', '93.00', '2025-2026', '2', '2026-03-22 11:13:15', '2026-03-22 11:13:15');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('55', '9', '1', 'Q1', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('56', '9', '1', 'Q2', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('57', '9', '1', 'Q3', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('58', '9', '1', 'Q4', '88.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('59', '9', '2', 'Q1', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('60', '9', '2', 'Q2', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('61', '9', '2', 'Q3', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('62', '9', '2', 'Q4', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('63', '9', '3', 'Q1', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('64', '9', '3', 'Q2', '95.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('65', '9', '3', 'Q3', '94.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('66', '9', '3', 'Q4', '96.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('67', '9', '4', 'Q1', '91.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('68', '9', '4', 'Q2', '92.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('69', '9', '4', 'Q3', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('70', '9', '4', 'Q4', '95.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('71', '9', '5', 'Q1', '80.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('72', '9', '5', 'Q2', '81.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('73', '9', '5', 'Q3', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('74', '9', '5', 'Q4', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('75', '9', '6', 'Q1', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('76', '9', '6', 'Q2', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('77', '9', '6', 'Q3', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('78', '9', '6', 'Q4', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('79', '9', '7', 'Q1', '80.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('80', '9', '7', 'Q2', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('81', '9', '7', 'Q3', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('82', '9', '7', 'Q4', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('83', '9', '8', 'Q1', '78.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('84', '9', '8', 'Q2', '79.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('85', '9', '8', 'Q3', '80.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('86', '9', '8', 'Q4', '81.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('87', '10', '9', 'Q1', '80.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('88', '10', '9', 'Q2', '81.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('89', '10', '9', 'Q3', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('90', '10', '9', 'Q4', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('91', '10', '10', 'Q1', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('92', '10', '10', 'Q2', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('93', '10', '10', 'Q3', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('94', '10', '10', 'Q4', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('95', '10', '11', 'Q1', '72.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('96', '10', '11', 'Q2', '74.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('97', '10', '11', 'Q3', '75.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('98', '10', '11', 'Q4', '76.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('99', '10', '12', 'Q1', '74.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('100', '10', '12', 'Q2', '75.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('101', '10', '12', 'Q3', '76.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('102', '10', '12', 'Q4', '77.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('103', '10', '13', 'Q1', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('104', '10', '13', 'Q2', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('105', '10', '13', 'Q3', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('106', '10', '13', 'Q4', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('107', '10', '14', 'Q1', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('108', '10', '14', 'Q2', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('109', '10', '14', 'Q3', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('110', '10', '14', 'Q4', '88.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('111', '10', '15', 'Q1', '90.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('112', '10', '15', 'Q2', '91.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('113', '10', '15', 'Q3', '92.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('114', '10', '15', 'Q4', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('115', '10', '16', 'Q1', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('116', '10', '16', 'Q2', '94.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('117', '10', '16', 'Q3', '95.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('118', '10', '16', 'Q4', '96.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('119', '11', '17', 'Q1', '92.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('120', '11', '17', 'Q2', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('121', '11', '17', 'Q3', '94.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('122', '11', '17', 'Q4', '95.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('123', '11', '18', 'Q1', '91.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('124', '11', '18', 'Q2', '92.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('125', '11', '18', 'Q3', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('126', '11', '18', 'Q4', '94.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('127', '11', '19', 'Q1', '75.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('128', '11', '19', 'Q2', '76.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('129', '11', '19', 'Q3', '77.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('130', '11', '19', 'Q4', '78.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('131', '11', '20', 'Q1', '76.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('132', '11', '20', 'Q2', '77.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('133', '11', '20', 'Q3', '78.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('134', '11', '20', 'Q4', '79.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('135', '11', '21', 'Q1', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('136', '11', '21', 'Q2', '94.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('137', '11', '21', 'Q3', '95.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('138', '11', '21', 'Q4', '96.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('139', '11', '22', 'Q1', '90.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('140', '11', '22', 'Q2', '91.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('141', '11', '22', 'Q3', '92.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('142', '11', '22', 'Q4', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('143', '11', '23', 'Q1', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('144', '11', '23', 'Q2', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('145', '11', '23', 'Q3', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('146', '11', '23', 'Q4', '88.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('147', '11', '24', 'Q1', '80.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('148', '11', '24', 'Q2', '81.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('149', '11', '24', 'Q3', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('150', '11', '24', 'Q4', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('151', '12', '25', 'Q1', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('152', '12', '25', 'Q2', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('153', '12', '25', 'Q3', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('154', '12', '25', 'Q4', '88.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('155', '12', '26', 'Q1', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('156', '12', '26', 'Q2', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('157', '12', '26', 'Q3', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('158', '12', '26', 'Q4', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('159', '12', '27', 'Q1', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('160', '12', '27', 'Q2', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('161', '12', '27', 'Q3', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('162', '12', '27', 'Q4', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('163', '12', '28', 'Q1', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('164', '12', '28', 'Q2', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('165', '12', '28', 'Q3', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('166', '12', '28', 'Q4', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('167', '12', '29', 'Q1', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('168', '12', '29', 'Q2', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('169', '12', '29', 'Q3', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('170', '12', '29', 'Q4', '88.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('171', '12', '30', 'Q1', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('172', '12', '30', 'Q2', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('173', '12', '30', 'Q3', '88.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('174', '12', '30', 'Q4', '89.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('175', '12', '31', 'Q1', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('176', '12', '31', 'Q2', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('177', '12', '31', 'Q3', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('178', '12', '31', 'Q4', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('179', '12', '32', 'Q1', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('180', '12', '32', 'Q2', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('181', '12', '32', 'Q3', '86.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('182', '12', '32', 'Q4', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('183', '13', '25', 'Q1', '80.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('184', '13', '25', 'Q2', '81.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('185', '13', '25', 'Q3', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('186', '13', '25', 'Q4', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('187', '13', '26', 'Q1', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('188', '13', '26', 'Q2', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('189', '13', '26', 'Q3', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('190', '13', '26', 'Q4', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('191', '13', '27', 'Q1', '78.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('192', '13', '27', 'Q2', '79.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('193', '13', '27', 'Q3', '80.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('194', '13', '27', 'Q4', '81.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('195', '13', '28', 'Q1', '76.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('196', '13', '28', 'Q2', '77.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('197', '13', '28', 'Q3', '78.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('198', '13', '28', 'Q4', '79.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('199', '13', '29', 'Q1', '89.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('200', '13', '29', 'Q2', '90.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('201', '13', '29', 'Q3', '91.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('202', '13', '29', 'Q4', '92.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('203', '13', '30', 'Q1', '87.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('204', '13', '30', 'Q2', '88.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('205', '13', '30', 'Q3', '89.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('206', '13', '30', 'Q4', '90.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('207', '13', '31', 'Q1', '82.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('208', '13', '31', 'Q2', '83.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('209', '13', '31', 'Q3', '84.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('210', '13', '31', 'Q4', '85.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('211', '13', '32', 'Q1', '92.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('212', '13', '32', 'Q2', '93.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('213', '13', '32', 'Q3', '94.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('214', '13', '32', 'Q4', '95.00', '2025-2026', '2', '2026-03-22 11:13:16', '2026-03-22 11:13:16');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('215', '7', '77', 'Q1', '90.00', '2025-2026', '4', '2026-03-22 11:15:37', '2026-03-22 11:15:37');
INSERT INTO `grades` (`id`, `student_id`, `subject_id`, `quarter`, `grade`, `school_year`, `encoded_by`, `created_at`, `updated_at`) VALUES ('216', '15', '93', 'Q1', '98.00', '2025-2026', '4', '2026-04-02 05:01:17', '2026-04-02 05:01:17');

DROP TABLE IF EXISTS `import_logs`;
CREATE TABLE `import_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) NOT NULL,
  `total_rows` int(11) DEFAULT 0,
  `inserted` int(11) DEFAULT 0,
  `skipped` int(11) DEFAULT 0,
  `errors` text DEFAULT NULL,
  `imported_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `imported_by` (`imported_by`),
  CONSTRAINT `import_logs_ibfk_1` FOREIGN KEY (`imported_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('1', 'student_import_template (1).csv', '3', '2', '1', '[\"Row 3 (100100100124): Section \\\"serdonyx\\\" not found, student added without section.\",\"Row 4: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '15', '2026-04-09 10:50:14');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('2', 'student_import_template (1).csv', '3', '3', '0', '[\"Row 3 (100100100124): Section \\\"serdonyx\\\" not found, student added without section.\"]', '15', '2026-04-09 10:51:48');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('3', 'student_import_template (1).csv', '3', '3', '0', NULL, '15', '2026-04-09 11:00:20');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('4', 'student_import_template (1).csv', '3', '3', '0', NULL, '15', '2026-04-10 03:07:27');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('5', 'student_import_template (1).csv', '3', '3', '0', NULL, '15', '2026-04-10 03:11:52');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('6', 'student_import_template (1).csv', '3', '3', '0', NULL, '15', '2026-04-10 03:18:35');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('7', 'student_import_template (1).csv', '3', '0', '3', '[\"Row 2 (100100100123): LRN already exists, skipped.\",\"Row 3 (100100100124): LRN already exists, skipped.\",\"Row 4 (100100100125): LRN already exists, skipped.\"]', '15', '2026-04-10 03:23:26');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('8', 'student_import_template (1).csv', '3', '3', '0', NULL, '15', '2026-04-10 03:24:29');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('9', 'ABM-12.csv', '10', '10', '0', NULL, '12', '2026-04-10 15:43:14');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('10', 'TVL-ICT-11.csv', '10', '0', '10', '[\"Row 2 (406031160004): Invalid grade level \\\"ICT-11\\\" in Strand Code. Only Grade 11 and 12 are allowed, skipped.\",\"Row 3 (130896160059): Invalid grade level \\\"ICT-11\\\" in Strand Code. Only Grade 11 and 12 are allowed, skipped.\",\"Row 4 (130890160021): Invalid grade level \\\"ICT-11\\\" in Strand Code. Only Grade 11 and 12 are allowed, skipped.\",\"Row 5 (406031160003): Invalid grade level \\\"ICT-11\\\" in Strand Code. Only Grade 11 and 12 are allowed, skipped.\",\"Row 6: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 7: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 8: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 9: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 10: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 11: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '11', '2026-04-10 15:44:40');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('11', 'HUMSS-11.csv', '10', '4', '6', '[\"Row 6: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 7: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 8: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 9: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 10: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 11: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '11', '2026-04-10 15:45:16');
INSERT INTO `import_logs` (`id`, `file_name`, `total_rows`, `inserted`, `skipped`, `errors`, `imported_by`, `created_at`) VALUES ('12', 'G10-AZURITE.csv', '17', '8', '9', '[\"Row 10: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 11: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 12: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 13: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 14: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 15: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 16: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 17: Missing required fields (LRN, name, gender, or school year), skipped.\",\"Row 18: Missing required fields (LRN, name, gender, or school year), skipped.\"]', '13', '2026-04-10 15:47:49');

DROP TABLE IF EXISTS `non_academic_indicators`;
CREATE TABLE `non_academic_indicators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `skills` text DEFAULT NULL COMMENT 'Skills assessment (free text)',
  `hobbies` text DEFAULT NULL COMMENT 'Student interests / hobbies',
  `career_preference` varchar(255) DEFAULT NULL COMMENT 'Stated career or college preference',
  `first_choice_strand_course` varchar(255) DEFAULT NULL COMMENT 'Student 1st choice strand or course (guidance: mismatch vs Top 3)',
  `technical_skill_level` enum('beginner','developing','proficient','advanced') NOT NULL DEFAULT 'developing',
  `entrance_exam_score` decimal(5,2) DEFAULT NULL,
  `entrance_exam_date` date DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `non_academic_indicators_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `non_academic_indicators_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `career_preference`, `first_choice_strand_course`, `technical_skill_level`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('1', '9', 'coding, robotics, math problem solving', 'science fair, programming, gadgets', 'Engineering or IT in college', 'STEM', 'proficient', '88.50', NULL, '5', '2026-03-22 11:13:17', '2026-03-23 08:15:05');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `career_preference`, `first_choice_strand_course`, `technical_skill_level`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('2', '10', 'cooking, sewing, handicrafts', 'baking, crafts, cooking experiments, gardening', 'Hospitality or culinary arts', 'TVL - Cookery', 'developing', '76.00', NULL, NULL, '2026-03-22 11:13:17', '2026-03-22 11:13:17');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `career_preference`, `first_choice_strand_course`, `technical_skill_level`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('3', '11', 'creative writing, public speaking, debating', 'reading, journalism, theater, social media', 'Law, communication, or education', 'HUMSS', 'proficient', '85.00', '2026-03-31', '5', '2026-03-22 11:13:17', '2026-04-03 12:25:43');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `career_preference`, `first_choice_strand_course`, `technical_skill_level`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('4', '12', 'drawing, music, research, organizing', 'painting, playing guitar, reading, volunteering', 'Flexible / undecided college program', NULL, 'developing', '80.00', NULL, NULL, '2026-03-22 11:13:17', '2026-03-22 11:13:17');
INSERT INTO `non_academic_indicators` (`id`, `student_id`, `skills`, `hobbies`, `career_preference`, `first_choice_strand_course`, `technical_skill_level`, `entrance_exam_score`, `entrance_exam_date`, `updated_by`, `created_at`, `updated_at`) VALUES ('5', '13', 'selling, negotiating, organizing events', 'business, trading, basketball, cooking', 'Business or entrepreneurship', 'ABM', 'proficient', '79.50', NULL, '5', '2026-03-22 11:13:17', '2026-04-06 08:57:11');

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) DEFAULT 'info',
  `is_read` tinyint(1) DEFAULT 0,
  `related_id` int(11) DEFAULT NULL,
  `related_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user` (`user_id`,`is_read`),
  KEY `idx_notifications_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `related_id`, `related_type`, `created_at`) VALUES ('1', '4', 'Support Ticket Resolved', 'Your support ticket \"Edit Button in sections\" has been marked as resolved. Admin reply: done', 'success', '1', '1', 'support_ticket', '2026-04-09 03:36:27');

DROP TABLE IF EXISTS `sections`;
CREATE TABLE `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section_name` varchar(50) NOT NULL,
  `grade_level` int(11) NOT NULL,
  `strand` varchar(50) DEFAULT NULL,
  `adviser_id` int(11) DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_section` (`section_name`,`grade_level`,`school_year`),
  KEY `adviser_id` (`adviser_id`),
  CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('1', 'Ruby', '7', NULL, '4', '2025-2026', '2026-04-09 02:42:53');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('2', 'Emerald', '8', NULL, '4', '2025-2026', '2026-04-09 02:43:05');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('3', 'Sardonyx', '9', NULL, '4', '2025-2026', '2026-04-09 02:43:22');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('4', 'Azurite', '10', NULL, '13', '2025-2026', '2026-04-09 02:43:35');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('5', 'Section B', '11', 'ABM', '4', '2025-2026', '2026-04-09 02:48:27');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('6', 'Section A', '11', 'ARTS', '4', '2025-2026', '2026-04-09 02:49:07');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('7', 'Section C', '11', 'GAS', '4', '2025-2026', '2026-04-09 02:56:18');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('8', 'Section D', '11', 'HUMSS', '4', '2025-2026', '2026-04-09 02:56:31');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('9', 'Section E', '11', 'STEM', '4', '2025-2026', '2026-04-09 02:56:45');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('10', 'Section F', '11', 'SPORTS', '4', '2025-2026', '2026-04-09 02:56:58');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('11', 'Section G', '11', 'TVL-HE', '4', '2025-2026', '2026-04-09 02:57:12');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('12', 'Section H', '11', 'TVL-ICT', '4', '2025-2026', '2026-04-09 02:57:24');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('13', 'Section I', '11', 'TVL-IA', '4', '2025-2026', '2026-04-09 02:57:37');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('14', 'Section A', '12', 'ABM', '4', '2025-2026', '2026-04-09 02:57:49');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('15', 'Section B', '12', 'ARTS', '4', '2025-2026', '2026-04-09 02:58:03');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('16', 'Section C', '12', 'GAS', '4', '2025-2026', '2026-04-09 02:58:15');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('17', 'Section D', '12', 'HUMSS', '4', '2025-2026', '2026-04-09 02:58:32');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('18', 'Section E', '12', 'STEM', '4', '2025-2026', '2026-04-09 02:58:52');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('19', 'Section F', '12', 'SPORTS', '4', '2025-2026', '2026-04-09 02:59:06');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('20', 'Section G', '12', 'TVL-HE', '4', '2025-2026', '2026-04-09 02:59:19');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('21', 'Section H', '12', 'TVL-ICT', '4', '2025-2026', '2026-04-09 02:59:47');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('22', 'Section I', '12', 'TVL-IA', '4', '2025-2026', '2026-04-09 03:00:02');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('23', 'Section Test', '7', NULL, '15', '2025-2026', '2026-04-09 10:57:34');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('24', 'A1', '12', 'ABM', '12', '2025-2026', '2026-04-10 15:54:28');
INSERT INTO `sections` (`id`, `section_name`, `grade_level`, `strand`, `adviser_id`, `school_year`, `created_at`) VALUES ('25', 'B1', '11', 'HUMSS', '11', '2025-2026', '2026-04-10 15:54:54');

DROP TABLE IF EXISTS `strand_course_mapping`;
CREATE TABLE `strand_course_mapping` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `strand_id` int(11) NOT NULL,
  `course_name` varchar(150) NOT NULL,
  `career_pathway` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_strand_course` (`strand_id`,`course_name`),
  CONSTRAINT `strand_course_mapping_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('1', '1', 'BS Computer Science', 'Software Development / IT Industry', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('2', '1', 'BS Information Technology', 'Systems Administration / Web Development', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('3', '1', 'BS Civil Engineering', 'Construction / Infrastructure', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('4', '1', 'BS Mechanical Engineering', 'Manufacturing / Automotive', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('5', '1', 'BS Electrical Engineering', 'Power / Electronics Industry', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('6', '1', 'BS Nursing', 'Healthcare / Medical', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('7', '1', 'BS Mathematics', 'Education / Research / Data Science', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('8', '2', 'BS Accountancy', 'Auditing / Finance', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('9', '2', 'BS Business Administration', 'Corporate Management / Entrepreneurship', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('10', '2', 'BS Marketing Management', 'Advertising / Sales / Digital Marketing', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('11', '2', 'BS Customs Administration', 'Import-Export / Logistics', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('12', '2', 'BS Hospitality Management', 'Hotel / Restaurant Industry', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('13', '3', 'BA Communication', 'Media / Journalism / Public Relations', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('14', '3', 'BA Political Science', 'Law / Government / Diplomacy', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('15', '3', 'BA Psychology', 'Counseling / Human Resources', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('16', '3', 'BA Sociology', 'Social Work / Community Development', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('17', '3', 'AB English', 'Education / Writing / Translation', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('18', '4', 'Any Bachelor Degree', 'Flexible - Multiple Career Options', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('19', '5', 'BS Information Technology', 'Web Development / Systems Admin', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('20', '5', 'BS Computer Science', 'Software Engineering / Programming', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('21', '6', 'BS Hotel & Restaurant Management', 'Hospitality Industry', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('22', '6', 'BS Tourism Management', 'Travel / Tourism Industry', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('23', '7', 'BS Industrial Technology', 'Manufacturing / Technical Work', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('24', '8', 'BS Physical Education', 'Sports Management / Coaching', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('25', '8', 'BS Sports Science', 'Athletic Training / Fitness', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('26', '9', 'BFA Fine Arts', 'Visual Arts / Gallery Management', '2026-03-22 11:13:15');
INSERT INTO `strand_course_mapping` (`id`, `strand_id`, `course_name`, `career_pathway`, `created_at`) VALUES ('27', '9', 'BS Multimedia Arts', 'Digital Media / Animation / Graphic Design', '2026-03-22 11:13:15');

DROP TABLE IF EXISTS `strands`;
CREATE TABLE `strands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `strand_code` varchar(20) NOT NULL,
  `strand_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `strand_code` (`strand_code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('1', 'STEM', 'Science, Technology, Engineering and Mathematics', 'Focus on advanced math, science, and technology subjects', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('2', 'ABM', 'Accountancy, Business and Management', 'Focus on business, finance, and management subjects', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('3', 'HUMSS', 'Humanities and Social Sciences', 'Focus on liberal arts, social sciences, and communication', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('4', 'GAS', 'General Academic Strand', 'Broad academic foundation across disciplines', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('5', 'TVL-ICT', 'Technical-Vocational-Livelihood: ICT', 'Focus on Information and Communications Technology', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('6', 'TVL-HE', 'Technical-Vocational-Livelihood: Home Economics', 'Focus on Home Economics and hospitality', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('7', 'TVL-IA', 'Technical-Vocational-Livelihood: Industrial Arts', 'Focus on Industrial Arts and technical skills', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('8', 'SPORTS', 'Sports Track', 'Focus on sports science, fitness, and athletics', '2026-03-22 11:13:14');
INSERT INTO `strands` (`id`, `strand_code`, `strand_name`, `description`, `created_at`) VALUES ('9', 'ARTS', 'Arts and Design Track', 'Focus on creative arts, media, and design', '2026-03-22 11:13:14');

DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lrn` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(100) DEFAULT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `birthdate` date DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `strand_id` int(11) DEFAULT NULL,
  `strand` varchar(50) DEFAULT NULL COMMENT 'Strand code (e.g., STEM, ABM, HUMSS)',
  `grade_level` int(11) DEFAULT NULL COMMENT 'Grade level (11 or 12 for SHS)',
  `school_year` varchar(20) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `status` enum('active','inactive','graduated') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `lrn` (`lrn`),
  KEY `section_id` (`section_id`),
  KEY `strand_id` (`strand_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_grade_level` (`grade_level`),
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE SET NULL,
  CONSTRAINT `students_ibfk_2` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL,
  CONSTRAINT `students_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('1', '100100100001', 'Juan', 'Dela Cruz', 'Santos', NULL, 'Male', '2008-03-15', '1', NULL, NULL, NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-09 03:59:28');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('2', '100100100002', 'Maria', 'Garcia', 'Reyes', NULL, 'Female', '2008-06-21', '1', NULL, NULL, NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-09 03:59:37');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('3', '100100100003', 'Pedro', 'Ramos', 'Lim', NULL, 'Male', '2008-01-10', '1', NULL, NULL, NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-09 03:59:46');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('4', '100100100004', 'Ana', 'Lopez', 'Cruz', NULL, 'Female', '2008-09-05', '2', NULL, NULL, NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-09 03:59:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('5', '100100100005', 'Carlos', 'Mendoza', 'Bautista', NULL, 'Male', '2007-12-18', '2', NULL, NULL, NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-09 03:59:53');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('6', '100100100006', 'Sofia', 'Villanueva', 'Torres', NULL, 'Female', '2008-04-22', '3', NULL, NULL, NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-09 03:59:56');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('7', '100100100007', 'Miguel', 'Aquino', 'Santos', NULL, 'Male', '2007-08-30', '3', NULL, NULL, NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-09 04:00:00');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('8', '100100100008', 'Isabella', 'Fernandez', 'Reyes', NULL, 'Female', '2008-02-14', '6', '9', 'ARTS', NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-10 03:22:00');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('9', '200200200001', 'Liam', 'Reyes', 'Cruz', NULL, 'Male', '2012-04-10', '11', '6', 'TVL-HE', NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-10 03:21:51');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('10', '200200200002', 'Chloe', 'Santos', 'Lim', NULL, 'Female', '2011-07-22', '12', '5', 'TVL-ICT', NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-10 03:21:42');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('11', '200200200003', 'Marco', 'Villanueva', 'Bautista', NULL, 'Male', '2010-09-15', '13', '7', 'TVL-IA', NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-10 03:21:30');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('12', '200200200004', 'Sophia', 'Dela Torre', 'Ramos', NULL, 'Female', '2009-11-03', '14', '2', 'ABM', NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-10 03:20:53');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('13', '200200200005', 'Nathan', 'Buenaventura', 'Garcia', NULL, 'Male', '2009-03-18', '14', '2', 'ABM', NULL, '2025-2026', NULL, 'active', '2026-03-22 11:13:15', '2026-04-10 03:21:13');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('15', '120123123123', 'Javidec', 'Monsion', 'Daylusan', 'Jr.', 'Male', '2002-09-19', '10', '8', 'SPORTS', NULL, '2025-2026', '4', 'active', '2026-04-02 04:55:48', '2026-04-10 03:21:21');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('16', '100100100123', 'Jember', 'Calay', 'Francisco', 'Jr.', 'Male', '2008-03-15', NULL, '1', 'STEM', '11', '2025-2026', '15', 'active', '2026-04-10 03:18:35', '2026-04-10 03:18:35');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('17', '100100100124', 'Vince', 'Guevarra', 'Pua', NULL, 'Male', '2008-06-21', NULL, '2', 'ABM', '12', '2025-2026', '15', 'active', '2026-04-10 03:18:35', '2026-04-10 03:18:35');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('18', '100100100125', 'Ledon Jay', 'Jordan', NULL, NULL, 'Male', '2007-04-22', NULL, '3', 'HUMSS', '11', '2025-2026', '15', 'active', '2026-04-10 03:18:35', '2026-04-10 03:18:35');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('19', '130894150036', 'Mohaiden', 'Dimalilay', 'Katigan', NULL, 'Male', '2009-05-25', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('20', '130806150026', 'Andrew', 'Dulang', NULL, NULL, 'Male', '2010-08-05', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('21', '468564150002', 'Yvan James', 'Espiritu', 'Ameller', NULL, 'Male', '2010-03-25', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('22', '131146120033', 'Randy', 'Jamod', 'Taban', NULL, 'Male', '2007-08-19', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('23', '130890150035', 'Rainzel Bien', 'Labayog', 'Daye', NULL, 'Male', '2010-03-01', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('24', '405896150117', 'Fiona Althea', 'Orillosa', 'Rosales', NULL, 'Female', '2009-10-29', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('25', '405882150039', 'Nica Izrah', 'Rivera', 'Sormillo', NULL, 'Female', '2010-03-05', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('26', '468521150014', 'Andy Lhurien', 'Ruba', NULL, NULL, 'Female', '2010-04-16', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('27', '130896150313', 'Joyce', 'Siacor', 'Engco', NULL, 'Female', '2010-07-10', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('28', '405708150013', 'Shekainah Kate', 'Uy', 'Castormayor', NULL, 'Female', '2010-09-23', NULL, '2', 'ABM', '12', '2025-2026', '12', 'active', '2026-04-10 15:43:14', '2026-04-10 15:43:14');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('29', '131276150664', 'Stanley', 'Kahulugan', 'Baltazar', NULL, 'Male', '2010-07-09', NULL, '3', 'HUMSS', '11', '2025-2026', '11', 'active', '2026-04-10 15:45:16', '2026-04-10 15:45:16');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('30', '406031160011', 'Rhylee', 'Magalaman', 'De Jesus', NULL, 'Male', '2011-04-01', NULL, '3', 'HUMSS', '11', '2025-2026', '11', 'active', '2026-04-10 15:45:16', '2026-04-10 15:45:16');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('31', '131007160068', 'Princess Althea Pearl', 'Esoma', 'Canlas', NULL, 'Female', '2011-07-24', NULL, '3', 'HUMSS', '11', '2025-2026', '11', 'active', '2026-04-10 15:45:16', '2026-04-10 15:45:16');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('32', '130887160012', 'Clowe-An', 'Feliz', 'Daniel', NULL, 'Female', '2011-05-11', NULL, '3', 'HUMSS', '11', '2025-2026', '11', 'active', '2026-04-10 15:45:16', '2026-04-10 15:45:16');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('33', '468543170003', 'Jayden Clark', 'Javellana', 'Jamio', NULL, 'Male', '2009-09-28', '4', NULL, NULL, NULL, '2025-2026', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('34', '406031180007', 'Paul Steven', 'Jayno', 'Flojo', NULL, 'Male', '2010-07-23', '4', NULL, NULL, NULL, '2025-2026', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('35', '404669170007', 'Kianin Dioven', 'Mulo', 'Villamor', NULL, 'Male', '2010-04-09', '4', NULL, NULL, NULL, '2025-2026', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('36', '130896150222', 'Dicky', 'Nabe', 'Lumogdang', 'Jr', 'Male', '2010-05-08', '4', NULL, NULL, NULL, '2025-2026', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('37', '405886170015', 'Arvy Klent', 'Neyra', 'Espiritu', NULL, 'Male', '2009-04-23', '4', NULL, NULL, NULL, '2025-2026', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('38', '130894170026', 'Ziara Angela', 'Taer', 'Panaha', NULL, 'Female', '2009-02-09', '4', NULL, NULL, NULL, '2025-2026', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('39', '130890170017', 'Nicole Jane', 'Tejada', 'Yunda', NULL, 'Female', '2009-06-19', '4', NULL, NULL, NULL, '2025-2026', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');
INSERT INTO `students` (`id`, `lrn`, `first_name`, `last_name`, `middle_name`, `name_suffix`, `gender`, `birthdate`, `section_id`, `strand_id`, `strand`, `grade_level`, `school_year`, `created_by`, `status`, `created_at`, `updated_at`) VALUES ('40', '130905170031', 'Angel Mae', 'Traje', 'Ramis', NULL, 'Female', '2010-10-22', '4', NULL, NULL, NULL, '2025-2027', '13', 'active', '2026-04-10 15:47:49', '2026-04-10 15:47:49');

DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(150) NOT NULL,
  `grade_level` int(11) DEFAULT NULL COMMENT 'NULL = all grade levels; 7-10 = JHS; 11-12 = SHS',
  `strand_id` int(11) DEFAULT NULL COMMENT 'NULL = applies to all strands',
  `subject_type` enum('core','specialized','applied','immersion','jhs_core','jhs_mapeh','jhs_tle','jhs_esp') NOT NULL DEFAULT 'core',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_subject_code` (`subject_code`),
  KEY `strand_id` (`strand_id`),
  CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`strand_id`) REFERENCES `strands` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('1', 'G7-ENG', 'English 7', '7', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('2', 'G7-FIL', 'Filipino 7', '7', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('3', 'G7-MAT', 'Mathematics 7', '7', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('4', 'G7-SCI', 'Science 7', '7', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('5', 'G7-AP', 'Araling Panlipunan 7', '7', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('6', 'G7-ESP', 'Edukasyon sa Pagpapakatao 7', '7', NULL, 'jhs_esp', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('7', 'G7-MAPEH', 'MAPEH 7', '7', NULL, 'jhs_mapeh', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('8', 'G7-TLE', 'Technology and Livelihood Education 7', '7', NULL, 'jhs_tle', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('9', 'G8-ENG', 'English 8', '8', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('10', 'G8-FIL', 'Filipino 8', '8', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('11', 'G8-MAT', 'Mathematics 8', '8', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('12', 'G8-SCI', 'Science 8', '8', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('13', 'G8-AP', 'Araling Panlipunan 8', '8', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('14', 'G8-ESP', 'Edukasyon sa Pagpapakatao 8', '8', NULL, 'jhs_esp', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('15', 'G8-MAPEH', 'MAPEH 8', '8', NULL, 'jhs_mapeh', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('16', 'G8-TLE', 'Technology and Livelihood Education 8', '8', NULL, 'jhs_tle', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('17', 'G9-ENG', 'English 9', '9', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('18', 'G9-FIL', 'Filipino 9', '9', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('19', 'G9-MAT', 'Mathematics 9', '9', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('20', 'G9-SCI', 'Science 9', '9', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('21', 'G9-AP', 'Araling Panlipunan 9', '9', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('22', 'G9-ESP', 'Edukasyon sa Pagpapakatao 9', '9', NULL, 'jhs_esp', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('23', 'G9-MAPEH', 'MAPEH 9', '9', NULL, 'jhs_mapeh', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('24', 'G9-TLE', 'Technology and Livelihood Education 9', '9', NULL, 'jhs_tle', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('25', 'G10-ENG', 'English 10', '10', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('26', 'G10-FIL', 'Filipino 10', '10', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('27', 'G10-MAT', 'Mathematics 10', '10', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('28', 'G10-SCI', 'Science 10', '10', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('29', 'G10-AP', 'Araling Panlipunan 10', '10', NULL, 'jhs_core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('30', 'G10-ESP', 'Edukasyon sa Pagpapakatao 10', '10', NULL, 'jhs_esp', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('31', 'G10-MAPEH', 'MAPEH 10', '10', NULL, 'jhs_mapeh', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('32', 'G10-TLE', 'Technology and Livelihood Education 10', '10', NULL, 'jhs_tle', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('33', 'CORE-ORALCOM', 'Oral Communication', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('34', 'CORE-RW', 'Reading and Writing', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('35', 'CORE-KOMFIL', 'Komunikasyon at Pananaliksik sa Wika at Kulturang Pilipino', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('36', 'CORE-GENMATH', 'General Mathematics', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('37', 'CORE-STATPROB', 'Statistics and Probability', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('38', 'CORE-ELS', 'Earth and Life Science', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('39', 'CORE-PHYSCI', 'Physical Science', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('40', 'CORE-PERDEV', 'Personal Development', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('41', 'CORE-PHILO', 'Introduction to the Philosophy of the Human Person', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('42', 'CORE-PEH1', 'Physical Education and Health 1', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('43', 'CORE-21LIT', '21st Century Literature from the Philippines and the World', '11', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('44', 'CORE-MIL', 'Media and Information Literacy', '12', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('45', 'CORE-CPAR', 'Contemporary Philippine Arts from the Regions', '12', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('46', 'CORE-UCSP', 'Understanding Culture, Society and Politics', '12', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('47', 'CORE-PAGBASA', 'Pagbasa at Pagsusuri ng Iba\'t Ibang Teksto Tungo sa Pananaliksik', '12', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('48', 'CORE-PEH2', 'Physical Education and Health 2', '12', NULL, 'core', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('49', 'APP-ETECH', 'Empowerment Technologies', '11', NULL, 'applied', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('50', 'APP-EAPP', 'English for Academic and Professional Purposes', '11', NULL, 'applied', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('51', 'APP-PR1', 'Practical Research 1', '12', NULL, 'applied', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('52', 'APP-PR2', 'Practical Research 2', '12', NULL, 'applied', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('53', 'APP-FIL', 'Filipino sa Piling Larangan', '12', NULL, 'applied', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('54', 'APP-ENTREP', 'Entrepreneurship', '12', NULL, 'applied', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('55', 'STEM-PRECAL', 'Pre-Calculus', '11', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('56', 'STEM-BIO1', 'General Biology 1', '11', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('57', 'STEM-CHEM1', 'General Chemistry 1', '11', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('58', 'STEM-PHYS1', 'General Physics 1', '11', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('59', 'STEM-BASCAL', 'Basic Calculus', '12', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('60', 'STEM-BIO2', 'General Biology 2', '12', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('61', 'STEM-CHEM2', 'General Chemistry 2', '12', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('62', 'STEM-PHYS2', 'General Physics 2', '12', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('63', 'STEM-CAPSTONE', 'Research/Capstone Project', '12', '1', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('64', 'ABM-FABM1', 'Fundamentals of ABM 1', '11', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('65', 'ABM-BMATH', 'Business Mathematics', '11', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('66', 'ABM-ORGMGMT', 'Organization and Management', '11', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('67', 'ABM-FABM2', 'Fundamentals of ABM 2', '12', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('68', 'ABM-BFIN', 'Business Finance', '12', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('69', 'ABM-MKTG', 'Principles of Marketing', '12', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('70', 'ABM-AE', 'Applied Economics', '12', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('71', 'ABM-BESR', 'Business Ethics and Social Responsibility', '12', '2', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('72', 'HUM-DISS', 'Disciplines and Ideas in the Social Sciences', '11', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('73', 'HUM-PPG', 'Philippine Politics and Governance', '11', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('74', 'HUM-IWRBS', 'Introduction to World Religions and Belief Systems', '11', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('75', 'HUM-DIASS', 'Disciplines and Ideas in Applied Social Sciences', '12', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('76', 'HUM-CNF', 'Creative Nonfiction', '12', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('77', 'HUM-CW', 'Creative Writing / Malikhaing Pagsulat', '12', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('78', 'HUM-TNCT', 'Trends, Networks and Critical Thinking', '12', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('79', 'HUM-CESC', 'Community Engagement, Solidarity and Citizenship', '12', '3', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('80', 'ICT-CP1', 'Computer Programming 1', '11', '5', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('81', 'ICT-CSS', 'Computer Systems Servicing NC II', '11', '5', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('82', 'ICT-CP2', 'Computer Programming 2', '12', '5', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('83', 'ICT-WEBDEV', 'Web Development', '12', '5', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('84', 'ICT-JAVA', 'Programming (Java / .Net)', '12', '5', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('85', 'HE-COOKERY1', 'Basic Cookery NC II', '11', '6', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('86', 'HE-BPP', 'Bread and Pastry Production NC II', '11', '6', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('87', 'HE-COOKERY2', 'Advanced Cookery NC II', '12', '6', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('88', 'HE-FBS', 'Food and Beverage Services NC II', '12', '6', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('89', 'IA-AUTO1', 'Automotive Servicing NC I', '11', '7', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('90', 'IA-PM', 'Preventive Maintenance', '11', '7', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('91', 'IA-AUTO2', 'Automotive Servicing NC II', '12', '7', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('92', 'IA-ESS', 'Engine System Servicing', '12', '7', 'specialized', '2026-04-02 03:28:59');
INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `grade_level`, `strand_id`, `subject_type`, `created_at`) VALUES ('93', 'WI-G12', 'Work Immersion', '12', NULL, 'immersion', '2026-04-02 03:28:59');

DROP TABLE IF EXISTS `support_tickets`;
CREATE TABLE `support_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `status` enum('open','in_progress','resolved') NOT NULL DEFAULT 'open',
  `admin_reply` text DEFAULT NULL,
  `replied_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `replied_by` (`replied_by`),
  KEY `idx_support_status` (`status`),
  CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `support_tickets_ibfk_2` FOREIGN KEY (`replied_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `support_tickets` (`id`, `user_id`, `subject`, `message`, `status`, `admin_reply`, `replied_by`, `created_at`, `updated_at`) VALUES ('1', '4', 'Edit Button in sections', 'error in editing sections', 'resolved', 'done', '1', '2026-04-09 03:36:12', '2026-04-09 03:36:27');

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('1', 'school_year', '2025-2026', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('2', 'comp_weak_threshold', '75', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('3', 'comp_at_risk_min', '75', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('4', 'comp_at_risk_max', '79', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('5', 'comp_proficient_min', '80', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('6', 'emp_moderate_min', '75', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('7', 'emp_high_min', '80', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('8', 'emp_very_high_min', '90', '2026-03-22 11:13:14');
INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES ('9', 'framework_notes', 'Maintain DepEd K to 12 alignment. Update strand descriptions when curriculum changes. Teachers encode grades; administrators do not access student academic records.', '2026-03-22 11:13:14');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` enum('admin','teacher','guidance') NOT NULL DEFAULT 'teacher',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `unique_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('1', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin@steps.edu', 'admin', 'active', '2026-03-22 11:13:14', '2026-03-22 11:13:14');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('2', 'teacher_santos', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Maria Santos', 'maria@steps.edu', 'teacher', 'inactive', '2026-03-22 11:13:14', '2026-04-09 10:12:53');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('3', 'teacher_delos_reyes', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Carlos Delos Reyes', 'carlos@steps.edu', 'teacher', 'inactive', '2026-03-22 11:13:14', '2026-04-09 10:12:57');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('4', 'teacher_seait', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ana Cruz', 'ana@steps.edu', 'teacher', 'active', '2026-03-22 11:13:14', '2026-04-09 10:19:44');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('5', 'guidance_seait', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jose Reyes', 'jose@steps.edu', 'guidance', 'active', '2026-03-22 11:13:14', '2026-04-09 10:15:15');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('6', 'guidance_mendoza', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sofia Mendoza', 'sofia@steps.edu', 'guidance', 'inactive', '2026-03-22 11:13:14', '2026-04-09 10:12:43');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('8', 'guidance_ugalinan', '$2y$10$l4TcLvv8w32S4x9oImCT7.ZUwzV.mcgBPFd9kXZD9XGMqXQJjQsye', 'Sarifah Ugalinan', 'ugalinanSarifah15@gmail.com', 'guidance', 'active', '2026-04-09 10:12:34', '2026-04-09 10:12:34');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('9', 'guidance_hambala', '$2y$10$PFPpkn7AVaKrr71WmfdNM.hzN1YEkNxe1YN4x7cjtUHqSQVvx.ruO', 'Alfred Hambala', 'hambalaAlfred123@gmail.com', 'guidance', 'active', '2026-04-09 10:13:49', '2026-04-09 10:13:49');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('10', 'guidance_villahermosa', '$2y$10$LLF1NEbEIeLJsPtDL8tMHOngMWz.3/xQRB/auRs/6PVImXPGKb6Ty', 'Mariann Daphne Villahermosa', 'villahermosaMD@gmail.com', 'guidance', 'active', '2026-04-09 10:15:00', '2026-04-09 10:15:00');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('11', 'teacher_bulo', '$2y$10$ZLiqIKf.FQz5dh8LJx6e2O3Xg2JzqlEtbcqAKYMWMp4tkcho5pEDy', 'Joann Bulo', 'bulojoann123@gmail.com', 'teacher', 'active', '2026-04-09 10:18:21', '2026-04-10 15:44:11');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('12', 'teacher_cangayda', '$2y$10$nZ0NuAxZ6GhKgXjIzd2M3.7sVQ6MN53frwEKDKCbOYVgTtTqkTgJK', 'Jearanie Cangayda', 'cangaydaJea@gmail.com', 'teacher', 'active', '2026-04-09 10:19:10', '2026-04-09 10:23:33');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('13', 'teacher_castromayor', '$2y$10$xobLS/DS4qb/390BsfyfKuyMOhxmZWgV5r5ndwoCebSChT3pa.rHm', 'Sheena Mae Castromayor', 'castromayorShemae23@gmail.com', 'teacher', 'active', '2026-04-09 10:20:31', '2026-04-10 15:47:13');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('14', 'teacher_bulo1', '$2y$10$K8K0UbQCva8ip7xdP.fIDOTQqL8OoTSV4gaI.faPDtsEqmQoW2H8K', 'Joann Bulo', 'bulojoann123@gmail.com', 'teacher', 'inactive', '2026-04-09 10:27:41', '2026-04-09 13:31:02');
INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `updated_at`) VALUES ('15', 'teacher_monsion', '$2y$10$eE0SZghEUpeQ8p5/8eINd.w2cs8GdWF6kvBoC.p1C4jV6FvPPGvFu', 'Javidec Monsion', 'javidecdaylusan@gmail.com', 'teacher', 'active', '2026-04-09 10:33:07', '2026-04-09 10:33:07');

DROP TABLE IF EXISTS `work_immersion`;
CREATE TABLE `work_immersion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `company_name` varchar(150) DEFAULT NULL,
  `rating` decimal(5,2) NOT NULL,
  `hours_completed` int(11) NOT NULL DEFAULT 0,
  `performance_remarks` text DEFAULT NULL,
  `school_year` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_work_immersion_student_year` (`student_id`,`school_year`),
  CONSTRAINT `work_immersion_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 1;

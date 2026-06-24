CREATE TABLE IF NOT EXISTS `cc_job_progress` (
  `citizenid` varchar(64) NOT NULL,
  `job` varchar(64) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `xp` int(11) NOT NULL DEFAULT 0,
  `completed` int(11) NOT NULL DEFAULT 0,
  `earned` bigint(20) NOT NULL DEFAULT 0,
  `streak` int(11) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`citizenid`, `job`),
  KEY `idx_job_xp` (`job`, `xp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

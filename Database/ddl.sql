-- followcheck2.migration_delete_tweets definition

CREATE TABLE `migration_delete_tweets` (
  `migration_service_user_id` varchar(10) NOT NULL,
  `migration_user_id` varchar(70) NOT NULL,
  `migration_tweet_id` varchar(50) NOT NULL,
  PRIMARY KEY (`migration_service_user_id`,`migration_user_id`,`migration_tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- followcheck2.migration_keep_tweets definition

CREATE TABLE `migration_keep_tweets` (
  `migration_service_user_id` varchar(10) NOT NULL,
  `migration_tweet_id` varchar(50) NOT NULL,
  PRIMARY KEY (`migration_service_user_id`,`migration_tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- followcheck2.running_batches definition

CREATE TABLE `running_batches` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `batch_name` varchar(100) NOT NULL,
  `running_name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- followcheck2.twitter_accounts definition

CREATE TABLE `twitter_accounts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `disp_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `thumbnail_path` varchar(200) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `theme_color` varchar(10) DEFAULT NULL,
  `follow` int(10) unsigned NOT NULL DEFAULT 0,
  `follower` int(10) unsigned NOT NULL DEFAULT 0,
  `locked` bit(1) NOT NULL DEFAULT b'0',
  `protected` bit(1) NOT NULL DEFAULT b'0',
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_user_id` varchar(70) NOT NULL,
  `migration_iceceam` tinyint(4) NOT NULL,
  `migration_not_found` tinyint(4) NOT NULL,
  `migration_protected` tinyint(4) NOT NULL,
  `icecream_datetime` varchar(19) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `twitter_accounts_UN` (`migration_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=548939 DEFAULT CHARSET=utf8mb4;


-- followcheck2.users definition

CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mail_address` varchar(100) NOT NULL,
  `password_hash` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_service_user_id` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_UN` (`migration_service_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;


-- followcheck2.configurations definition

CREATE TABLE `configurations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `value` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `configurations_FK` (`user_id`),
  CONSTRAINT `configurations_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- followcheck2.profile_icons definition

CREATE TABLE `profile_icons` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `twitter_account_id` bigint(20) unsigned DEFAULT NULL,
  `url` varchar(400) NOT NULL,
  `directory_path` varchar(150) DEFAULT NULL,
  `file_name` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_user_id` varchar(70) NOT NULL,
  `migartion_sequence` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile_icons_UN` (`migration_user_id`,`migartion_sequence`),
  KEY `profile_icons_FK` (`twitter_account_id`),
  CONSTRAINT `profile_icons_FK` FOREIGN KEY (`twitter_account_id`) REFERENCES `twitter_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=514570 DEFAULT CHARSET=utf8mb4;


-- followcheck2.take_twitter_accounts definition

CREATE TABLE `take_twitter_accounts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `twitter_account_id` bigint(20) unsigned DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `took_at` datetime DEFAULT NULL,
  `continue_row_status_id` varchar(50) DEFAULT NULL,
  `not_long_time_tweeted` bigint(20) NOT NULL DEFAULT 0,
  `take_canceled` bigint(20) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_sevice_user_id` varchar(10) NOT NULL,
  `migration_user_id` varchar(70) NOT NULL,
  `migration_status` varchar(2) NOT NULL,
  `migation_not_tweeted_longtime` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `take_twitter_accounts_UN` (`migration_sevice_user_id`,`migration_user_id`),
  KEY `take_twitter_accounts_FK_1` (`twitter_account_id`),
  KEY `take_twitter_accounts_FK` (`user_id`),
  CONSTRAINT `take_twitter_accounts_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `take_twitter_accounts_FK_1` FOREIGN KEY (`twitter_account_id`) REFERENCES `twitter_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7304 DEFAULT CHARSET=utf8mb4;


-- followcheck2.tweets definition

CREATE TABLE `tweets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `take_twitter_account_id` bigint(20) unsigned DEFAULT NULL,
  `raw_status_id` varchar(100) DEFAULT NULL,
  `body` varchar(500) NOT NULL,
  `favorites` int(10) unsigned NOT NULL DEFAULT 0,
  `retweets` int(10) unsigned NOT NULL DEFAULT 0,
  `replied` bit(1) NOT NULL DEFAULT b'0',
  `retweeted` bit(1) NOT NULL DEFAULT b'0',
  `media_posted` bit(1) NOT NULL DEFAULT b'0',
  `media_readied` bit(1) NOT NULL DEFAULT b'0',
  `kept` bit(1) NOT NULL DEFAULT b'0',
  `showed` bit(1) NOT NULL DEFAULT b'0',
  `tweeted_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_service_user_id` varchar(10) NOT NULL,
  `migration_user_id` varchar(70) NOT NULL,
  `migration_tweet_id` varchar(50) NOT NULL,
  `migation_tweet_user_id` varchar(70) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tweets_UN` (`migration_service_user_id`,`migration_user_id`,`migration_tweet_id`),
  KEY `tweets_FK` (`take_twitter_account_id`),
  CONSTRAINT `tweets_FK` FOREIGN KEY (`take_twitter_account_id`) REFERENCES `take_twitter_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1790394 DEFAULT CHARSET=utf8mb4;


-- followcheck2.user_tokens definition

CREATE TABLE `user_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `token` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_tokens_FK` (`user_id`),
  CONSTRAINT `user_tokens_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- followcheck2.tweet_medias definition

CREATE TABLE `tweet_medias` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` bigint(20) unsigned DEFAULT NULL,
  `url` varchar(400) DEFAULT NULL,
  `type` varchar(30) NOT NULL,
  `sizes` varchar(30) NOT NULL,
  `bitrate` varchar(15) DEFAULT NULL,
  `directory_path` varchar(100) DEFAULT NULL,
  `file_name` varchar(100) DEFAULT NULL,
  `bytes` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_service_user_id` varchar(10) NOT NULL,
  `migration_user_id` varchar(70) NOT NULL,
  `migrartion_tweet_id` varchar(50) NOT NULL,
  `migration_url` varchar(400) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tweet_medias_UN` (`migration_service_user_id`,`migration_user_id`,`migrartion_tweet_id`,`migration_url`),
  KEY `tweet_medias_FK` (`tweet_id`),
  CONSTRAINT `tweet_medias_FK` FOREIGN KEY (`tweet_id`) REFERENCES `tweets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1581243 DEFAULT CHARSET=utf8mb4;


-- followcheck2.tweet_media_compress_queues definition

CREATE TABLE `tweet_media_compress_queues` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_media_id` bigint(20) unsigned NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `running_name` varchar(100) DEFAULT NULL,
  `error_text` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_sevice_user_id` varchar(10) NOT NULL,
  `migration_user_id` varchar(70) NOT NULL,
  `migration_tweet_id` varchar(50) NOT NULL,
  `migration_url` varchar(400) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tweet_media_compress_queues_UN` (`migration_sevice_user_id`,`migration_user_id`,`migration_tweet_id`,`migration_url`),
  KEY `tweet_media_compress_queues_FK` (`tweet_media_id`),
  CONSTRAINT `tweet_media_compress_queues_FK` FOREIGN KEY (`tweet_media_id`) REFERENCES `tweet_medias` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- followcheck2.tweet_media_download_queues definition

CREATE TABLE `tweet_media_download_queues` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_media_id` bigint(20) unsigned NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `running_name` varchar(100) DEFAULT NULL,
  `error_text` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `migration_sevice_user_id` varchar(10) NOT NULL,
  `migration_user_id` varchar(70) NOT NULL,
  `migration_tweet_id` varchar(50) NOT NULL,
  `migration_url` varchar(400) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tweet_media_download_queues_UN` (`migration_sevice_user_id`,`migration_user_id`,`migration_tweet_id`,`migration_url`),
  KEY `tweet_media_download_queues_FK` (`tweet_media_id`),
  CONSTRAINT `tweet_media_download_queues_FK` FOREIGN KEY (`tweet_media_id`) REFERENCES `tweet_medias` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
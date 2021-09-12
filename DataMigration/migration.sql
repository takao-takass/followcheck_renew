-- MIGRATION twitter_accounts.
UPDATE twitter_accounts 
SET locked = CASE migration_iceceam WHEN 0 THEN 0 ELSE 1 END,
    protected = CASE migration_protected WHEN 0 THEN 0 ELSE 1 END,
    deleted = CASE migration_not_found WHEN 0 THEN 0 ELSE 1 END;

-- MIGRATION profile_icons.
UPDATE profile_icons p
SET p.twitter_account_id = (
        SELECT id
        FROM twitter_accounts t
        WHERE t.migration_user_id = p.migration_user_id
        LIMIT 1
    );

-- MIGRTION take_twitter_accounts.
UPDATE take_twitter_accounts tta
SET tta.user_id = (
        SELECT u.id
        FROM users u
        WHERE u.migration_service_user_id = tta.migration_sevice_user_id
        LIMIT 1
    ),
    tta.twitter_account_id = (
        SELECT ta.id
        FROM twitter_accounts ta
        WHERE ta.migration_user_id = tta.migration_user_id
        LIMIT 1
    ),
    tta.status = 0,
    tta.not_long_time_tweeted = CASE tta.migation_not_tweeted_longtime WHEN 0 THEN 0 ELSE 1 END,
    tta.take_canceled = CASE tta.migration_status WHEN 'D' THEN 1 ELSE 0 END;

-- MIGRATION tweets.    
UPDATE tweets t 
SET t.take_twitter_account_id = (
        SELECT tta.id 
        FROM take_twitter_accounts tta 
        INNER JOIN twitter_accounts ta 
        ON tta.twitter_account_id = ta.id 
        INNER JOIN users u 
        ON tta.user_id = u.id 
        WHERE ta.migration_user_id = t.migration_user_id 
        AND u.migration_service_user_id = t.migration_service_user_id
        LIMIT 1
    ),
    t.raw_status_id = migration_tweet_id,
    t.kept = (
        CASE (
            SELECT COUNT(*)
            FROM migration_keep_tweets mkt
            WHERE mkt.migration_service_user_id = t.migration_service_user_id 
            AND mkt.migration_tweet_id = t.migration_tweet_id
        ) WHEN 0 THEN 0 ELSE 1 END
    ),
    t.showed = (
        CASE (
            SELECT COUNT(*)
            FROM migration_delete_tweets mdt
            WHERE mdt.migration_service_user_id = t.migration_service_user_id 
            AND mdt.migration_user_id = t.migration_user_id 
            AND mdt.migration_tweet_id = t.migration_tweet_id
        ) WHEN 0 THEN 0 ELSE 1 END
    );

-- MIGRATION tweet_medias.
UPDATE tweet_medias tm 
SET tm.tweet_id = (
        SELECT t.id 
        FROM tweets t
        WHERE t.migration_service_user_id = tm.migration_service_user_id 
        AND t.migration_user_id = tm.migration_user_id 
        AND t.migration_tweet_id = tm.migrartion_tweet_id 
        LIMIT 1
    ),
    tm.url = tm.migration_url;
    

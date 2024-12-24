-- Drop existing tables to avoid duplicates
SET FOREIGN_KEY_CHECKS = 0; -- Disable foreign key checks
DROP TABLE IF EXISTS WATCHED_HISTORY;
DROP TABLE IF EXISTS RATING_AND_REVIEW;
DROP TABLE IF EXISTS VOICE_ACTOR;
DROP TABLE IF EXISTS EPISODES;
DROP TABLE IF EXISTS ANIME_SERIES;
DROP TABLE IF EXISTS STUDIO;
DROP TABLE IF EXISTS ANIME_GENRE;
DROP TABLE IF EXISTS USER;
SET FOREIGN_KEY_CHECKS = 1; -- Re-enable foreign key checks

-- Create USER table with additional fields
CREATE TABLE IF NOT EXISTS `USER` (
    `USER_ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `register_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `watchlist` TEXT NULL
);

-- Create STUDIO table with location details
CREATE TABLE IF NOT EXISTS `STUDIO` (
    `studio_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `studio_name` VARCHAR(100) NOT NULL,
    `location` VARCHAR(100),
    `contact_info` VARCHAR(255) NULL
);

-- Create ANIME_SERIES table with foreign key referencing STUDIO
CREATE TABLE IF NOT EXISTS `ANIME_SERIES` (
    `anime_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `anime_title` VARCHAR(100) NOT NULL,
    `release_date` DATE NOT NULL,
    `studio_id` INT NOT NULL,
    `image_url` VARCHAR(255) NULL,
    FOREIGN KEY (studio_id) REFERENCES `STUDIO`(studio_id) ON DELETE CASCADE
);

-- Create a junction table for anime-genre many-to-many relationship
CREATE TABLE IF NOT EXISTS `ANIME_GENRE` (
    `anime_id` INT NOT NULL,
    `genre_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`anime_id`, `genre_name`),
    FOREIGN KEY (`anime_id`) REFERENCES `ANIME_SERIES`(`anime_id`) ON DELETE CASCADE
);

-- Create RATING_AND_REVIEW table for user reviews and ratings
CREATE TABLE IF NOT EXISTS `RATING_AND_REVIEW` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `USER_ID` INT NOT NULL,
    `anime_id` INT NOT NULL,
    `score` INT CHECK (`score` BETWEEN 1 AND 10),
    `review_text` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (USER_ID) REFERENCES `USER`(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES `ANIME_SERIES`(anime_id) ON DELETE CASCADE
);

-- Create EPISODES table to track episodes of each anime
CREATE TABLE IF NOT EXISTS `EPISODES` (
    `episode_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `anime_id` INT NOT NULL,
    `air_date` DATE NOT NULL,
    `episode_num` INT NOT NULL,
    `episode_title` VARCHAR(100),
    FOREIGN KEY (anime_id) REFERENCES `ANIME_SERIES`(anime_id) ON DELETE CASCADE
);

-- Create WATCHED_HISTORY table to track user's watch history
CREATE TABLE IF NOT EXISTS `WATCHED_HISTORY` (
    `watched_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `USER_ID` INT NOT NULL,
    `anime_id` INT NOT NULL,
    `last_watched_episode` INT,
    `last_watched_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (USER_ID) REFERENCES `USER`(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES `ANIME_SERIES`(anime_id) ON DELETE CASCADE
);

-- Create VOICE_ACTOR table for voice actor and character association
CREATE TABLE IF NOT EXISTS `VOICE_ACTOR` (
    `actor_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `actor_name` VARCHAR(100) NOT NULL,
    `character_name` VARCHAR(100),
    `anime_id` INT NOT NULL,
    FOREIGN KEY (anime_id) REFERENCES `ANIME_SERIES`(anime_id) ON DELETE CASCADE
);

ALTER TABLE ANIME_SERIES
ADD COLUMN thumbnail VARCHAR(255);

-- Insert Users
INSERT INTO USER (username, password, email, watchlist) VALUES
('animefan1', 'password123', 'animefan1@example.com', ''),
('otaku_girl', 'password321', 'otaku_girl@example.com', ''),
('narutofan', 'leafvillage1', 'narutofan@example.com', ''),
('mangareader', 'onepieceislife', 'mangareader@example.com', ''),
('admin1', 'admin1', 'admin1@example.com', ''),
('dbzlover', 'sayianpower', 'dbzlover@example.com', ''),
('otakumaster', 'powerlevel999', 'otakumaster@example.com', ''),
('cosplayer01', 'cosplayfan', 'cosplayer01@example.com', ''),
('gokufan', 'kakarot123', 'gokufan@example.com', ''),
('sailormoonfan', 'moonlight321', 'sailormoonfan@example.com', '');

-- Insert Studios
INSERT INTO STUDIO (studio_name, location, contact_info) VALUES
('MAPPA', 'Tokyo, Japan', 'contact@mappa.jp'),
('Toei Animation', 'Tokyo, Japan', 'contact@toeianimation.com'),
('Studio Pierrot', 'Mitaka, Tokyo', 'contact@studiopierrot.jp'),
('Bones', 'Osaka, Japan', 'contact@bones.co.jp'),
('Kyoto Animation', 'Uji, Kyoto', 'contact@kyotoanimation.co.jp'),
('Madhouse', 'Tokyo, Japan', 'contact@madhouse.co.jp'),
('A-1 Pictures', 'Suginami, Tokyo', 'contact@a1pictures.com'),
('Sunrise', 'Tachikawa, Tokyo', 'contact@sunrise-inc.co.jp'),
('Studio Ghibli', 'Koganei, Tokyo', 'contact@ghibli.jp'),
('Trigger', 'Suginami, Tokyo', 'contact@trigger.jp');

-- Insert Anime Series
INSERT INTO ANIME_SERIES (anime_title, release_date, studio_id, image_url) VALUES
('Attack on Titan', '2013-04-07', 1, '"static/Images/attack_titan.jpg"'),
('Naruto', '2002-10-03', 2, '"static/Images/naruto.jpg"'),
('One Piece', '1999-10-20', 3, '"static/Images/one-piece.jpg"'),
('Demon Slayer', '2019-04-06', 4, '"static/Images/demon-slayer.jpg"'),
('My Hero Academia', '2016-04-03', 5, '"static/Images/my-hero-academia.jpg"'),
('Fullmetal Alchemist: Brotherhood', '2009-04-05', 6, '"static/Images/fullmetal-alchemist.jpg"'),
('Sword Art Online', '2012-07-08', 7, '"static/Images/sword-art-online.jpg"'),
('Mobile Suit Gundam', '1979-04-07', 8, '"static/Images/mobile-suit-gundam.jpg"'),
('Spirited Away', '2001-07-20', 9, '"static/Images/spirited-away.jpg"'),
('Promare', '2019-05-24', 10, '"static/Images/promare.jpg"');

-- Insert Anime Genre (No duplicates)
INSERT INTO ANIME_GENRE (anime_id, genre_name) VALUES
(1, 'Action'),
(2, 'Adventure'),
(3, 'Fantasy'),
(4, 'Action'),
(5, 'Superhero'),
(6, 'Drama'),
(7, 'Sci-Fi'),
(8, 'Mecha'),
(9, 'Fantasy'),
(10, 'Action');

-- Insert Rating and Review
INSERT INTO RATING_AND_REVIEW (USER_ID, anime_id, score, review_text) VALUES
(1, 1, 9, 'Great anime with intense action!'),
(2, 2, 8, 'A classic! Could use better pacing.'),
(3, 3, 10, 'Amazing world-building and characters!'),
(4, 4, 9, 'Incredible fight scenes and animation!'),
(5, 5, 8, 'Great character development and story!'),
(6, 6, 10, 'A masterpiece with deep themes!'),
(7, 7, 9, 'Interesting premise and beautiful animation.'),
(8, 8, 8, 'Epic battles but could use more character depth.'),
(9, 9, 10, 'A magical and touching film!'),
(10, 10, 9, 'Visually stunning with an amazing soundtrack.');

-- Insert Episodes
INSERT INTO EPISODES (anime_id, air_date, episode_num, episode_title) VALUES
(1, '2013-04-07', 1, 'To You, in 2000 Years'),
(2, '2002-10-03', 1, 'Enter: Naruto Uzumaki!'),
(3, '1999-10-20', 1, 'I’m Luffy! The Man Who’s Gonna Be King of the Pirates!'),
(4, '2019-04-06', 1, 'Cruelty'),
(5, '2016-04-03', 1, 'Izuku Midoriya: Origin'),
(6, '2009-04-05', 1, 'Fullmetal Alchemist'),
(7, '2012-07-08', 1, 'The World of Swords'),
(8, '1979-04-07', 1, 'Gundam Rising'),
(9, '2001-07-20', 1, 'The Journey to the Wasteland'),
(10, '2019-05-24', 1, 'The Burning Rescue');

-- Insert Voice Actors
INSERT INTO VOICE_ACTOR (actor_name, character_name, anime_id) VALUES
('Yuki Kaji', 'Eren Yeager', 1),
('Junko Takeuchi', 'Naruto Uzumaki', 2),
('Mayumi Tanaka', 'Monkey D. Luffy', 3),
('Natsuki Hanae', 'Tanjiro Kamado', 4),
('Daiki Yamashita', 'Izuku Midoriya', 5),
('Vic Mignogna', 'Edward Elric', 6),
('Matsuoka Yoshitsugu', 'Kirito', 7),
('Takahiro Sakurai', 'Char Aznable', 8),
('Takahata Mitsuki', 'Chihiro Ogino', 9),
('Kazuki Yao', 'Galo Thymos', 10);

-- --------------------getUploader-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getUploader //

CREATE PROCEDURE getUploader(IN videoIdIn int)
begin
  SELECT userId FROM video WHERE videoId = videoIdIn;
end//
DELIMITER ;

-- --------------------getTitle--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getTitle //

CREATE PROCEDURE getTitle(IN videoIdIn int)
begin
  SELECT title FROM video WHERE videoId = videoIdIn;
end//
DELIMITER ;

-- --------------------getDescription--------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getDescription //

CREATE PROCEDURE getDescription(IN videoIdIn int)
begin
  SELECT description FROM video WHERE videoId = videoIdIn;
end//
DELIMITER ;

-- -----------------------getVideoLikes----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getVideoLikes //

CREATE PROCEDURE getVideoLikes(IN videoIdIn int)
begin
  SELECT likes FROM video WHERE videoId = videoIdIn;
end//
DELIMITER ;

-- ----------------------getViews-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getViews //

CREATE PROCEDURE getViews(IN videoIdIn int)
begin
  SELECT views FROM video WHERE videoId = videoIdIn;
end//
DELIMITER ;

-- ----------------------getVideoFile-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getVideoFile //

CREATE PROCEDURE getVideoFile(IN videoIdIn int)
begin
  SELECT videoFile FROM video WHERE videoId = videoIdIn;
end//
DELIMITER ;

-- ----------------------getVideoCreated-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getVideoCreated //

CREATE PROCEDURE getVideoCreated(IN videoIdIn int)
begin
  SELECT created FROM video WHERE videoId = videoIdIn;
end//
DELIMITER ;

-- ----------------------setTitle-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS setTitle //

CREATE PROCEDURE setTitle(IN videoIdIn int, titleIn varchar(256))
begin
  IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
    THEN UPDATE video SET title = titleIn WHERE videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
  END IF;
end//
DELIMITER ;

-- ----------------------setDescription-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS setDescription //

CREATE PROCEDURE setDescription(IN videoIdIn int, descriptionIn varchar(1024))
begin
  IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
    THEN UPDATE video SET description = descriptionIn WHERE videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
  END IF;
end//
DELIMITER ;

-- ----------------------increaseViews-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS increaseViews //

CREATE PROCEDURE increaseViews(IN videoIdIn int)
begin
  IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
    THEN UPDATE video SET views = views + 1 WHERE videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
  END IF;
end//
DELIMITER ;

-- ----------------------increaseVideoLikes-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS increaseVideoLikes //

CREATE PROCEDURE increaseVideoLikes(IN videoIdIn int)
begin
  IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
    THEN UPDATE video SET likes = likes + 1 WHERE videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
  END IF;
end//
DELIMITER ;

-- ----------------------decreaseVideoLikes-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS decreaseVideoLikes //

CREATE PROCEDURE decreaseVideoLikes(IN videoIdIn int)
begin
  IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
    THEN UPDATE video SET likes = likes - 1 WHERE videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
  END IF;
end//
DELIMITER ;

-- ------------------------createVideo---------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS createVideo //

CREATE PROCEDURE createVideo(IN userIdIn int, titleIn varchar(256), descriptionIn varchar(1024), videoFileIn varchar(256))
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn)
    THEN INSERT INTO video (userId, title, description, likes, views, videoFile, created) VALUES (userIdIn, titleIn, descriptionIn, 0, 0, videoFileIn, NOW());
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'uploader does not exist';
  END IF;
end//
DELIMITER ;

-- ---------------------removeVideo---------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeVideo //

CREATE PROCEDURE removeVideo(IN videoIdIn int)
begin
  IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
    THEN DELETE FROM video WHERE videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
  END IF;
end//
DELIMITER ;

-- --------------------getVideos-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getVideos //

CREATE PROCEDURE getVideos()
begin
  SELECT * FROM video;
end//
DELIMITER ;
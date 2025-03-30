-- --------------------getVideoDislike-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getVideoDislike //

CREATE PROCEDURE getVideoDislike(IN videoIdIn int, userIdIn int)
begin
  SELECT dislike FROM videoLike WHERE userId = userIdIn AND videoId = videoIdIn;
end//
DELIMITER ;

-- ------------------updateVideoDislike----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS updateVideoDislike //

CREATE PROCEDURE updateVideoDislike(IN videoIdIn int, userIdIn int, likeIn boolean)
begin
  IF EXISTS(SELECT * FROM videoLike WHERE userId = userIdIn AND videoId = videoIdIn)
    THEN UPDATE videoLike SET dislike = likeIn WHERE userId = userIdIn AND videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user has not liked/disliked this video previously';
  END IF;
end//
DELIMITER ;

-- ------------------addVideoLike------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS addVideoLike //

CREATE PROCEDURE addVideoLike(IN videoIdIn int, userIdIn int, likeIn boolean)
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn)
    THEN IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
      THEN INSERT INTO videoLike (userId, videoId, dislike) VALUES (userIdIn, videoIdIn, likeIn);
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user does not exist';    
  END IF;
end//
DELIMITER ;

-- ---------------------removeVideoLike---------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeVideoLike //

CREATE PROCEDURE removeVideoLike(IN videoIdIn int, userIdIn int)
begin
  IF EXISTS(SELECT * FROM videoLike WHERE userId = userIdIn AND videoId = videoIdIn)
    THEN DELETE FROM videoLike WHERE userId = userIdIn AND videoId = videoIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user has not liked/disliked this video';
  END IF;
end//
DELIMITER ;
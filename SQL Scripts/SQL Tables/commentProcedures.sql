-- --------------------getCommenter--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getCommenter //

CREATE PROCEDURE getCommenter(IN commentIdIn int)
begin
  SELECT userId FROM comment WHERE commentId = commentIdIn;
end//
DELIMITER ;

-- --------------------getCommentVideo--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getCommentVideo //

CREATE PROCEDURE getCommentVideo(IN commentIdIn int)
begin
  SELECT videoId FROM comment WHERE commentId = commentIdIn;
end//
DELIMITER ;

-- --------------------getComment--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getComment //

CREATE PROCEDURE getComment(IN commentIdIn int)
begin
  SELECT comment FROM comment WHERE commentId = commentIdIn;
end//
DELIMITER ;

-- -------------------getCommentCreated------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getCommentCreated //

CREATE PROCEDURE getCommentCreated(IN commentIdIn int)
begin
  SELECT created FROM comment WHERE commentId = commentIdIn;
end//
DELIMITER ;


-- ------------------getCommentParent--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getCommentParent //

CREATE PROCEDURE getCommentParent(IN commentIdIn int)
begin
  IF EXISTS(SELECT * FROM comment WHERE commentId = commentIdIn AND parentCommentId IS NOT NULL)
    THEN SELECT parentCommentId FROM comment WHERE commentId = commentIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'comment does not have a parent';
  END IF;
end//
DELIMITER ;

-- ---------------------------isReply--------------------------
-- 1 if comment is a reply, 0 if it isn't
DELIMITER //
DROP PROCEDURE IF EXISTS isReply //

CREATE PROCEDURE isReply(IN commentIdIn int, OUT reply boolean)
begin
  IF EXISTS(SELECT * FROM comment WHERE commentId = commentIdIn AND parentCommentId IS NOT NULL)
    THEN SET reply = 1;
  ELSE
    SET reply = 0;
  END IF;
end//
DELIMITER ;

-- ----------------------setComment-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS setComment //

CREATE PROCEDURE setComment(IN commentIdIn int, commentIn varchar(1024))
begin
  IF EXISTS(SELECT * FROM comment WHERE commentId = commentIdIn)
    THEN UPDATE comment SET comment = commentIn WHERE commentId = commentIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'comment does not exist';
  END IF;
end//
DELIMITER ;

-- ---------------------createComment--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS createComment //

CREATE PROCEDURE createComment(IN userIdIn int, IN videoIdIn int, IN commentIn varchar(1024))
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn)
    THEN IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
      THEN INSERT INTO comment (userId, videoId, comment, created) VALUES (userIdIn, videoIdIn, commentIn, NOW());
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'commenter does not exist';
  END IF;
end//
DELIMITER ;

-- ---------------------createReply--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS createReply //

CREATE PROCEDURE createReply(IN userIdIn int, IN videoIdIn int, IN parentCommentIdIn int, commentIn varchar(1024))
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn)
    THEN IF EXISTS(SELECT * FROM video WHERE videoId = videoIdIn)
      THEN INSERT INTO comment (userId, videoId, parentCommentId, comment, created) VALUES (userIdIn, videoIdIn, parentCommentIdIn, commentIn, NOW());
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'video does not exist';
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'commenter does not exist';
  END IF;
end//
DELIMITER ;

-- ---------------------removeComment--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeComment //

CREATE PROCEDURE removeComment(IN commentIdIn int)
begin
  IF EXISTS(SELECT * FROM comment WHERE commentId = commentIdIn)
    THEN DELETE FROM comment WHERE commentId = commentIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'comment does not exist';    
  END IF;
end//
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS getVideoComments //

CREATE PROCEDURE getVideoComments(IN videoIDIn int)
BEGIN
  SELECT * FROM comments WHERE videoId = videoIDIn;
END //
DELIMITER ;
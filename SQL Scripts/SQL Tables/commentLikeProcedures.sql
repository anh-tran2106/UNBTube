-- --------------------getCommentDislike-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getCommentDislike //

CREATE PROCEDURE getCommentDislike(IN commentIdIn int, userIdIn int)
begin
  SELECT dislike FROM commentLike WHERE userId = userIdIn AND commentId = commentIdIn;
end//
DELIMITER ;

-- ------------------updateCommentDislike----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS updateCommentDislike //

CREATE PROCEDURE updateCommentDislike(IN commentIdIn int, userIdIn int, likeIn boolean)
begin
  IF EXISTS(SELECT * FROM commentLike WHERE userId = userIdIn AND commentId = commentIdIn)
    THEN UPDATE commentLike SET dislike = likeIn WHERE userId = userIdIn AND commentId = commentIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user has not liked/disliked this comment previously';
  END IF;
end//
DELIMITER ;

-- ------------------addCommentLike------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS addCommentLike //

CREATE PROCEDURE addCommentLike(IN commentIdIn int, userIdIn int, likeIn boolean)
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn)
    THEN IF EXISTS(SELECT * FROM comment WHERE commentId = commentIdIn)
      THEN INSERT INTO commentLike (userId, commentId, dislike) VALUES (userIdIn, commentIdIn, likeIn);
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'comment does not exist';
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user does not exist';    
  END IF;
end//
DELIMITER ;

-- ---------------------removeCommentLike---------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeCommentLike //

CREATE PROCEDURE removeCommentLike(IN commentIdIn int, userIdIn int)
begin
  IF EXISTS(SELECT * FROM commentLike WHERE userId = userIdIn AND commentId = commentIdIn)
    THEN DELETE FROM commentLike WHERE userId = userIdIn AND commentId = commentIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user has not liked/disliked this comment';
  END IF;
end//
DELIMITER ;
-- --------------------getAllSubsOfUser-----------------------
-- returns everyone who is subscribed to the given userId
DELIMITER //
DROP PROCEDURE IF EXISTS getAllSubsOfUser //

CREATE PROCEDURE getAllSubsOfUser(IN userIdIn int)
begin
  SELECT userId FROM subscriber WHERE subChannelId = userIdIn;
end//
DELIMITER ;

-- --------------------getAllUserSubbed-----------------------
-- returns everyone who the given userId is subscribed to
DELIMITER //
DROP PROCEDURE IF EXISTS getAllUserSubbed //

CREATE PROCEDURE getAllUserSubbed(IN userIdIn int)
begin
  SELECT subChannelId FROM subscriber WHERE userId = userIdIn;
end//
DELIMITER ;

-- --------------------getTimeSubscribed----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getTimeSubscribed //

CREATE PROCEDURE getTimeSubscribed(IN userIdIn int, subChannelIdIn int)
begin
  SELECT created FROM subscriber WHERE userId = userIdIn and subChannelId = subChannelIdIn;
end//
DELIMITER ;

-- --------------------isSubscribed----------------------
-- checks if userIdIn is subscribed to subChannelIdIn | 1 = true, 0 = false
DELIMITER //
DROP PROCEDURE IF EXISTS isSubscribed //

CREATE PROCEDURE isSubscribed(IN userIdIn int, subChannelIdIn int, OUT subscribed boolean)
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn and subChannelId = subChannelIdIn)
    THEN SET subscribed = 1;
  ELSE
    SET subscribed = 0;
  END IF;
end//
DELIMITER ;

-- --------------------addSubscriber--------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS addSubscriber //

CREATE PROCEDURE addSubscriber(IN userIdIn int, subChannelIdIn int)
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn)
    THEN IF EXISTS(SELECT * FROM user WHERE userId = subChannelIdIn)
      THEN INSERT INTO subscriber (userId, subChannelIdIn, created) VALUES (userIdIn, subChannelIdIn, NOW());
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user being subscribed to does not exist';
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user subscribing does not exist';    
  END IF;
end//
DELIMITER ;

-- -------------------removeSubscriber------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeSubscriber //

CREATE PROCEDURE removeSubscriber(IN userIdIn int, subChannelIdIn int)
begin
  IF EXISTS(SELECT * FROM user WHERE userId = userIdIn and subChannelId = subChannelIdIn)
    THEN DELETE FROM subscriber WHERE userId = userIdIn AND subChannelId = subChannelIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user was not subscribed';    
  END IF;
end//
DELIMITER ;
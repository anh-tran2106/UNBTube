-- --------------------getEmailHash-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getEmailHash //

CREATE PROCEDURE getEmailHash(IN userIdIn int)
begin
  SELECT emailHash FROM userVerification WHERE userId = userIdIn;
end//
DELIMITER ;

-- --------------------getEmailCreation-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getEmailCreation //

CREATE PROCEDURE getEmailCreation(IN userIdIn int)
begin
  SELECT created FROM userVerification WHERE userId = userIdIn;
end//
DELIMITER ;

-- --------------------createEmail-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS createEmail //

CREATE PROCEDURE createEmail(IN userIdIn int, emailHashIn varchar(256))
begin
  IF EXISTS(SELECT * FROM userVerification WHERE userId = userIdIN)
    THEN
      DELETE FROM userVerification WHERE userId = userIdIN;
  ELSE
    INSERT INTO userVerification (userId, emailHash, created) VALUES
          (userIdIn, emailHashIn, NOW());
  END IF;
end//
DELIMITER ;


-- ---------------------removeEmail---------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeEmail //

CREATE PROCEDURE removeEmail(IN userIdIn int)
begin
  IF EXISTS(SELECT * FROM userVerification WHERE userId = userIdIn)
    THEN DELETE FROM userVerification WHERE userId = userIdIn;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user does not exist';
  END IF;
end//
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS getUser //

CREATE PROCEDURE getUser(IN hashIN VARCHAR(256))
BEGIN
  SELECT * FROM userVerification WHERE emailHash = hashIN;
END //
DELIMITER ;

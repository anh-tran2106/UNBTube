-- --------------------getUsername-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getUsername //

CREATE PROCEDURE getUsername(IN userIdIn int)
begin
  SELECT username FROM user WHERE userId = userIdIn;
end//
DELIMITER ;

-- ---------------get(hashed)Password--------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getPassword //

CREATE PROCEDURE getPassword(IN userIdIn int)
begin
  SELECT pswd FROM user WHERE userId = userIdIn;
end//
DELIMITER ;

-- ----------------------getEmail------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getEmail //

CREATE PROCEDURE getEmail(IN userIdIn int)
begin
  SELECT email FROM user WHERE userId = userIdIn;
end//
DELIMITER ;

-- --------------------getAccCreation--------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getAccCreation //

CREATE PROCEDURE getAccCreation(IN userIdIn int)
begin
  SELECT created FROM user WHERE userId = userIdIn;
end//
DELIMITER ;

-- ------------------checkVerified-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS checkVerified //

CREATE PROCEDURE checkVerified(IN userIdIn int)
begin
  SELECT verified FROM user WHERE userId = userIdIn;
end//
DELIMITER ;

-- -----------------makeVerified-------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS makeVerified //

CREATE PROCEDURE makeVerified(IN userIdIn int)
begin
  UPDATE user SET verified = 1 WHERE userId = userIdIn;
end//
DELIMITER ;

-- -----------------setUsername-------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS setUsername //

CREATE PROCEDURE setUsername(IN userIdIn int, usernameIn varchar(255))
begin
  IF(SELECT * FROM user WHERE userId = userIdIn)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'username already in use';
  ELSE
    UPDATE user SET username = usernameIn WHERE userId = userIdIn;
  END IF;
end//
DELIMITER ;

-- ----------------set(hashed)Password-------------------
DELIMITER //
DROP PROCEDURE IF EXISTS setPassword //

CREATE PROCEDURE setPassword(IN userIdIn int, passwordIn varchar(255))
begin
  UPDATE user SET pswd = passwordIn WHERE userId = userIdIn;
end//
DELIMITER ;

-- -----------------setEmail-------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS setEmail //

CREATE PROCEDURE setEmail(IN userIdIn int, emailIn varchar(255))
begin
  IF(SELECT * FROM user WHERE userId = userIdIn)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'email already in use';
  ELSE
    UPDATE user SET email = emailIn WHERE userId = userIdIn;
  END IF;
end//
DELIMITER ;

-- -----------------createUser-------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS createUser //

CREATE PROCEDURE createUser(IN usernameIn varchar(255), emailIn varchar(255), passwordIn varchar(255), saltIn varchar(256))
begin
 IF(SELECT * FROM user WHERE email = emailIn)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'email already in use';
 ELSE
    IF(SELECT * FROM user WHERE username = usernameIn)
      THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'username already in use';
    ELSE 
      INSERT INTO user (username, email, pswd, salt, verified, created) VALUES (usernameIn, emailIn, passwordIn, saltIn, 0, CURDATE());
    END IF;
  END IF;
end//
DELIMITER ;

-- ---------------------removeUser---------------------
DELIMITER //
DROP PROCEDURE IF EXISTS removeUser //

CREATE PROCEDURE removeUser(IN userIdIn int)
begin
  IF(SELECT * FROM user WHERE userId = userIdIn)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user does not exist';
  ELSE
    DELETE FROM user WHERE userId = userIdIn;
  END IF;
end//
DELIMITER ;

-- --------------------getUsers-----------------------
DELIMITER //
DROP PROCEDURE IF EXISTS getUsers //

CREATE PROCEDURE getUsers()
begin
  SELECT * FROM user;
end//
DELIMITER ;
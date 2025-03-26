-- -------------user table----------------
DROP TABLE IF EXISTS user;
CREATE TABLE user(
    userId int NOT NULL AUTO_INCREMENT,
    username varchar(255) NOT NULL, 
    email varchar(255) NOT NULL,
    pswd varchar(255) NOT NULL,
    verified boolean NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (userId)
);

-- -------userVerification table----------
DROP TABLE IF EXISTS userVerification;
CREATE TABLE userVerification(
    userId int NOT NULL,
    email varchar(255) NOT NULL,
    emailHash varchar(255) NOT NULL,
    created datetime NOT NULL,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);
drop table if exists userVerification;
create table
    userVerification (
        userID int,
        emailHash varchar(256),
        timestamp DATETIME,
        PRIMARY KEY (userID),
        FOREIGN KEY (userId) REFERENCES user (userID)
    );
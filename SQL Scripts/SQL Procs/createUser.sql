delimiter //
drop procedure if exists createUser / / create procedure createUser (
    IN usernameIN varchar(50),
    IN hashPassIN varchar(256),
    IN emailIN varchar(50)
) BEGIN if ((
    select
        *
    from
        user
    where
        username = usernameIn
        or email = emailIN) = 0,
    insert into
        user (username, pswd, email)
    values
        (usernameIN, hashPassIN, emailIN), return -1;
);
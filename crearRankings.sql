create table rankingSemanal(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nick VARCHAR(40) NOT NULL,
    puntuacion INT DEFAULT 0,
    avatar VARCHAR(100)
)

insert into rankingSemanal(nick, puntuacion, avatar)
values 
    ("Pepito", 20, "imgs/avatar1.png"),
    ("Lucas", 15, "imgs/avatar2.png"),
    ("JuanPalomo", 21, "imgs/avatar3.png")

create table rankingGlobal(
    id INT PRIMARY key AUTO_INCREMENT,
    nick VARCHAR(40) NOT NULL,
    avatar VARCHAR(100) NOT NULL,
    puntuacion INT DEFAULT 0
)

insert into rankingGlobal(nick, avatar)
values
    ("Pepito", "imgs/avatar1.png"),
    ("Lucas", "imgs/avatar2.png"),
    ("JuanPalomo", "imgs/avatar3.png")



DROP PROCEDURE IF EXISTS actualizarRankingGlobal;
DELIMITER //

CREATE PROCEDURE actualizarRankingGlobal()
BEGIN
    
    DECLARE contador INT DEFAULT 0;
    DECLARE nick_val VARCHAR(40);
    DECLARE avatar_val VARCHAR(100);
    DECLARE puntuacion_val INT;
    
    CREATE TEMPORARY TABLE TempTop3 AS
    SELECT *
    FROM rankingSemanal
    ORDER BY puntuacion DESC
    LIMIT 3;
    
    WHILE contador < 3 DO
        SELECT nick, avatar, puntuacion INTO nick_val, avatar_val, puntuacion_val
        FROM TempTop3
        LIMIT contador, 1;

        INSERT INTO rankingGlobal (nick, avatar, puntuacion)
        VALUES (nick_val, avatar_val, 
            CASE contador
                WHEN 0 THEN 5
                WHEN 1 THEN 3
                WHEN 2 THEN 1
            END)
        ON DUPLICATE KEY UPDATE puntuacion = puntuacion + 
            CASE contador
                WHEN 0 THEN 5
                WHEN 1 THEN 3
                WHEN 2 THEN 1
            END;
        
        SET contador = contador + 1;
    END WHILE;
    
    DROP TEMPORARY TABLE IF EXISTS TempTop3;
END //

DELIMITER ;



CALL actualizarRankingGlobal();

DELIMITER $$

CREATE PROCEDURE add_ticket(title_way VARCHAR(100))
BEGIN
	SET @count = (SELECT COUNT(1) FROM Ticket JOIN Way ON Way.num_way = Ticket.num_way WHERE Way.title_way = title_way);
	IF (SELECT @count < (SELECT Bus.count_places FROM Bus JOIN Rays ON Rays.num_bus = Bus.num_bus JOIN Way ON Way.num_way = Rays.num_way WHERE Way.title_way = title_way)) THEN
		INSERT INTO Ticket(place, num_way, time_hour, time_min)
		SELECT DISTINCT (SELECT @count) + 1, Way.num_way, Rays.time_hour, Rays.time_min FROM Way
		JOIN Station
		JOIN Rays ON Rays.num_way = Way.num_way
		WHERE Way.title_way = title_way;
	ELSE
		SIGNAL SQLSTATE '45004'
		SET MESSAGE_TEXT = 'Ошибка! Мест нет!';
    END IF;
END$$

DELIMITER ;

-- Way
-- INSERT INTO Way(title_way) VALUES('');
INSERT INTO Way(title_way) VALUES('Орел-Курск');
INSERT INTO Way(title_way) VALUES('Орел-Ливны');
INSERT INTO Way(title_way) VALUES('Орел-Малоархангельск');
INSERT INTO Way(title_way) VALUES('Орел-Москва');
INSERT INTO Way(title_way) VALUES('Орел-Санкт-Питербург');
INSERT INTO Way(title_way) VALUES('Орел-Брянск');
INSERT INTO Way(title_way) VALUES('Орел-Тула');

-- Station
-- INSERT INTO Station(title_st, distance) VALUES('', 1);
INSERT INTO Station(title_st, distance) VALUES('Орел', 0);
INSERT INTO Station(title_st, distance) VALUES('Курск', 100);
INSERT INTO Station(title_st, distance) VALUES('Ливны', 150);
INSERT INTO Station(title_st, distance) VALUES('Малоархангельск', 50);
INSERT INTO Station(title_st, distance) VALUES('Москва', 400);
INSERT INTO Station(title_st, distance) VALUES('Санкт-Питербург', 500);
INSERT INTO Station(title_st, distance) VALUES('Брянск', 100);
INSERT INTO Station(title_st, distance) VALUES('Тула', 300);

-- Station_way
-- INSERT INTO Station_way(num_way, num_st)
-- SELECT Way.num_way, Station.num_st FROM Way, Station
-- WHERE Way.title_way = '' AND Station.title_st = '';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Курск' AND Station.title_st = 'Орел';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Курск' AND Station.title_st = 'Курск';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Ливны' AND Station.title_st = 'Орел';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Ливны' AND Station.title_st = 'Ливны';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Малоархангельск' AND Station.title_st = 'Орел';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Малоархангельск' AND Station.title_st = 'Малоархангельск';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Москва' AND Station.title_st = 'Орел';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Москва' AND Station.title_st = 'Москва';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Санкт-Питербург' AND Station.title_st = 'Орел';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Санкт-Питербург' AND Station.title_st = 'Санкт-Питербург';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Брянск' AND Station.title_st = 'Орел';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Брянск' AND Station.title_st = 'Брянск';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Тула' AND Station.title_st = 'Орел';
INSERT INTO Station_way(num_way, num_st)
SELECT Way.num_way, Station.num_st FROM Way, Station
WHERE Way.title_way = 'Орел-Тула' AND Station.title_st = 'Тула';

-- Bus
-- INSERT INTO Bus(num_bus, model, count_places) VALUES('12345678', 'GAZ', 15);
INSERT INTO Bus(num_bus, model, count_places) VALUES('00000001', 'GAZ', 15);
INSERT INTO Bus(num_bus, model, count_places) VALUES('00000002', 'MAZ', 20);
INSERT INTO Bus(num_bus, model, count_places) VALUES('00000003', 'Volvo', 25);
INSERT INTO Bus(num_bus, model, count_places) VALUES('00000004', 'ПАЗ', 30);
INSERT INTO Bus(num_bus, model, count_places) VALUES('00000005', 'VolgaBus', 20);

-- Rays
-- INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
-- SELECT DISTINCT Way.num_way, 2, 1, '12345678' FROM Way, Bus
-- WHERE Way.title_way = '';
INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
SELECT DISTINCT Way.num_way, 7, 30, '00000001' FROM Way, Bus
WHERE Way.title_way = 'Орел-Курск';
INSERT  INTO Rays(num_way, time_hour, time_min, num_bus)
SELECT DISTINCT Way.num_way, 7, 45, '00000002' FROM Way, Bus
WHERE Way.title_way = 'Орел-Ливны';
INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
SELECT DISTINCT Way.num_way, 7, 30, '00000003' FROM Way, Bus
WHERE Way.title_way = 'Орел-Малоархангельск';
INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
SELECT DISTINCT Way.num_way, 7, 30, '00000004' FROM Way, Bus
WHERE Way.title_way = 'Орел-Москва';
INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
SELECT DISTINCT Way.num_way, 7, 30, '00000005' FROM Way, Bus
WHERE Way.title_way = 'Орел-Санкт-Питербург';
INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
SELECT DISTINCT Way.num_way, 17, 10, '00000001' FROM Way, Bus
WHERE Way.title_way = 'Орел-Брянск';
INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
SELECT DISTINCT Way.num_way, 14, 10, '00000003' FROM Way, Bus
WHERE Way.title_way = 'Орел-Тула';

-- Ticket
-- INSERT INTO Ticket(place, num_way, time_hour, time_min)
-- SELECT 'place', Way.num_way, Rays.time_hour, Rays.time_min, Station.num_st FROM Way, Station
-- JOIN Rays ON Rays.num_way = Way.num_way
-- WHERE Way.title_way = '';
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');
CALL add_ticket('Орел-Курск');

CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');
CALL add_ticket('Орел-Ливны');

CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');
CALL add_ticket('Орел-Малоархангельск');




-- DROP PROCEDURE add_ticket;

-- CALL add_ticket('Орел-Курск');
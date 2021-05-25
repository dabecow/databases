-- Way
-- INSERT INTO Way(title_way) VALUES('');

-- Station
-- INSERT INTO Station(title_st, distance) VALUES('', 1);

-- Station_way
-- INSERT INTO Station_way(num_way, num_st)
-- SELECT Way.num_way, Station.num_st FROM Way, Station
-- WHERE Way.title_way = '' AND Station.title_st;

-- Bus
-- INSERT INTO Bus(num_bus, model, count_places) VALUES('12345678', 'GAZ', 15);

-- Rays
-- INSERT INTO Rays(num_way, time_hour, time_min, num_bus)
-- SELECT Way.num_way, 2, 1, '12345678' FROM Way, Bus
-- WHERE Way.title_way = '';

-- Ticket
-- INSERT INTO Ticket(place, num_way, time_hour, time_min, num_st)
-- SELECT 'place', Way.num_way, Rays.time_hour, Rays.time_min, Station.num_st FROM Way, Station
-- JOIN Rays ON Rays.num_way = Way.num_way
-- WHERE Way.title_way = '' AND Station.title_st = '';
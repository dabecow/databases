-- Task 1

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

CALL sell_ticket('Орел-Курск', 1, 'Курск');
SELECT * FROM Ticket;

COMMIT;

-- Task 2

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;



UPDATE Rays SET Rays.num_bus = '00000002' WHERE Rays.num_way = (SELECT Way.num_way FROM Way WHERE Way.title_way = 'Орел-Курск');


COMMIT;

-- Task 3

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;


SELECT * FROM Ticket;

COMMIT;

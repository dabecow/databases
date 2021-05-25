/*
1)	Выбрать в каждой из транзакций все записи таблицы Station.
2)	Внести новую запись в транзакции А и еще одну в транзакции В и снова в каждой из них прочитать данные.
3)	Зафиксировать изменения, сделанные транзакцией А. Снова прочи-тать данные в транзакции В, затем в транзакции А.
4)	а) Зафиксировать изменения транзакции В и снова выбрать данные в обеих транзакциях;
               б) зафиксировать изменения транзакции А и снова выбрать данные в обеих транзакциях.
5)	Удалить одну из новых записей (обозначим ее X) транзакцией А, прочитать таблицу транзакцией В.
6)	Удалить вторую новую запись (Y) транзакцией В, прочитать данные.
7)	Выполнить запрос в транзакции В на удаление первой из новых записей (X).
8)	Выполнить запрос в транзакции А на удаление второй новой записи (Y).
9)	Выполнить запрос в транзакции A на удаление записи X.
10)	Зафиксировать изменения транзакции А.

*/

-- transaction A/B
START TRANSACTION;

-- 1 A/B
 SELECT * FROM station;

-- 2 A

INSERT INTO station 
VALUES (100, "Station 1", 100);
SELECT * FROM station;

-- 2 B

INSERT INTO station 
VALUES (200, "Station 2", 200);
SELECT * FROM station;

-- 3 A

COMMIT;
SELECT * FROM station;

-- 3 B

SELECT * FROM station;

-- 4-1 A

SELECT * FROM station;

-- 4-2 A

COMMIT;
SELECT * FROM station;

-- 4-1 B

COMMIT;
SELECT * FROM station;

-- 4-1 B

SELECT * FROM station;

-- 5 A
DELETE FROM station 
WHERE num_st = 100;

-- 5 B 

SELECT * FROM station;

-- 6 B

DELETE FROM station 
WHERE num_st = 200;

SELECT * FROM station;

-- 7 B

DELETE FROM station 
WHERE num_st = 100;

-- 8 A

DELETE FROM station 
WHERE num_st = 200;

-- 9 A

DELETE FROM station 
WHERE num_st = 100;

-- 10 A

COMMIT;
-- 1. Студент может быть старостой только в своей группе 

DELIMITER //
CREATE TRIGGER headmanCheckTrigger
BEFORE UPDATE
ON Группа
FOR EACH ROW
IF NEW.Староста_зачетка NOT IN (SELECT Зачетка FROM Студент WHERE Группа_id = NEW.id) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Нельзя назначить старостой студента, не принадлежащего группе.';
END IF//
DELIMITER ;

-- 2. Год рождения должен быть меньше года поступления

DELIMITER //
CREATE TRIGGER BirthDateCheckOnUpdateTrigger
BEFORE UPDATE
ON Студент
FOR EACH ROW
IF TIMESTAMPDIFF(YEAR, NEW.Дата_рождения, NEW.Год_поступления) < 0 THEN
SIGNAL SQLSTATE '45001'
SET MESSAGE_TEXT = 'Ошибка: год рождения больше года поступления';
END IF//
DELIMITER ;

DELIMITER //
CREATE TRIGGER BirthDateCheckOnInsertTrigger
BEFORE INSERT
ON Студент
FOR EACH ROW
IF TIMESTAMPDIFF(YEAR, NEW.Дата_рождения, NEW.Год_поступления) < 0 THEN
SIGNAL SQLSTATE '45001'
SET MESSAGE_TEXT = 'Ошибка: год рождения больше года поступления';
END IF//
DELIMITER ;

-- 3. Номер телефона может начинаться только с 8.

DELIMITER //
CREATE TRIGGER phoneNumberCheckOnUpdateTrigger
BEFORE UPDATE
ON Студент
FOR EACH ROW
IF LEFT(New.Номер_телефона, 1) != '8' THEN
SIGNAL SQLSTATE '45002'
SET MESSAGE_TEXT = 'Ошибка: номер телефона начинается не с 8';
END IF//
DELIMITER ;

DELIMITER //
CREATE TRIGGER phoneNumberCheckOnInsertTrigger
BEFORE INSERT
ON Студент
FOR EACH ROW
IF LEFT(New.Номер_телефона, 1) != '8' THEN
SIGNAL SQLSTATE '45002'
SET MESSAGE_TEXT = 'Ошибка: номер телефона начинается не с 8';
END IF//
DELIMITER ;

-- 4. Номер курса должен находиться в промежутке с 1 до 5.

DELIMITER //
CREATE TRIGGER courseNumberCheckOnUpdateTrigger
BEFORE UPDATE
ON План_дисциплин
FOR EACH ROW
IF NEW.Курс NOT BETWEEN 1 AND 5 THEN
SIGNAL SQLSTATE '45010'
SET MESSAGE_TEXT = 'Ошибка: номер курса не принадлежит домену [1; 5]';
END IF//
DELIMITER ;

DELIMITER //
CREATE TRIGGER courseNumberCheckOnInsertTrigger
BEFORE INSERT
ON План_дисциплин
FOR EACH ROW
IF NEW.Курс NOT BETWEEN 1 AND 5 THEN
SIGNAL SQLSTATE '45010'
SET MESSAGE_TEXT = 'Ошибка: номер курса не принадлежит домену [1; 5]';
END IF//
DELIMITER ;

-- 5. Номер семестра должен находится в промежутке с 1 до 10.

DELIMITER //
CREATE TRIGGER semesterNumberCheckOnUpdateTrigger
BEFORE UPDATE
ON План_дисциплин
FOR EACH ROW
IF NEW.Номер_семестра NOT BETWEEN 1 AND 10 THEN
SIGNAL SQLSTATE '45003'
SET MESSAGE_TEXT = 'Ошибка: номер семестра не принадлежит домену [1; 10]';
END IF//
DELIMITER ;

DELIMITER //
CREATE TRIGGER semesterNumberCheckOnInsertTrigger
BEFORE INSERT
ON План_дисциплин
FOR EACH ROW
IF NEW.Номер_семестра NOT BETWEEN 1 AND 10 THEN
SIGNAL SQLSTATE '45004'
SET MESSAGE_TEXT = 'Ошибка: номер семестра не принадлежит домену [1; 10] ';
END IF//
DELIMITER ;

-- 6. Название типа занятие может быть только лекция, практика или лабораторная работа.

DELIMITER //
CREATE TRIGGER lessonTypeRestrictionOnInsertTrigger
BEFORE INSERT
ON Тип_занятия
FOR EACH ROW
IF NEW.Название NOT IN ('Лекция', 'Лабораторная работа', 'Практика') THEN
SIGNAL SQLSTATE '45005'
SET MESSAGE_TEXT = 'Ошибка: неверное название типа занятия';
END IF//
DELIMITER ;

DELIMITER //
CREATE TRIGGER lessonTypeRestrictionOnUpdateTrigger
BEFORE UPDATE
ON Тип_занятия
FOR EACH ROW
IF NEW.Название NOT IN ('Лекция', 'Лабораторная работа', 'Практика') THEN
SIGNAL SQLSTATE '45005'
SET MESSAGE_TEXT = 'Ошибка: неверное название типа занятия';
END IF//
DELIMITER ;

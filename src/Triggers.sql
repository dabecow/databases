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


-- 7. Количество часов на тип занятия может быть 2 или 4 часа.

    DELIMITER //
    CREATE TRIGGER CountInLesson
    BEFORE INSERT
    ON тип_занятия
    FOR EACH ROW
    IF NEW.Длительность != 2 or NEW.Длительность != 4 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Введено некорректное число длительность занятия';
    END IF//
    DELIMITER ;
    
    DELIMITER //
    CREATE TRIGGER CountInLesson
    BEFORE UPDATE
    ON тип_занятия
    FOR EACH ROW
    IF NEW.Длительность != 2 or NEW.Длительность != 4 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Введено некорректное число длительность занятия';
    END IF//
    DELIMITER ;

-- 8. Количество часов на план дисциплин должно быть больше, чем количество часов на тип занятия. 
-- И общее количество часов на дисциплину должно быть кратно 2.

    DELIMITER //
    CREATE TRIGGER CountOfAllHrsMoreThenCurrentTypeOfLesson
    BEFORE INSERT
    ON план_дисциплин
    FOR EACH ROW
    IF (NEW.Запланированно_часов < (SELECT Длительность FROM Тип_занятия WHERE Тип_занятия.id = NEW.id) or NEW.Запланированно_часов % 2 != 0) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Введено некорректно число на план дисциплины';
    END IF//
    DELIMITER ;
    
    DELIMITER //
    CREATE TRIGGER CountOfAllHrsMoreThenCurrentTypeOfLesson
    BEFORE UPDATE
    ON план_дисциплин
    FOR EACH ROW
    IF (NEW.Запланированно_часов < (SELECT Длительность FROM Тип_занятия WHERE Тип_занятия.id = NEW.id) or NEW.Запланированно_часов % 2 != 0) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Введено некорректно число на план дисциплины';
    END IF//
    DELIMITER ;
    
-- 9. Посещение студентов отмечается только на занятиях их группы.

    DELIMITER //
    CREATE TRIGGER StudientOnHisLesson
    BEFORE INSERT
    ON посещаемость
    FOR EACH ROW
    IF (NEW.Занятие_Группа_id != (SELECT Группа_id FROM Студент WHERE Группа.id = NEW.id)) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Студент не находится в этой группе';
    END IF//
    DELIMITER ;
    
    DELIMITER //
    CREATE TRIGGER StudientOnHisLesson
    BEFORE UPDATE
    ON посещаемость
    FOR EACH ROW
    IF (NEW.Занятие_Группа_id != (SELECT Группа_id FROM Студент WHERE Группа.id = NEW.id)) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Студент не находится в этой группе';
    END IF//
    DELIMITER ;
-- s
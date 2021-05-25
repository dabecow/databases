DELIMITER //
CREATE TRIGGER checkOverflow
BEFORE INSERT
ON Занятие
FOR EACH ROW
IF (SELECT (План_дисциплин.Запланированно_часов - IFNULL((SELECT COUNT(Занятие.План_дисциплин_id) * Тип_занятия.Длительность FROM Занятие 
JOIN План_дисциплин ON Занятие.План_дисциплин_id = План_дисциплин.id 
JOIN Дисциплина ON Дисциплина.id = План_дисциплин.Дисциплина_id 
JOIN Тип_занятия ON Тип_занятия.id = План_дисциплин.Тип_занятия_id 
JOIN Группа ON Группа.id = Занятие.Группа_id 
WHERE NEW.План_дисциплин_id = План_дисциплин.id AND Группа.id = NEW.Группа_id), 0)) FROM 
План_дисциплин 
JOIN Занятие ON Занятие.План_дисциплин_id = План_дисциплин.id 
JOIN Дисциплина ON Дисциплина.id = План_дисциплин.Дисциплина_id 
JOIN Тип_занятия ON Тип_занятия.id = План_дисциплин.Тип_занятия_id 
JOIN Группа ON Группа.id = Занятие.Группа_id 
WHERE NEW.План_дисциплин_id = План_дисциплин.id AND Группа.id = NEW.Группа_id) = 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Занятия уже распределены';
END IF//
DELIMITER ;

-- DROP TRIGGER checkOverflow


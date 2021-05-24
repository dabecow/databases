-- Вывести количество студентов в группе по шифру

DELIMITER //

CREATE PROCEDURE count_students_in_group(code VARCHAR(30))

BEGIN

SELECT COUNT(Студент.Зачетка) FROM Студент
INNER JOIN Группа ON Студент.Группа_id = Группа.id;

END//

-- Вывести имена всех старост

DELIMITER //

CREATE PROCEDURE print_headMen()

BEGIN

SELECT Студент.Зачетка, Студент.Фамилия, Студент.Имя, Группа.Зачетка FROM Студент
RIGHT JOIN Группа ON Студент.Группа_id = Группа.id
WHERE Студент.Зачетка = Группа.Староста_зачетка;

END//

-- Вывести колличество пар по предмету

DELIMITER //

CREATE PROCEDURE count_lessons(lesson_name VARCHAR(100))

BEGIN

SELECT Дисциплина.Название, Тип_занятия.Название, COUNT(1) FROM Занятие 
JOIN План_дисциплин ON План_дисциплин.id = Занятие.План_дисциплин_id 
JOIN Дисциплина ON Дисциплина.id = План_дисциплин.Дисциплина_id 
JOIN Тип_занятия ON Тип_занятия.id = План_дисциплин.Тип_занятия_id 
GROUP BY Дисциплина.Название, Тип_занятия.Название HAVING Дисциплина.Название = lesson_name;

END//
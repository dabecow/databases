-- Вывести количество студентов в группе по шифру

DELIMITER //

CREATE PROCEDURE count_students_in_group(code VARCHAR(30))

BEGIN

SELECT COUNT(Студент.Зачетка) FROM Студент
INNER JOIN Группа ON Студент.Группа_id = Группа.id

END//

-- Вывести имена всех старост

DELIMITER //

CREATE PROCEDURE print_headMen()

BEGIN

SELECT Студент.Зачетка, Студент.Фамилия, Студент.Имя, Группа.Зачетка FROM Студент
RIGHT JOIN Группа ON Студент.Группа_id = Группа.id
WHERE Студент.Зачетка = Группа.Староста_зачетка

END//

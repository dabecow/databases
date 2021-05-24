USE mydb;

-- факультет
-- INSERT INTO факультет(Название) VALUES ();
INSERT INTO факультет(Название) VALUES ("ИПАИТ"), ("ИЭиУ"), ("АСИ");

-- INSERT INTO специальность(Шифр, Название) VALUES ();
INSERT INTO специальность(Шифр, Название) VALUES ("09.03.04", "Программная инженерия");
INSERT INTO специальность(Шифр, Название) VALUES ("09.03.01", "Информатика и вычислительная техника");
INSERT INTO специальность(Шифр, Название) VALUES ("09.03.03", "Прикладная информатика");

INSERT INTO специальность(Шифр, Название) VALUES ("38.03.05", "Бизнес-информатика");
INSERT INTO специальность(Шифр, Название) VALUES ("38.03.02", "Менеджмент");
INSERT INTO специальность(Шифр, Название) VALUES ("38.03.06", "Торговое дело — бакалавриат");

INSERT INTO специальность(Шифр, Название) VALUES ("07.03.01", "Архитектура");
INSERT INTO специальность(Шифр, Название) VALUES ("07.03.02", "Реконструкция и реставрация архитектурного наследия");
INSERT INTO специальность(Шифр, Название) VALUES ("07.03.03", "Дизайн архитектурной среды");

-- INSERT INTO кафедра(Название) VALUES ();
INSERT INTO кафедра(Название) VALUES ("Кафедра информационных систем и цифровых технологий");
INSERT INTO кафедра(Название) VALUES ("Кафедра инноватики и прикладной экономики"), ("Кафедра маркетинга и предпринимательства");
INSERT INTO кафедра(Название) VALUES ("Кафедра архитектуры"), ("Кафедра проектирования городской среды");


/* INSERT INTO профиль(Название, Факультет_id, Специальность_id, Кафедра_id)
SELECT "<Значение>", Факультет.id, Специальность.id, Кафедра.id
FROM Факультет, Специальность, Кафедра
WHERE Факультет.Название = "<Значение>"
AND Специальность.Название = "<Значение>"
AND Кафедра.Название = "<Значение>"
;*/

INSERT INTO профиль(Название, Факультет_id, Специальность_id, Кафедра_id)
SELECT "Программная инженерия", Факультет.id, Специальность.id, Кафедра.id
FROM Факультет, Специальность, Кафедра
WHERE Факультет.Название = "ИПАИТ"
AND Специальность.Название = "Программная инженерия"
AND Кафедра.Название = "Кафедра информационных систем и цифровых технологий"
;

INSERT INTO профиль(Название, Факультет_id, Специальность_id, Кафедра_id)
SELECT "Прикладная информатика", Факультет.id, Специальность.id, Кафедра.id
FROM Факультет, Специальность, Кафедра
WHERE Факультет.Название = "ИПАИТ"
AND Специальность.Название = "Прикладная информатика"
AND Кафедра.Название = "Кафедра информационных систем и цифровых технологий"
;

INSERT INTO профиль(Название, Факультет_id, Специальность_id, Кафедра_id)
SELECT "Бизнес-информатика", Факультет.id, Специальность.id, Кафедра.id
FROM Факультет, Специальность, Кафедра
WHERE Факультет.Название = "ИЭиУ"
AND Специальность.Название = "Бизнес-информатика"
AND Кафедра.Название = "Кафедра инноватики и прикладной экономики"
;

INSERT INTO профиль(Название, Факультет_id, Специальность_id, Кафедра_id)
SELECT "Архитектура", Факультет.id, Специальность.id, Кафедра.id
FROM Факультет, Специальность, Кафедра
WHERE Факультет.Название = "АСИ"
AND Специальность.Название = "Архитектура"
AND Кафедра.Название = "Кафедра архитектуры"
;

/* INSERT INTO учебный_план(Год_поступления, Профиль_id)
   SELECT <значение>, Профиль.id
   FROM Профиль
   WHERE Название = "<Значение>"
;*/

INSERT INTO учебный_план(Год_поступления, Профиль_id)
   SELECT 2019, Профиль.id
   FROM Профиль
   WHERE Название = "Программная инженерия"
;

INSERT INTO учебный_план(Год_поступления, Профиль_id)
   SELECT 2019, Профиль.id
   FROM Профиль
   WHERE Название = "Прикладная информатика"
;

INSERT INTO учебный_план(Год_поступления, Профиль_id)
   SELECT 2019, Профиль.id
   FROM Профиль
   WHERE Название = "Архитектура"
;

-- INSERT INTO дисциплина(Название) VALUES ();

INSERT INTO дисциплина(Название) VALUES ("Язык программирования Java");
INSERT INTO дисциплина(Название) VALUES ("Базы данных");
INSERT INTO дисциплина(Название) VALUES ("Язык программирования C#");
INSERT INTO дисциплина(Название) VALUES ("Операционные системы");
INSERT INTO дисциплина(Название) VALUES ("Компьютерные сети");

/* default query in группатип_занятия*/
INSERT INTO тип_занятия(Название, Длительность) VALUES ("Лекция", 2), ("Лабораторная работа", 4), ("Практика", 2);

/*INSERT INTO план_дисциплин(Тип_занятия_id, Дисциплина_id,
   Учебный_план_Год_поступления, Учебный_план_Профиль_id,
    Заланированно_часов, Номер_семестра)
    SELECT Тип_занятия.id, Дисциплина.id, Учебный_план.Год_поступления,
    Учебный_план.Профиль_id, <Значение_часов>, <номер_семестра>
    FROM Тип_занятия, Дисциплина, Учебный_план
    WHERE Тип_занятия.Название = "<ЗНачение>"
    AND Дисциплина.Название = "<Значение>"
    AND Учебный_план.Год_поступления = <Значение>
    AND Учебный_план.Профиль_id = (SELECT Профиль.id FROM Профиль WHERE Название = "<Значение>")
    ;*/

-- 1 
INSERT INTO план_дисциплин(Тип_занятия_id, Дисциплина_id,
   Учебный_план_Год_поступления, Учебный_план_Профиль_id,
    Запланированно_часов, Номер_семестра)
    SELECT Тип_занятия.id, Дисциплина.id, Учебный_план.Год_поступления,
    Учебный_план.Профиль_id, 80, 4
    FROM Тип_занятия, Дисциплина, Учебный_план
    WHERE Тип_занятия.Название = "Лекция"
    AND Дисциплина.Название = "Базы данных"
    AND Учебный_план.Год_поступления = 2019
    AND Учебный_план.Профиль_id = (SELECT Профиль.id FROM Профиль WHERE Название = "Программная инженерия")
    ;

-- 2 
INSERT INTO план_дисциплин(Тип_занятия_id, Дисциплина_id,
   Учебный_план_Год_поступления, Учебный_план_Профиль_id,
    Запланированно_часов, Номер_семестра)
    SELECT Тип_занятия.id, Дисциплина.id, Учебный_план.Год_поступления,
    Учебный_план.Профиль_id, 40, 4
    FROM Тип_занятия, Дисциплина, Учебный_план
    WHERE Тип_занятия.Название = "Лабораторная работа"
    AND Дисциплина.Название = "Базы данных"
    AND Учебный_план.Год_поступления = 2019
    AND Учебный_план.Профиль_id = (SELECT Профиль.id FROM Профиль WHERE Название = "Программная инженерия")
    ;

-- 3
INSERT INTO план_дисциплин(Тип_занятия_id, Дисциплина_id,
   Учебный_план_Год_поступления, Учебный_план_Профиль_id,
    Запланированно_часов, Номер_семестра)
    SELECT Тип_занятия.id, Дисциплина.id, Учебный_план.Год_поступления,
    Учебный_план.Профиль_id, 80, 4
    FROM Тип_занятия, Дисциплина, Учебный_план
    WHERE Тип_занятия.Название = "Лекция"
    AND Дисциплина.Название = "Язык программирования C#"
    AND Учебный_план.Год_поступления = 2019
    AND Учебный_план.Профиль_id = (SELECT Профиль.id FROM Профиль WHERE Название = "Программная инженерия")
    ;
-- 4
INSERT INTO план_дисциплин(Тип_занятия_id, Дисциплина_id,
   Учебный_план_Год_поступления, Учебный_план_Профиль_id,
    Запланированно_часов, Номер_семестра)
    SELECT Тип_занятия.id, Дисциплина.id, Учебный_план.Год_поступления,
    Учебный_план.Профиль_id, 40, 4
    FROM Тип_занятия, Дисциплина, Учебный_план
    WHERE Тип_занятия.Название = "Лабораторная работа"
    AND Дисциплина.Название = "Язык программирования C#"
    AND Учебный_план.Год_поступления = 2019
    AND Учебный_план.Профиль_id = (SELECT Профиль.id FROM Профиль WHERE Название = "Программная инженерия")
    ;



-- INSERT INTO преподаватель(Имя, Фамилия, Отчество) VALUES ("<value>", "<value>", "<value>");
INSERT INTO преподаватель(Имя, Фамилия, Отчество) VALUES ("Денис", "Рыженков", "Викторович");
INSERT INTO преподаватель(Имя, Фамилия, Отчество) VALUES ("Антон", "Ужаринский", "Юрьевич");
INSERT INTO преподаватель(Имя, Фамилия, Отчество) VALUES ("Ольга", "Захарова", "Владимировна");

-- INSERT INTO группа(Шифр) VALUES ("<value>");

INSERT INTO группа(Шифр) VALUES ("91ПГ");
INSERT INTO группа(Шифр) VALUES ("91ИВТ");
INSERT INTO группа(Шифр) VALUES ("91ПИ");


/* INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT <План_дисциплин_id>, Преподаватель.id, <дата>,
   <номер_пары>, Группа.id, <Тема>
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = <> AND
   Преподаватель.Фамилия = <> AND
   Преподаватель.Отчество = <> AND
   Группа.Шифр = "<>"
 ;*/

INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT 1, Преподаватель.id, '2021-05-01',
   1, Группа.id, 'Транзакции'
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = 'Денис' AND
   Преподаватель.Фамилия = 'Рыженков' AND
   Преподаватель.Отчество = 'Викторович' AND
   Группа.Шифр = "91ПГ"
   ;

INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT 1, Преподаватель.id, '2021-05-01',
   1, Группа.id, 'Транзакции'
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = 'Денис' AND
   Преподаватель.Фамилия = 'Рыженков' AND
   Преподаватель.Отчество = 'Викторович' AND
   Группа.Шифр = "91ПИ"
   ;

INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT 1, Преподаватель.id, '2021-05-01',
   1, Группа.id, 'Транзакции'
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = 'Денис' AND
   Преподаватель.Фамилия = 'Рыженков' AND
   Преподаватель.Отчество = 'Викторович' AND
   Группа.Шифр = "91ИВТ"
   ;
   
INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT 2, Преподаватель.id, '2021-05-01',
   2, Группа.id, 'Проектирование БД'
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = 'Денис' AND
   Преподаватель.Фамилия = 'Рыженков' AND
   Преподаватель.Отчество = 'Викторович' AND
   Группа.Шифр = "91ПГ"
   ;

INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT 3, Преподаватель.id, '2021-05-01',
   3, Группа.id, 'Свойства'
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = 'Антон' AND
   Преподаватель.Фамилия = 'Ужаринский' AND
   Преподаватель.Отчество = 'Юрьевич' AND
   Группа.Шифр = "91ПГ"
   ;
   
INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT 2, Преподаватель.id, '2021-05-02',
   1, Группа.id, 'Проектирование БД'
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = 'Денис' AND
   Преподаватель.Фамилия = 'Рыженков' AND
   Преподаватель.Отчество = 'Викторович' AND
   Группа.Шифр = "91ПИ"
   ;
   
INSERT INTO занятие (План_дисциплин_id, Преподаватель_id, Дата,
   Номер_пары, Группа_id, Тема)
   SELECT 4, Преподаватель.id, '2021-05-02',
   1, Группа.id, '.NET 5'
   FROM Преподаватель, Группа
   WHERE Преподаватель.Имя = 'Антон' AND
   Преподаватель.Фамилия = 'Ужаринский' AND
   Преподаватель.Отчество = 'Юрьевич' AND
   Группа.Шифр = "91ПГ"
   ;

/* INSERT INTO студент(Зачетка, Имя, Фамилия, Отчество, Дата_рождения, Адрес,
Номер_телефона, Группа_id, Год_поступления)
SELECT <Зачетка>, <Имя>, <Фамилия>, <Отчество>, <Дата_рождения>,
 <Адрес>, <Номер_телефона>, Группа.id, <Год_поступления>
FROM Группа
WHERE Группа.Шифр = "<>"
 ;*/
-- INSERT INTO студент VALUES (191010, "Александр", "Бородин", "Алексеевич", "13.07.2001", "Орел", "89513371828", 1, 2019);

INSERT INTO студент(Зачетка, Имя, Фамилия, Отчество, Дата_рождения, Адрес,
	Номер_телефона, Группа_id, Год_поступления)
	SELECT 191010, 'Александр', 'Бородин', 'Алексеевич', '2001-07-13',
	'Наугорское шоссе', '71234567890', Группа.id, 2019
	FROM Группа
	WHERE Группа.Шифр = "91ПГ"
	;
    
INSERT INTO студент(Зачетка, Имя, Фамилия, Отчество, Дата_рождения, Адрес,
	Номер_телефона, Группа_id, Год_поступления)
	SELECT 191011, 'Андрей', 'Быков', 'Сергеевич', '2002-01-15',
	'ул. Пушкина', '70987654321', Группа.id, 2019
	FROM Группа
	WHERE Группа.Шифр = "91ПГ"
	;
    
INSERT INTO студент(Зачетка, Имя, Фамилия, Отчество, Дата_рождения, Адрес,
	Номер_телефона, Группа_id, Год_поступления)
	SELECT 191888, 'Сергей', 'Голахов', 'Юрьевич', '2001-08-28',
	'ул. Проспект мир', '71234560987', Группа.id, 2019
	FROM Группа
	WHERE Группа.Шифр = "91ПГ"
	;
    
INSERT INTO студент(Зачетка, Имя, Фамилия, Отчество, Дата_рождения, Адрес,
	Номер_телефона, Группа_id, Год_поступления)
	SELECT 191228, 'Василий', 'Пупкин', 'Павлович', '2000-03-20',
	'ул. Ленина', '70009991134', Группа.id, 2019
	FROM Группа
	WHERE Группа.Шифр = "91ПИ"
	;
    
INSERT INTO студент(Зачетка, Имя, Фамилия, Отчество, Дата_рождения, Адрес,
	Номер_телефона, Группа_id, Год_поступления)
	SELECT 191001, 'Николай', 'Пупкин', 'Павлович', '2000-06-12',
	'ул. Героев пожарных', '71113332244', Группа.id, 2019
	FROM Группа
	WHERE Группа.Шифр = "91ИВТ"
	;


/* INSERT INTO посещаемость(Студент_Зачетка, Занятие_План_Дисциплин_id
Занятие_Преподаватель_id, Занятие_Дата, Занятие_Номер_пары, Занятие_Группа_id)
  SELECT <Зачетка>, <Дата>, <номер_пары>, <группа>
  FROM Группа
  WHERE Шифр = "<шифр>"


*/

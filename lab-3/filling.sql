use mydb;

-- факультет

insert into факультет(Название) values("ИПАИТ"), ("Иняз");
-- insert into специальность(Шифр, Название) values();
-- insert into кафедра(Название) values();

-- insert into профиль(Название, Факультет_id, Специальность_id, Кафедра_id) values();
-- insert into учебный_план(Год_поступления, Профиль_id) values();

-- insert into дисциплина(Название) values();
insert into тип_занятия(Название, Длительность) values("Лекция", 2), ("Лабораторная работа", 4), ("Практика", 2);

-- insert into план_дисциплин(Тип_занятия_id, Дисциплина_id, Учебный_план_Год_поступления, Учебный_план_Профиль_id, Заланированно_часов, Номер_семестра) values();

insert into преподаватель(Имя, Фамилия, Отчество) values("Денис", "Рыженков", "Викторович");
insert into группа(Шифр) values("91ПГ");

insert into студент values(191010, "Александр", "Бородин", "Алексеевич", "13.07.2001", "Орел", "89513371828", 1, 2019);

-- insert into занятие values();

-- insert into посещаемость values();
CREATE SCHEMA IF NOT EXISTS busstop;

USE busstop;

CREATE TABLE Bus (
    num_bus VARCHAR(8) PRIMARY KEY,
    model VARCHAR(50),
    count_places SMALLINT(1)
);

CREATE TABLE Station (
    num_st SMALLINT(1) PRIMARY KEY AUTO_INCREMENT,
    title_st VARCHAR(100),
    distance SMALLINT(1)
);

CREATE TABLE Way (
    num_way SMALLINT(1) PRIMARY KEY AUTO_INCREMENT,
    title_way VARCHAR(100)
);

CREATE TABLE Station_Way (
    num_way SMALLINT(1),
    num_st SMALLINT(1),

    PRIMARY KEY (num_way, num_st),
    FOREIGN KEY (num_way) REFERENCES Way(num_way),
    FOREIGN KEY (num_st) REFERENCES Station(num_st)
);

CREATE TABLE Rays (
    num_way SMALLINT(1),
    time_hour TINYINT(1),
    time_min TINYINT(1),

    num_bus VARCHAR(8),

    PRIMARY KEY (num_way, time_hour, time_min),
    FOREIGN KEY (num_bus) REFERENCES Bus(num_bus),
    FOREIGN KEY (num_way) REFERENCES Way(num_way)
);

CREATE TABLE Ticket (
    place VARCHAR(100),
    num_way SMALLINT(1),
    time_hour TINYINT(1),
    time_min TINYINT(1),

    num_st SMALLINT(1),

    PRIMARY KEY (place, num_way, time_hour, time_min),
    FOREIGN KEY (num_way) REFERENCES Rays(num_way),
    FOREIGN KEY (time_hour) REFERENCES Rays(time_hour),
    FOREIGN KEY (time_min) REFERENCES Rays(time_min),
    FOREIGN KEY (num_st) REFERENCES Station(num_st)


);


-- drop schema busstop
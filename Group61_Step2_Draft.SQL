/*
* AUTHORS: Hayley Leavitt & Kenny Igbechi
* GROUP: 61
* PROJECT: Intermediate SQL Assignment
* DUE DATE: 2022-04-25
* DESCRIPTION: Implement a series of MariaDB MySQL databases with foreign keys, 
*   primary keys, attributes, and constraints.
* LAST EDITED: 2022-04-24
*/

-- MySQL dump 10.13  Distrib 5.1.66, for redhat-linux-gnu (x86_64)
--
-- Host: mysql.eecs.oregonstate.edu    Database: CS340
-------------------------------------------------------------------------------------------
-- Server version	5.1.65-community-log

-------------------------------------- DEFINE TABLES --------------------------------------

CREATE OR REPLACE TABLE Customers
(
    customerID              INT(11), AUTO_INCREMENT, NOT NULL,
    fname                   VARCHAR(50), 
    lname                   VARCHAR(50), 
    pronouns                VARCHAR(20), 
    age                     INT(11), 
    customerAddress         VARCHAR(100), 
    email                   VARCHAR(50), 
    membershipType          VARCHAR(20), 
    hasActiveMembership     VARCHAR(10),
    transID                 INT,

    PRIMARY KEY (customerID),
    FOREIGN KEY (transID)   REFERENCES Transactions(transactionID) 
);

CREATE OR REPLACE TABLE Schedules
(
    scheduleID               INT(11), AUTO_INCREMENT, NOT NULL, 
    activity                 VARCHAR(50), 
    activityDays             VARCHAR(50),
    startTime                TIME, 
    DURATION                 TIME,
    trainID                  INT, 

    PRIMARY KEY (scheduleID),
    FOREIGN KEY (trainID) REFERENCES Trainers(trainerID)
);

CREATE OR REPLACE TABLE Locations
(
    locationID              INT(11) AUTO_INCREMENT NOT NULL, 
    locationAddress         VARCHAR(100), 
    manager                 VARCHAR(50),
    linvID                  INT, 

    PRIMARY KEY (locationID),
    FOREIGN KEY (linvID)    REFERENCES Inventories(inventoryID)
);

CREATE OR REPLACE TABLE Equipment 
(
    equipmentID            INT(11) AUTO_INCREMENT NOT NULL, 
    equipmentType          VARCHAR(50), 
    equipmentName          VARCHAR(50),
    einvID                 INT, 

    PRIMARY (equipmentID), 
    FOREIGN KEY (einvID)   REFERENCES Inventories(inventoryID)
); 

CREATE OR REPLACE TABLE Trainers
(
    trainerID             INT(11) AUTO_INCREMENT NOT NULL, 
    trainerName           VARCHAR, 
    salary                INT(11), 
    email                 VARCHAR(50),
    scheduleID            INT(11),

    PRIMARY KEY   (trainerID),
    FOREIGN KEY   (scheduleID)  REFERENCES Schedules(scheduleID),
);

CREATE OR REPLACE TABLE Transactions
(
    transactionID         INT(11) AUTO_INCREMENT NOT NULL,
    amount                DOUBLE(12,5),
    transactionDate       DATETIME,
    tcustID               INT, 

    PRIMARY KEY (transactionID),
    FOREIGN KEY (tcustID) REFERENCES Customers(customerID)
);

CREATE OR REPLACE TABLE Inventories
(
    inventoryID            INT(11) AUTO_INCREMENT NOT NULL,
    equipmentQuantity      INT(11), AUTO_INCREMENT NOT NULL, 
    ilocID                 INT, 
    iequipID               INT,
    

    PRIMARY KEY (inventoryID),
    FOREIGN KEY (ilocID)   REFERENCES Locations(locationID), 
    FOREIGN KEY (iequipID) REFERENCES equipmentID
);

----------------------------------- INSERT INTO TABLES ------------------------------------

-- insert 3 entries into Customers Table
INSERT INTO Customers (fname, lname, pronouns, age, customerAddress, email, membershipType, hasActiveMembership, transID)
VALUES ("Jane", "Doe", "she/her", 27, "1000 Bicycle Lane, Walton, IL 20002", "jdoe@bellsouth.net", "single location", "TRUE", NULL), 
       ("John", "Smith", "he/him", 48, "292 Peachtree St, Atlanta, GA 30001", "smitj@comcast.net", "all locations", "TRUE", NULL),
       ("Mary", "Sue", "she/her", 19, "4500 Cascade Dr, Portland, OR 11111", "suem@oregonstate.edu", "single location", "FALSE", NULL);

-- insert 3 entries into Trainers
INSERT INTO Trainers (trainerName, salary, email)
VALUES ("Eric Idle", "100000", "nothingquiteaswonderful@bbc.org"), 
       ("Bob Pancakes", "50000", "justsomeguy2@gmail.com"), 
       ("Jaina Moore", "25000", "parttimewonder@gmail.com");

-- insert 3 entries into Schedules Table
INSERT INTO Schedules (activity, activityDays, startTime, duration, trainID)
VALUES ("yoga", "Monday/Tuesday/Wednesday/Thursday/Friday/Saturday/Sunday", '18:00:00', '02:00:00', 
        (SELECT trainerID FROM Trainers WHERE trainerName = "Jaina Moore")), 

       ("power lifting", "Wednesday/Saturday", '17:00:00', '01:00:00', 
        (SELECT trainerID FROM Trainers WHERE trainerName = "Bob Pancakes")), 

       ("30 minute circuits", "Monday/Wednesday/Friday", '20:00:00', '00:30:00', 
        (SELECT trainerID FROM Trainers WHERE trainerName = "Eric Idle"));

-- insert 3 entries into Locations
INSERT INTO Locations (locationAddress, manager, linvID)
VALUES ("1111 One Way, Juno, AK 1111111", "Chester Eaton", NULL),
       ("2018 Falkreath Rd, Falkreath, Skyrim 000000", "Todd Howard", NULL),
       ("125 Notlob, Bolton, UK", "John Cleese", NULL);

-- insert 3 entries into Equipment
INSERT INTO Equipment (equipmentType, equipmentName, einvID)
VALUES ("Upper Body", "Bench Press", NULL), 
       ("Cardio", "Elliptical", NULL), 
       ("Cardio", "Stair Stepper", NULL);

-- insert 3 entries into Transactions
INSERT INTO Transactions (amount, transactionDate, tcustID)
VALUES (100.00, '1997-01-01', (SELECT customerID FROM Customers WHERE fname = "John" AND lname = "Smith")), 
       (42.24, '2020-02-02', (SELECT customerID FROM Customers WHERE fname = "Mary" AND lname = "Sue")), 
       (19.28, '2018-12-05', (SELECT customerID FROM Customers WHERE fname = "Jane" AND lname = "Doe"));

-- insert 3 entries into Inventories
INSERT INTO Inventories (equipmentQuantity, ilocID, iequipID)
VALUES (4, (SELECT equipmentID FROM Equipment WHERE equipmentName = "Stair Stepper"), NULL), 
       (8, (SELECT equipmentID FROM Equipment WHERE equipmentName = "Bench Press"), NULL),
       (15, (SELECT equipmentID FROM Equipment WHERE equipmentName = "Elliptical"), NULL);

-------------------------------------------------------------------------------------------

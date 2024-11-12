/*
 * ER/Studio Data Architect SQL Code Generation
 * Project :      Final.DM1
 *
 * Date Created : Sunday, April 07, 2024 19:58:52
 * Target DBMS : Microsoft SQL Server 2019
 */

/* 
 * TABLE: dim_contributing_factor 
 */

CREATE TABLE dim_contributing_factor(
    SK_ContributingFactor    int             NOT NULL,
    Code                     int             NOT NULL,
    Factor                   varchar(100)    NOT NULL,
    Start_Date               date            NOT NULL,
    End_Date                 date            NOT NULL,
    Is_Current               int             NOT NULL,
    DI_CreateDate            date            NOT NULL,
    DI_Source                varchar(100)    NOT NULL,
    CONSTRAINT PK7 PRIMARY KEY NONCLUSTERED (SK_ContributingFactor)
)

go


IF OBJECT_ID('dim_contributing_factor') IS NOT NULL
    PRINT '<<< CREATED TABLE dim_contributing_factor >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dim_contributing_factor >>>'
go

/* 
 * TABLE: dim_date 
 */

CREATE TABLE dim_date(
    SK_Date          int             NOT NULL,
    Day_Num          int             NOT NULL,
    Day_Str          varchar(100)    NOT NULL,
    Month_Num        int             NOT NULL,
    Month_Str        varchar(100)    NOT NULL,
    Year_Num         int             NOT NULL,
    is_weekend       varchar(100)    NOT NULL,
    Season           varchar(100)    NOT NULL,
    Dt               date            NOT NULL,
    DI_CreateDate    date            NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (SK_Date)
)

go


IF OBJECT_ID('dim_date') IS NOT NULL
    PRINT '<<< CREATED TABLE dim_date >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dim_date >>>'
go

/* 
 * TABLE: dim_flag 
 */

CREATE TABLE dim_flag(
    SK_Flag             int             NOT NULL,
    Flag                int             NOT NULL,
    [Flag Description]  varchar(100)    NOT NULL,
    CONSTRAINT PK15 PRIMARY KEY NONCLUSTERED (SK_Flag)
)

go


IF OBJECT_ID('dim_flag') IS NOT NULL
    PRINT '<<< CREATED TABLE dim_flag >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dim_flag >>>'
go

/* 
 * TABLE: dim_location 
 */

CREATE TABLE dim_location(
    SK_Location       int                 NOT NULL,
    Street_Address    varchar(100)        NOT NULL,
    City              varchar(100)        NOT NULL,
    Zip_Code          varchar(100)        NOT NULL,
    Latitude          double precision    NOT NULL,
    Longitude         double precision    NOT NULL,
    DI_CreateDate     date                NOT NULL,
    DI_Source         varchar(100)        NOT NULL,
    CONSTRAINT PK1 PRIMARY KEY NONCLUSTERED (SK_Location)
)

go


IF OBJECT_ID('dim_location') IS NOT NULL
    PRINT '<<< CREATED TABLE dim_location >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dim_location >>>'
go

/* 
 * TABLE: dim_source 
 */

CREATE TABLE dim_source(
    SK_Source        int             NOT NULL,
    Source           varchar(100)    NOT NULL,
    DI_CreateDate    date            NOT NULL,
    CONSTRAINT PK14 PRIMARY KEY NONCLUSTERED (SK_Source)
)

go


IF OBJECT_ID('dim_source') IS NOT NULL
    PRINT '<<< CREATED TABLE dim_source >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dim_source >>>'
go

/* 
 * TABLE: dim_time 
 */

CREATE TABLE dim_time(
    SK_Time          int             NOT NULL,
    Hour             int             NOT NULL,
    Minute           int             NOT NULL,
    TimeOfDay        varchar(100)    NOT NULL,
    DI_CreateDate    date            NOT NULL,
    DI_Sorce         varchar(100)    NOT NULL,
    CONSTRAINT PK11 PRIMARY KEY NONCLUSTERED (SK_Time)
)

go


IF OBJECT_ID('dim_time') IS NOT NULL
    PRINT '<<< CREATED TABLE dim_time >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dim_time >>>'
go

/* 
 * TABLE: dim_vehicle_type 
 */

CREATE TABLE dim_vehicle_type(
    SK_VehicelType    int             NOT NULL,
    Vehicle_Type      varchar(100)    NOT NULL,
    DI_CreateDate     date            NOT NULL,
    DI_Source         varchar(100)    NOT NULL,
    CONSTRAINT PK7_1 PRIMARY KEY NONCLUSTERED (SK_VehicelType)
)

go


IF OBJECT_ID('dim_vehicle_type') IS NOT NULL
    PRINT '<<< CREATED TABLE dim_vehicle_type >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dim_vehicle_type >>>'
go

/* 
 * TABLE: fact_accidents 
 */

CREATE TABLE fact_accidents(
    SK_FactAccidents          int     NOT NULL,
    Crash_ID                  int     NOT NULL,
    Crash_Date                int     NULL,
    Crash_Time                int     NULL,
    Location                  int     NULL,
    Pedestrian_Injuries       int     NOT NULL,
    Pedestrian_Deaths         int     NOT NULL,
    Motorist_Injuries         int     NOT NULL,
    Motorist_Deaths           int     NOT NULL,
    Micromobility_Injuries    int     NOT NULL,
    Micromobility_Deaths      int     NOT NULL,
    Total_Injuries            int     NOT NULL,
    Total_Deaths              int     NOT NULL,
    Flag_Just_Injuries        int     NULL,
    Flag_Just_Deaths          int     NULL,
    Pedestrian_Flag           int     NULL,
    Motorist_Flag             int     NULL,
    Micromobility_Flag        int     NULL,
    DI_CreateDate             date    NOT NULL,
    DI_Source                 int     NULL,
    CONSTRAINT PK8 PRIMARY KEY NONCLUSTERED (SK_FactAccidents)
)

go


IF OBJECT_ID('fact_accidents') IS NOT NULL
    PRINT '<<< CREATED TABLE fact_accidents >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE fact_accidents >>>'
go

/* 
 * TABLE: fact_contributing_factor 
 */

CREATE TABLE fact_contributing_factor(
    SK_Fact_ContributingFactor    int     NOT NULL,
    SK_FactAccidents              int     NULL,
    SK_ContributingFactor         int     NULL,
    DK_Contributing_Factor        int     NOT NULL,
    DI_CreateDate                 date    NOT NULL,
    CONSTRAINT PK13 PRIMARY KEY NONCLUSTERED (SK_Fact_ContributingFactor)
)

go


IF OBJECT_ID('fact_contributing_factor') IS NOT NULL
    PRINT '<<< CREATED TABLE fact_contributing_factor >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE fact_contributing_factor >>>'
go

/* 
 * TABLE: fact_vehicle 
 */

CREATE TABLE fact_vehicle(
    SK_Fact_Vehicle     int     NOT NULL,
    SK_FactAccidents    int     NULL,
    SK_VehicelType      int     NULL,
    DI_CreateDate       date    NOT NULL,
    CONSTRAINT PK13_1 PRIMARY KEY NONCLUSTERED (SK_Fact_Vehicle)
)

go


IF OBJECT_ID('fact_vehicle') IS NOT NULL
    PRINT '<<< CREATED TABLE fact_vehicle >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE fact_vehicle >>>'
go

/* 
 * TABLE: fact_accidents 
 */

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_location1 
    FOREIGN KEY (Location)
    REFERENCES dim_location(SK_Location)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_date4 
    FOREIGN KEY (Crash_Date)
    REFERENCES dim_date(SK_Date)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_time6 
    FOREIGN KEY (Crash_Time)
    REFERENCES dim_time(SK_Time)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_source14 
    FOREIGN KEY (DI_Source)
    REFERENCES dim_source(SK_Source)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_flag15 
    FOREIGN KEY (Pedestrian_Flag)
    REFERENCES dim_flag(SK_Flag)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_flag17 
    FOREIGN KEY (Motorist_Flag)
    REFERENCES dim_flag(SK_Flag)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_flag18 
    FOREIGN KEY (Micromobility_Flag)
    REFERENCES dim_flag(SK_Flag)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_flag19 
    FOREIGN KEY (Flag_Just_Injuries)
    REFERENCES dim_flag(SK_Flag)
go

ALTER TABLE fact_accidents ADD CONSTRAINT Refdim_flag21 
    FOREIGN KEY (Flag_Just_Deaths)
    REFERENCES dim_flag(SK_Flag)
go


/* 
 * TABLE: fact_contributing_factor 
 */

ALTER TABLE fact_contributing_factor ADD CONSTRAINT Reffact_accidents7 
    FOREIGN KEY (SK_FactAccidents)
    REFERENCES fact_accidents(SK_FactAccidents)
go

ALTER TABLE fact_contributing_factor ADD CONSTRAINT Refdim_contributing_factor8 
    FOREIGN KEY (SK_ContributingFactor)
    REFERENCES dim_contributing_factor(SK_ContributingFactor)
go


/* 
 * TABLE: fact_vehicle 
 */

ALTER TABLE fact_vehicle ADD CONSTRAINT Refdim_vehicle_type12 
    FOREIGN KEY (SK_VehicelType)
    REFERENCES dim_vehicle_type(SK_VehicelType)
go

ALTER TABLE fact_vehicle ADD CONSTRAINT Reffact_accidents13 
    FOREIGN KEY (SK_FactAccidents)
    REFERENCES fact_accidents(SK_FactAccidents)
go



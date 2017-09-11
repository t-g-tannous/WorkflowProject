-- Thanks to Amir Kibbar and Peter Rietzler for contributing the schema for H2 database, 
-- and verifying that it works with Quartz's StdJDBCDelegate
--
-- Note, Quartz depends on row-level locking which means you must use the MVCC=TRUE 
-- setting on your H2 database, or you will experience dead-locks
--
--
-- In your Quartz properties file, you'll need to set 
-- org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate

CREATE TABLE QRTZ_CALENDARS (
  CALENDAR_NAME VARCHAR (200)  NOT NULL ,
  CALENDAR IMAGE NOT NULL
);

CREATE TABLE QRTZ_CRON_TRIGGERS (
  TRIGGER_NAME VARCHAR (200)  NOT NULL ,
  TRIGGER_GROUP VARCHAR (200)  NOT NULL ,
  CRON_EXPRESSION VARCHAR (120)  NOT NULL ,
  TIME_ZONE_ID VARCHAR (80) 
);

CREATE TABLE QRTZ_FIRED_TRIGGERS (
  ENTRY_ID VARCHAR (95)  NOT NULL ,
  TRIGGER_NAME VARCHAR (200)  NOT NULL ,
  TRIGGER_GROUP VARCHAR (200)  NOT NULL ,
  IS_VOLATILE BOOLEAN  NOT NULL ,
  INSTANCE_NAME VARCHAR (200)  NOT NULL ,
  FIRED_TIME BIGINT NOT NULL ,
  PRIORITY INTEGER NOT NULL ,
  STATE VARCHAR (16)  NOT NULL,
  JOB_NAME VARCHAR (200)  NULL ,
  JOB_GROUP VARCHAR (200)  NULL ,
  IS_STATEFUL BOOLEAN  NULL ,
  REQUESTS_RECOVERY BOOLEAN  NULL 
);

CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
  TRIGGER_GROUP VARCHAR (200)  NOT NULL 
);

CREATE TABLE QRTZ_SCHEDULER_STATE (
  INSTANCE_NAME VARCHAR (200)  NOT NULL ,
  LAST_CHECKIN_TIME BIGINT NOT NULL ,
  CHECKIN_INTERVAL BIGINT NOT NULL
);

CREATE TABLE QRTZ_LOCKS (
  LOCK_NAME VARCHAR (40)  NOT NULL 
);

CREATE TABLE QRTZ_JOB_DETAILS (
  JOB_NAME VARCHAR (200)  NOT NULL ,
  JOB_GROUP VARCHAR (200)  NOT NULL ,
  DESCRIPTION VARCHAR (250) NULL ,
  JOB_CLASS_NAME VARCHAR (250)  NOT NULL ,
  IS_DURABLE BOOLEAN  NOT NULL ,
  IS_VOLATILE BOOLEAN  NOT NULL ,
  IS_STATEFUL BOOLEAN  NOT NULL ,
  REQUESTS_RECOVERY BOOLEAN  NOT NULL ,
  JOB_DATA IMAGE NULL
);

CREATE TABLE QRTZ_JOB_LISTENERS (
  JOB_NAME VARCHAR (200)  NOT NULL ,
  JOB_GROUP VARCHAR (200)  NOT NULL ,
  JOB_LISTENER VARCHAR (200)  NOT NULL
);

CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
  TRIGGER_NAME VARCHAR (200)  NOT NULL ,
  TRIGGER_GROUP VARCHAR (200)  NOT NULL ,
  REPEAT_COUNT BIGINT NOT NULL ,
  REPEAT_INTERVAL BIGINT NOT NULL ,
  TIMES_TRIGGERED BIGINT NOT NULL
);

CREATE TABLE QRTZ_BLOB_TRIGGERS (
  TRIGGER_NAME VARCHAR (200)  NOT NULL ,
  TRIGGER_GROUP VARCHAR (200)  NOT NULL ,
  BLOB_DATA IMAGE NULL
);

CREATE TABLE QRTZ_TRIGGER_LISTENERS (
  TRIGGER_NAME VARCHAR (200)  NOT NULL ,
  TRIGGER_GROUP VARCHAR (200)  NOT NULL ,
  TRIGGER_LISTENER VARCHAR (200)  NOT NULL
);

CREATE TABLE QRTZ_TRIGGERS (
  TRIGGER_NAME VARCHAR (200)  NOT NULL ,
  TRIGGER_GROUP VARCHAR (200)  NOT NULL ,
  JOB_NAME VARCHAR (200)  NOT NULL ,
  JOB_GROUP VARCHAR (200)  NOT NULL ,
  IS_VOLATILE BOOLEAN  NOT NULL ,
  DESCRIPTION VARCHAR (250) NULL ,
  NEXT_FIRE_TIME BIGINT NULL ,
  PREV_FIRE_TIME BIGINT NULL ,
  PRIORITY INTEGER NULL ,
  TRIGGER_STATE VARCHAR (16)  NOT NULL ,
  TRIGGER_TYPE VARCHAR (8)  NOT NULL ,
  START_TIME BIGINT NOT NULL ,
  END_TIME BIGINT NULL ,
  CALENDAR_NAME VARCHAR (200)  NULL ,
  MISFIRE_INSTR SMALLINT NULL ,
  JOB_DATA IMAGE NULL
);

ALTER TABLE QRTZ_CALENDARS  ADD
  CONSTRAINT PK_QRTZ_CALENDARS PRIMARY KEY  
  (
    CALENDAR_NAME
  );

ALTER TABLE QRTZ_CRON_TRIGGERS  ADD
  CONSTRAINT PK_QRTZ_CRON_TRIGGERS PRIMARY KEY  
  (
    TRIGGER_NAME,
    TRIGGER_GROUP
  );

ALTER TABLE QRTZ_FIRED_TRIGGERS  ADD
  CONSTRAINT PK_QRTZ_FIRED_TRIGGERS PRIMARY KEY  
  (
    ENTRY_ID
  );

ALTER TABLE QRTZ_PAUSED_TRIGGER_GRPS  ADD
  CONSTRAINT PK_QRTZ_PAUSED_TRIGGER_GRPS PRIMARY KEY  
  (
    TRIGGER_GROUP
  );

ALTER TABLE QRTZ_SCHEDULER_STATE  ADD
  CONSTRAINT PK_QRTZ_SCHEDULER_STATE PRIMARY KEY  
  (
    INSTANCE_NAME
  );

ALTER TABLE QRTZ_LOCKS  ADD
  CONSTRAINT PK_QRTZ_LOCKS PRIMARY KEY  
  (
    LOCK_NAME
  );

ALTER TABLE QRTZ_JOB_DETAILS  ADD
  CONSTRAINT PK_QRTZ_JOB_DETAILS PRIMARY KEY  
  (
    JOB_NAME,
    JOB_GROUP
  );

ALTER TABLE QRTZ_JOB_LISTENERS  ADD
  CONSTRAINT PK_QRTZ_JOB_LISTENERS PRIMARY KEY  
  (
    JOB_NAME,
    JOB_GROUP,
    JOB_LISTENER
  );

ALTER TABLE QRTZ_SIMPLE_TRIGGERS  ADD
  CONSTRAINT PK_QRTZ_SIMPLE_TRIGGERS PRIMARY KEY  
  (
    TRIGGER_NAME,
    TRIGGER_GROUP
  );

ALTER TABLE QRTZ_TRIGGER_LISTENERS  ADD
  CONSTRAINT PK_QRTZ_TRIGGER_LISTENERS PRIMARY KEY  
  (
    TRIGGER_NAME,
    TRIGGER_GROUP,
    TRIGGER_LISTENER
  );

ALTER TABLE QRTZ_TRIGGERS  ADD
  CONSTRAINT PK_QRTZ_TRIGGERS PRIMARY KEY  
  (
    TRIGGER_NAME,
    TRIGGER_GROUP
  );

ALTER TABLE QRTZ_CRON_TRIGGERS ADD
  CONSTRAINT FK_QRTZ_CRON_TRIGGERS_QRTZ_TRIGGERS FOREIGN KEY
  (
    TRIGGER_NAME,
    TRIGGER_GROUP
  ) REFERENCES QRTZ_TRIGGERS (
    TRIGGER_NAME,
    TRIGGER_GROUP
  ) ON DELETE CASCADE;

ALTER TABLE QRTZ_JOB_LISTENERS ADD
  CONSTRAINT FK_QRTZ_JOB_LISTENERS_QRTZ_JOB_DETAILS FOREIGN KEY
  (
    JOB_NAME,
    JOB_GROUP
  ) REFERENCES QRTZ_JOB_DETAILS (
    JOB_NAME,
    JOB_GROUP
  ) ON DELETE CASCADE;

ALTER TABLE QRTZ_SIMPLE_TRIGGERS ADD
  CONSTRAINT FK_QRTZ_SIMPLE_TRIGGERS_QRTZ_TRIGGERS FOREIGN KEY
  (
    TRIGGER_NAME,
    TRIGGER_GROUP
  ) REFERENCES QRTZ_TRIGGERS (
    TRIGGER_NAME,
    TRIGGER_GROUP
  ) ON DELETE CASCADE;

ALTER TABLE QRTZ_TRIGGER_LISTENERS ADD
  CONSTRAINT FK_QRTZ_TRIGGER_LISTENERS_QRTZ_TRIGGERS FOREIGN KEY
  (
    TRIGGER_NAME,
    TRIGGER_GROUP
  ) REFERENCES QRTZ_TRIGGERS (
    TRIGGER_NAME,
    TRIGGER_GROUP
  ) ON DELETE CASCADE;

ALTER TABLE QRTZ_TRIGGERS ADD
  CONSTRAINT FK_QRTZ_TRIGGERS_QRTZ_JOB_DETAILS FOREIGN KEY
  (
    JOB_NAME,
    JOB_GROUP
  ) REFERENCES QRTZ_JOB_DETAILS (
    JOB_NAME,
    JOB_GROUP
  );

INSERT INTO QRTZ_LOCKS VALUES('TRIGGER_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('JOB_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('CALENDAR_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('STATE_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('MISFIRE_ACCESS');
COMMIT;

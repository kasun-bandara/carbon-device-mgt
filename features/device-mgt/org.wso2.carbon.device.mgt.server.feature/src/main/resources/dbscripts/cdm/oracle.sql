CREATE TABLE DM_DEVICE_TYPE (
  ID NUMBER(10) NOT NULL,
  NAME VARCHAR2(300) DEFAULT NULL,
  DEVICE_TYPE_META VARCHAR2(3000) DEFAULT NULL,
  LAST_UPDATED_TIMESTAMP TIMESTAMP(0) NOT NULL,
  PROVIDER_TENANT_ID INTEGER DEFAULT 0,
  SHARED_WITH_ALL_TENANTS NUMBER(1) DEFAULT 0 NOT NULL,
  CONSTRAINT PK_DM_DEVICE_TYPE PRIMARY KEY (ID),
  UNIQUE (NAME, PROVIDER_TENANT_ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_TYPE_id_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_TYPE_id_seq_tr
BEFORE INSERT
ON DM_DEVICE_TYPE
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_TYPE_id_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_GROUP (
  ID NUMBER(10) NOT NULL,
  DESCRIPTION CLOB DEFAULT NULL,
  GROUP_NAME VARCHAR2(100) DEFAULT NULL,
  OWNER VARCHAR2(45) DEFAULT NULL,
  TENANT_ID NUMBER(10) DEFAULT 0,
  CONSTRAINT PK_DM_GROUP PRIMARY KEY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_GROUP_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_GROUP_seq_tr
BEFORE INSERT
ON DM_GROUP
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_GROUP_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_ROLE_GROUP_MAP (
  ID        NUMBER(10) NOT NULL,
  GROUP_ID  NUMBER(10)   DEFAULT NULL,
  ROLE      VARCHAR2(45) DEFAULT NULL,
  TENANT_ID NUMBER(10)   DEFAULT 0,
  CONSTRAINT PK_DM_ROLE_GROUP PRIMARY KEY (ID),
  CONSTRAINT fk_DM_ROLE_GROUP_MAP_GROUP2
    FOREIGN KEY (GROUP_ID)
    REFERENCES DM_GROUP (ID)
    ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_ROLE_GROUP_MAP_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_ROLE_GROUP_MAP_seq_tr
BEFORE INSERT
ON DM_ROLE_GROUP_MAP
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_ROLE_GROUP_MAP_seq.NEXTVAL
    INTO :NEW.ID
    FROM DUAL;
  END;
/

CREATE TABLE DM_DEVICE (
  ID                    NUMBER(10) NOT NULL,
  DESCRIPTION           CLOB DEFAULT NULL,
  NAME                  VARCHAR2(100) DEFAULT NULL,
  DEVICE_TYPE_ID        NUMBER(10) DEFAULT NULL,
  DEVICE_IDENTIFICATION VARCHAR2(300) DEFAULT NULL,
  LAST_UPDATED_TIMESTAMP TIMESTAMP NOT NULL,
  TENANT_ID NUMBER(10) DEFAULT 0,
  CONSTRAINT PK_DM_DEVICE PRIMARY KEY (ID),
  CONSTRAINT FK_DM_DEVICE_DM_DEVICE_TYPE2 FOREIGN KEY (DEVICE_TYPE_ID )
  REFERENCES DM_DEVICE_TYPE (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_seq_tr
BEFORE INSERT
ON DM_DEVICE
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_DEVICE_PROPERTIES (
     DEVICE_TYPE_NAME VARCHAR2(300) NOT NULL,
     DEVICE_IDENTIFICATION VARCHAR2(300) NOT NULL,
     PROPERTY_NAME VARCHAR2(100) DEFAULT 0,
     PROPERTY_VALUE VARCHAR2(100) DEFAULT NULL,
     TENANT_ID VARCHAR2(100) DEFAULT NULL,
     CONSTRAINT PK_DM_DEVICE_PROPERTY  PRIMARY KEY (DEVICE_TYPE_NAME, DEVICE_IDENTIFICATION, PROPERTY_NAME, TENANT_ID)
)
/


CREATE TABLE DM_DEVICE_GROUP_MAP (
  ID        NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) DEFAULT NULL,
  GROUP_ID  NUMBER(10) DEFAULT NULL,
  TENANT_ID NUMBER(10) DEFAULT 0,
  PRIMARY KEY (ID),
  CONSTRAINT fk_DM_DEV_GROUP_MAP_DM_DEV2
    FOREIGN KEY (DEVICE_ID)
    REFERENCES DM_DEVICE (ID)
    ON DELETE CASCADE,
  CONSTRAINT fk_DM_DEV_GROUP_MAP_DM_GROUP2
    FOREIGN KEY (GROUP_ID)
    REFERENCES DM_GROUP (ID)
    ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_GROUP_MAP_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_GROUP_MAP_seq_tr
BEFORE INSERT ON DM_DEVICE_GROUP_MAP FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_GROUP_MAP_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_OPERATION (
  ID NUMBER(10) NOT NULL,
  TYPE VARCHAR2(50) NOT NULL,
  CREATED_TIMESTAMP TIMESTAMP(0) NOT NULL,
  RECEIVED_TIMESTAMP TIMESTAMP(0) NULL,
  OPERATION_CODE VARCHAR2(1000) NOT NULL,
  CONSTRAINT PK_DM_OPERATION PRIMARY KEY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_OPERATION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_OPERATION_seq_tr
BEFORE INSERT
ON DM_OPERATION
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_OPERATION_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_CONFIG_OPERATION (
  OPERATION_ID NUMBER(10) NOT NULL,
  OPERATION_CONFIG  BLOB DEFAULT NULL,
  CONSTRAINT PK_DM_CONFIG_OPERATION PRIMARY KEY (OPERATION_ID),
  CONSTRAINT FK_DM_OPERATION_CONFIG FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID)
)
/
CREATE TABLE DM_COMMAND_OPERATION (
  OPERATION_ID NUMBER(10) NOT NULL,
  ENABLED NUMBER(10) DEFAULT 0 NOT NULL,
  CONSTRAINT PK_DM_COMMAND_OPERATION PRIMARY KEY (OPERATION_ID),
  CONSTRAINT FK_DM_OPERATION_COMMAND FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID)
)
/
CREATE TABLE DM_POLICY_OPERATION (
  OPERATION_ID NUMBER(10) NOT NULL,
  ENABLED NUMBER(10) DEFAULT 0 NOT NULL,
  OPERATION_DETAILS BLOB DEFAULT NULL,
  CONSTRAINT PK_DM_POLICY_OPERATION PRIMARY KEY (OPERATION_ID),
  CONSTRAINT FK_DM_OPERATION_POLICY FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID)
)
/
CREATE TABLE DM_PROFILE_OPERATION (
  OPERATION_ID NUMBER(10) NOT NULL,
  ENABLED NUMBER(10) DEFAULT 0 NOT NULL,
  OPERATION_DETAILS BLOB DEFAULT NULL,
  CONSTRAINT PK_DM_PROFILE_OPERATION PRIMARY KEY (OPERATION_ID),
  CONSTRAINT FK_DM_OPERATION_PROFILE FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID)
)
/
CREATE TABLE DM_ENROLMENT (
  ID NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) NOT NULL,
  OWNER VARCHAR2(50) NOT NULL,
  OWNERSHIP VARCHAR2(45) DEFAULT NULL,
  STATUS VARCHAR2(50) NULL,
  DATE_OF_ENROLMENT TIMESTAMP(0) DEFAULT NULL,
  DATE_OF_LAST_UPDATE TIMESTAMP(0) DEFAULT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  CONSTRAINT PK_DM_ENROLMENT PRIMARY KEY (ID),
  CONSTRAINT FK_DM_DEVICE_ENROLMENT FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_ENROLMENT_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_ENROLMENT_seq_tr
BEFORE INSERT
ON DM_ENROLMENT
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_ENROLMENT_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_ENROLMENT_OP_MAPPING (
  ID NUMBER(10) NOT NULL,
  ENROLMENT_ID NUMBER(10) NOT NULL,
  OPERATION_ID NUMBER(10) NOT NULL,
  STATUS VARCHAR2(50) NULL,
  PUSH_NOTIFICATION_STATUS VARCHAR2(50) NULL,
  CREATED_TIMESTAMP NUMBER(14) NOT NULL,
  UPDATED_TIMESTAMP NUMBER(14) NOT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_DM_DEVICE_OP_MAP_DEVICE FOREIGN KEY (ENROLMENT_ID) REFERENCES
    DM_ENROLMENT (ID),
  CONSTRAINT FK_DM_DEVICE_OP_MAP_OPERATION FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_ENROLMENT_OP_MAP_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_ENROLMENT_OP_MAP_seq_tr
BEFORE INSERT
ON DM_ENROLMENT_OP_MAPPING
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_ENROLMENT_OP_MAP_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_DEVICE_OPERATION_RESPONSE (
  ID NUMBER(10) NOT NULL,
  ENROLMENT_ID NUMBER(10) NOT NULL,
  OPERATION_ID NUMBER(10) NOT NULL,
  OPERATION_RESPONSE BLOB DEFAULT NULL,
  RECEIVED_TIMESTAMP TIMESTAMP(0) NULL,
  CONSTRAINT PK_DM_DEVICE_OP_RESPONSE PRIMARY KEY (ID),
  CONSTRAINT FK_DM_DEVICE_OP_RES_DEVICE FOREIGN KEY (ENROLMENT_ID) REFERENCES
    DM_ENROLMENT (ID),
  CONSTRAINT FK_DM_DEVICE_OP_RES_OPERATION FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_OP_RESPONSE_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_OP_RESPONSE_seq_tr
BEFORE INSERT
ON DM_DEVICE_OPERATION_RESPONSE
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_OP_RESPONSE_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

-- POLICY RELATED TABLES ---
CREATE  TABLE DM_PROFILE (
  ID NUMBER(10) NOT NULL ,
  PROFILE_NAME VARCHAR2(45) NOT NULL ,
  TENANT_ID NUMBER(10) NOT NULL ,
  DEVICE_TYPE VARCHAR2(300) NOT NULL ,
  CREATED_TIME TIMESTAMP(0) NOT NULL ,
  UPDATED_TIME TIMESTAMP(0) NOT NULL ,
  CONSTRAINT PK_DM_PROFILE PRIMARY KEY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_PROFILE_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_PROFILE_seq_tr
BEFORE INSERT
ON DM_PROFILE
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_PROFILE_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE  TABLE DM_POLICY (
  ID NUMBER(10) NOT NULL ,
  NAME VARCHAR2(45) DEFAULT NULL ,
  DESCRIPTION VARCHAR2(1000) NULL,
  TENANT_ID NUMBER(10) NOT NULL ,
  PROFILE_ID NUMBER(10) NOT NULL ,
  OWNERSHIP_TYPE VARCHAR2(45) NULL,
  COMPLIANCE VARCHAR2(100) NULL,
  PRIORITY NUMBER(10) NOT NULL,
  ACTIVE NUMBER(10) NOT NULL,
  UPDATED NUMBER(10) NULL,
  CONSTRAINT PK_DM_PROFILE_DM_POLICY PRIMARY KEY (ID) ,
  CONSTRAINT FK_DM_PROFILE_DM_POLICY
  FOREIGN KEY (PROFILE_ID )
  REFERENCES DM_PROFILE (ID )
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_POLICY_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_POLICY_seq_tr
BEFORE INSERT
ON DM_POLICY
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_POLICY_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE  TABLE DM_DEVICE_POLICY (
  ID NUMBER(10) NOT NULL ,
  DEVICE_ID NUMBER(10) NOT NULL ,
  ENROLMENT_ID NUMBER(10) NOT NULL,
  DEVICE BLOB NOT NULL,
  POLICY_ID NUMBER(10) NOT NULL ,
  CONSTRAINT PK_POLICY_DEVICE_POLICY PRIMARY KEY (ID) ,
  CONSTRAINT FK_POLICY_DEVICE_POLICY
  FOREIGN KEY (POLICY_ID )
  REFERENCES DM_POLICY (ID ),
  CONSTRAINT FK_DEVICE_DEVICE_POLICY
  FOREIGN KEY (DEVICE_ID )
  REFERENCES DM_DEVICE (ID )
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_POLICY_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_POLICY_seq_tr
BEFORE INSERT
ON DM_DEVICE_POLICY
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_POLICY_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE  TABLE DM_DEVICE_TYPE_POLICY (
  ID NUMBER(10) NOT NULL ,
  DEVICE_TYPE VARCHAR2(300) NOT NULL ,
  POLICY_ID NUMBER(10) NOT NULL ,
  CONSTRAINT PK_DEV_TYPE_POLICY PRIMARY KEY (ID) ,
  CONSTRAINT FK_DEV_TYPE_POLICY
  FOREIGN KEY (POLICY_ID )
  REFERENCES DM_POLICY (ID )
)
/


CREATE  TABLE DM_PROFILE_FEATURES (
  ID NUMBER(10) NOT NULL,
  PROFILE_ID NUMBER(10) NOT NULL,
  FEATURE_CODE VARCHAR2(100) NOT NULL,
  DEVICE_TYPE VARCHAR2(300) NOT NULL ,
  TENANT_ID NUMBER(10) NOT NULL ,
  CONTENT BLOB DEFAULT NULL NULL,
  CONSTRAINT PK_DM_PROF_DM_POLICY_FEATURES PRIMARY KEY (ID),
  CONSTRAINT FK_DM_PROF_DM_POLICY_FEATURES
  FOREIGN KEY (PROFILE_ID)
  REFERENCES DM_PROFILE (ID)
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_PROFILE_FEATURES_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_PROFILE_FEATURES_seq_tr
BEFORE INSERT
ON DM_PROFILE_FEATURES
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_PROFILE_FEATURES_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE  TABLE DM_ROLE_POLICY (
  ID NUMBER(10) NOT NULL ,
  ROLE_NAME VARCHAR2(45) NOT NULL ,
  POLICY_ID NUMBER(10) NOT NULL ,
  CONSTRAINT PK_ROLE_POLICY_POLICY PRIMARY KEY (ID) ,
  CONSTRAINT FK_ROLE_POLICY_POLICY
  FOREIGN KEY (POLICY_ID )
  REFERENCES DM_POLICY (ID )
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_ROLE_POLICY_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_ROLE_POLICY_seq_tr
BEFORE INSERT
ON DM_ROLE_POLICY
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_ROLE_POLICY_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE  TABLE DM_USER_POLICY (
  ID NUMBER(10) NOT NULL ,
  POLICY_ID NUMBER(10) NOT NULL ,
  USERNAME VARCHAR2(45) NOT NULL ,
  CONSTRAINT PK_DM_USER_POLICY PRIMARY KEY (ID) ,
  CONSTRAINT FK_DM_POLICY_USER_POLICY
  FOREIGN KEY (POLICY_ID )
  REFERENCES DM_POLICY (ID )
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_USER_POLICY_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_USER_POLICY_seq_tr
BEFORE INSERT
ON DM_USER_POLICY
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_USER_POLICY_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE TABLE DM_DEVICE_POLICY_APPLIED (
  ID NUMBER(10) NOT NULL ,
  DEVICE_ID NUMBER(10) NOT NULL ,
  ENROLMENT_ID NUMBER(10) NOT NULL,
  POLICY_ID NUMBER(10) NOT NULL ,
  POLICY_CONTENT BLOB NULL ,
  TENANT_ID NUMBER(10) NOT NULL,
  APPLIED NUMBER(1) DEFAULT 0,
  CREATED_TIME TIMESTAMP(0) NULL ,
  UPDATED_TIME TIMESTAMP(0) NULL ,
  APPLIED_TIME TIMESTAMP(0) NULL ,
  CONSTRAINT PK_DM_POLICY_DEV_APPLIED PRIMARY KEY (ID),
  CONSTRAINT FK_DM_POLICY_DEV_APPLIED
  FOREIGN KEY (DEVICE_ID )
  REFERENCES DM_DEVICE (ID )
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_POLICY_APPLIED_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEV_POLICY_APPLIED_seq_tr
BEFORE INSERT
ON DM_DEVICE_POLICY_APPLIED
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_POLICY_APPLIED_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_CRITERIA (
  ID NUMBER(10) NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  NAME VARCHAR2(50) NULL,
  CONSTRAINT PK_DM_CRITERIA PRIMARY KEY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_CRITERIA_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_CRITERIA_seq_tr
BEFORE INSERT
ON DM_CRITERIA
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_CRITERIA_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_POLICY_CRITERIA (
  ID NUMBER(10) NOT NULL,
  CRITERIA_ID NUMBER(10) NOT NULL,
  POLICY_ID NUMBER(10) NOT NULL,
  CONSTRAINT PK_DM_POLICY_CRITERIA PRIMARY KEY (ID),
  CONSTRAINT FK_CRITERIA_POLICY_CRITERIA
  FOREIGN KEY (CRITERIA_ID)
  REFERENCES DM_CRITERIA (ID),
  CONSTRAINT FK_POLICY_POLICY_CRITERIA
  FOREIGN KEY (POLICY_ID)
  REFERENCES DM_POLICY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_POLICY_CRITERIA_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_POLICY_CRITERIA_seq_tr
BEFORE INSERT
ON DM_POLICY_CRITERIA
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_POLICY_CRITERIA_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_POLICY_CRITERIA_PROPERTIES (
  ID NUMBER(10) NOT NULL,
  POLICY_CRITERION_ID NUMBER(10) NOT NULL,
  PROP_KEY VARCHAR2(45) NULL,
  PROP_VALUE VARCHAR2(100) NULL,
  CONTENT BLOB NULL ,
  CONSTRAINT PK_DM_POLICY_CRITERIA_PROP PRIMARY KEY (ID),
  CONSTRAINT FK_POLICY_CRITERIA_PROP
  FOREIGN KEY (POLICY_CRITERION_ID)
  REFERENCES DM_POLICY_CRITERIA (ID)
  ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_POLICY_CRITERIA_PROP_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_POLICY_CRITERIA_PROP_seq_tr
BEFORE INSERT
ON DM_POLICY_CRITERIA_PROPERTIES
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_POLICY_CRITERIA_PROP_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_POLICY_COMPLIANCE_STATUS (
  ID NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) NOT NULL,
  ENROLMENT_ID NUMBER(10) NOT NULL,
  POLICY_ID NUMBER(10) NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  STATUS NUMBER(10) NULL,
  LAST_SUCCESS_TIME TIMESTAMP(0) NULL,
  LAST_REQUESTED_TIME TIMESTAMP(0) NULL,
  LAST_FAILED_TIME TIMESTAMP(0) NULL,
  ATTEMPTS NUMBER(10) NULL,
  CONSTRAINT PK_DM_POLICY_COMP_STATUS PRIMARY KEY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_POLICY_COMP_STATUS_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_POLICY_COMP_STATUS_seq_tr
BEFORE INSERT
ON DM_POLICY_COMPLIANCE_STATUS
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_POLICY_COMP_STATUS_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_POLICY_CHANGE_MGT (
  ID NUMBER(10) NOT NULL,
  POLICY_ID NUMBER(10) NOT NULL,
  DEVICE_TYPE VARCHAR2(300) NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  CONSTRAINT PK_DM_POLICY_CHANGE_MGT PRIMARY KEY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_POLICY_CHANGE_MGT_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_POLICY_CHANGE_MGT_seq_tr
BEFORE INSERT
ON DM_POLICY_CHANGE_MGT
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_POLICY_CHANGE_MGT_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_POLICY_COMPLIANCE_FEATURES (
  ID NUMBER(10) NOT NULL,
  COMPLIANCE_STATUS_ID NUMBER(10) NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  FEATURE_CODE VARCHAR2(100) NOT NULL,
  STATUS NUMBER(10) NULL,
  CONSTRAINT PK_COMPLIANCE_FEATURES_STATUS PRIMARY KEY (ID),
  CONSTRAINT FK_COMPLIANCE_FEATURES_STATUS
  FOREIGN KEY (COMPLIANCE_STATUS_ID)
  REFERENCES DM_POLICY_COMPLIANCE_STATUS (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_POLICY_COMP_FEATURES_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_POLICY_COMP_FEATURES_seq_tr
BEFORE INSERT
ON DM_POLICY_COMPLIANCE_FEATURES
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_POLICY_COMP_FEATURES_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE TABLE DM_DEVICE_GROUP_POLICY (
  ID NUMBER(10) NOT NULL,
  DEVICE_GROUP_ID NUMBER(10) NOT NULL,
  POLICY_ID NUMBER(10) NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_DM_DEVICE_GROUP_POLICY
    FOREIGN KEY (DEVICE_GROUP_ID)
    REFERENCES DM_GROUP (ID)
    ON DELETE CASCADE,
  CONSTRAINT FK_DM_DEVICE_GROUP_DM_POLICY
    FOREIGN KEY (POLICY_ID)
    REFERENCES DM_POLICY (ID)
    ON DELETE CASCADE
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_GROUP_POLICY_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_GROUP_POLICY_seq_tr
BEFORE INSERT ON DM_DEVICE_GROUP_POLICY FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_GROUP_POLICY_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE TABLE DM_APPLICATION (
  ID NUMBER(10) NOT NULL,
  NAME VARCHAR2(150) NOT NULL,
  APP_IDENTIFIER VARCHAR2(150) NOT NULL,
  PLATFORM VARCHAR2(50) DEFAULT NULL,
  CATEGORY VARCHAR2(50) NULL,
  VERSION VARCHAR2(50) NULL,
  TYPE VARCHAR2(50) NULL,
  LOCATION_URL VARCHAR2(100) DEFAULT NULL,
  IMAGE_URL VARCHAR2(100) DEFAULT NULL,
  APP_PROPERTIES BLOB NULL,
  MEMORY_USAGE NUMBER(10) NULL,
  IS_ACTIVE NUMBER(10) DEFAULT 0 NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  CONSTRAINT PK_DM_APPLICATION PRIMARY KEY (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_APPLICATION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_APPLICATION_seq_tr
BEFORE INSERT
ON DM_APPLICATION
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_APPLICATION_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/


CREATE TABLE DM_DEVICE_APPLICATION_MAPPING (
  ID NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) NOT NULL,
  APPLICATION_ID NUMBER(10) NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  CONSTRAINT PK_DM_DEVICE_APP_MAPPING PRIMARY KEY (ID),
  CONSTRAINT fk_dm_device FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID),
  CONSTRAINT fk_dm_application FOREIGN KEY (APPLICATION_ID) REFERENCES
    DM_APPLICATION (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_APP_MAPPING_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_APP_MAPPING_seq_tr
BEFORE INSERT
ON DM_DEVICE_APPLICATION_MAPPING
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_APP_MAPPING_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

-- POLICY RELATED TABLES  FINISHED --

-- NOTIFICATION TABLE --
CREATE TABLE DM_NOTIFICATION (
  NOTIFICATION_ID NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) NOT NULL,
  OPERATION_ID NUMBER(10) NOT NULL,
  TENANT_ID NUMBER(10) NOT NULL,
  STATUS VARCHAR2(10) NULL,
  DESCRIPTION VARCHAR2(1000) NULL,
  CONSTRAINT PK_DM_NOTIFICATION PRIMARY KEY (NOTIFICATION_ID),
  CONSTRAINT FK_DM_DEVICE_NOTIFICATION FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID),
  CONSTRAINT FK_DM_OPERATION_NOTIFICATION FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID)
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_NOTIFICATION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_NOTIFICATION_seq_tr
BEFORE INSERT
ON DM_NOTIFICATION
REFERENCING NEW AS NEW
FOR EACH ROW
WHEN (NEW.NOTIFICATION_ID IS NULL)
  BEGIN
    SELECT DM_NOTIFICATION_seq.NEXTVAL INTO :NEW.NOTIFICATION_ID FROM DUAL;
  END;
/
-- NOTIFICATION TABLE END --


-- Device Info and Search Table --

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE DM_DEVICE_INFO';
  EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE DM_DEVICE_INFO (
  ID NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) NULL,
  KEY_FIELD VARCHAR2(45) NULL,
  VALUE_FIELD VARCHAR2(100) NULL,
  PRIMARY KEY (ID)
  ,
  CONSTRAINT DM_DEVICE_INFO_DEVICE
  FOREIGN KEY (DEVICE_ID)
  REFERENCES DM_DEVICE (ID)
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_INFO_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_INFO_seq_tr
BEFORE INSERT ON DM_DEVICE_INFO FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_INFO_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_DEVICE_LOCATION (
  ID NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) NULL,
  LATITUDE BINARY_DOUBLE NULL,
  LONGITUDE BINARY_DOUBLE NULL,
  STREET1 VARCHAR2(45) NULL,
  STREET2 VARCHAR2(45) NULL,
  CITY VARCHAR2(45) NULL,
  ZIP VARCHAR2(10) NULL,
  STATE VARCHAR2(45) NULL,
  COUNTRY VARCHAR2(45) NULL,
  UPDATE_TIMESTAMP NUMBER(19) NOT NULL,
  PRIMARY KEY (ID)
  ,
  CONSTRAINT DM_DEVICE_LOCATION_DEVICE
  FOREIGN KEY (DEVICE_ID)
  REFERENCES DM_DEVICE (ID)
)
/

-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_LOCATION_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_LOCATION_seq_tr
BEFORE INSERT ON DM_DEVICE_LOCATION FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_LOCATION_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

CREATE TABLE DM_DEVICE_DETAIL (
  ID NUMBER(10) NOT NULL,
  DEVICE_ID NUMBER(10) NOT NULL,
  DEVICE_MODEL VARCHAR2(45) NULL,
  VENDOR VARCHAR2(45) NULL,
  OS_VERSION VARCHAR2(45) NULL,
  OS_BUILD_DATE VARCHAR(100) NULL,
  BATTERY_LEVEL NUMBER(4) NULL,
  INTERNAL_TOTAL_MEMORY NUMBER(30,3) NULL,
  INTERNAL_AVAILABLE_MEMORY NUMBER(30,3) NULL,
  EXTERNAL_TOTAL_MEMORY NUMBER(30,3) NULL,
  EXTERNAL_AVAILABLE_MEMORY NUMBER(30,3) NULL,
  CONNECTION_TYPE VARCHAR2(10) NULL,
  SSID VARCHAR2(45) NULL,
  CPU_USAGE NUMBER(5) NULL,
  TOTAL_RAM_MEMORY NUMBER(30,3) NULL,
  AVAILABLE_RAM_MEMORY NUMBER(30,3) NULL,
  PLUGGED_IN NUMBER(10) NULL,
  UPDATE_TIMESTAMP NUMBER(19) NOT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_DM_DEVICE_DETAILS_DEVICE
  FOREIGN KEY (DEVICE_ID)
  REFERENCES DM_DEVICE (ID)
)
/
-- Generate ID using sequence and trigger
CREATE SEQUENCE DM_DEVICE_DETAIL_seq START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER DM_DEVICE_DETAIL_seq_tr
BEFORE INSERT ON DM_DEVICE_DETAIL FOR EACH ROW
WHEN (NEW.ID IS NULL)
  BEGIN
    SELECT DM_DEVICE_DETAIL_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
  END;
/

-- DASHBOARD RELATED VIEWS --

CREATE VIEW POLICY_COMPLIANCE_INFO AS
SELECT
DEVICE_INFO.DEVICE_ID,
DEVICE_INFO.DEVICE_IDENTIFICATION,
DEVICE_INFO.PLATFORM,
DEVICE_INFO.OWNERSHIP,
DEVICE_INFO.CONNECTIVITY_STATUS,
NVL(DEVICE_WITH_POLICY_INFO.POLICY_ID, -1) AS POLICY_ID,
NVL(DEVICE_WITH_POLICY_INFO.IS_COMPLIANT, -1) AS IS_COMPLIANT,
DEVICE_INFO.TENANT_ID
FROM
(SELECT
DM_DEVICE.ID AS DEVICE_ID,
DM_DEVICE.DEVICE_IDENTIFICATION,
DM_DEVICE_TYPE.NAME AS PLATFORM,
DM_ENROLMENT.OWNERSHIP,
DM_ENROLMENT.STATUS AS CONNECTIVITY_STATUS,
DM_DEVICE.TENANT_ID
FROM DM_DEVICE, DM_DEVICE_TYPE, DM_ENROLMENT
WHERE DM_DEVICE.DEVICE_TYPE_ID = DM_DEVICE_TYPE.ID AND DM_DEVICE.ID = DM_ENROLMENT.DEVICE_ID) DEVICE_INFO
LEFT JOIN
(SELECT
DEVICE_ID,
POLICY_ID,
STATUS AS IS_COMPLIANT
FROM DM_POLICY_COMPLIANCE_STATUS) DEVICE_WITH_POLICY_INFO
ON DEVICE_INFO.DEVICE_ID = DEVICE_WITH_POLICY_INFO.DEVICE_ID
/

CREATE VIEW FEATURE_NON_COMPLIANCE_INFO AS
SELECT
DM_DEVICE.ID AS DEVICE_ID,
DM_DEVICE.DEVICE_IDENTIFICATION,
DM_DEVICE_DETAIL.DEVICE_MODEL,
DM_DEVICE_DETAIL.VENDOR,
DM_DEVICE_DETAIL.OS_VERSION,
DM_ENROLMENT.OWNERSHIP,
DM_ENROLMENT.OWNER,
DM_ENROLMENT.STATUS AS CONNECTIVITY_STATUS,
DM_POLICY_COMPLIANCE_STATUS.POLICY_ID,
DM_DEVICE_TYPE.NAME AS PLATFORM,
DM_POLICY_COMPLIANCE_FEATURES.FEATURE_CODE,
DM_POLICY_COMPLIANCE_FEATURES.STATUS AS IS_COMPLAINT,
DM_DEVICE.TENANT_ID
FROM
DM_POLICY_COMPLIANCE_FEATURES, DM_POLICY_COMPLIANCE_STATUS, DM_ENROLMENT, DM_DEVICE, DM_DEVICE_TYPE, DM_DEVICE_DETAIL
WHERE
DM_POLICY_COMPLIANCE_FEATURES.COMPLIANCE_STATUS_ID = DM_POLICY_COMPLIANCE_STATUS.ID AND
DM_POLICY_COMPLIANCE_STATUS.ENROLMENT_ID = DM_ENROLMENT.ID AND
DM_POLICY_COMPLIANCE_STATUS.DEVICE_ID = DM_DEVICE.ID AND
DM_DEVICE.DEVICE_TYPE_ID = DM_DEVICE_TYPE.ID AND
DM_DEVICE.ID = DM_DEVICE_DETAIL.DEVICE_ID
/

-- END OF DASHBOARD RELATED VIEWS --


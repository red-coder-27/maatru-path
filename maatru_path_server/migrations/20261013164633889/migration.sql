BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "case_action_log" (
    "id" bigserial PRIMARY KEY,
    "caseId" bigint NOT NULL,
    "actionType" text NOT NULL,
    "previousStatus" text,
    "newStatus" text,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "case_record" (
    "id" bigserial PRIMARY KEY,
    "applicantReference" text NOT NULL,
    "schemeName" text NOT NULL,
    "blockerCategory" text NOT NULL,
    "blockerDescription" text NOT NULL,
    "priority" text NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "case_action_log"
    ADD CONSTRAINT "case_action_log_fk_0"
    FOREIGN KEY("caseId")
    REFERENCES "case_record"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR maatru_path
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('maatru_path', '20261013164633889', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013164633889', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;

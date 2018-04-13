SET ECHO OFF
SET TERMOUT OFF
SET TRIMSPOOL ON
SET PAGESIZE 0
SET LINESIZE 2000
SET FEEDBACK OFF
SET TIMING OFF
spool grant_role.lst
SELECT 'grant select on '||owner||'.'||table_name||' to MP_SELECT_ROLE;'
  FROM dba_tables
 WHERE owner = 'MPADMIN'
   AND table_name NOT IN ('USER_CUSTOMER','P_USER_CUSTOMER')
   AND table_name NOT IN (SELECT table_name
                                FROM role_tab_privs
                               WHERE     ROLE = 'MP_SELECT_ROLE'
                                     AND owner = 'MPADMIN');

SELECT 'grant select on '||owner||'.'||view_name||' to MP_SELECT_ROLE;'
  FROM dba_views
 WHERE owner = 'MPADMIN'
   AND view_name NOT IN ('USER_CUSTOMER','P_USER_CUSTOMER')
   AND view_name NOT IN (SELECT table_name
                                FROM role_tab_privs
                               WHERE     ROLE = 'MP_SELECT_ROLE'
                                     AND owner = 'MPADMIN');

SELECT 'grant select on '||owner||'.'||object_name||' to MP_SELECT_ROLE;'
  FROM dba_objects
 WHERE owner = 'MPADMIN'
   and object_type = 'SEQUENCE'
   AND object_name NOT IN ('USER_CUSTOMER','P_USER_CUSTOMER')
   AND object_name NOT IN (SELECT table_name
                                FROM role_tab_privs
                               WHERE     ROLE = 'MP_SELECT_ROLE'
                                     AND owner = 'MPADMIN');

SELECT 'create public synonym '||table_name||' for '||owner||'.'||table_name ||' ;'
  FROM dba_tables
 WHERE owner = 'MPADMIN'
   AND table_name <> 'TOAD_PLAN_TABLE'
   AND table_name NOT LIKE 'FUND_CHANGE_LOG_2015%'
   AND table_name NOT IN ('USER_CUSTOMER','P_USER_CUSTOMER')
   AND table_name NOT IN (SELECT table_name
                                FROM dba_synonyms
                               WHERE     owner = 'PUBLIC'
                                     AND table_owner = 'MPADMIN');

SELECT 'create public synonym  '||view_name||' for '||owner||'.'||view_name||' ;'
  FROM dba_views
 WHERE owner = 'MPADMIN'
   AND view_name NOT IN ('USER_CUSTOMER','P_USER_CUSTOMER')
   AND view_name NOT IN (SELECT table_name
                                FROM role_tab_privs
                               WHERE     ROLE = 'MP_SELECT_ROLE'
                                     AND owner = 'MPADMIN');

SELECT 'create public synonym  '||object_name||' for '||owner||'.'||object_name||' ;'
  FROM dba_objects
 WHERE owner = 'MPADMIN'
   and object_type = 'SEQUENCE'
   AND object_name NOT IN ('USER_CUSTOMER','P_USER_CUSTOMER')
   AND object_name NOT IN (SELECT table_name
                                FROM role_tab_privs
                               WHERE     ROLE = 'MP_SELECT_ROLE'
                                     AND owner = 'MPADMIN');	
spool off


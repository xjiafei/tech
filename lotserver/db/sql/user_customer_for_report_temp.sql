insert into USER_CUSTOMER_FOR_REPORT_TEMP
SELECT id u_id, account u_account,
       user_chain u_user_chain,
       TO_NUMBER (SUBSTR ( SYS_CONNECT_BY_PATH (LPAD (id, 10, '0'), '/'), 2, 10), '9999999999') o_id,
       level lev
  FROM USER_CUSTOMER
CONNECT BY PRIOR parent_id = id
start with register_date  >=  TRUNC(SYSDATE,'hh24')- 1/24 AND register_date  < TRUNC(SYSDATE,'hh24');
commit;

insert into USER_CUSTOMER_FOR_REPORT_TEMP
SELECT id u_id, account u_account,
       user_chain u_user_chain,
       TO_NUMBER (SUBSTR ( SYS_CONNECT_BY_PATH (LPAD (id, 10, '0'), '/'), 2, 10), '9999999999') o_id,
       level lev
  FROM USER_CUSTOMER
CONNECT BY PRIOR parent_id = id
start with register_date  <  TRUNC(SYSDATE,'hh24')- 1/24 AND   not exists ( select 'X' from USER_CUSTOMER_FOR_REPORT_TEMP where o_id = id);
commit;


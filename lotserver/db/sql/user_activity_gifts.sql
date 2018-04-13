insert into user_activity_gifts(USER_ID,REASON,AMOUNT,CREATE_TIME)
SELECT
  R.USER_ID,
  R.REASON,
  R.AMOUNT,
  R.CREATE_TIME
FROM (
  select
    USER_ID,
    REASON,
    SUM(CT_BAL-BEFOR_BAL) as AMOUNT,
    TRUNC(GMT_CREATED,'hh24') as CREATE_TIME
  from FUND_CHANGE_LOG
  where SUBSTR(REASON,4,4) = 'PGXX'
  and GMT_CREATED >= TRUNC(SYSDATE,'hh24')- 1/24
  AND GMT_CREATED < TRUNC(SYSDATE,'hh24')
  group by USER_ID, REASON, TRUNC(GMT_CREATED,'hh24')
) R;
commit;

delete from USER_ACTIVITY_GIFTS where create_time < trunc(sysdate - 180,'HH24');
commit;


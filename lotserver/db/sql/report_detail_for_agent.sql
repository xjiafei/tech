TRUNCATE TABLE USER_REPORT_FOR_AGENT ;
--TRUNCATE TABLE USER_CUSTOMER_FOR_REPORT_TEMP ;
TRUNCATE TABLE REPORT_DETAIL_FOR_AGENT_TEMP ;

--(固定排程)
--2.data彙整(新註冊數)
INSERT INTO USER_REPORT_FOR_AGENT
     SELECT t.id,
            TRUNC (tt.register_date) AS DAY,
            TO_CHAR (tt.register_date, 'HH24') AS hh,
            COUNT (1) AS user_count,
            0 AS binds
       FROM (    SELECT DISTINCT id, user_chain
                   FROM user_customer
             CONNECT BY PRIOR parent_id = id
             START WITH register_date > TRUNC (SYSDATE - 1)
             AND register_date < TRUNC (SYSDATE)) t,
            user_customer tt
      WHERE     t.id <> tt.id
            AND tt.user_chain LIKE t.user_chain || '%'
            AND tt.register_date > TRUNC (SYSDATE - 1)
            AND tt.register_date < TRUNC (SYSDATE)
   GROUP BY t.id,
            TRUNC (tt.register_date),
            TO_CHAR (tt.register_date, 'HH24');
COMMIT;

--Elapsed: 00:00:03.37
--上下級關係
------另有排程每小時彙整USER_CUSTOMER_FOR_REPORT_TEMP

--(固定排程)
--data彙整(綁定數)
MERGE INTO USER_REPORT_FOR_AGENT t1
     USING (   SELECT u_id AS USER_ID,
         TRUNC (ub.gmt_created) AS EVENT_DAY,
         TO_CHAR (ub.gmt_created, 'HH24') AS hh,
         COUNT (1) AS BINDS
    FROM USER_CUSTOMER_FOR_REPORT_TEMP ,
         USER_BANK ub
   WHERE     o_id = ub.USER_ID
     AND ub.gmt_created > TRUNC (SYSDATE - 1)
     AND ub.gmt_created < TRUNC (SYSDATE)
     AND LEV > 1
GROUP BY u_id, TRUNC (ub.gmt_created), TO_CHAR (ub.gmt_created, 'HH24')) t2
        ON (    t1.id = t2.user_id
            AND t1.EVENT_DAY = t2.EVENT_DAY
            AND t1.HH = t2.HH)
WHEN MATCHED
THEN
   UPDATE SET t1.binds = t1.binds + t2.binds
WHEN NOT MATCHED
THEN
   INSERT     (t1.ID,
               t1.EVENT_DAY,
               t1.HH,
               t1.USER_COUNT,
               t1.BINDS)
       VALUES (t2.USER_ID,
               t2.EVENT_DAY,
               t2.HH,
               0,
               t2.BINDS);
COMMIT;
--Elapsed: 00:00:00.20

--(固定排程)
--分段寫入最後TABLE
----BUG 18317074 
----Query fails with ORA-600[xtydty2ldi] using function based index
INSERT INTO REPORT_DETAIL_FOR_AGENT_TEMP
select  u_id USER_ID ,
        c.lotteryid AS LOT_ID,
        TRUNC (a.GMT_CREATED) AS EVENT_DAY,
        TO_CHAR (a.GMT_CREATED, 'HH24') AS HH,
         SUM ( DECODE (a.REASON,
                    'FD,ADAL,null,3', a.ct_bal - a.befor_bal,
                    'FD,ADML,null,8', a.ct_bal - a.befor_bal,
                    'FD,MDAX,null,5', a.ct_bal - a.befor_bal,
                    'OT,AAXX,null,3', a.ct_bal - a.befor_bal,
                    0)) AS charge,
         SUM ( DECODE (a.REASON,
                    'GM,DVCN,null,2', a.before_damt - a.ct_damt,
                    'GM,DVCB,null,2', a.before_damt - a.ct_damt,
                    0)) AS bet,
         SUM ( DECODE (a.REASON,
                    'FD,CWCS,null,6', a.before_damt - a.ct_damt,
                    'FD,CWCS,null,5', a.before_damt - a.ct_damt,
                    'FD,CWTS,null,5', a.before_damt - a.ct_damt,
                    'FD,CWTS,null,6', a.before_damt - a.ct_damt,
                    0)) AS withdraw,
         SUM ( DECODE (a.REASON,
                    'GM,RSXX,null,1', a.ct_bal - a.befor_bal,
                    'GM,RHAX,null,2', a.ct_bal - a.befor_bal,
                    0)) AS ret,
         SUM (DECODE (a.REASON, 'GM,PDXX,null,3', a.ct_bal - a.befor_bal, 0))
            AS win,
         SUM ( DECODE (a.REASON,
                    'PM,IPXX,null,3', a.ct_bal - a.befor_bal,
                    'PM,PGXX,null,3', a.ct_bal - a.befor_bal,
                    0)) AS ACT_AWARD,
         SUM ( DECODE (a.REASON, 'TF,BIRX,null,4', a.ct_bal - a.befor_bal, 0))
            AS TRANSFER_IN,
         SUM (DECODE (a.REASON, 'TF,SOSX,null,1', a.befor_bal - a.ct_bal, 0))
            AS TRANSFER_OUT,
         SUM ( DECODE (a.REASON,
                    'PM,IPXX,null,3', a.ct_bal - a.befor_bal,
                    'OT,AAXX,null,3', a.ct_bal - a.befor_bal,
                    'OT,CEXX,null,3', a.ct_bal - a.befor_bal,
                    'GM,CRVC,null,1', a.ct_bal - a.befor_bal,
                    0)) AS OTHER_IN,
         SUM ( DECODE (a.REASON,
                    'GM,BDRX, null,1', a.befor_bal - a.ct_bal,
                    'GM,RRHA,null,2', a.befor_bal - a.ct_bal,
                    'GM,RRSX,null,2', a.befor_bal - a.ct_bal,
                    0)) AS OTHER_OUT,
         0 AS PT_BONUS,
         0 AS new_User,
         0 BINDS
    FROM fund_change_log a,
         USER_CUSTOMER_FOR_REPORT_TEMP b,
         game_order c
   WHERE     gmt_created BETWEEN TRUNC (SYSDATE - 1) AND TRUNC (SYSDATE)
     AND A.USER_ID = b.o_id
     AND a.ex_code = c.order_code
     AND LEV > 1
GROUP BY u_id,
         c.lotteryid,
         TO_CHAR (a.GMT_CREATED, 'HH24'),
         TRUNC (a.GMT_CREATED);
commit;

--Elapsed: 00:00:14.58  
  
--分段寫入最後TABLE
INSERT INTO REPORT_DETAIL_FOR_AGENT_TEMP
SELECT u_id USER_ID,
       0 AS LOT_ID,
       TRUNC (a.GMT_CREATED) AS EVENT_DAY,
       TO_CHAR (a.GMT_CREATED, 'HH24') AS HH,
       SUM ( DECODE (a.REASON,
                  'FD,ADAL,null,3', a.ct_bal - a.befor_bal,
                  'FD,ADML,null,8', a.ct_bal - a.befor_bal,
                  'FD,MDAX,null,5', a.ct_bal - a.befor_bal,
                  'OT,AAXX,null,3', a.ct_bal - a.befor_bal,
                  0))   AS charge,
       SUM ( DECODE (a.REASON,
                  'GM,DVCN,null,2', a.before_damt - a.ct_damt,
                  'GM,DVCB,null,2', a.before_damt - a.ct_damt,
                  0))   AS bet,
       SUM ( DECODE (a.REASON,
                  'FD,CWCS,null,6', a.before_damt - a.ct_damt,
                  'FD,CWCS,null,5', a.before_damt - a.ct_damt,
                  'FD,CWTS,null,5', a.before_damt - a.ct_damt,
                  'FD,CWTS,null,6', a.before_damt - a.ct_damt,
                  0))   AS withdraw,
       SUM ( DECODE (a.REASON,
                  'GM,RSXX,null,1', a.ct_bal - a.befor_bal,
                  'GM,RHAX,null,2', a.ct_bal - a.befor_bal,
                  0))   AS ret,
       SUM ( DECODE (a.REASON, 'GM,PDXX,null,3', a.ct_bal - a.befor_bal, 0))
          AS win,
       SUM ( DECODE (a.REASON,
                  'PM,IPXX,null,3', a.ct_bal - a.befor_bal,
                  'PM,PGXX,null,3', a.ct_bal - a.befor_bal,
                  0))   AS ACT_AWARD,
       SUM ( DECODE (a.REASON, 'TF,BIRX,null,4', a.ct_bal - a.befor_bal, 0))
          AS TRANSFER_IN,
       SUM ( DECODE (a.REASON, 'TF,SOSX,null,1', a.befor_bal - a.ct_bal, 0))
          AS TRANSFER_OUT,
       SUM ( DECODE (a.REASON,
                  'PM,IPXX,null,3', a.ct_bal - a.befor_bal,
                  'OT,AAXX,null,3', a.ct_bal - a.befor_bal,
                  'OT,CEXX,null,3', a.ct_bal - a.befor_bal,
                  'GM,CRVC,null,1', a.ct_bal - a.befor_bal,
                  0))   AS OTHER_IN,
       SUM ( DECODE (a.REASON,
                  'GM,BDRX, null,1', a.befor_bal - a.ct_bal,
                  'GM,RRHA,null,2', a.befor_bal - a.ct_bal,
                  'GM,RRSX,null,2', a.befor_bal - a.ct_bal,
                  0))   AS OTHER_OUT,
       SUM ( DECODE (a.REASON, 'GM,DDAX,null,1', a.ct_bal - a.befor_bal, 0))
          AS PT_BONUS,
       0 AS new_User,
       0 BINDS
  FROM fund_change_log a, USER_CUSTOMER_FOR_REPORT_TEMP b
 WHERE gmt_created BETWEEN TRUNC (SYSDATE - 1) AND TRUNC (SYSDATE)
   AND A.USER_ID = b.o_id
   AND ex_code IS NULL
   AND LEV > 1
GROUP BY u_id, TO_CHAR (a.GMT_CREATED, 'HH24'), TRUNC (a.GMT_CREATED);
commit;
 --Elapsed: 00:00:03.52

INSERT INTO REPORT_DETAIL_FOR_AGENT
SELECT SEQ_AGENT_REPORT_DETAIL.nextval,
       USER_ID,
       LOT_ID,
       EVENT_DAY,
       HH,
       charge,
       bet,
       WITH_DRAW,
       ret,
       win,
       ACT_AWARD,
       TRANSFER_IN,
       TRANSFER_OUT,
       OTHER_IN,
       OTHER_OUT,
       new_User,
       binds,
       PT_BONUS
  FROM REPORT_DETAIL_FOR_AGENT_TEMP;
COMMIT;
 
MERGE INTO REPORT_DETAIL_FOR_AGENT t1 USING
  (SELECT rt.id,
    rt.EVENT_DAY        AS EVENT_DAY,
    rt.hh         AS HH,
    rt.user_count AS USER_COUNT,
    rt.binds      AS BINDS
  FROM USER_REPORT_FOR_AGENT rt
  ) t2 ON (t1.user_id = t2.id AND t1.EVENT_DAY=t2.EVENT_DAY AND t1.HH=t2.HH AND t1.LOT_ID = 0)
WHEN MATCHED THEN
  UPDATE
  SET t1.new_user = t1.new_user+t2.user_count,
    t1.binds      =t1.binds    +t2.binds WHEN NOT MATCHED THEN
  INSERT
    (
      t1.ID,
      t1.LOT_ID,
      t1.USER_ID,
      t1.EVENT_DAY,
      t1.hh,
      t1.CHARGE,
      t1.BET,
      t1.WITH_DRAW ,
      t1.RET,
      t1.WIN,
      t1.ACT_AWARD,
      t1.TRANSFER_IN,
      t1.TRANSFER_OUT,
      t1.OTHER_IN ,
      t1.OTHER_OUT,
      t1.NEW_USER,
      t1.BINDS
    )
    VALUES
    (
      SEQ_AGENT_REPORT_DETAIL.nextval,
      0,
      t2.id,
      t2.EVENT_DAY,
      t2.HH,
      0,0,0 ,
      0,0,0,0,0,0,0,
      t2.USER_COUNT,
      t2.BINDS
    );
  COMMIT;
--Elapsed: 00:00:02.04

delete from REPORT_DETAIL_FOR_AGENT  where EVENT_DAY < trunc(sysdate-70);
commit;

------------------------------------------------------------------------------------

MERGE INTO USER_CUSTOMER_FOR_AGENT t1 USING
(SELECT c.id         AS ID,
  c.account         AS ACCOUNT ,
  c.user_lvl        AS user_lvl,
  c.user_chain      AS USER_CHAIN,
  c.parent_id       AS PARENT_ID,
  c.register_date   AS REGISTER_DATE,
  c.last_login_date AS LAST_LOGIN_DATE,
  (select memo from user_url where id=c.url_id) AS MEMO
FROM
  user_customer c WHERE (c.register_date >= TRUNC(sysdate-1) AND c.REGISTER_DATE < TRUNC(SYSDATE))
OR (c.last_login_date  >= TRUNC(sysdate-1) AND c.last_login_date < TRUNC(SYSDATE))
) t2 ON (t1.id = t2.ID)
WHEN MATCHED THEN
  UPDATE SET t1.last_login_date = t2.last_login_date 
  WHEN NOT MATCHED THEN
  INSERT
    (
      t1.ID,
      t1.ACCOUNT,
      t1.user_lvl,
      t1.USER_CHAIN,
      t1.PARENT_ID,
      t1.REGISTER_DATE,
      t1.LAST_LOGIN_DATE,
      t1.MEMO
    )
    VALUES
    (
      t2.ID,
      t2.ACCOUNT,
      t2.user_lvl,
      t2.USER_CHAIN,
      t2.PARENT_ID,
      t2.REGISTER_DATE,
      t2.LAST_LOGIN_DATE,
      t2.MEMO
    );

COMMIT;

MERGE INTO USER_CUSTOMER_FOR_AGENT t1 USING
 (SELECT user_id ,COUNT(user_id) AS binds
FROM user_bank
WHERE (gmt_created >= TRUNC(sysdate-1)
  AND gmt_created    < TRUNC(SYSDATE)) group by user_id
 ) t2 ON (t1.id     = t2.user_id)
WHEN MATCHED THEN
    UPDATE SET t1.binds =t1.binds + t2.binds;

COMMIT;


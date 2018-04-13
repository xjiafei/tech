--Clear old data
-- keep 1 month Data
DELETE FROM GAME_ORDER_REPORT 
WHERE CREATE_TIME < ADD_MONTHS(TRUNC(SYSDATE,'hh24'),-1);
COMMIT;
DELETE FROM GAME_RET_BETTYPE_POINT 
WHERE CREATE_TIME < ADD_MONTHS(TRUNC(SYSDATE,'hh24'),-1);
COMMIT;

--Group and sum TOTAL_RET FROM GAME_RISK_FUND last hour's data into GAME_ORDER_REPORT
INSERT INTO GAME_ORDER_REPORT (ID,PARENT_ID,USER_ID,USER_ACCOUNT,LOTTERYID,BET_TYPE_CODE,TOTAL_AMOUNT,TOTAL_WIN,TOTAL_RET,TOTAL_BET,TOTAL_RESULT,STATUS,CREATE_TIME,UPDATE_TIME)
   SELECT 
	SEQ_GAME_ORDER_REPORT_ID.NEXTVAL AS ID,
	NVL(UC.PARENT_ID,-1) AS PARENT_ID,
	R.USERID AS USER_ID,
	NVL(UC.ACCOUNT,-1) AS USER_ACCOUNT,
	R.LOTTERYID AS LOTTERYID,
	R.BET_TYPE_CODE AS BET_TYPE_CODE,
	0 AS TOTAL_AMOUNT,
	0 AS TOTAL_WIN,
	R.TOTAL_RET AS TOTAL_RET,
	(0 - R.TOTAL_RET) AS TOTAL_BET,
	R.TOTAL_RET AS TOTAL_RESULT,
	0 AS STATUS,
	R.CREATE_TIME AS CREATE_TIME,
	R.CREATE_TIME AS UPDATE_TIME  
FROM (  
    select
    GRF.USERID AS USERID,
    GRF.LOTTERYID AS LOTTERYID,
    GPI.BET_TYPE_CODE AS BET_TYPE_CODE,
    TRUNC(GRF.CREATE_TIME,'hh24') AS CREATE_TIME ,
    SUM( NVL( TO_NUMBER(regexp_substr(GRBP.BETTYPE_RET_POINT_CHAIN,'[^,]+', 1, REGEXP_COUNT(SUBSTR(GRBP.BETTYPE_RET_USER_CHAIN,1,INSTR(GRBP.BETTYPE_RET_USER_CHAIN,GRF.USERID)),',',1,'i')+1 )),0)) AS TOTAL_RET
    FROM GAME_RISK_FUND GRF
    LEFT JOIN GAME_RET_BETTYPE_POINT GRBP ON GRBP.ORDER_CODE = GRF.ORDER_CODE
    LEFT JOIN GAME_PACKAGE_ITEM GPI ON GPI.ID = GRBP.ITEM_ID
    WHERE GRF.STATUS IN (2,3)
    AND GRF.CANCEL_STATUS=0 AND GRF.FUND_TYPE=5008 --未撤銷
    AND TRUNC(GRF.CREATE_TIME) >= TRUNC(SYSDATE-0.1) --今天開始的資料
    AND GRF.CREATE_TIME >= TRUNC(SYSDATE,'hh24')- 1/24 -- 前一個小時資料
    AND GRF.CREATE_TIME < TRUNC(SYSDATE,'hh24')
    GROUP BY GRF.USERID,GRF.LOTTERYID,GPI.BET_TYPE_CODE,TRUNC(GRF.CREATE_TIME,'hh24')
  )R 
  LEFT JOIN USER_CUSTOMER UC ON UC.ID = R.USERID;
COMMIT; 
--Group and sum TOTAL_AMOUNT,TOTAL_WIN FROM GAME_ORDER last hour's data into GAME_ORDER_REPORT
INSERT INTO GAME_ORDER_REPORT (ID,PARENT_ID,USER_ID,USER_ACCOUNT,LOTTERYID,BET_TYPE_CODE,TOTAL_AMOUNT,TOTAL_WIN,TOTAL_RET,TOTAL_BET,TOTAL_RESULT,STATUS,CREATE_TIME,UPDATE_TIME)
SELECT 
	SEQ_GAME_ORDER_REPORT_ID.NEXTVAL AS ID,
	NVL(UC.PARENT_ID,-1) AS PARENT_ID,
	R.USERID AS USER_ID,
	NVL(UC.ACCOUNT,-1) AS USER_ACCOUNT,
	R.LOTTERYID AS LOTTERYID,
	R.BET_TYPE_CODE AS BET_TYPE_CODE,
	NVL(R.TOTAL_AMOUNT,0) AS TOTAL_AMOUNT,
	NVL(R.TOTAL_WIN,0) AS TOTAL_WIN,
	0 AS TOTAL_RET,
	(NVL(R.TOTAL_AMOUNT,0)) AS TOTAL_BET,
	(NVL(R.TOTAL_WIN,0)-NVL(R.TOTAL_AMOUNT,0)) AS TOTAL_RESULT,
	0 AS STATUS,
	R.CALCULATE_TIME AS CREATE_TIME,
	R.CALCULATE_TIME AS UPDATE_TIME
FROM (
    SELECT 
        GO.USERID AS USERID,
        GO.LOTTERYID AS LOTTERYID,
        GL.BET_TYPE_CODE AS BET_TYPE_CODE,
        --SUM(GL.TOTAMOUNT) AS TOTAL_AMOUNT, -- edit by DavidWu 原報表用
        --SUM(NVL(GL.EVALUATE_WIN,0)) AS TOTAL_WIN,-- edit by DavidWu 原報表用
		(SUM(GL.TOTAMOUNT)+SUM(GL.DIAMOND_AMOUNT)) AS TOTAL_AMOUNT, -- edit by chien lo 鑽石嘉獎上線後才可上線
        (SUM(NVL(GL.EVALUATE_WIN,0))+SUM(NVL(GL.DIAMOND_WIN,0))) AS TOTAL_WIN, -- edit by chien lo 鑽石嘉獎上線後才可上線
        TRUNC(GO.CALCULATE_WIN_TIME,'hh24') AS CALCULATE_TIME
	FROM GAME_ORDER GO
   LEFT JOIN GAME_SLIP GL ON GL.ORDERID = GO.ID
    WHERE GO.STATUS IN (2,3)
    AND GO.CALCULATE_WIN_TIME >= TRUNC(SYSDATE,'hh24')- 1/24
    AND GO.CALCULATE_WIN_TIME < TRUNC(SYSDATE,'hh24')
    GROUP BY GO.USERID,GO.LOTTERYID,GL.BET_TYPE_CODE,TRUNC(GO.CALCULATE_WIN_TIME,'hh24')
)R 
LEFT JOIN USER_CUSTOMER UC ON UC.ID = R.USERID;

COMMIT;


spool game_control_event.log;
set time on timing on feedback on echo on


insert into game_control_event_his
select * from game_control_event where CREATE_TIME   < trunc(sysdate -30);
commit;

delete from game_control_event where CREATE_TIME   < trunc(sysdate -30);
commit;

delete from GAME_TREND_JBYL where lotteryid=99112 and create_time < trunc(sysdate-7);
commit;

delete from GAME_TREND_JBYL where lotteryid=99111 and create_time < trunc(sysdate-1);
commit;

delete from GAME_TREND_JBYL where lotteryid=99306 and create_time < trunc(ADD_MONTHS(sysdate,-6)) ;
commit;

delete from game_trend_task where create_time < trunc(sysdate-1);
commit;

---GAME_TRANSACTION_FUND 數據不留
DELETE FROM GAME_TRANSACTION_FUND WHERE CREATE_TIME < TRUNC(SYSDATE);
COMMIT;

exec dbms_stats.gather_table_stats(ownname=> 'MPADMIN',tabname=> 'game_control_event',estimate_percent => dbms_stats.auto_sample_size, method_opt=> 'for all columns'  )  ;

spool off


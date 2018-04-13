set line 1000         --设置行的长度
set pagesize 0        --输出不换页
set feedback off      --默认的当一条sql发出的时候，oracle会给一个反馈，比如说创建表的时候，如果成功命令行会返回类似：Table created的反馈,off后不显示反馈
set heading off       --不显示表头信息
set trimspool on      --如果trimspool设置为on，将移除spool文件中的尾部空
set trims on          --去掉空字符
set echo off;　　　　   --显示start启动的脚本中的每个sql命令，缺省为on
set colsep '|'         --设置分隔符
set termout off        --不在屏幕上显示结果
spool db1.txt          --记录数据到db1.txt
select object_id,object_name from all_objects;  --导出数据语句
spool off              --收集完毕
exit
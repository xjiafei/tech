set line 1000         --�����еĳ���
set pagesize 0        --�������ҳ
set feedback off      --Ĭ�ϵĵ�һ��sql������ʱ��oracle���һ������������˵�������ʱ������ɹ������л᷵�����ƣ�Table created�ķ���,off����ʾ����
set heading off       --����ʾ��ͷ��Ϣ
set trimspool on      --���trimspool����Ϊon�����Ƴ�spool�ļ��е�β����
set trims on          --ȥ�����ַ�
set echo off;��������   --��ʾstart�����Ľű��е�ÿ��sql���ȱʡΪon
set colsep '|'         --���÷ָ���
set termout off        --������Ļ����ʾ���
spool db1.txt          --��¼���ݵ�db1.txt
select object_id,object_name from all_objects;  --�����������
spool off              --�ռ����
exit
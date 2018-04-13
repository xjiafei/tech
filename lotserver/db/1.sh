export ORACLE_SID=WQCDEV
impdp FIREFOG/FIREFOG  directory=DMP dumpfile=firefog_20170214.dmp log=imp_firefog_20170214.log remap_schema=firefog:firefog 

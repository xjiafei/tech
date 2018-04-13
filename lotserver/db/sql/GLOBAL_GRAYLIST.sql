insert into GLOBAL_GRAYLIST 
(select seq_global_graylist_id.nextval,a.ID,a.LAST_LOGIN_DATE,1,sysdate,sysdate,a.REGISTER_DATE from user_customer a 
	where (
		(a.LAST_LOGIN_DATE is null and a.register_date < add_months(sysdate,-3)) or 
			a.LAST_LOGIN_DATE < add_months(sysdate,-3)
		) 
	and not exists(select b.USER_ID from global_graylist b where b.user_id = a.id)
);

commit;


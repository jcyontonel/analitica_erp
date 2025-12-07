SELECT *, CURRENT_DATE() AS fecdia, DATE_FORMAT(CURRENT_DATE(), '%Y%m') AS codmes FROM role_has_permissions;

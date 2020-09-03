# OTRS-System-Configuration-History
- SQL / Statistic Module Regarding Changes in OTRS System Configuration  

- SQL For Current Changes (Unique)  
	
		SELECT 
		sm.NAME, 
		sm.effective_value AS MODIFIED_VALUE, 
		sd.effective_value AS DEFAULT_VALUE,
		sm.change_time AS MODIFIED_TIME, 
		CONCAT_WS(' ', u.first_name, u.last_name) AS MODIFIED_BY 
		FROM sysconfig_modified sm
		JOIN sysconfig_default sd ON (sm.sysconfig_default_id=sd.id)
		JOIN users u ON (sm.change_by=u.id)
		
		
- SQL For All the System Configuration Changes (may contains multiple value per name)  

		SELECT 
		smv.name, 
		smv.effective_value AS MODIFIED_VALUE, 
		sdv.effective_value AS DEFAULT_VALUE,
		smv.change_time AS MODIFIED_TIME, 
		CONCAT_WS(' ', u.first_name, u.last_name) AS MODIFIED_BY 
		FROM sysconfig_modified_version smv
		JOIN sysconfig_default_version sdv ON (smv.sysconfig_default_version_id=sdv.id)
		JOIN users u ON (smv.change_by=u.id)
		ORDER BY smv.name
		

[![1.png](https://i.postimg.cc/Fs68R9jS/1.png)](https://postimg.cc/HVQBv1vW)

[![2.png](https://i.postimg.cc/yN4GmvpY/2.png)](https://postimg.cc/JsxKmcW9)

[![3.png](https://i.postimg.cc/KYPHJBC7/3.png)](https://postimg.cc/McG5GM6X)
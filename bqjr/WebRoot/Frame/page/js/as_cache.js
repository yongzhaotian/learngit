var AsDebug = {
	reloadCacheAll:function(oBody){
		var sReturn = RunJavaMethod("com.amarsoft.app.awe.common.action.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("���ز�������ɹ���");
		else alert("���ز�������ʧ�ܣ�");
	},
	reloadCache:function(CacheType){
		var sReturn = RunJavaMethod("com.amarsoft.app.awe.common.action.ReloadCacheConfigAction","reloadCache","ConfigName="+CacheType);
		if(sReturn=="SUCCESS") alert("ˢ�³ɹ���");
		else alert("ˢ��ʧ�ܣ�");
	},
	reloadConfigFile:function(){
		var sReturn = PopPage("/AppConfig/ControlCenter/ClearConfigFileCache.jsp","","");
		if(sReturn=="SUCCESS") alert("���������ļ��ɹ���");
		else alert("���������ļ�ʧ�ܣ�");
	}
};

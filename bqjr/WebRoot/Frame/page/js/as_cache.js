var AsDebug = {
	reloadCacheAll:function(oBody){
		var sReturn = RunJavaMethod("com.amarsoft.app.awe.common.action.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("重载参数缓存成功！");
		else alert("重载参数缓存失败！");
	},
	reloadCache:function(CacheType){
		var sReturn = RunJavaMethod("com.amarsoft.app.awe.common.action.ReloadCacheConfigAction","reloadCache","ConfigName="+CacheType);
		if(sReturn=="SUCCESS") alert("刷新成功！");
		else alert("刷新失败！");
	},
	reloadConfigFile:function(){
		var sReturn = PopPage("/AppConfig/ControlCenter/ClearConfigFileCache.jsp","","");
		if(sReturn=="SUCCESS") alert("重载配置文件成功！");
		else alert("重载配置文件失败！");
	}
};

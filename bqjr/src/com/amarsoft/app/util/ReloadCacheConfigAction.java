package com.amarsoft.app.util;

import com.amarsoft.are.ARE;
import com.amarsoft.dict.als.cache.CacheLoaderFactory;

/**
 * ͬ�����ݿ��뻺���е����ݣ�����CacheLoaderFactory����Ӧ����
 * @author xhgao
 *
 */
public class ReloadCacheConfigAction {
	
	private String configName; //��Ҫ����reload�Ļ��漯������ 

	public String getConfigName() {
		return configName;
	}

	public void setConfigName(String configName) {
		this.configName = configName;
	}

	public String reloadCache() throws Exception{
		//�������
		String sReturn = "SUCCESS";
		if(configName.trim().length() > 0 ){
			try{
				CacheLoaderFactory.reload(configName);
			}catch(Exception e){
				ARE.getLog().error("ͬ�����ݿ⻺��ʧ�ܣ�"+e);
				sReturn = "FAILED";
			}
		}
		return sReturn;
	}
	
	public String reloadCacheAll() throws Exception{
		//�������
		String sReturn = "SUCCESS";
		try{
			CacheLoaderFactory.reloadAll();
		}catch(Exception e){
			ARE.getLog().error("�������л���ʧ�ܣ�"+e);
			sReturn = "FAILED";
		}
		return sReturn;
	}
}

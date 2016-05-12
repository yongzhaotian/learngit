package com.amarsoft.app.als.process;

import com.amarsoft.app.als.process.util.ConfigProvider;
import com.amarsoft.are.ARE;

public class ProcessServiceFactory {
	//Ĭ�����̷���ʵ����
	private static final String DEFAULT_PROCESS_SERVICE = "com.amarsoft.app.als.process.impl.AmarProcessService";
	//���̷��������ļ�
	public static final String PROCESS_CONFIG_FILE = ARE.getProperty("APP_HOME") + "/etc/engine_config.properties";
	//�����ļ��������̷���Ĺؼ���
	private static final String PROCESS_SERVICE_SOURCE_KEY = "process_service";
	
	/**
	 * ��ȡ���̷���ʵ��,���ȴ����̷��������ļ��ж�ȡ,��������ļ����������ȡĬ�ϵ������������
	 * @return
	 */
	public static ProcessService getService(){
		ProcessService ps = null;
		ConfigProvider cp = ConfigProvider.getProvider(PROCESS_CONFIG_FILE);
		if(!cp.isConfiged()){
			ps = getDefaultService();
		}else{
			String processServiceSource = cp.getProperty(PROCESS_SERVICE_SOURCE_KEY);
			if(processServiceSource == null || "".equals(processServiceSource)){
				ARE.getLog().error("���̷��������ļ�δָ��������Դ");
			}
			
			try {
				ps = getService(processServiceSource);
			} catch (InstantiationException e) {
				ARE.getLog().debug("��ȡ��������������",e);
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				ARE.getLog().debug("��ȡ��������������",e);
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				ARE.getLog().debug("��ȡ��������������",e);
				e.printStackTrace();
			}
		}
		return ps;
	}
	
	/**
	 * ȡ��Ĭ�ϵ������������
	 * @return ���̷���
	 */
	private static ProcessService getDefaultService(){
		ProcessService ps = null;
		try {
			ps = getService(DEFAULT_PROCESS_SERVICE);
		} catch (InstantiationException e) {
			ARE.getLog().debug("��ȡĬ����������������",e);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			ARE.getLog().debug("��ȡĬ����������������",e);
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			ARE.getLog().debug("��ȡĬ����������������",e);
			e.printStackTrace();
		}
		return ps;
	}
	
	/**
	 * ȡ��ָ�������̷���
	 * @param processServiceSource ���̷����ṩ��
	 * @return ���̷���
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 */
	private static ProcessService getService(String processServiceSource) throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		return (ProcessService)Class.forName(processServiceSource).newInstance();
	}
	
	public static void main(String[] args){
	}
}

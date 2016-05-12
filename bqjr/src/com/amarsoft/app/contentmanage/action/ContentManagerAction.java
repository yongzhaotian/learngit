package com.amarsoft.app.contentmanage.action;

import com.amarsoft.app.contentmanage.ContentManager;
import com.amarsoft.app.contentmanage.DefaultContentManagerImpl;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;
/**
 * ����������;��1, ��ȡContentManagerʵ����; 2, ��JSPҳ��ͨ��runJavaMethod������ز���
 */
public class ContentManagerAction {
	/**
	 * IsUseContentManager�Ƿ�ʹ�����ݹ���: true/false
	 */
	public static boolean IsUseContentManager;
	/**
	 * ���ݹ�����
	 */
	public static String ContentManagerClass;
	/**
	 * �����Ƿ���ȷ: ���ݹ������ܹ���������Ϊ������ȷ
	 */
	public static boolean isConfCorrect =false;
	
	private String docId;
	
	public String getDocId() {
		return docId;
	}
	public void setDocId(String docId) {
		this.docId = docId;
	}
	static{
		try {
			Configure curConf = Configure.getInstance();
			IsUseContentManager = StringX.parseBoolean(
					curConf.getConfigure("IsUseContentManager", "false"));
			ContentManagerClass = curConf.getConfigure("ContentManagerClass");
			
		} catch (Exception e) {
			ARE.getLog().error("��ȡawe ���ó���!");
		}
		if(IsUseContentManager){
			try {
				ContentManager obj = (ContentManager) Class.forName(ContentManagerClass).newInstance();
				obj = null;
				isConfCorrect = true;
			} catch (Exception e) {
				ARE.getLog().error("���ݹ��������ó���(����ԭ��:1,û��������û���޲εĹ��췽��; 2,δʵ��ContentManager�ӿ�), ����:"+ContentManagerClass, e);
			}
		}
	}
	/**
	 * ����һ�����ݹ��������
	 * @return ���ݹ��������
	 */
	public static ContentManager getContentManager(){
		if(IsUseContentManager && isConfCorrect){
			ContentManager manager = null;
			try {
				manager = (ContentManager) Class.forName(ContentManagerClass).newInstance();
			} catch (Exception e) {
				ARE.getLog().error("�������ݹ�����������,����:"+ContentManagerClass, e);
			}
			return manager;
		}else{
			return new DefaultContentManagerImpl();
		}
	}
	
	public String delAllVersion(){
		String sRet = "FAILED";
		ContentManager manager = getContentManager();
		if(manager==null) return sRet;
		boolean bool = manager.delAllVersion(this.docId);
		if(bool) sRet = "SUCCESS";
		return sRet;
	}
	
	public String delete(){
		String sRet = "FAILED";
		ContentManager manager = getContentManager();
		if(manager==null) return sRet;
		boolean bool = manager.delete(this.docId);
		if(bool) sRet = "SUCCESS";
		return sRet;
	}
	
}

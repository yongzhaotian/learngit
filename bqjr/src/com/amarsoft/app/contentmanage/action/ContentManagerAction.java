package com.amarsoft.app.contentmanage.action;

import com.amarsoft.app.contentmanage.ContentManager;
import com.amarsoft.app.contentmanage.DefaultContentManagerImpl;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;
/**
 * 本类两个用途：1, 获取ContentManager实现类; 2, 被JSP页面通过runJavaMethod调用相关操作
 */
public class ContentManagerAction {
	/**
	 * IsUseContentManager是否使用内容管理: true/false
	 */
	public static boolean IsUseContentManager;
	/**
	 * 内容管理类
	 */
	public static String ContentManagerClass;
	/**
	 * 配置是否正确: 内容管理类能够创建则认为配置正确
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
			ARE.getLog().error("读取awe 配置出错!");
		}
		if(IsUseContentManager){
			try {
				ContentManager obj = (ContentManager) Class.forName(ContentManagerClass).newInstance();
				obj = null;
				isConfCorrect = true;
			} catch (Exception e) {
				ARE.getLog().error("内容管理类配置出错(可能原因:1,没有这个类或没有无参的构造方法; 2,未实现ContentManager接口), 类名:"+ContentManagerClass, e);
			}
		}
	}
	/**
	 * 创建一个内容管理类对象
	 * @return 内容管理类对象
	 */
	public static ContentManager getContentManager(){
		if(IsUseContentManager && isConfCorrect){
			ContentManager manager = null;
			try {
				manager = (ContentManager) Class.forName(ContentManagerClass).newInstance();
			} catch (Exception e) {
				ARE.getLog().error("创建内容管理类对象出错,类名:"+ContentManagerClass, e);
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

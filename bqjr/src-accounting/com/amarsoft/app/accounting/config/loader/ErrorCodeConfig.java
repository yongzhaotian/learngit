package com.amarsoft.app.accounting.config.loader;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class ErrorCodeConfig extends AbstractCache {
	private static ASValuePool errorCodeSet = new ASValuePool();//�����뼯��
	
	public void clear() throws Exception {		

	}

	public synchronized boolean load(Transaction transaction) throws Exception {
		InputStream in = this.getClass().getResourceAsStream("etc/ErrorCodeConfig.xml");
		if (in == null) {
			in = this.getClass().getClassLoader().getResourceAsStream("etc/ErrorCodeConfig.xml");
		}
		if (in == null) {
			String locPath = ErrorCodeConfig.class.getResource("").getFile();
			String path[] = locPath.split("WEB-INF");
			String realPath = path[0].substring(0,path[0].length()-1);//ɾ������б��
			realPath = realPath+"/WEB-INF/etc/ErrorCodeConfig.xml";
			File file = new File(realPath);
			in = new FileInputStream(file);
		}
		init(in);
		in.close();
		return true;
	}
	
	 /**��ʼ������������
	 * @param in
	 */
	private void init(InputStream in){
		 try {
			Element e = new Document(in).getRootElement();
			List list = e.getChildren("ErrorCode");
			String code = "";
			String describe = "";
			for(int i=0;i<list.size();i++){
				Element ec = (Element)list.get(i);
				code = ec.getAttributeValue("code");
				describe = ec.getAttributeValue("describe");
				errorCodeSet.setAttribute(code, describe);
			}
			
		} catch (Exception e) {
			ARE.getLog().debug("======�����������쳣!======",e);
		}
	 }
	 
	 
	 /**��ô�����Ϣ
	 * @param code
	 * @return
	 */
	public static String getMsg(String codeNo,String[] para){		
		String msg = "";
		try {		
			msg = errorCodeSet.getString(codeNo);
			if(para!=null){
				for(int i=0;i<para.length;i++){
					msg = msg.replace("@"+i+"@", para[i]);
				}
			}			
			//�ж��Ƿ񻹴��������ַ���@
			if(msg.indexOf("@")>0){
				try {
					throw new Exception("������Ϣ�ж���Ĳ��������ʹ���Ĳ���������ƥ�䣬����!");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return codeNo+":"+msg;
	}

}

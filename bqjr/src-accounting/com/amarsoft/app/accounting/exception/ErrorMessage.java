package com.amarsoft.app.accounting.exception;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Properties;

public class ErrorMessage {
	
	public ArrayList<String> messageList = new ArrayList<String>();
	
	public ArrayList<String> getMessage(String type) throws Exception {
		return this.messageList;
	}
	
	public ArrayList<String> getMessage() throws Exception {
		return this.messageList;
	}
	
	public void setErrorMessage(String type,String messagecode,String messagedesc) throws Exception {
		this.messageList.add(messagedesc);
	}
	
	public static String getMessageByCode(String codeNo,String[] para){
		InputStream in = ErrorMessage.class.getClassLoader().getResourceAsStream("ErrorCode.properties");
		Properties p = new Properties();
		String msg = "";
		try {
			p.load(in);
			msg = p.get(codeNo).toString();
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
		}
		return msg;
	}

}

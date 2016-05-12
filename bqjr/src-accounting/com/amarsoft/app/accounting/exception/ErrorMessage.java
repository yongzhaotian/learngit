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
			//判断是否还存在特殊字符串@
			if(msg.indexOf("@")>0){
				try {
					throw new Exception("错误信息中定义的参数个数和传入的参数个数不匹配，请检查!");
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

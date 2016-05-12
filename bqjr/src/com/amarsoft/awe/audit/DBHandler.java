package com.amarsoft.awe.audit;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.*;
import com.amarsoft.are.security.AppContext;
import com.amarsoft.are.security.DefaultAppContext;
import com.amarsoft.are.security.audit.*;
import com.amarsoft.are.util.StringFunction;

public class DBHandler extends Handler {
	
	private static long iCount = 100000L;
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmssSSS");

	public DBHandler() {
	}

	public void handle(AuditRecord record) {
		String acOperator;
		String acServerAddress;
		String acClientAddress;
		String acApplication;
		String acAdditionalInfo;
		acOperator = "";
		acServerAddress = "";
		acClientAddress = "";
		acApplication = "";
		acAdditionalInfo = "";
		if (record == null)
			return;
		try {
			AppContext ac = record.getAppContext();
			if (ac != null) {
				acOperator = ac.getOperator();
				acServerAddress = ac.getOperator();
				acClientAddress = ac.getClientAddress();
				acApplication = ac.getApplication();
				acAdditionalInfo = ac.getAdditionalInfo();
			}
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.awe.AUDIT_INFO");
			BizObject bo = bm.newObject();
			bo.setAttributeValue("SERIALNO", getSerialNo("AI"));
			bo.setAttributeValue("OPERATOR", acOperator);
			bo.setAttributeValue("SERVERADDRESS", acServerAddress);
			bo.setAttributeValue("CLIENTADDRESS", acClientAddress);
			bo.setAttributeValue("APPLICATION", acApplication);
			bo.setAttributeValue("ADDITIONALINFO", acAdditionalInfo);
			bo.setAttributeValue("RECORDTYPE", record.getType());
			bo.setAttributeValue("RECORDACTION", record.getAction());
			bo.setAttributeValue("RECORDTARGET", record.getTarget());
			bo.setAttributeValue("AUDITTIME", StringFunction.getTodayNow());
			bo.setAttributeValue("AUDITDATA", record.getData() != null ? ((Object) (record.getData().exportText())) : "");
			DefaultAppContext c = new DefaultAppContext();
			c.setApplication("审计程序的DBHandler");
			c.setAdditionalInfo("审计程序的扩展信息");
			bm.setAppContext(c);
			bm.saveObject(bo);
		} catch (JBOException e) {
			e.printStackTrace();
			ARE.getLog().debug(e);
		}
		return;
	}
	
	/**
	 * 获取以“sPrefix”开头的序列号
	 * 
	 * @param sPrefix [sPrefix字符建议长度两位以内字符,超过两位去前两位]
	 * @return **MMddHHmmssSSSxxxxxxx000000
	 */
	public String getSerialNo(String sPrefix) {
		if(sPrefix != null && !"".equals(sPrefix)){
			sPrefix = sPrefix.trim();
			if(sPrefix.length()>2)
				sPrefix = sPrefix.substring(2).toUpperCase();
			else
				sPrefix = sPrefix.toUpperCase();
		}
		
		if (iCount > 999999L) 
			iCount = 100000L;
		
		String sTime = sdf.format(new Date()); //获取时间
		
		String sRandom = getMathRandom(); //获取7位随机数
		
		return sPrefix + sTime + sRandom + iCount++;
	}
	

	/**
	 * 
	 * 获取随7位机数（为避免重复，分别获取4位和3位两组随机数）
	 * Math.random()产生一个[0，1)之间的随机double数值，是Java、js等语言常用代码。 
	 * 例如：var a = Math.random() * 2 + 1，设置一个随机1到3(取不到3)的变量。
	 * 
	 * @return
	 */
	public String getMathRandom() {
		//获取4位随机数
		String r1 = Double.toString(Math.random()).substring(2);
		if (r1.length() > 4) 
			r1 = r1.substring(0, 4);
		else
			r1 = (r1 + "000").substring(0, 4);
		
		//获取3位随机数
		String r2 = Double.toString(Math.random()).substring(2);
		if (r2.length() > 3) 
			r2 = r2.substring(0, 3);
		else
			r2 = (r2 + "00").substring(0, 3);
		return r1 + r2;
	}

	public void close() {
	}
}

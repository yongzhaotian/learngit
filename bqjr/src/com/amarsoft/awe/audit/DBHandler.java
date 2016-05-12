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
			c.setApplication("��Ƴ����DBHandler");
			c.setAdditionalInfo("��Ƴ������չ��Ϣ");
			bm.setAppContext(c);
			bm.saveObject(bo);
		} catch (JBOException e) {
			e.printStackTrace();
			ARE.getLog().debug(e);
		}
		return;
	}
	
	/**
	 * ��ȡ�ԡ�sPrefix����ͷ�����к�
	 * 
	 * @param sPrefix [sPrefix�ַ����鳤����λ�����ַ�,������λȥǰ��λ]
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
		
		String sTime = sdf.format(new Date()); //��ȡʱ��
		
		String sRandom = getMathRandom(); //��ȡ7λ�����
		
		return sPrefix + sTime + sRandom + iCount++;
	}
	

	/**
	 * 
	 * ��ȡ��7λ������Ϊ�����ظ����ֱ��ȡ4λ��3λ�����������
	 * Math.random()����һ��[0��1)֮������double��ֵ����Java��js�����Գ��ô��롣 
	 * ���磺var a = Math.random() * 2 + 1������һ�����1��3(ȡ����3)�ı�����
	 * 
	 * @return
	 */
	public String getMathRandom() {
		//��ȡ4λ�����
		String r1 = Double.toString(Math.random()).substring(2);
		if (r1.length() > 4) 
			r1 = r1.substring(0, 4);
		else
			r1 = (r1 + "000").substring(0, 4);
		
		//��ȡ3λ�����
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

package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2013-05-06
 * xjzhao 
 * ������������ǰ�ֹ�һ������ȡ���ķ���
 */

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;

public class FeeDealTransaction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		try
		{
			String feeSerialNo = (String)this.getAttribute("FeeSerialNo");//���ñ��
			String objectType = (String)this.getAttribute("ObjectType");//������������
			String objectNo = (String)this.getAttribute("ObjectNo");//������������
			String dealReturn="";
			
			AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
			if(feeSerialNo == null || "".equals(feeSerialNo))
			{
				if(objectType==null || "".equals(objectType) || objectNo == null || "".equals(objectNo))
				{
					throw new Exception("���ñ�źͷ�������������ͬʱΪ�գ����飡");
				}
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectType", objectType);
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("Status", "0");
				List<BusinessObject> boList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status", as);
				if(boList.isEmpty()) return "δ�ҵ����������ķ��ã����飡";
				for(BusinessObject bo:boList)
				{
					//��������ǰ�ֹ�һ������ȡ\�ֹ�һ������ȡ
					if("02".equals(bo.getString("FeePayDateFlag")) || "03".equals(bo.getString("FeePayDateFlag")))
					{
						dealReturn+=dealFee(bo,Sqlca)+"\r\n";
					}
				}
			}
			else
			{
				BusinessObject bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee, feeSerialNo);
				if(bo == null) return "δ�ҵ����������ķ��ã����飡";
				if("02".equals(bo.getString("FeePayDateFlag")) || "03".equals(bo.getString("FeePayDateFlag")))
					dealReturn+=dealFee(bo,Sqlca);
				else
					return "�ֹ���ȡ�ķ��ò���ʹ�øù��ܣ�";
			}
			return dealReturn;
		}catch(Exception e)
		{
			e.printStackTrace();
			ARE.getLog().debug("ϵͳ����", e);
			return e.getMessage();
		}
	}
	
	private String dealFee(BusinessObject bo,Transaction Sqlca) throws Exception{
		String userID = (String)this.getAttribute("UserID");//�����û�
		String transactionCode = (String)this.getAttribute("TransactionCode");//���״���
		String transactionDate = (String)this.getAttribute("TransactionDate");//��������
		String transactionCodeName = CodeCache.getItemName("T_Transaction_Def", transactionCode);
		CreateTransaction ct = new CreateTransaction();
		ct.setAttribute("RelativeObjectType", bo.getObjectType());
		ct.setAttribute("RelativeObjectNo", bo.getObjectNo());
		ct.setAttribute("UserID", userID);
		ct.setAttribute("TransactionCode", transactionCode);
		ct.setAttribute("TransactionDate", transactionDate);
		ct.setAttribute("FlowFlag", "2");
		String s = (String)ct.run(Sqlca);
		if(s==null || "".equals(s) || s.startsWith("false") || s.indexOf("@")<0) return "���ñ��Ϊ��"+bo.getObjectNo()+"���������ס�"+transactionCodeName+"��ʱ����";
		
		String transactionSerialNo = s.split("@")[1];
		RunTransaction2 rt2=new RunTransaction2();
		rt2.setAttribute("TransactionSerialNo", transactionSerialNo);
		rt2.setAttribute("UserID", userID);
		rt2.setAttribute("Flag", "Y");
		String r=(String)rt2.run(Sqlca);
		if(r==null || "".equals(s)) return "���ñ��Ϊ��"+bo.getObjectNo()+"��ִ�н��ס�"+transactionCodeName+"��ʱ����";
		if(r.startsWith("false")) return r.split("@")[1];
		if(r.equals("true")) return "���ñ��Ϊ��"+bo.getObjectNo()+"��ִ�н��ס�"+transactionCodeName+"���ɹ���";
		return "";
	}
	
}

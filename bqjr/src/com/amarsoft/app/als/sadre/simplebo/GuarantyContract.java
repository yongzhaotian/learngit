/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.app.als.sadre.simplebo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * @ GuarantyContract.java
 * DESCRIPT: ������ͬ����
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-26 ����08:02:00
 *
 * logs: 1. 
 */
public class GuarantyContract implements ISimpleBO{
	
	public static final String ��֤��ʽ_�������� = "010";
	
	public static final String ��֤��ʽ_һ������ = "020";
	
	public static final String ������ͬ����_һ�㵣�� = "010";
	
	public static final String ������ͬ����_��߶�� = "020";
	
	private String contractSerial = "";
	
	private String guarantyType = "";
	
	private String guarantorId = "";
	
	private String guarantorName = "";
	/**
	 * �����ܽ��
	 */
	private double guarantedSum = 0.0D;
	/**
	 * ��֤��ʽ:
	 * 010 �������α�֤ 
	 * 020 һ�����α�֤
	 */
//	private String guarantyStyle = "";
	/**
	 * ������ͬ״̬
	 */
	private String contractStatus = "";
	
	/**
	 * ������ͬ����:
	 * 010 һ�㵣��
	 * 020 ��߶��
	 */
	private String contractType = "";
	
	private String currency = "";
	
	private List<GuarantyInfo> guarantyInfos = null;
	
	private Transaction Sqlca;
	
	public GuarantyContract(String serialNo, Transaction to){
		this.contractSerial = serialNo;
		this.Sqlca = to;
	}
	
	public void fullfill() throws SADREException{
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select guarantyType,GuarantorID,GuarantorName,GuarantyValue," +
					"GuarantyCurrency,ContractStatus,ContractType " +
					"from GUARANTY_CONTRACT where SERIALNO='"+getContractSerial()+"'");
			if(resultset.next()){
				guarantyType 	= StringUtil.getString(resultset.getString("guarantyType"));
				guarantorId 	= StringUtil.getString(resultset.getString("GuarantorID"));
				guarantorName 	= StringUtil.getString(resultset.getString("GuarantorName"));
				currency		= StringUtil.getString(resultset.getString("GuarantyCurrency"));
				contractStatus 	= StringUtil.getString(resultset.getString("ContractStatus"));
				contractType 	= StringUtil.getString(resultset.getString("ContractType"));
				guarantedSum	= resultset.getDouble("GuarantyValue");
			}
			resultset.getStatement().close();
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
	}
//	
//	/**
//	 * ��֤��ʽ
//	 * @return
//	 */
//	public String getGuarantyStyle() {
//		return guarantyStyle;
//	}

	public String getContractStatus() {
		return contractStatus;
	}

	public String getContractType() {
		return contractType;
	}

	/**
	 * �ӳټ��ص�����ͬ���µ���Ʒ
	 * @return
	 * @throws SADREException
	 */
	public List<GuarantyInfo> getGuarantyInfos() throws SADREException{
		if(guarantyInfos == null) {
			guarantyInfos = new ArrayList<GuarantyInfo>();
			
			//----------------�оٸõ�����ͬ���µĵ���Ʒ
			if(!guarantyType.startsWith("010")){		//��������ϸ
				String sGuarantyID = "";
				//TODO;
//				try {
//					BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.GUARANTY_CONTRACT");
//					BizObjectQuery boq = bom.createQuery("select GR.GUARANTYID from O,jbo.app.GUARANTY_RELATIVE GR " +
//							"where O.SERIALNO=GR.GCCONTRACTNO " +
//							"and O.SERIALNO=:SERIALNO");
//					boq.setParameter("SERIALNO", getContractSerial());
//					BizObject bo = boq.getSingleResult(false);
//					if(bo!=null){
//						sGuarantyID 	= StringUtil.getString(bo.getAttribute("GUARANTYID").getString());
//						
//						GuarantyInfo gi = new GuarantyInfo(sGuarantyID,Sqlca);
//						gi.fullfill();
//						guarantyInfos.add(gi);
//					}
//				} catch (JBOException e) {
//					throw new SADREException(e);
//				}
				
			}
		}
		
		return guarantyInfos;
	}
	
	public String getContractSerial() {
		return contractSerial;
	}

	public void setContractSerial(String contractSerial) {
		this.contractSerial = contractSerial;
	}

	public String getGuarantyType() {
		return guarantyType;
	}

	public String getGuarantorId() {
		return guarantorId;
	}

	public String getGuarantorName() {
		return guarantorName;
	}

	public double getGuarantedSum() {
		return guarantedSum;
	}

	public String getCurrency() {
		return currency;
	}

	/**
	 * �ڵ�����ͬ�����й��˳�ָ��������ʽ����Ч������ͬ��
	 * 1.��Ч�жϣ���߶��������Ч;һ�㵣������Ҫ��Ч
	 * 
	 * @param gcs
	 * @return
	 */
	public static List<GuarantyContract> scanByTypeInApply(List<GuarantyContract> gcs,String guarantyType){
		List<GuarantyContract> tmpgc = new ArrayList<GuarantyContract>();
		//
		Iterator<GuarantyContract> agc = gcs.iterator();
		while(agc.hasNext()){
			GuarantyContract gctmp = agc.next();
			
			//��Ч������ͬ:��߶��������Ч;һ�㵣������Ҫ��Ч
			if((gctmp.getContractStatus().equals("010")				//һ�㵣��
					|| (gctmp.getContractStatus().equals("020") 	//��߶��
							&& gctmp.getContractType().equals(GuarantyContract.������ͬ����_��߶��)))
							){
				
				if(gctmp.getGuarantyType().equals(guarantyType)){
					tmpgc.add(gctmp);
				
				}
			}
		}
		
		return tmpgc;
	}
	
	/**
	 * ���˵õ�����δʧЧ�ĵ�����ͬ(����һ�㵣������߶��)
	 * @param gcs
	 * @param guarantyType
	 * @return
	 */
	public static List<GuarantyContract> scanByTypeInContract(List<GuarantyContract> gcs,String guarantyType){
		List<GuarantyContract> tmpgc = new ArrayList<GuarantyContract>();
		//
		Iterator<GuarantyContract> agc = gcs.iterator();
		while(agc.hasNext()){
			GuarantyContract gctmp = agc.next();
			
			//��Ч������ͬ:����δʧЧ�ĵ�����ͬ(����һ�㵣������߶��)
			if(gctmp.getContractStatus().matches("(010|020)")				//��ͬ״̬
					&& (gctmp.getContractType().equals(GuarantyContract.������ͬ����_��߶��)	//������ͬ����
						||gctmp.getContractType().equals(GuarantyContract.������ͬ����_һ�㵣��))	
					){
				
				if(gctmp.getGuarantyType().equals(guarantyType)){
					tmpgc.add(gctmp);
				
				}
			}
		}
		
		return tmpgc;
	}
}

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
 * DESCRIPT: 担保合同对象
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-26 下午08:02:00
 *
 * logs: 1. 
 */
public class GuarantyContract implements ISimpleBO{
	
	public static final String 保证方式_连带责任 = "010";
	
	public static final String 保证方式_一般责任 = "020";
	
	public static final String 担保合同类型_一般担保 = "010";
	
	public static final String 担保合同类型_最高额担保 = "020";
	
	private String contractSerial = "";
	
	private String guarantyType = "";
	
	private String guarantorId = "";
	
	private String guarantorName = "";
	/**
	 * 担保总金额
	 */
	private double guarantedSum = 0.0D;
	/**
	 * 保证方式:
	 * 010 连带责任保证 
	 * 020 一般责任保证
	 */
//	private String guarantyStyle = "";
	/**
	 * 担保合同状态
	 */
	private String contractStatus = "";
	
	/**
	 * 担保合同类型:
	 * 010 一般担保
	 * 020 最高额担保
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
//	 * 保证方式
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
	 * 延迟加载担保合同项下担保品
	 * @return
	 * @throws SADREException
	 */
	public List<GuarantyInfo> getGuarantyInfos() throws SADREException{
		if(guarantyInfos == null) {
			guarantyInfos = new ArrayList<GuarantyInfo>();
			
			//----------------列举该担保合同项下的担保品
			if(!guarantyType.startsWith("010")){		//担保无明细
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
	 * 在担保合同集合中过滤出指定担保方式的有效担保合同。
	 * 1.有效判断：最高额担保必须有效;一般担保不需要有效
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
			
			//有效担保合同:最高额担保必须有效;一般担保不需要有效
			if((gctmp.getContractStatus().equals("010")				//一般担保
					|| (gctmp.getContractStatus().equals("020") 	//最高额担保
							&& gctmp.getContractType().equals(GuarantyContract.担保合同类型_最高额担保)))
							){
				
				if(gctmp.getGuarantyType().equals(guarantyType)){
					tmpgc.add(gctmp);
				
				}
			}
		}
		
		return tmpgc;
	}
	
	/**
	 * 过滤得到所有未失效的担保合同(包括一般担保和最高额担保)
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
			
			//有效担保合同:所有未失效的担保合同(包括一般担保和最高额担保)
			if(gctmp.getContractStatus().matches("(010|020)")				//合同状态
					&& (gctmp.getContractType().equals(GuarantyContract.担保合同类型_最高额担保)	//担保合同类型
						||gctmp.getContractType().equals(GuarantyContract.担保合同类型_一般担保))	
					){
				
				if(gctmp.getGuarantyType().equals(guarantyType)){
					tmpgc.add(gctmp);
				
				}
			}
		}
		
		return tmpgc;
	}
}

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
package com.amarsoft.sadre.app.action;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.Dimensions;
import com.amarsoft.sadre.rules.aco.Dimension;

/**
 * @ SADREUpdateDimension.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-5-12 下午01:55:00
 *
 * logs: 1. 
 */
public class UpdateDimension extends BasicWebAction {
	private String dimensionId = "";

	public String getDimensionId() {
		return dimensionId==null?"":dimensionId;
	}

	public void setDimensionId(String dimensionId) {
		this.dimensionId = dimensionId;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	
	public int execute(Transaction Sqlca) throws SADREException {
		String sDimensionID		= getDimensionId();
		String sDimensionName 	= "";
		String sDimensionType 	= "";
//		String sDimensionSource = "";
		String sDimensionImpl 	= "";
//		String sDimensionArgs 	= "";
		String sOptionType 		= "";
		String sOptionImpl 		= "";
		
		if(sDimensionID==null||sDimensionID.length()==0) throw new SADREException("授权维度更新失败!原因:维度编号为空");
		/**/
		try {
			String sql = "select DIMENSIONID,DIMENSIONNAME,DIMENSIONTYPE,DIMENSIONIMPL,OPTIONTYPE,OPTIONIMPL " +
					"from SADRE_DIMENSION where DIMENSIONID='"+sDimensionID+"'";
			ASResultSet resultset = Sqlca.getASResultSet(sql);
			if(resultset.next()){
				sDimensionName 	 = StringUtil.getString(resultset.getString("DimensionName"));
				sDimensionType 	 = StringUtil.getString(resultset.getString("DimensionType"));
				sDimensionImpl 	 = StringUtil.getString(resultset.getString("DimensionImpl"));
				sOptionType 	 = StringUtil.getString(resultset.getString("OptionType"));
				sOptionImpl 	 = StringUtil.getString(resultset.getString("OptionImpl"));
			}
			resultset.getStatement().close();
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
		/*JBO等价实现
		try {
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.sadre.DIMENSION");
			tx.join(bm);		//加入事务内
			
			BizObjectQuery bq = bm.createQuery("DIMENSIONID=:DIMENSIONID");
			bq.setParameter("DIMENSIONID", sDimensionID);
			BizObject bo = bq.getSingleResult(false);
			if(bo != null){
				sDimensionName 	 = StringUtil.getString(bo.getAttribute("DIMENSIONNAME").getString());
				sDimensionType 	 = StringUtil.getString(bo.getAttribute("DIMENSIONTYPE").getString());
				sDimensionImpl 	 = StringUtil.getString(bo.getAttribute("DIMENSIONIMPL").getString());
				sOptionType 	 = StringUtil.getString(bo.getAttribute("OPTIONTYPE").getString());
				sOptionImpl 	 = StringUtil.getString(bo.getAttribute("OPTIONIMPL").getString());
			}
		} catch (JBOException e) {
			throw new SADREException(e);
		}
		*/
		log.trace("DimensionID		="+sDimensionID);
		log.trace("DimensionName	="+sDimensionName);
		log.trace("DimensionType	="+sDimensionType);
//		log.trace("DimensionSource	="+sDimensionSource);
		log.trace("DimensionImpl	="+sDimensionImpl);
//		log.trace("DimensionArgs	="+sDimensionArgs);
		log.trace("OptionType		="+sOptionType);
		log.trace("OptionImpl		="+sOptionImpl);
		
		if(Dimensions.containsDimension(sDimensionID)){
			Dimension dms = Dimensions.getDimension(sDimensionID);
			dms.setType(sDimensionType);
//			dms.setSourceType(sDimensionSource);
			dms.setImpl(sDimensionImpl);
//			dms.setArgs(sDimensionArgs);
			dms.setOptionType(sOptionType);
			dms.setOptionSource(sOptionImpl);
			
			log.info("授权维度更新成功!维度编号:"+sDimensionID);
		}else{
			Dimension dms = new Dimension(sDimensionID,sDimensionName);
			dms.setType(sDimensionType);
//			dms.setSourceType(sDimensionSource);
			dms.setImpl(sDimensionImpl);
//			dms.setArgs(sDimensionArgs);
			dms.setOptionType(sOptionType);
			dms.setOptionSource(sOptionImpl);
			
			Dimensions.addDimension(dms);
			
			log.info("授权维度新增成功!维度编号:"+sDimensionID);
		}
		
		
		return WEB_ACTION_成功;
	}

}

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

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * @ GuarantyInfo.java
 * DESCRIPT: 担保合同项下担保品对象
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-27 上午10:58:45
 *
 * logs: 1. 
 */
public class GuarantyInfo implements ISimpleBO{
	
	private String guarantyId 		= "";
	private String guarantyType 	= "";
	private String ownerId 			= "";
	private String ownerName 		= "";
	private double evalNetValue 	= 0.0D;
	private double confirmValue 	= 0.0D;
	private double registValue 		= 0.0D;		//登记价值
	private double accountValue 	= 0.0D;		//入账价值
	private String guarantyCurrency = "";
	
	private Transaction Sqlca;
	
	public GuarantyInfo(String thingSerial, Transaction to){
		this.guarantyId = thingSerial;
		this.Sqlca = to;
	}
	
	public void fullfill() throws SADREException {
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select GUARANTYTYPE,COLASSETOWNER,GUARANTORNAME,CURRENCY," +
					"EVALNETVALUE,CONFIRMVALUE,CRMVALUE01,CRMVALUE02 " +
					"from GUARANTY_INFO where GUARANTYID='"+getGuarantyId()+"'");
			if(resultset.next()){
				guarantyType 	= StringUtil.getString(resultset.getString("GUARANTYTYPE"));
				ownerId 		= StringUtil.getString(resultset.getString("COLASSETOWNER"));
				ownerName 		= StringUtil.getString(resultset.getString("GUARANTORNAME"));
				guarantyCurrency= StringUtil.getString(resultset.getString("CURRENCY"));

				evalNetValue	= resultset.getDouble("EVALNETVALUE");
				confirmValue	= resultset.getDouble("CONFIRMVALUE");
				registValue		= resultset.getDouble("CRMVALUE01");
				accountValue	= resultset.getDouble("CRMVALUE02");
			}
			resultset.getStatement().close();
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
	}

	public String getGuarantyId() {
		return guarantyId;
	}

	public String getGuarantyType() {
		return guarantyType;
	}

	public String getOwnerId() {
		return ownerId;
	}

	public String getOwnerName() {
		return ownerName;
	}

	public double getEvalNetValue() {
		return evalNetValue;
	}

	public double getConfirmValue() {
		return confirmValue;
	}
	
	public String getGuarantyCurrency() {
		return guarantyCurrency;
	}

	public double getRegistValue() {
		return registValue;
	}

	public double getAccountValue() {
		return accountValue;
	}
}

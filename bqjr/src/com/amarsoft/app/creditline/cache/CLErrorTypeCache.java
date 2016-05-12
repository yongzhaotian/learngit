/*
 * @(#)ErrorTypeCache.java
 *
 * Copyright 2001-2012 Amarsoft, Inc. All Rights Reserved.
 * 
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * 
 * Author:Administrator
 */
package com.amarsoft.app.creditline.cache;

import java.sql.SQLException;
import java.util.LinkedHashMap;

import com.amarsoft.app.creditline.model.ErrorType;
import com.amarsoft.app.creditline.model.ErrorTypeTable;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

/**
 * @author xhgao
 *
 */
public class CLErrorTypeCache  extends AbstractCache {

	private ErrorTypeTable errorTypeTable = null;
	private static CLErrorTypeCache instance = null;

	/**
	 * ���캯��
	 */
	private CLErrorTypeCache() {
	}

	/**
	 * ÿ��ʹ�õ�ʱ��,�ܹ����ñ�����,���õ�ȫ��Ψһ�Ķ���ʵ������ 
	 * @return RoleCache ����һ��ȫ��Ψһ�Ķ���ʵ������
	 */
	public static synchronized CLErrorTypeCache getInstance() {
		if (instance == null) {
			instance = new CLErrorTypeCache();
		}
		return instance;
	}

	/**
	 * ÿ��ʹ�õ�ʱ��,�ܹ����ñ�����,���õ�ȫ��Ψһ�Ķ���ʵ������ 
	 * @return ����һ��ȫ��Ψһ�Ķ���ʵ������
	 */
	private synchronized ErrorTypeTable getErrorTypeTable() throws Exception{
		if (errorTypeTable == null) {
			errorTypeTable = new ErrorTypeTable(new LinkedHashMap<String,ErrorType>());
		}
		return errorTypeTable;
	}

	/**
	 * �����ݿ�װ��
	 * @param Sqlca
	 * @throws Exception
	 */
	public boolean load(Transaction Sqlca) throws Exception{
		ARE.getLog().info("[CACHE] CreditLine ErrorType Cache bulid Begin .................");
		errorTypeTable = getErrorTypeTable(Sqlca);
		//������װ��ASValuePool���Ա��ϵ�Ӧ�õ���
		//loadConfig(Sqlca);
		ARE.getLog().info("[CACHE] CreditLine ErrorType Cache bulid CL_ERROR_TYPE["+errorTypeTable.getSize()+"] End ...................");
		return true;
	}

	public void clear() throws Exception {
		if (errorTypeTable != null) {
			getErrorTypeTable().clear();
			errorTypeTable = null;
		}
	}
	
	private static ErrorTypeTable getErrorTypeTable(Transaction Sqlca) throws SQLException {
		ErrorTypeTable table = new ErrorTypeTable(new LinkedHashMap<String,ErrorType>());
		String sql = "select ErrorTypeID,ErrorTypeName,ErrorLevel from CL_ERROR_TYPE Order by ErrorTypeID";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));
		while (rs.next()) {
			table.addErrorType(new ErrorType(rs.getString("ErrorTypeID"), rs.getString("ErrorTypeName"),rs.getString("ErrorLevel")));
		}
		rs.getStatement().close();
		ARE.getLog().info("[CACHE] CreditLine ErrorType Cache get CL_ERROR_TYPE["+table.getSize()+"] End ...................");

		return table;
	}
	
	/**
	 * ����sErrorTypeID��ȡCLErrorType����
	 */
	public static ErrorType getErrorType(String sErrorTypeID) throws Exception {
		ErrorTypeTable table = getInstance().getErrorTypeTable();
		if (table.getErrorTypeMap().isEmpty()) {
			Transaction Sqlca = getSqlca();
			try {
				return getErrorType(sErrorTypeID, Sqlca);
			} finally {
				if (Sqlca != null)
					Sqlca.disConnect();
			}
		} else {
			return table.getErrorType(sErrorTypeID);
		}
	}
	
	private static ErrorType getErrorType(String sErrorTypeID, Transaction Sqlca) throws Exception {
		String sql = "select ErrorTypeID,ErrorTypeName,ErrorLevel,ErrorDescribe,HandleDescribe from CL_ERROR_TYPE where ErrorTypeID=:ErrorTypeID";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("ErrorTypeID", sErrorTypeID));
		if (rs.next()) {
			ErrorType type = new ErrorType(rs.getString("ErrorTypeID"), rs.getString("ErrorTypeName"),rs.getString("ErrorLevel"));
			type.setErrorDescribe(rs.getString("ErrorDescribe"));
			type.setHandleDescribe(rs.getString("HandleDescribe"));
			rs.getStatement().close();
			return type;
		}
		rs.getStatement().close();
		return null;
	}
	
	/**
	 * ���Ƕ�ԭ��Ӧ�õļ��ݣ�������װ��ASValuePool���Ա��ϵ�Ӧ�õ���
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	/*private ASValuePool loadConfig(Transaction Sqlca) throws Exception {
        String sErrorTypeKey = null;
        ASValuePool vpErrorTypeDef = new ASValuePool();
        ASValuePool attributes = new ASValuePool();
        String[] sKeys = {"ErrorTypeID",
        		"ErrorTypeName",
        		"ErrorLevel"
        		};
        StringBuffer sbSelect = new StringBuffer("");
        sbSelect.append("select ");
        for(int i=0;i<sKeys.length;i++) sbSelect.append(sKeys[i]+",");
        sbSelect.deleteCharAt(sbSelect.length()-1);
        sbSelect.append(" from CL_ERROR_TYPE");
        
        SqlObject so = new SqlObject(sbSelect.toString());
        String[][] sValueMatrix = Sqlca.getStringMatrix(so);
        for(int i=0;i<sValueMatrix.length;i++){
        	sErrorTypeKey = sValueMatrix[i][0];
        	for(int j=0;j<sValueMatrix[i].length;j++){
        		attributes.setAttribute(sKeys[j],sValueMatrix[i][j]);
            }
            vpErrorTypeDef.setAttribute(sErrorTypeKey,attributes,false);
        }
        ASConfigure.setSysConfig("SYSCONF_CL_ERROR_TYPE",vpErrorTypeDef);
        return vpErrorTypeDef;		
	}*/
}

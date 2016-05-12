/***********************************************************************
 * Module:  CreditLineKeeper.java
 * Author:  William
 * Modified: 2005.6.10 18:19:23
 * Purpose: Defines the Class CreditLineKeeper
 * @updatesuer:yhshan
 * @updatedate:2012/09/12
 ***********************************************************************/
package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.are.ASException;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public abstract class CreditLineKeeper implements ICreditLineKeeper {
	private CreditLine line;
	private SqlObject so;

	/** @param Sqlca 
	 * @throws Exception */
	public abstract Vector checkLimitations(Transaction Sqlca,String sObjectType,String sObjectNo) throws Exception;

	public final void setCreditLine(CreditLine cl) {
		this.line = cl;
	}

	/** @param Sqlca */
	public abstract double calcBalance(Transaction Sqlca) throws Exception;

	/**
	 * @param Sqlca
	 * @param BalanceID
	 * @throws Exception
	 */
	public abstract double calcBalance(Transaction Sqlca, String BalanceID)
			throws Exception;


	public abstract Vector checkLine(Transaction Sqlca,String sObjectType,String sObjectNo)
			throws Exception;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.amarsoft.app.creditline.ICreditLineKeeper#check(com.amarsoft.are.sql.Transaction,
	 *      java.lang.String, java.lang.String)
	 */
	public final Vector check(Transaction Sqlca,String Options, String ObjectType,String ObjectNo) throws Exception {
		if (this.getCreditLine().getCurCheckNo() == null) {
			throw new ASException("当前额度尚未进入“检查”状态，请通过 enterCheckMode()进入检查状态。");
		}
		Vector errors = new Vector();

//		 执行额度总体限制条件判断
		try {
			Vector lineErrors = checkLine(Sqlca,ObjectType,ObjectNo);
			for(int i=0;i<lineErrors.size();i++){
				String error=(String)lineErrors.get(i);
				if(error!=null && error.length()>0) errors.add(error);
			}
		} catch (Exception ex) {
			throw new ASException("额度总体限制判断时出错：" + ex.getMessage());
		}

//		 执行附加限制条件判断
		try {
			Vector limitationErrors = checkLimitations(Sqlca,ObjectType,ObjectNo);
			for(int i=0;i<limitationErrors.size();i++){
				String error=(String)limitationErrors.get(i);
				if(error!=null && error.length()>0) errors.add(error);
			}
		} catch (Exception ex) {
			throw new ASException("额度限制条件判断时出错：" + ex.getMessage());
		}
		
		//记录错误日志
		String sLogOption = StringFunction.getProfileString(Options,"LOG");
		if(sLogOption!=null && sLogOption.equalsIgnoreCase("Y")){
			logError(Sqlca,errors);
		}else{
			so = new SqlObject("delete from CL_CHECK_LOG where LineID=:LineID and CheckNo=:CheckNo ");	
			so.setParameter("LineID", this.getCreditLine().id());
			so.setParameter("CheckNo", this.getCreditLine().getCurCheckNo());
			Sqlca.executeSQL(so);
		}
		return errors;
	}

	public CreditLine getCreditLine() throws Exception {
		if (this.line == null)
			throw new ASException("Keeper没有获得到额度实例。");
		return this.line;
	}
	private void logError(Transaction Sqlca,Vector errors) throws Exception{
//		记录检查日志
		String sCurCheckLog = this.getCreditLine().getCurCheckNo();
		String sSql = null;
		int heighestErrorLevel = 0;
		for(int i=0;i<errors.size();i++){
			String sErrorString = (String)errors.get(i);
			String sErrorType = StringFunction.getProfileString(sErrorString,"ErrorType");
			String sMeasureColumn = StringFunction.getProfileString(sErrorString,"MeasureColumn");
			String sLimitationSetID = StringFunction.getProfileString(sErrorString,"LimitationSetID");
			String sLimitationID = StringFunction.getProfileString(sErrorString,"LimitationID");
			
			if(sErrorType==null || sErrorType.equals("")) throw new ASException("异常点描述串("+sErrorString+")中未找到类型关键字（ErrorType）");
			if(CreditLineManager.getCLErrorType(sErrorType) == null){
				throw new ASException("未定义的异常点类型："+sErrorType+"，请检查异常点定义表(CL_ERROR_TYPE)");
			}
			String sSerialNo = DBKeyHelp.getSerialNo("CL_ERROR_LIST","ErrorNo","",Sqlca);
			sSql = "insert into CL_ERROR_LIST" +
					"(LineID," +
					"CheckNo," +
					"ErrorNo," +
					"ErrorTypeID," +
					"MeasureColumn," +
					"LimitationSetID," +
					"LimitationID" +
					") values(:LineID,:CheckNo,:ErrorNo,:ErrorTypeID,:MeasureColumn,:LimitationSetID,:LimitationID)";
			so = new SqlObject(sSql);	
			so.setParameter("LineID", this.getCreditLine().id());
			so.setParameter("CheckNo", sCurCheckLog);
			so.setParameter("ErrorNo", sSerialNo);
			so.setParameter("ErrorTypeID", sErrorType);
			so.setParameter("MeasureColumn", sMeasureColumn);
			so.setParameter("LimitationSetID", sLimitationSetID);
			so.setParameter("LimitationID", sLimitationID);
			Sqlca.executeSQL(so);
			//通过比较，计算异常点最高级别
			int errorLevel = this.getErrorLevel(sErrorType);
			if(errorLevel>heighestErrorLevel) heighestErrorLevel = errorLevel;		
		}
		//更新CL_CHECK_LOG异常点最高级别
		sSql = "update CL_CHECK_LOG set ErrorLevel=:ErrorLevel where LineID=:LineID and CheckNo=:CheckNo";
		so = new SqlObject(sSql);	
		so.setParameter("ErrorLevel", heighestErrorLevel);
		so.setParameter("LineID", this.getCreditLine().id());
		so.setParameter("CheckNo", this.getCreditLine().getCurCheckNo());
		Sqlca.executeSQL(so);
	}
	
	private int getErrorLevel(String sErrorType) throws Exception {
		int errorLevel = 0;
		String sErrorLevel = CreditLineManager.getCLErrorType(sErrorType).getErrorLevel();
		if(sErrorLevel==null) sErrorLevel="0";
		errorLevel = Integer.parseInt(sErrorLevel);
		
		return errorLevel;
	}

}
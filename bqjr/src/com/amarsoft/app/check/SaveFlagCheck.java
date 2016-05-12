package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 自动风险探测中暂存状态检查
 * @author djia
 * @since 2009/11/05
 *
 */
public class SaveFlagCheck extends AlarmBiz{
	
	public Object  run(Transaction Sqlca) throws Exception
	{		 
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量：SQL语句
		String sSql = "";
		//定义变量：主要主体表名、关联表名
		String sMainTable = "",sRelativeTable = "";
		//定义变量：暂存标志
		String sTempSaveFlag = "";
		//定义变量：查询结果集
		ASResultSet rs = null;			
		
		//根据对象类型获取主体表名
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = :ObjectType ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType));
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//将空值转化成空字符串
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			sSql = 	" select TempSaveFlag from "+sMainTable+" where SerialNo = :SerialNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				//将空值转化成空字符串
				if (sTempSaveFlag == null) sTempSaveFlag = "";				
				if (sTempSaveFlag.equals("1")||sTempSaveFlag.equals("")) {
					putMsg("信息详情为暂存状态，请先填写完信息详情并点击保存按钮");
				}			
			}
			rs.getStatement().close();
		} 
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}

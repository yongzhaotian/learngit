package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class BatchSuspendOrRecoveryContract {
	
	private String objectNos;

	public String getObjectNos() {
		return objectNos;
	}

	public void setObjectNos(String objectNos) {
		this.objectNos = objectNos;
	}
	/**
	 * 
	 * @param objNos
	 * @return
	 */
	public String getObjectNoArray(String objNos){
		
		String objNoArray = "";
		String[] temp =  objNos.split("@");
		for(int i=0;i<temp.length;i++){
			objNoArray = objNoArray + "," + temp[i];
		}
		
		return objNoArray.substring(1);
		
	}
	
	
	public String contractSuspendValidate(Transaction sqlca){
		if (objectNos == null) {
			return "1";//请传入合同号！
		}
		
		String objNoArray = getObjectNoArray(objectNos);
		ARE.getLog().info("objNoArray="+objNoArray);
		
		ASResultSet rs = null;
		String serialNos = "";
		String sql = "select max(t.serialno) as serialno from flow_task t where t.objectno in ("+objNoArray+") group by t.objectno";
		String sql2 = "select t.phasetype,t.taskstate from flow_task t where t.serialno in(";
		String temp = ")";
		String sql3 = "select count(1) from business_contract t where t.serialno in ("+objNoArray+") and t.cancelstatus = '1'";
		String phasetype = "";
		String taskstate = "";
		String returnMsg = "";
		
		try {
			rs = sqlca.getASResultSet(new SqlObject(sql));
			while (rs.next()){
				serialNos = serialNos +",'" + rs.getString("serialno")+"'";
			}
			
			serialNos = serialNos.substring(1);
			ARE.getLog().info("serialNos==="+serialNos);
			rs = sqlca.getASResultSet(new SqlObject(sql2+serialNos+temp));
			
			while(rs.next()){
				phasetype = rs.getString("phasetype");
				taskstate = rs.getString("taskstate");
				if(!"1010".equals(phasetype) && "1".equals(taskstate)){
					return "2";//所选择的合同有审核中的合同，请按条件搜索合同再进行操作!
				}
			}
			
			returnMsg = sqlca.getString(new SqlObject(sql3));
			if(!"0".equals(returnMsg)){
				return "3";//所选择的合同有已暂停的合同，请按条件搜索合同再进行操作!
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			return "4";//系统异常，请稍后重试或联系IT。
		}
		
		return "0";//校验通过
	}
	
	public String contractSuspendExecute(Transaction sqlca){
		
		String objNoArray = getObjectNoArray(objectNos);
		
		String sql = "update business_contract set cancelstatus='1' where serialno in ("+objNoArray+")";
		
		try {
			sqlca.executeSQL(new SqlObject(sql));
		}  catch (Exception e) {
			e.printStackTrace();
			return "1";
		}
		
		
		return "0";
	}
	
	public String contractRecoveryValidate(Transaction sqlca){
		if (objectNos == null) {
			return "1";//请传入合同号！
		}
		
		String objNoArray = getObjectNoArray(objectNos);
		System.out.println("objNoArray="+objNoArray);
		String sql = "select count(1) from business_contract t where nvl(t.cancelstatus,'99') <> '1' and t.serialno in ("+objNoArray+")";
		String returnMsg = "";
		
		try {
			returnMsg = sqlca.getString(new SqlObject(sql));
			if(!"0".equals(returnMsg)){
				return "2";//所选择的合同有未暂停的合同，请按条件搜索合同再进行操作!
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return "3";//合同恢复校验系统异常，请稍后重试或联系IT。
		}
		
		return "0";//校验通过
	}
	
	public String contractRecoveryExecute(Transaction sqlca){
		
		String objNoArray = getObjectNoArray(objectNos);
		String sql = "update business_contract set cancelstatus='2' where serialno in ("+objNoArray+")";
		
		try {
			sqlca.executeSQL(new SqlObject(sql));
		}  catch (Exception e) {
			e.printStackTrace();
			return "1";//合同恢复执行系统异常，请稍后重试或联系IT。
		}
		
		
		return "0";//合同恢复成功。
	}

}

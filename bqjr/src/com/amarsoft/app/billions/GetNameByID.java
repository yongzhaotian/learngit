package com.amarsoft.app.billions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 通过给出的ID到对应的表中找出名称用于显示
 * @author huzp 
 * @date 2015-08-04
 */
public class GetNameByID {
	String colId="";
	String colName="";
	String tablename="";


	public String getColId() {
		return colId;
	}


	public void setColId(String colId) {
		this.colId = colId;
	}


	public String getColName() {
		return colName;
	}


	public void setColName(String colName) {
		this.colName = colName;
	}


	public String getTablename() {
		return tablename;
	}


	public void setTablename(String tablename) {
		this.tablename = tablename;
	}


	/****
	 * 通过给出的ID编号查询对应所在信息表中的名称
	 * @param Sqlca
	 * @throws Exception
	 */
	public String getNameById(Transaction Sqlca) throws Exception {
		String str="";
		String sql="SELECT "+colName+" FROM "+tablename+" WHERE USERID="+getvalus(colId);
		Connection conn =Sqlca.getConnection();
		PreparedStatement ps=conn.prepareStatement(sql);  
		ResultSet rs = ps.executeQuery(); 
		if(rs.next())
		{
			str=rs.getString(colName);
		}
		ps.close();   
		conn.close(); 
		return str;
	}
	/****
	 * 通过给出的身份证编号与名称查询对应的客户编号与期数
	 * @param Sqlca CCS-1112 添加限制时间条件查询  update huzp 20151020
	 * @throws Exception
	 */
	public String getCustomerName(Transaction Sqlca) throws Exception {
		String str="";
		String sCUSTOMERID="";
		String sTERM="";
		String sql="SELECT CUSTOMERID,TERM  FROM RESCASHACCESSCUSTOMER "
				 + " WHERE  CERTID = '"+colId+"' and CUSTOMERNAME = '"+colName+"' and  (to_date(to_char(SYSDATE, 'yyyy/MM/dd'), 'yyyy/mm/dd')  BETWEEN to_date(eventdate, 'yyyy/MM/dd')   AND to_date(eventenddate, 'yyyy/MM/dd'))";
		Connection conn =Sqlca.getConnection();
		PreparedStatement ps=conn.prepareStatement(sql);  
		ResultSet rs = ps.executeQuery(); 
		if(rs.next())
		{
			sCUSTOMERID=rs.getString("CUSTOMERID");
			sTERM=rs.getString("TERM");
			str=sCUSTOMERID+"@"+sTERM;
		}
		ps.close();   
		conn.close(); 
		return str;
	}
	
	
	
	private String getvalus(String val){
		if(null==val){
			return val;
		}
		if("undefined".equals(val)){
			return null;
		}
		
		return  "'"+val+"'";
	}
}

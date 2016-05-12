package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class DelectLoanCity {
	/** 参数值 **/
	private String paramList;
	/**关联模板编号**/
	private String spSerialNo;
	/**模板类型**/
	private String businessType;
	
	StringBuffer sb = new StringBuffer();
	StringBuffer sql = new StringBuffer();
	
	public String deletLoaner(Transaction transaction) throws Exception{
		String[] array = paramList.split("\\|");
   	 	String endTime = DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss");
		try{
			for (String str : array) {
				sql = new StringBuffer("INSERT INTO PROVIDERSCITY_LOG (SERIALNO,AREACODE,PRODUCTTYPE,TURNACCOUNTNUMBER,");
				sql.append("TURNACCOUNTNAME,TURNACCOUNTBLANK,BACKACCOUNTPREFIX,SPSERIALNO,SUBBANKNAME,BEGINTIME,ENDTIME) ");
				sql.append("SELECT SERIALNO,AREACODE,PRODUCTTYPE,TURNACCOUNTNUMBER,TURNACCOUNTNAME,TURNACCOUNTBLANK,");
				sql.append("BACKACCOUNTPREFIX,SPSERIALNO,SUBBANKNAME,BEGINTIME,:ENDTIME");
				sql.append(" FROM PROVIDERSCITY WHERE ");
				sql.append("SERIALNO = :SERIALNO AND AREACODE = :AREACODE AND PRODUCTTYPE = :PRODUCTTYPE");
				String[] paras = str.split("@@");
				transaction.executeSQL(new SqlObject(sql.toString())
					.setParameter("SERIALNO", paras[0])
					.setParameter("AREACODE", paras[1])
					.setParameter("PRODUCTTYPE", paras[2])
					.setParameter("ENDTIME", endTime));
				
				//查询出关联模板号
				sql = new StringBuffer("SELECT SPSERIALNO FROM ProvidersCity WHERE SERIALNO = :SERIALNO ");
				sql.append("AND AREACODE = :AREACODE AND PRODUCTTYPE = :PRODUCTTYPE");
				ASResultSet rs = transaction.getASResultSet(new SqlObject(sql.toString())
						.setParameter("SERIALNO", paras[0])
						.setParameter("AREACODE", paras[1])
						.setParameter("PRODUCTTYPE", paras[2]));
				if (rs.next()){
					spSerialNo = rs.getString("SPSERIALNO");
				}
				rs.getStatement().close();
				
				//将数据插入LOG中
				sb = new StringBuffer("INSERT INTO FORMATDOC_VERSION_LOG SELECT * FROM FORMATDOC_VERSION WHERE SPSERIALNO = :SPSERIALNO");
				transaction.executeSQL(new SqlObject(sb.toString())
						.setParameter("SPSERIALNO", spSerialNo));
				
				//根据关联合同号删除合同配置
				sb = new StringBuffer("DELETE FROM FORMATDOC_VERSION WHERE SPSERIALNO = :SPSERIALNO");
				transaction.executeSQL(new SqlObject(sb.toString())
						.setParameter("SPSERIALNO", spSerialNo));
				
				//根据贷款人编号，城市编号、产品子类型删除数据
				sb = new StringBuffer("DELETE FROM ProvidersCity WHERE SERIALNO = :SERIALNO ");
				sb.append("AND AREACODE = :AREACODE AND PRODUCTTYPE = :PRODUCTTYPE");
				transaction.executeSQL(new SqlObject(sb.toString())
						.setParameter("SERIALNO", paras[0])
						.setParameter("AREACODE", paras[1])
						.setParameter("PRODUCTTYPE", paras[2]));
			}
		}catch (SQLException e){
			e.printStackTrace();
			transaction.rollback();
			return "false@数据异常，请联系IT相关人员！";
		}
		
		return "true@删除成功！";
	}
	
	public String deletePrint(Transaction transaction) throws Exception{
		
		String[] array = paramList.split("\\|");
		try{
			for (String str : array) {
			//将数据插入LOG中
				sb = new StringBuffer("INSERT INTO FORMATDOC_VERSION_LOG SELECT * FROM FORMATDOC_VERSION WHERE ");
				sb.append("SPSERIALNO = :SPSERIALNO AND BUSINESSTYPE = :BUSINESSTYPE");
				String[] paras = str.split("@@");
				transaction.executeSQL(new SqlObject(sb.toString())
						.setParameter("SPSERIALNO", paras[0])
						.setParameter("BUSINESSTYPE", paras[1]));
						
				//将记录删除掉
				sb = new StringBuffer("DELETE FROM FORMATDOC_VERSION WHERE  ");
				sb.append("SPSERIALNO = :SPSERIALNO AND BUSINESSTYPE = :BUSINESSTYPE");
				transaction.executeSQL(new SqlObject(sb.toString())
						.setParameter("SPSERIALNO", paras[0])
						.setParameter("BUSINESSTYPE", paras[1]));
					}
		} catch (SQLException e){
			e.printStackTrace();
			transaction.rollback();
			return "false@数据异常，请联系IT相关人员！";
		}
		return "true@删除成功！";
	}

	/*public String getSerialNoS() {
		return serialNoS;
	}

	public void setSerialNoS(String serialNoS) {
		this.serialNoS = serialNoS;
	}

	public String getAreaCodes() {
		return areaCodes;
	}

	public void setAreaCodes(String areaCodes) {
		this.areaCodes = areaCodes;
	}

	public String getProductTypes() {
		return productTypes;
	}

	public void setProductTypes(String productTypes) {
		this.productTypes = productTypes;
	}*/

	public String getParamList() {
		return paramList;
	}

	public void setParamList(String paramList) {
		this.paramList = paramList;
	}

	public String getSpSerialNo() {
		return spSerialNo;
	}

	public void setSpSerialNo(String spSerialNo) {
		this.spSerialNo = spSerialNo;
	}

	public String getBusinessType() {
		return businessType;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}	
}

package com.amarsoft.app.billions;

import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 保险公司关联城市管理
 * CCS-906
 * 新增
 * @author bwang
 *
 */
public class ManageInsuranceCityRela {

	//定义变量
	private String insuranceNo; //保险公司编号
	private String itemno; //城市编号
	private String subproductType;
	private String relaValues=""; //关联属性值序列,定义为空串，防止该值为空时传递出错
	


	public String getInsuranceNo() {
		return insuranceNo;
	}

	public void setInsuranceNo(String insuranceNo) {
		this.insuranceNo = insuranceNo;
	}

	public String getItemno() {
		return itemno;
	}

	public void setItemno(String itemno) {
		this.itemno = itemno;
	}

	public String getRelaValues() {
		return relaValues;
	}

	public void setRelaValues(String relaValues) {
		this.relaValues = relaValues;
	}

	public String getSubproductType() {
		return subproductType;
	}

	public void setSubproductType(String subproductType) {
		this.subproductType = subproductType;
	}

	/**
	 * 保险公司关联城市管理
	 * @return
	 * @throws Exception 
	 */
	public String addCity(Transaction Sqlca) throws Exception{
		//先删除指定保险公司对应产品的关联城市
/*		SqlObject asql = new SqlObject("DELETE FROM InsuranceCity_Info WHERE insuranceNo = :insuranceNo and subproducttype = :subproducttype and cityno is not null").setParameter("insuranceNo", insuranceNo).setParameter("subproducttype", subproductType);
		Sqlca.executeSQL(asql);
		*/
		if(relaValues != null){
			//再将新关联关系插入
			String[] itemnos = relaValues.split("@");
			for(int i=0; i<itemnos.length; i++){
				if(StringX.isSpace(itemnos[i])) continue; //有空字符串时不处理
				String sSerialNo = DBKeyHelp.getSerialNo("INSURANCECITY_INFO", "SERIALNO");
				Sqlca.executeSQL(new SqlObject("INSERT INTO InsuranceCity_Info(serialno,cityno,insuranceNo,subproducttype) values(:serialno,:cityno,:insuranceNo,:subproducttype)").setParameter("serialno", sSerialNo).setParameter("insuranceNo", insuranceNo).setParameter("cityno", itemnos[i]).setParameter("subproducttype", subproductType));
			}
		}
		return "SUCCEEDED";
	}
}

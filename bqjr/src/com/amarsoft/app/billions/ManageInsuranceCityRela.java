package com.amarsoft.app.billions;

import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���չ�˾�������й���
 * CCS-906
 * ����
 * @author bwang
 *
 */
public class ManageInsuranceCityRela {

	//�������
	private String insuranceNo; //���չ�˾���
	private String itemno; //���б��
	private String subproductType;
	private String relaValues=""; //��������ֵ����,����Ϊ�մ�����ֹ��ֵΪ��ʱ���ݳ���
	


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
	 * ���չ�˾�������й���
	 * @return
	 * @throws Exception 
	 */
	public String addCity(Transaction Sqlca) throws Exception{
		//��ɾ��ָ�����չ�˾��Ӧ��Ʒ�Ĺ�������
/*		SqlObject asql = new SqlObject("DELETE FROM InsuranceCity_Info WHERE insuranceNo = :insuranceNo and subproducttype = :subproducttype and cityno is not null").setParameter("insuranceNo", insuranceNo).setParameter("subproducttype", subproductType);
		Sqlca.executeSQL(asql);
		*/
		if(relaValues != null){
			//�ٽ��¹�����ϵ����
			String[] itemnos = relaValues.split("@");
			for(int i=0; i<itemnos.length; i++){
				if(StringX.isSpace(itemnos[i])) continue; //�п��ַ���ʱ������
				String sSerialNo = DBKeyHelp.getSerialNo("INSURANCECITY_INFO", "SERIALNO");
				Sqlca.executeSQL(new SqlObject("INSERT INTO InsuranceCity_Info(serialno,cityno,insuranceNo,subproducttype) values(:serialno,:cityno,:insuranceNo,:subproducttype)").setParameter("serialno", sSerialNo).setParameter("insuranceNo", insuranceNo).setParameter("cityno", itemnos[i]).setParameter("subproducttype", subproductType));
			}
		}
		return "SUCCEEDED";
	}
}

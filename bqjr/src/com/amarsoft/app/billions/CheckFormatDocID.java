package com.amarsoft.app.billions;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CheckFormatDocID {
	
	
	private String objectNo;
	private String docID;


	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getDocID() {
		return docID;
	}

	public void setDocID(String docID) {
		this.docID = docID;
	}

	/**
	 * ���ݵ�ǰ��ͬ�����Ĵ�����ѡ��ͬ��ģ��
	 * @param Sqlca
	 * @return docID
	 */
	public String selectFormatDocID(Transaction Sqlca) {
//		�����߼����£�
//		1��	ͨ����ͬȡ�ŵ�
//		2��	ͨ���ŵ�ȡ����
//		3��	ͨ������ȡ������
//		4��	ͨ����ͬȡҵ��Ʒ��		
//		5��	ͨ�������˺�ҵ��Ʒ��ȡ��Ӧ����
		try {
			String sSql = "";
			
			//��ȡ�ŵ����
			sSql = "select city from store_info si "+
		    		" where si.identtype='01' and si.sno=(select STORES from Business_Contract where SerialNo = :SerialNo)";
		   String  sCity = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo", objectNo));
		   if(sCity==null) sCity="";
		    
		   //ȡ������
			sSql = "select SP.SerialNo "
					+ "from BaseDataSet_Info BI,Business_Contract BC,Service_Providers SP   where BI.ATTRSTR1 = BC.CREDITID and SP.SerialNo = BC.CREDITID and BI.ATTRSTR1 = SP.SerialNo  and BC.SerialNo ='"+objectNo+"'  and BI.BigValue like '%"+sCity+"%'  ";
			sSql = "select CreditID from Business_Contract where SerialNo = '"+objectNo+"'";
			String sSPSeialNoString = Sqlca.getString(new SqlObject(sSql));
			if(sSPSeialNoString==null) sSPSeialNoString="";
			ARE.getLog().info("�����˱�ţ�"+sSPSeialNoString);
			
			//ȡҵ��Ʒ��
			sSql = "Select BusinessType From Business_Contract where SerialNo = '"+objectNo+"'";
			String  sBusinessType = Sqlca.getString(new SqlObject(sSql));
			if(sBusinessType==null) sBusinessType="";
			ARE.getLog().info("ҵ��Ʒ�ֱ�ţ�"+sBusinessType);
			
			//ȡģ����
			sSql = "select DocID from FormatDoc_Version  where SPSerialNo= '"+sSPSeialNoString+"' and BusinessType = '"+sBusinessType+"' and isinuse = '1'";
			String sDocID =Sqlca.getString(new SqlObject(sSql));
			if(sDocID==null) sDocID="";
			ARE.getLog().info("ģ���ţ�"+sDocID);
			return sDocID;
		} catch (Exception e) { 
			e.printStackTrace(); 
			return "Failure";
		}
	}
	
	/**
	 * ���ݸ�ʽ������ģ���Ż�ȡ�ڵ��Ӧ��jspҳ��
	 * @param Sqlca
	 * @return docID
	 */
	public String selectFormatUrl(Transaction Sqlca) {

		try {
			//�������
			String sSql = "";
			ASResultSet rs = null;
			String  sUrl = "";
			//Ĭ��ȡ��һ���ڵ�
			sSql = "select JspFileName  from FormatDoc_Def  "+
		    		" where DocID = '"+docID+"' order by dirid";
		    //��ȡjspҳ��·��
			rs= Sqlca.getASResultSet(new SqlObject(sSql));
			if(rs.next()){
				sUrl = DataConvert.toString(rs.getString("JspFileName"));
			}
			rs.getStatement().close();
			return sUrl;
		} catch (Exception e) { 
			e.printStackTrace(); 
			return "Failure";
		}
	}
}

package com.amarsoft.proj.action;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * @author xswang
 * @��ʼ���ļ�������������Ϣ
 * @since 2015/05/27
 */
public class InitCheckDocEcmImageOpinion {
	private String objectNo;//������
	private String objectType;//��������
	private String typeNo;//Ӱ����
	private String opinion1;
	private String opinion2;

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getTypeNo() {
		return typeNo;
	}

	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}

	/**
	 * ��ʼ�����������Ӱ���ļ��������
	 * @param Sqlca
	 * @return
	 */
	public String InitOpinion(Transaction Sqlca) throws Exception{
		//��������
		String sTypeNo;
		String sFlag ="";
		//String sBusinessType = "";
		//�����ж��Ƿ��Ѿ�ִ�й���ʼ��
		sFlag = Sqlca.getString(new SqlObject("select objectNo from ECM_IMAGE_OPINION where objectno = '"+objectNo+"' and objecttype='Business'"));
		//sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT Where SerialNo = '"+objectNo+"' "));
		//��Ʒ���Ͳ�ѯ
		String sProductCategory = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT "+
				" Where SerialNo = :SerialNo ").setParameter( "SerialNo", objectNo ) );

		if( sProductCategory == null ) sProductCategory = " ";
		if(sFlag==null||sFlag.equals("")){
			String sSql = "";
			if(objectType.equals("Business")){
				sSql = "select typeNo from ECM_IMAGE_TYPE where IsInUse = '1' "+
						" and TypeNo In (Select IMAGE_TYPE_NO from PRODUCT_ECM_TYPE "+
						" where PRODUCT_TYPE_ID in (Select PRODUCT_TYPE_ID  from PRODUCT_TYPE_CTYPE where PRODUCT_ID = '"+sProductCategory+"')) "+
						" order by typeno";
			}
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql));
			while(rs.next()){
				sTypeNo = DataConvert.toString(rs.getString("typeNo"));
				String sSerialNo = DBKeyHelp.getSerialNo("ECM_IMAGE_OPINION","SerialNo",Sqlca);
				String sSql0 = "insert into ECM_IMAGE_OPINION (SerialNo,ObjectNo,ObjectType,TypeNo) values (:SerialNo,:ObjectNo,:ObjectType,:TypeNo) ";
				Sqlca.executeSQL(new SqlObject(sSql0).setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).setParameter("TypeNo", sTypeNo).setParameter("SerialNo", sSerialNo));
			}
			rs.getStatement().close();
		}		
		return sFlag;
	}
	
	/**
	 * ��ʼ����������Ĵ���Ӱ���ļ��������
	 * @param Sqlca
	 * @return
	 */
	public String InitOpinionAfterLoan(Transaction Sqlca) throws Exception{
		//��������
		String sTypeNo;
		String sFlag ="";
		String sProductID = "";
		//�����ж��Ƿ��Ѿ�ִ�й���ʼ��
		sFlag = Sqlca.getString(new SqlObject("select objectNo from ECM_IMAGE_OPINION where objectno = '"+objectNo+"' and objecttype='"+objectType+"'"));
		//��Ʒ���Ͳ�ѯ
		sProductID = Sqlca.getString( new SqlObject("Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID " +
                " from business_contract where serialno = :SerialNo ").setParameter( "SerialNo", objectNo ) );
		while(sProductID.endsWith(",")){
			sProductID = sProductID.substring(0, sProductID.length()-1);
		}
		if(sFlag==null||sFlag.equals("")){
			String sSql = "";
			if(objectType.equals("BusinessLoan")){
				sSql = "select typeNo from ECM_IMAGE_TYPE where IsInUse = '1' "+
						" and TypeNo In (Select IMAGE_TYPE_NO from PRODUCT_ECM_UPLOAD where PRODUCT_TYPE_ID in ("+sProductID+")) "+
						" order by typeno";
			}
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql));
			while(rs.next()){
				sTypeNo = DataConvert.toString(rs.getString("typeNo"));
				String sSerialNo = DBKeyHelp.getSerialNo("ECM_IMAGE_OPINION","SerialNo",Sqlca);
				String sSql0 = "insert into ECM_IMAGE_OPINION (SerialNo,ObjectNo,ObjectType,TypeNo) values (:SerialNo,:ObjectNo,:ObjectType,:TypeNo) ";
				Sqlca.executeSQL(new SqlObject(sSql0).setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).setParameter("TypeNo", sTypeNo).setParameter("SerialNo", sSerialNo));
			}
			rs.getStatement().close();
		}		
		return sFlag;
	}
}
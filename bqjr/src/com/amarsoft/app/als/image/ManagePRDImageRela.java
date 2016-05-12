package com.amarsoft.app.als.image;

import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * Ӱ�����ͶԲ�Ʒ�Ĺ���
 * @author jqcao
 *
 */
public class ManagePRDImageRela {

	//�������
	private String imageTypeNo; //Ӱ�����ͱ��
	private String productID; //��Ʒ���
	private String relaValues=""; //����Ӱ����������
	
	
	/**
	 * ���Ӳ�Ʒ��Ӱ�����͹���
	 * @return
	 * @throws Exception 
	 */
	public String addRelation(Transaction Sqlca) throws Exception{
		//��Ʒ��Ӱ�����͹���
		SqlObject asql = new SqlObject("DELETE FROM ECM_PRDIMAGE_RELA WHERE ProductID Like :ProductID").setParameter("ProductID", productID+"%");
		Sqlca.executeSQL(asql);
		
		if( relaValues != null ){
			//�ٽ��¹�����ϵ����
			String[] sTypeNos = relaValues.split("@");
			for( int i=0; i<sTypeNos.length; i++ ){
				if( StringX.isSpace( sTypeNos[i] ) ) continue; //�п��ַ���ʱ������
				Sqlca.executeSQL( new SqlObject("INSERT INTO ECM_PRDIMAGE_RELA(ProductID,ImageTypeNo) " +
						"SELECT TypeNo, :ImageTypeNo FROM BUSINESS_TYPE Where TypeNo like :ProductID ").setParameter("ProductID", productID+"%").setParameter("ImageTypeNo", sTypeNos[i]) );
			}
		}
		return "true";
	}
	
	/**
	 * ɾ����Ʒ��Ӱ�����͹���
	 * @return
	 * @throws Exception 
	 */
	public String delRelationByImageTypeNo(Transaction Sqlca) throws Exception{
		//��Ʒ��Ӱ�����͹���
		SqlObject sql = new SqlObject("DELETE FROM ECM_PRDIMAGE_RELA " +
				" WHERE ImageTypeNo = :ImageTypeNo ").setParameter("ImageTypeNo", this.imageTypeNo);
		Sqlca.executeSQL( sql );
		return "true";
	}
	
	/**
	 * ɾ����Ʒ��Ӱ�����͹���
	 * @return
	 * @throws Exception 
	 */
	public String delRelationByProductID(Transaction Sqlca) throws Exception{
		//��Ʒ��Ӱ�����͹���
		SqlObject sql = new SqlObject("DELETE FROM ECM_PRDIMAGE_RELA " +
				" WHERE ProductID = :ProductID ").setParameter("ProductID", this.productID);
		Sqlca.executeSQL( sql );
		return "true";
	}
	
	public String getRelaValues() {
		return relaValues;
	}
	public void setRelaValues(String relaValues) {
		this.relaValues = relaValues;
	}
	public String getProductID() {
		return productID;
	}
	public void setProductID(String productID) {
		this.productID = productID;
	}
	public String getImageTypeNo() {
		return imageTypeNo;
	}
	public void setImageTypeNo(String imageTypeNo) {
		this.imageTypeNo = imageTypeNo;
	}
}

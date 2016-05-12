package com.amarsoft.app.als.image;

import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 影像类型对产品的关联
 * @author jqcao
 *
 */
public class ManagePRDImageRela {

	//定义变量
	private String imageTypeNo; //影像类型编号
	private String productID; //产品编号
	private String relaValues=""; //关联影像类型序列
	
	
	/**
	 * 增加产品与影像类型关联
	 * @return
	 * @throws Exception 
	 */
	public String addRelation(Transaction Sqlca) throws Exception{
		//产品与影像类型关联
		SqlObject asql = new SqlObject("DELETE FROM ECM_PRDIMAGE_RELA WHERE ProductID Like :ProductID").setParameter("ProductID", productID+"%");
		Sqlca.executeSQL(asql);
		
		if( relaValues != null ){
			//再将新关联关系插入
			String[] sTypeNos = relaValues.split("@");
			for( int i=0; i<sTypeNos.length; i++ ){
				if( StringX.isSpace( sTypeNos[i] ) ) continue; //有空字符串时不处理
				Sqlca.executeSQL( new SqlObject("INSERT INTO ECM_PRDIMAGE_RELA(ProductID,ImageTypeNo) " +
						"SELECT TypeNo, :ImageTypeNo FROM BUSINESS_TYPE Where TypeNo like :ProductID ").setParameter("ProductID", productID+"%").setParameter("ImageTypeNo", sTypeNos[i]) );
			}
		}
		return "true";
	}
	
	/**
	 * 删除产品与影像类型关联
	 * @return
	 * @throws Exception 
	 */
	public String delRelationByImageTypeNo(Transaction Sqlca) throws Exception{
		//产品与影像类型关联
		SqlObject sql = new SqlObject("DELETE FROM ECM_PRDIMAGE_RELA " +
				" WHERE ImageTypeNo = :ImageTypeNo ").setParameter("ImageTypeNo", this.imageTypeNo);
		Sqlca.executeSQL( sql );
		return "true";
	}
	
	/**
	 * 删除产品与影像类型关联
	 * @return
	 * @throws Exception 
	 */
	public String delRelationByProductID(Transaction Sqlca) throws Exception{
		//产品与影像类型关联
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

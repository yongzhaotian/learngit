package com.amarsoft.app.als.image;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GetUploadCity {
	
	public String productTypeID = "";
	
	public String getProductTypeID() {
		return productTypeID;
	}
	public void setProductTypeID(String productTypeID) {
		this.productTypeID = productTypeID;
	}
	
	public String getUploadCityStr(Transaction Sqlca){
		// 获取当前客户录入合同门店所在城市名称
		String uploadCityStr = "";
		ASResultSet tmpRs = null;
		try{
			String sSql = "";
			sSql = "Select uploadCity, uploadCity2, uploadCity3, uploadCity4, uploadCity5, uploadCity6 from product_ecm_upload where product_type_id = '"+productTypeID+"'";
			ASResultSet resultSet = Sqlca.getASResultSet(new SqlObject(sSql));
			StringBuffer strBuffer = new StringBuffer();
			while(resultSet.next()){
				strBuffer.append(resultSet.getString("uploadCity")==null?"":resultSet.getString("uploadCity")).append(resultSet.getString("uploadCity2")==null?"":resultSet.getString("uploadCity2")).append(resultSet.getString("uploadCity3")==null?"":resultSet.getString("uploadCity3")).append(resultSet.getString("uploadCity4")==null?"":resultSet.getString("uploadCity4")).append(resultSet.getString("uploadCity5")==null?"":resultSet.getString("uploadCity5")).append(resultSet.getString("uploadCity6")==null?"":resultSet.getString("uploadCity6"));
			}
			return strBuffer.toString();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(null != tmpRs){
				try {
					tmpRs.getStatement().close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return uploadCityStr;
	}
}

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCarInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��ȡ�����ͺŴ���
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo==null) sObjectNo="";
		System.out.println("======================"+sObjectNo);
		
		String sReturn = "" ;//ƴ�ӷ���ֵ
		String sModelsBrand="",sCarDescription="",sModelsSeries="",sPrice="",sBodyType="",sEngineSize="",sSalesstartTime="",sColor="";
		ASResultSet rs = null;
		SqlObject so ;
		String sSql = " select distinct ModelsBrand,CarDescription,ModelsSeries,Price,BodyType,EngineSize,SalesstartTime,Color from Car_Model_Info where CarModelCode =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		//sCustomerID = Sqlca.getString(so);//����һ��ֵʱ��
		rs = Sqlca.getASResultSet(so);//����һ�������
		
		if (rs.next()) 
		{			
			sModelsBrand = rs.getString("ModelsBrand");	
			sCarDescription = rs.getString("CarDescription");
			sModelsSeries = rs.getString("ModelsSeries");
			sPrice = rs.getString("Price");
			sBodyType = rs.getString("BodyType");
			sEngineSize = rs.getString("EngineSize");
			sSalesstartTime = rs.getString("SalesstartTime");
			sColor = rs.getString("Color");
			
			
			if(sModelsBrand == null) sModelsBrand = "";
			if(sCarDescription == null) sCarDescription = "";
			if(sModelsSeries == null) sModelsSeries = "";
			if(sPrice == null) sPrice = "";
			if(sBodyType == null) sBodyType = "";
			if(sEngineSize == null) sEngineSize = "";
			if(sSalesstartTime == null) sSalesstartTime = "";
			if(sColor == null) sColor = "";
			
		}
		rs.getStatement().close();
		
		sReturn=sModelsBrand+"@"+sCarDescription+"@"+sModelsSeries+"@"+sPrice+"@"+sBodyType+"@"+sEngineSize+"@"+sSalesstartTime+"@"+sColor;
		
		return sReturn;
		
	}


}

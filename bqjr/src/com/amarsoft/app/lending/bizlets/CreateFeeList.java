package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.util.ArrayList;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CreateFeeList extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sBusinessType = (String)this.getAttribute("BusinessType");//��Ʒ����
		String dobjectType = (String)this.getAttribute("ObjectType");//��������
		String objectNo = (String)this.getAttribute("ObjectNo");//���ݱ��
		String userID = (String)this.getAttribute("UserID");//�����û�
		String sCreditCycle = (String)this.getAttribute("CreditCycle");//�Ƿ�Ͷ�� 1���� 2����
		//String feeTermID = (String)this.getAttribute("FeeTermID");//���״���
		String dObjectType = "";
		String objectType = "";
		BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(dobjectType, objectNo,Sqlca);
		if(businessObject != null){				
			objectType = businessObject.getObjectType();//��ȡ��������
		}else{
			throw new Exception("����"+dobjectType+".+"+objectNo+"�������ڣ�");
		}

		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		BusinessObject relativeObject=null;
		if(objectNo.length()>0&&objectType.length()>0){
			relativeObject = bom.loadObjectWithKey(objectType, objectNo);
			if(relativeObject==null) throw new Exception("δ�ҵ�����{"+objectType+"-"+objectNo+"}");
		}
		else{
			 throw new Exception("δ����������ͺͶ�����!");
		}
		
		String sSql="";
		ASResultSet rs = null;
		String sTermID = "";
		
		deleteFeeList(objectType,objectNo,Sqlca);
		
		sSql = "SELECT TermID FROM product_term_library where SetFlag in ('SET', 'BAS') "+
				"and TermType = 'FEE' and ObjectType = 'Product' and status = '1' "+
				"and ObjectNo = '"+sBusinessType+"-V1.0"+"' "+
				"and (termid in (select termid from product_term_library where sortno is null) "+
				"or termid in (select termid from product_term_library where sortno is not null "+
                "and subtermtype not in ('A9','A10') "+
                "and to_date(to_char(sysdate, 'yyyy/MM/dd'), 'yyyy/mm/dd') between "+
                "to_date(activedate, 'yyyy/MM/dd') and "+
                "to_date(closedate, 'yyyy/MM/dd'))) ";
		
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		ArrayList<String> termIDList = new ArrayList<String>();
		
		while(rs.next()){
		 	termIDList.add(rs.getString("TermID"));
		}
		rs.getStatement().close();
		
		for(int i=0;i<termIDList.size();i++){
			 sTermID = termIDList.get(i);
			 BusinessObject fee = FeeFunctions.createFee(sTermID, relativeObject,bom);
			 bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, fee);
			 bom.updateDB();
		}
		
		return "ture";
		//return fee.getString("SerialNo");
	}

	private void deleteFeeList(String objectType, String objectNo, Transaction Sqlca) throws Exception {
		String sSql="";
		ASResultSet rs = null;
		String sSerialNo = "";
		sSql="select SerialNo from ACCT_FEE where objecttype='"+objectType+"' and objectno='"+objectNo+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		ArrayList<String> feeSerialnoList = new ArrayList<String>();
		while(rs.next()){
			feeSerialnoList.add(rs.getString("SerialNo"));
		}
		rs.getStatement().close();
		for(int i=0;i<feeSerialnoList.size();i++){
			sSerialNo = feeSerialnoList.get(i);
			sSql = "delete from acct_fee where serialno='"+sSerialNo+"' ";
			Sqlca.executeSQL(sSql);
		}
	
	}
}


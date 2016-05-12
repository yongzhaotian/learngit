package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class InsertFeeWaive extends Bizlet{
	
	public Object  run(Transaction Sqlca) throws Exception{
		
		//�Զ���ô���Ĳ���ֵ
		String sUserID = (String)this.getAttribute("UserID");
		String sBusinessType = (String)this.getAttribute("BusinessType");//��Ʒ����
		String objectType = (String)this.getAttribute("ObjectType");//��������
		String objectNo = (String)this.getAttribute("ObjectNo");//���ݱ��
		
		//DBKeyHelp
		//�������
		ASResultSet rs = null;
		String sSql = "";
		String insertSql = "";
		String waiveSerialno="";
		String waivefromstage="";
		String waivetostage="";
		String costreductiontype="";
		SqlObject so; //��������
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
				
		//ȡ�ú�ͬ�����ķ�����Ϣ
		sSql = "select serialno,feetype,feetermid from acct_fee where objectno =:objectNo";		
		so = new SqlObject(sSql).setParameter("objectNo", objectNo);
		rs = Sqlca.getResultSet(so);
		
		//ɾ���ú�ͬ��ǰ������ļ�����Ϣ
		String deleteSql = "DELETE FROM acct_fee_waive where objectno in (select serialno from acct_fee where objectno = :objectNo) ";
		so = new SqlObject(deleteSql);
		so.setParameter("objectNo", objectNo);
		Sqlca.executeSQL(so);
		
		ArrayList<String> feeWaiveList = new ArrayList<String>();
		String feeobject= "";
		
		while(rs.next()){
			String serialno = rs.getString("serialno");
			String feetype = rs.getString("feetype");
			String feetermid = rs.getString("feetermid");
			feeobject +="@"+serialno+","+feetype+","+feetermid;
		}
		rs.close();
		
		//ȡ�ò�Ʒ�����ķ��ü�����Ϣ ��ʼ�ڴΣ�������Σ��������͡���
		sSql = "select serialno from acct_fee_waive where typeno =:sBusinessType";		
		so = new SqlObject(sSql).setParameter("sBusinessType", sBusinessType);
		rs = Sqlca.getResultSet(so);
		ArrayList<String> waiveList = new ArrayList<String>();
		
		while(rs.next()){
			waiveList.add(rs.getString("serialno"));
		}
		rs.close();
		for(int i=0;i<waiveList.size();i++){
			waiveSerialno = waiveList.get(i);
			sSql = "select serialno,waivefromstage,waivetostage,costreductiontype from acct_fee_waive where typeno =:sBusinessType and serialno=:waiveSerialno";		
			so = new SqlObject(sSql).setParameter("sBusinessType", sBusinessType).setParameter("waiveSerialno",	waiveSerialno);		
			rs = Sqlca.getResultSet(so);
			if(rs.next()){ 
				waivefromstage = rs.getString("waivefromstage");
				waivetostage = rs.getString("waivetostage");
				costreductiontype = rs.getString("costreductiontype");
			}

			rs.getStatement().close();	
			
			String WaiveFromDate = "";
			String WaiveToDate = "";
			//DateFunctions.getRelativeDate(sScheduleDate, DateFunctions.TERM_UNIT_MONTH, 1)
			//ArrayList<String> costreTypeList = new ArrayList<String>();
			
			String[] costreductiontypes=costreductiontype.split(",");
			for(int j=0;j<costreductiontypes.length;j++){
				String costtypes = costreductiontypes[j];
				String feeType = "";
				if(costtypes.equals("3")){//ӡ��˰
					feeType="A11";
				}else if(costtypes.equals("4")){//���շ�
					feeType="A12";
				}else if(costtypes.equals("6")){//�²�����ʷ�
					feeType="A7";
				}else if(costtypes.equals("7")){//�¿ͻ������
					feeType="A2";
				}
				String[] feeobjectsub = feeobject.substring(feeobject.indexOf("@")+1).trim().split("@");
				
				for(String feeobject_type:feeobjectsub){
					String[] rules = feeobject_type.split(",");
					String feeserialno_object = rules[0];
					String feetype_object = rules[1];
					if(feetype_object.equals(feeType)){						
						insertSql = "insert into acct_fee_waive (serialno,objecttype,objectno,status,waivefromstage,waivetostage,waivetype,inputtime,COSTREDUCTIONTYPE)" +
								"  values(:serialno,'jbo.app.ACCT_FEE',:objectno,'1',:waivefromstage,:waivetostage,'0',:inputtime,:COSTREDUCTIONTYPE) ";
						so = new SqlObject(insertSql);
						so.setParameter("serialno", DBKeyHelp.getSerialNo("acct_fee_waive","SerialNo",Sqlca)).setParameter("objectno", feeserialno_object).setParameter("waivefromstage",waivefromstage )
						.setParameter("waivetostage",waivetostage).setParameter("inputtime", StringFunction.getToday()).setParameter("COSTREDUCTIONTYPE", feeType);
						//ִ�и������
						Sqlca.executeSQL(so);
						
					}
					
				}
				
			}
			 
		}
		
		return "success";
	}
	
}

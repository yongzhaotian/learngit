package com.amarsoft.app.bizmethod;

import java.util.ArrayList;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SelectRecordData extends Bizlet {

	private String sReturnStatus="";

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		String sSerialNo = (String) this.getAttribute("SerialNo");
		String sSql1 = "";
		String sNowQualityGrade="";//当前状态下的质量等级
		String sSql2 = "";
		String sSql3 = "";
		String sSql4 = "";
		int i = 0;
		int j = 0;
		int t = 0;
		ASResultSet rs = null;
		ASResultSet rs1 = null;
		ASResultSet rs2 = null;
		ASResultSet rs3 = null;
		String a = "";
		String b = "";
		String sUpdateQualityGrade = null;
		String count = Sqlca.getString("select count(*) from quality_grade where artificialNo='"+sSerialNo+"' and qualityGrade=1");
		String count1 = Sqlca.getString("select count(*) from quality_grade where artificialNo='"+sSerialNo+"' and qualityGrade=2");
		sSql2 = "select  SerialNo  "
				+ " from Quality_Grade WHERE ARTIFICIALNO='" + sSerialNo
				+ "' and QualityGrade='1'";
		sSql3 = "select  SerialNo "
				+ " from Quality_Grade WHERE ARTIFICIALNO='" + sSerialNo
				+ "' and QualityGrade='2'";
		sSql4 = "select SerialNo "
				+ " from Quality_Grade WHERE ARTIFICIALNO='" + sSerialNo
				+ "' and QualityGrade='3'";
		//rs = Sqlca.getASResultSet(new SqlObject(sSql1));
		//System.out.println("sSql2="+sSql1);
		System.out.println("sSql2="+sSql2);
		System.out.println("sSql3="+sSql3);	
			if(!count.equals("0")){
				sNowQualityGrade="关键错误";
			}else if(!count1.equals("0")){
				sNowQualityGrade="非关键错误";
			}else{
				sNowQualityGrade="合格";
			}
			//System.out.println("########sUpdateQualityGrade="+sUpdateQualityGrade);
			if (sNowQualityGrade.equals("关键错误")) {

				i++;
			} else if (sNowQualityGrade.equals("非关键错误")) {

				j++;

			} else {
				t++;
			}

		
		System.out.println("@@@@@i="+i);
		System.out.println("%%%%%j="+j);
		System.out.println("*****t="+t);
		if (i > 0) {
			//System.out.println();
			rs1=Sqlca.getASResultSet(new SqlObject(sSql2));
			while (rs1.next()) {
				
				
				 sReturnStatus += rs1.getString("SerialNo")+"@"	;
				 
				
			}
			
		}else if(i==0 && j>0){
			rs2=Sqlca.getASResultSet(new SqlObject(sSql3));
			while (rs2.next()) {
				sReturnStatus += rs2.getString("SerialNo")+"@"	;
				 
			}
			
		}else{
			rs3=Sqlca.getASResultSet(new SqlObject(sSql4));
			while (rs3.next()) {
				sReturnStatus += rs3.getString("SerialNo")+"@"	;
				
			}
			
		
		}
		System.out.println(sReturnStatus);
		 return sReturnStatus;
		
	}
	
	
}

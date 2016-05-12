package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateLawCaseInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
        //hxli 2005-8-5  
	 	//自动获得传入的参数值
		ASResultSet rs = null;
		SqlObject so;
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sBookType   = (String)this.getAttribute("BookType");
		String ssDate   = (String)this.getAttribute("sDate");
		//定义变量
		String sCasePhase = "";
		String sCaseStatus = "";
		String sCourtStatus = "";
		String sCognizanceResult = "";
		String pCognizanceResult = "";
		String pIntoEffectDate = "";
		String pCasePhase = "";
		String pCaseStatus = "";
		String pCourtStatus = "";
		String sSql = "";
		//更具参数获取需要的值
		//从案件信息表中选择案件所属阶段、案件当前诉讼进程、受理结果、受理法院

		sSql= " select CasePhase,CaseStatus,CourtStatus,CognizanceResult from LAWCASE_INFO"+
		  	" where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getResultSet(so);
	    if(rs.next())
	    {
	    	sCasePhase = rs.getString("CasePhase");
	    	sCaseStatus = rs.getString("CaseStatus");
	    	sCourtStatus = rs.getString("CourtStatus");
	    	sCognizanceResult = rs.getString("CognizanceResult");
	    }
	    
	    rs.getStatement().close();
	    
	    //判断台帐信息表中是否由满足条件的记录 
	    int ICount = 0;
	    sSql= " select count(*) from LAWCASE_BOOK"+
			  " where ObjectNo =:ObjectNo and BookType =:BookType "+
			  " and AppDate in(select max(AppDate) from LAWCASE_BOOK "+
			  " where ObjectNo=:ObjectNo and BookType =:BookType )";
	    so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("BookType", sBookType).setParameter("ObjectNo", sObjectNo)
	    .setParameter("BookType", sBookType);
	    rs = Sqlca.getResultSet(so);
	    if(rs.next())
	    {
	    	ICount = rs.getInt(1);
	    }
	    
	    rs.getStatement().close();
	    
	    //如果有满足条件的多条记录、则选出满足条件为申请日期最大的数据信息 
	    if(ICount>0)
	    {
	    	sSql= " select nvl(CognizanceResult,'') as CognizanceResult,nvl(IntoEffectDate,'') as IntoEffectDate,"+
  		  		  " nvl(AcceptedCourt,'') as AcceptedCourt from LAWCASE_BOOK"+
				  " where ObjectNo =:ObjectNo1 and BookType =:BookType1"+
				  " and AppDate in (select max(AppDate) from LAWCASE_BOOK where ObjectNo=:ObjectNo and BookType =:BookType)";
	    		so = new SqlObject(sSql).setParameter("ObjectNo1", sObjectNo).setParameter("BookType1", sBookType).setParameter("ObjectNo", sObjectNo)
	    		.setParameter("BookType", sBookType);
	    	rs = Sqlca.getResultSet(so);
		    if(rs.next())
		    {
		    	pCognizanceResult = rs.getString("CognizanceResult");
		    	pIntoEffectDate = rs.getString("IntoEffectDate");
		    	pCourtStatus = rs.getString("AcceptedCourt");
		    }
		    
		    rs.getStatement().close();
	    }
	    if(pIntoEffectDate==null) pIntoEffectDate = "";
	    //如果为支付令台帐，则案件属于诉前阶段、但不属于任何诉讼进程 
	    if(sBookType.equals("010")) 
	    {
	    	pCasePhase="010"; 
		    pCaseStatus=sBookType; 	    	
	    }
	    //如果为诉前保全台帐，则案件属于诉前阶段
	    if(sBookType.equals("020")) 
	    {
	    	pCasePhase="010"; 
	    	pCaseStatus=sBookType; 	    	
	    }
	    //如果为诉讼保全台帐，则案件属于诉讼中阶段 
	    if(sBookType.equals("026")) 
	    {
	    	pCasePhase="020"; 
	    }
	    //如果为立案台帐，则案件属于诉讼中阶段 
	    if(sBookType.equals("030")) 
	    {
	    	pCasePhase="020"; 
	    	pCaseStatus=sBookType; 	    	
	    }
	    //如果为一审、二审、再审台帐，则案件属于诉讼中阶段 
	    if((sBookType.equals("040") || sBookType.equals("050") || sBookType.equals("060")) &&  ssDate.compareTo(pIntoEffectDate)>=0 && !pIntoEffectDate.equals(""))
	    {
	    	pCasePhase="025"; 
	    	pCaseStatus=sBookType; 	 
	    }
	    else
	    {
	    	pCasePhase="020"; 
	    	pCaseStatus=sBookType; 
	    }
	    //如果为执行、破产台帐，则案件属于执行中阶段 
	    if(sBookType.equals("070") || sBookType.equals("080")) 
	    {
	    	pCasePhase="030"; 
	    	pCaseStatus=sBookType; 	    	
	    }
	    //如果为公证台帐，则案件属于诉前阶段
	    if(sBookType.equals("065"))
	    {
	    	pCasePhase="010"; 
	    	pCaseStatus=sBookType; 
	    }
	    //如果为仲裁台帐，则案件属于诉讼中阶段 
	    if(sBookType.equals("068"))
	    {
	    	pCasePhase="020"; 
	    	pCaseStatus=sBookType; 
	    }
	    
	    
	    	    
        //如果案件原诉讼进程在案件新进程之前， 则更新案件诉讼进程   
	    //pCaseStatus=pCaseStatus.substring(1,4);
	    if(sCaseStatus==null || sCaseStatus.equals("")) sCaseStatus="000";
	    
	    if(Integer.parseInt(sCaseStatus)<=Integer.parseInt(pCaseStatus))
	    {
	    	sSql=" update LAWCASE_INFO set CaseStatus=:CaseStatus,"+
		         " OldCourtStatus=:OldCourtStatus,"+
		         " CourtStatus=:CourtStatus,"+
		         " OldCaseStatus=:OldCaseStatus,"+
		         " OldCognizeResult=:OldCognizeResult,"+
		         " CognizanceResult=:CognizanceResult where SerialNo=:SerialNo";
	    	so = new SqlObject(sSql).setParameter("CaseStatus", pCaseStatus).setParameter("OldCourtStatus", sCourtStatus)
	    	.setParameter("CourtStatus", pCourtStatus).setParameter("OldCaseStatus", sCaseStatus).setParameter("OldCognizeResult", sCognizanceResult)
	    	.setParameter("CognizanceResult", pCognizanceResult).setParameter("SerialNo", sObjectNo);
	    	Sqlca.executeSQL(so);
	    }
	    
        //如果案件阶段发生变化，则更新案件的阶段 
	    //if(sCasePhase<=pCasePhase)
	   	if(Integer.parseInt(sCasePhase)<=Integer.parseInt(pCasePhase))
	    {
	   		sSql=" update LAWCASE_INFO set CasePhase=:CasePhase,"+
		         " OldCasePhase=:OldCasePhase"+
		         " where SerialNo=:SerialNo";
	   		so = new SqlObject(sSql).setParameter("CasePhase", pCasePhase).setParameter("OldCasePhase", sCasePhase)
	   		.setParameter("SerialNo", sObjectNo);
	   		Sqlca.executeSQL(so);
	    }
	    //如果原案件阶段为待执行阶段，而更新后阶段为诉讼中，则更新案件的阶段
	    if(sCasePhase.equals("025") && pCasePhase.equals("020"))
	    {
	    	sSql=" update LAWCASE_INFO set CasePhase=:CasePhase,OldCasePhase=:OldCasePhase,"+
   		 		 " CaseStatus=:CaseStatus,"+
		         " OldCourtStatus=:OldCourtStatus,"+
		         " CourtStatus=:CourtStatus,"+
		         " OldCaseStatus=:OldCaseStatus,"+
		         " OldCognizeResult=:OldCognizeResult,"+
		         " CognizanceResult=:CognizanceResult where SerialNo=:SerialNo";
	    	so = new SqlObject(sSql).setParameter("CasePhase", pCasePhase).setParameter("OldCasePhase", sCasePhase)
	    	.setParameter("CaseStatus", pCaseStatus).setParameter("OldCourtStatus", sCourtStatus)
	    	.setParameter("CourtStatus", pCourtStatus).setParameter("OldCaseStatus", sCaseStatus)
	    	.setParameter("OldCognizeResult", sCognizanceResult).setParameter("CognizanceResult", pCognizanceResult)
	    	.setParameter("SerialNo", sObjectNo);
	    	Sqlca.executeSQL(so);
	    }

	    
	    return null;
	 }

}

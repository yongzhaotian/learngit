/**
 * Author: --hwang 2009-06-23 21:00            
 * Tester:                               
 * Describe: --取得授信额度子额度余额  
 * Input Param:                          
 * 		LineNo : 子额度所在授信额度额度协议号
 * 		BusinessType : 当前对象(申请、审批、合同)的业务类型       
 * Output Param:                         
 * 		sBalance：
 * 			如果有对应的子额度则返回：可用余额&子额度币种名称&子额度币种
 * 			如果没有则返回:  可用余额  
 * updatesuer:yhshan
 * updatedate:2012/09/11
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class GetCreditSubLineBalance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineNo = (String)this.getAttribute("LineNo");
        String sBusinessType = (String)this.getAttribute("BusinessType");
		
        ASResultSet rs = null;
		String sSql = "";
		String sParentLineID="";//子额度所在额度额度编号
        String sBalance = null;//余额
        String sObjectNo = "";//获取关联主额度的合同流水号
        String sContractNoList = "";//获取关联主额度的合同流水号序列
        String[] sContractNos=null;//合同流水号数组,用于计算每笔合同的敞口
        String sLineCurrency = "";//授信额度币种
        String sCurrency = "";//子额度币种
        String sSubLineBusinessType="";//子额度业务类型
        String sRotative = "";//子额度循环标志。1：可循环，2：不可循环
        String sAssignFlag ="";//是否分配指定业务品种的子额度。false:未分配,true:已分配
        String sPigeonholeDate=null;//完成放贷日期
        String sExposureFlag="";//计算敞口标志。sum:计算敞口金额,balance:计算敞口余额
        double dSubCLOpenBalance = 0.0;//子额度合同敞口余额
    	double dSubCLOpenSum = 0.0;//子额度合同敞口金额
    	double dSubCLContractSum=0.0;//子额度合同金额
    	double dSubCLContractBalance=0.0;//子额度合同余额
    	double dSubCreditLineBalance=0.0;//子额度可用余额
        double dLineSum1=0.0;//子额度授信限额
    	double dLineSum2=0.0;//子额度敞口限额
    	int i = 0;//用于计数
    	int iCount=0;//与子额度业务类型相同的合同数
    	SqlObject so = null;//声明对象
        
    	/***********************第一步：取子额度授信限额,敞口限额,是否循环信息**************************/
    	//取子额度所在额度的额度ID、币种,用于查询子额度授信限额,敞口限额,是否循环信息
    	sSql = "select LineID,Currency from CL_INFO where BCSerialNO =:BCSerialNO ";
    	so = new SqlObject(sSql);
    	so.setParameter("BCSerialNO", sLineNo);
    	rs = Sqlca.getASResultSet(so);
        if(rs.next()){
    		sLineCurrency = rs.getString("Currency");
    		sParentLineID = rs.getString("LineID");
    	}
    	rs.getStatement().close();
    	if(sLineCurrency==null) sLineCurrency="";
        if(sParentLineID == null) throw new Exception("取额度金额错误：没有找到额度.该笔额度的额度协议号为："+sLineNo);
        
        //获取子额度授信限额,敞口限额,是否循环信息,币种、币种名称、转换成额度币种后汇率值
        if(sBusinessType.length() >=4){
        	sSql = "Select nvl(LineSum1,0) as LineSum1,nvl(LineSum2,0) as LineSum2,Currency,Rotative,BusinessType from CL_INFO Where ParentLineID =:ParentLineID  and (BusinessType=:BusinessType1 or BusinessType =:BusinessType2)";
        	so = new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("BusinessType1", sBusinessType).setParameter("BusinessType2", sBusinessType.substring(0,4));
        	rs = Sqlca.getASResultSet(so);
        }else{
        	sSql = "Select nvl(LineSum1,0) as LineSum1,nvl(LineSum2,0)  as LineSum2,Currency,Rotative,BusinessType from CL_INFO Where ParentLineID =:ParentLineID and (BusinessType=:BusinessType)";
        	so = new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("BusinessType", sBusinessType);
        	rs = Sqlca.getASResultSet(so);
        }
    	if(rs.next()){//这里默认认为没有分配业务类型相同的子额度
    		dLineSum1 = rs.getDouble("LineSum1");
    		dLineSum2 = rs.getDouble("LineSum2");
    		sRotative = rs.getString("Rotative");
    		sCurrency = rs.getString("Currency");
    		sSubLineBusinessType=rs.getString("BusinessType");
    	}else{//如果没有分配当前业务类型相同的子额度,将是否分配置为false
    		sAssignFlag="false";
    	}
    	rs.getStatement().close();
    	if(sRotative == null) sRotative="";
    	if(sCurrency == null) sCurrency="";
    	if(sSubLineBusinessType == null) sSubLineBusinessType="";
    	
    	if(!sAssignFlag.equals("false")){//有指定的业务类型子额度
	    	/***********************第二步：取子额度合同金额dSubCLContractSum、合同余额dSubCLContractBalance、合同敞口金额dSubCLOpenSum、合同敞口余额dSubCLOpenBalance**************************/
	    	//获取与子额度业务类型相同及该业务类型子类型的合同流水号,合同数组
    		String sSubLineBusinessType1 = sSubLineBusinessType+"%";
    		sSql = "Select ObjectNo from CREDITLINE_RELA where LineNo=:LineNo and ObjectType='BusinessContract' and BusinessType like :BusinessType ";
    		so = new SqlObject(sSql).setParameter("LineNo", sLineNo).setParameter("BusinessType", sSubLineBusinessType1);
    		sContractNos = Sqlca.getStringArray(so);
	    	iCount = sContractNos.length;
	    	for(i=0;i<iCount;i++){
	    		if(i==0){
	    			sContractNoList+="'"+sContractNos[i]+"'";
	    		}else{
	    			sContractNoList+=",'"+sContractNos[i]+"'";
	    		}
	    	}
	    	if(sContractNoList.length()==0) sContractNoList ="''";
	    	
	    	/******取子额度合同金额dSubCLContractSum、合同余额dSubCLContractBalance***/
	    	//取子额度合同金额总和,合同余额总和(合同余额求法：如果该笔合同已完成放贷，取合同余额；如果该笔合同未完成放贷，取合同金额)
	    	sSql = " select sum(nvl(BusinessSum,0)*getERate1(BusinessCurrency,:BusinessCurrency)) as Sum1,"+
		 		   " sum(case when (PigeonholeDate !=' ' and PigeonholeDate is not null) then nvl(Balance,0)*getERate1(BusinessCurrency,:BusinessCurrency1) "+
		 		   "     else  nvl(BusinessSum,0)*getERate1(BusinessCurrency,:BusinessCurrency2) end) as Balance1 "+
		 		   " from BUSINESS_CONTRACT where SerialNo in("+sContractNoList+")";
	    	so = new SqlObject(sSql).setParameter("BusinessCurrency", sCurrency).setParameter("BusinessCurrency1", sCurrency)
	    	.setParameter("BusinessCurrency2", sCurrency);
    		rs = Sqlca.getASResultSet(so);
	    	while(rs.next()){
	    		dSubCLContractSum = rs.getDouble("Sum1");
	    		dSubCLContractBalance = rs.getDouble("Balance1");
	    	}
	    	rs.getStatement().close();
	    	
	    	/******合同敞口金额dSubCLOpenSum、合同敞口余额dSubCLOpenBalance***/
	    	//取子额度合同敞口金额总和、合同敞口余额余额
	    	Bizlet bzGetExposureBalance = new GetExposureBalance();
	    	//获取子额度的合同敞口余额总和dSubCLOpenBalance
	    	for(i=0;i<iCount;i++)
	    	{
	    		sObjectNo=sContractNos[i];//求每笔合同敞口余额
	    		sSql="select PigeonholeDate from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
	    		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
	    		rs = Sqlca.getASResultSet(so);
	        	if(rs.next()){
	        		sPigeonholeDate = rs.getString("PigeonholeDate");
	        	}
	        	rs.getStatement().close();
	        	if(sPigeonholeDate !=null && sPigeonholeDate.length() !=0){//该笔合同已完成放贷
	        		sExposureFlag="balance";
	        	}else{//没有完成放贷
	        		sExposureFlag="sum";
	        	}
	        	bzGetExposureBalance.setAttribute("Currency",sCurrency);
	    		bzGetExposureBalance.setAttribute("Flag",sExposureFlag);
	    		bzGetExposureBalance.setAttribute("ObjectType","BusinessContract");
	    		bzGetExposureBalance.setAttribute("ObjectNo",sObjectNo);
	    		dSubCLOpenBalance+=Double.valueOf((String)bzGetExposureBalance.run(Sqlca)).doubleValue();//做累加
	    	}
	    	//获取子额度的合同敞口金额总和dSubCLOpenSum
	    	for(i=0;i<iCount;i++)
	    	{
	    		sObjectNo=sContractNos[i];//求每笔合同敞口金额
	    		bzGetExposureBalance.setAttribute("Currency",sCurrency);
	    		bzGetExposureBalance.setAttribute("Flag","sum");
	    		bzGetExposureBalance.setAttribute("ObjectType","BusinessContract");
	    		bzGetExposureBalance.setAttribute("ObjectNo",sObjectNo);
	    		dSubCLOpenSum+=Double.valueOf((String)bzGetExposureBalance.run(Sqlca)).doubleValue();//做累加
	    	}
	    	
	    	/**************************第三步：取子额度实际可用余额************************************/
	    	//获取子额度实际可用余额
	    	if(dLineSum1 ==0 && dLineSum2==0)//如果授信限额,敞口限额均为0,则该子额度可用额度为0.
	    	{
	    		dSubCreditLineBalance = 0.0;
	    	}else{
	    		if(sRotative.equals("1"))//可循环,计算余额
	    		{
	    			if(dLineSum1==0 && dLineSum2>0)//授信限额为0，敞口限额>0
	    			{
	    				dSubCreditLineBalance = dLineSum2-dSubCLOpenBalance;//子额度可用余额=子额度敞口限额-子额度敞口余额;
	    			}else if(dLineSum2==0 && dLineSum1>0)//授信限额>0，敞口限额为0
	    			{
	    				dSubCreditLineBalance = dLineSum1-dSubCLContractBalance;//子额度可用余额=子额度授信限额-子额度合同余额;
	    			}else{//授信限额，敞口限额均>0;对敞口余额，授信余额均做控制，取余额小者。
	    				if((dLineSum2-dSubCLOpenBalance)>=(dLineSum1-dSubCLContractBalance))
	    				{
	    					dSubCreditLineBalance = dLineSum1-dSubCLContractBalance;
	    				}else{
	    					dSubCreditLineBalance = dLineSum2-dSubCLOpenBalance;
	    				}						
	    			}
	    		}else{//不可循环，计算金额
	    			if(dLineSum1==0 && dLineSum2>0)//授信限额为0，敞口限额>0
	    			{
	    				dSubCreditLineBalance = dLineSum2-dSubCLOpenSum;//子额度可用余额=子额度敞口限额-子额度敞口金额;
	    			}else if(dLineSum2==0 && dLineSum1>0)//授信限额>0，敞口限额=0
	    			{
	    				dSubCreditLineBalance = dLineSum1-dSubCLContractSum;//子额度可用余额=子额度授信限额-子额度合同金额;
	    			}else{//授信限额，敞口限额均>0;取敞口限额金额，授信限额金额小者
	    				if((dLineSum2-dSubCLOpenSum)>=(dLineSum1-dSubCLContractSum))
	    				{
	    					dSubCreditLineBalance = dLineSum1-dSubCLContractSum;
	    				}else{
	    					dSubCreditLineBalance = dLineSum2-dSubCLOpenSum;
	    				}						
	    			}
	    		}
	    	}
	    	sBalance = ""+dSubCreditLineBalance+"&"+sCurrency;
    	}else{//没有分配指定业务类型的子额度,将子额度可用余额置为-1
    		dSubCreditLineBalance=-1;
    		sBalance = ""+dSubCreditLineBalance;
    	}
    	sSql = "update CL_INFO set SubBalance =:SubBalance  where BCSerialNO =:BCSerialNO  and BusinessType =:BusinessType ";
    	so = new SqlObject(sSql).setParameter("SubBalance", dSubCreditLineBalance).setParameter("BCSerialNO", sLineNo).setParameter("BusinessType", sBusinessType);
    	Sqlca.executeSQL(so);
        return sBalance;

	}

}

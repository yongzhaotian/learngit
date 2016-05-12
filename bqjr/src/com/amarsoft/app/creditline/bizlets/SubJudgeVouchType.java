/**
 * Author: --jbye 2005-08-31 17:57            
 * Tester:                               
 * Describe: --判断是否符合担保方式限制条件  
 * Input Param:                          
 * 		ObjectType: 对象类型          
 * 		ObjectNo: 对象编号 
 * 		LimitationSetID : 授信限制组ID
 *      LineID : 授信ID
 * Output Param:                         
 * 		sErrorLog：返回错误信息          
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SubJudgeVouchType extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        String sObjectType = (String)this.getAttribute("ObjectType");
        String sLimitationSetID = (String)this.getAttribute("LimitationSetID");
        String sLineID = (String)this.getAttribute("LineID");
		
        if(sObjectNo==null) sObjectNo = "";
        if(sObjectType==null) sObjectType = "";
        if(sLimitationSetID==null) sLimitationSetID = "";
        if(sLineID==null) sLineID = "";
        
        String sRelativeTable = "",sVouchType = "",sLimitationID = "",sSubBalance = "";
		String sSql = "";
        String sErrorLog = "";//返回日志
        double dSubBusinessSum = 0.0,dSubBalance = 0.0;
        ASResultSet rs=null;
        
        //根据对象类型确定对应的业务判断主体
        if(sObjectType.equals("CreditApply"))	sRelativeTable = "BUSINESS_APPLY";
        else if(sObjectType.equals("AgreeApproveApply"))	sRelativeTable = "BUSINESS_APPROVE";
        else if(sObjectType.equals("BusinessContract"))	sRelativeTable = "BUSINESS_CONTRACT";
        
        //判断一：取得当前业务币种、申请敞口金额信息，如果没有表示 该业务币种不属于对应授信范围
        sSql = "select VouchType,(BusinessSum-BailSum)*getERate(BusinessCurrency,'01','') "+
        	 " from "+sRelativeTable+" where  SerialNo=:SerialNo";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
        if(rs.next())
		{ 
        	sVouchType = rs.getString("VouchType");
        	dSubBusinessSum = rs.getDouble(2);
		}else	sErrorLog = "ErrorType=NOFOUND_BUSINESSAPPLY;";
        rs.getStatement().close();
        //判断一结束
        
        //判断二开始：取得对应限制条件的条件ID，判断是否满足余额限制
        sSql = "select LimitationID from CL_LIMITATION where  LimitationSetID=:LimitationSetID " +
        		" and LimObjectNo=:LimObjectNo";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("LimitationSetID", sLimitationSetID).setParameter("LimObjectNo", sVouchType));
        if(rs.next())
        { 
        	sLimitationID = rs.getString("LimitationID");//授信敞口金额
        	//取得对应限制条件的可用余额
            Bizlet SubLineBalance2 = new GetCreditLine2Balance_Sub();
            SubLineBalance2.setAttribute("LimitationID",sLimitationID); 
            SubLineBalance2.setAttribute("LineID",sLineID); 
            SubLineBalance2.setAttribute("WhereClause"," and VouchType like '"+sVouchType+"%'"); 
            sSubBalance = (String)SubLineBalance2.run(Sqlca);
            dSubBalance = DataConvert.toDouble(sSubBalance);
            //如果对象授信金额超过对应限制条件的可用余额则返回 不通过 标志为 ： EX_SUB_VOUCHTYPE
            if(dSubBusinessSum>dSubBalance) sErrorLog = "ErrorType=EX_SUB_VOUCHTYPE;";
       	}else sErrorLog = "ErrorType=EX_SUB_VOUCHTYPE_NF;";
        rs.getStatement().close();
    	
        //判断二结束
        return sErrorLog;

	}

}

/**
 * Author: --hwang 2009-06-23 21:00            
 * Tester:                               
 * Describe: --计算敞口金额/余额
 * Input Param:                          
 * 		Currency: 币种(该对象关联的额度/子额度币种)
 * 		ObjectType : 对象类型(CreditApply,ApproveApply,BusinessContract)		
 * 		ObjectNo : 对象编号(申请流水号,审批流水号,合同流水号)
 * 		Flag:      标志位(sum:计算敞口金额，balance:计算敞口余额，默认计算金额)
 * Output Param:                         
 * 		sBalance：敞口金额/敞口余额          
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class GetExposureBalance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String sCurrency = (String)this.getAttribute("Currency");//币种信息
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sFlag = (String)this.getAttribute("Flag");
		String sSql = "";
		ASResultSet rs = null;//数据集
		double dBalance=0.0;//合同金额/余额
		double dBailSum=0.0;//保证金
		double dAvailableBalance=0.0;//敞口金额/余额
		String sBalance = null;//敞口金额/余额
		
		String sTable="";//相关表
		if(sObjectType.equals("CreditApply")){//对象类型为业务申请,相关表为申请
			sTable="BUSINESS_APPLY";
		}else if(sObjectType.equals("ApproveApply")){//对象类型为业务审批,相关表为审批
			sTable="BUSINESS_APPROVE";
		}else{//默认相关表为合同
			sTable="BUSINESS_CONTRACT";
		}
        
        //如果Flag没有值,默认计算敞口金额
        if(sFlag==null || sFlag.length() ==0) sFlag="sum";
        
        //获取敞口,获取的金额均转换为当前业务关联的额度/子额度金额
        if("balance".equals(sFlag)){
        	sSql = " Select nvl(Balance,0)*getERate1(BusinessCurrency,'"+sCurrency+"') as Balance,nvl(BailSum,0)*getERate1(BailCurrency,'"+sCurrency+"') as BailSum "+
        		   " from "+sTable+" where SerialNo=:SerialNo and (PigeonholeDate !=' ' and PigeonholeDate is not null) ";
        	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
        }else{
        	sSql = " Select nvl(BusinessSum,0)*getERate1(BusinessCurrency,'"+sCurrency+"') as Balance,nvl(BailSum,0)*getERate1(BailCurrency,'"+sCurrency+"') as BailSum "+
			       " from "+sTable+" where SerialNo=:SerialNo ";
        	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
        }
    	while(rs.next()){
    		dBalance=rs.getDouble("Balance");
    		dBailSum=rs.getDouble("BailSum");
    	}
    	rs.getStatement().close();
    	//对敞口金额进行处理,如果得到值<0,则人为设置为0。查询出来再做处理可以优化性能
    	dAvailableBalance = dBalance-dBailSum;
    	if(dBalance<0){
    		dBalance=0.0;
    	}
    	
        sBalance=""+dBalance;
        return sBalance;
	}
}

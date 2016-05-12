package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 *  Description:   该Bizlet，在集团申请认定书管理页面选择好该集团的各集团成员，包括母公司和子公司，后所做的更新字段处理。
 *                 更新在集团关联搜索页面RelationList.jsp中保存逻辑在GROUP_RESULT表中新增的记录，即在该记录中填入本次关
 *                 联搜索后填写的集团母公司ID（最多只有一个母公司，也可能没有母公司）和子公司ID串。<p>
 *         Time:   2009/10/26    
 *       @author   PWang 
 *             
 */
public class SaveGroupRela  extends Bizlet {
	
/**
 *  @param   SerialNo,RelaMaStr,RelaChildStr 
 *  @return 1 成功
 *          2 没有选择子公司,子公司是必填项
 */
	public Object  run(Transaction Sqlca) throws Exception{
		
		//定义传入参数变量：关联搜索记录流水号（表GROUP_RESULT记录的流水号），母公司ID，子公司ID串。
		String sSerialNo   = (String)this.getAttribute("SerialNo");
		String sRelaMaStr   = (String)this.getAttribute("RelaMaStr");
		String sRelaChildStr   = (String)this.getAttribute("RelaChildStr");	
	
		if(sSerialNo == null) sSerialNo = "";
		if(sRelaMaStr == null) sRelaMaStr = "";
		if(sRelaChildStr == null || sRelaChildStr.equals("")) return "2";	
						
		//定义变量		
		String sSql ="";	

		try{
			//已有的记录做更新。
			sSql ="update GROUP_RESULT set RelaMacustid =:RelaMacustid ,RelaChildcustid =:RelaChildcustid where SerialNo =:SerialNo ";
			SqlObject so = new SqlObject(sSql).setParameter("RelaMacustid", sRelaMaStr).setParameter("RelaChildcustid", sRelaChildStr).setParameter("SerialNo", sSerialNo);
			Sqlca.executeSQL(so);
		}
		catch(Exception e){
			ARE.getLog().error(e.getMessage());
			throw new Exception(e);
		}	
		return "1";
		
	}

}

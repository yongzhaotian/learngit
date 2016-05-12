/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: 根据五级分类参数表中配置的分类口径(借据或者合同)来获取借据或者合同的流水号
 *	Input Param:
 *			ObjectType:对象类型
 *			ObjectNo:对象编号
 *	Output Param:
 *	HistoryLog:
 *
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetClassifySerialNo extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception {
		//对象类型:借据BusinessDueBill或者合同BusinessContract
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		SqlObject so=null; //声明对象
		//定义变量：SQL语句
		String sSerialNo = "";
		String sRelativeSerialNo = "";
		String sSql = "";
		String sClassifyType = "";
		//查询配置表中配置的五级分类是用借据还是合同，默认是用借据。
		sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'"; 
		sClassifyType = Sqlca.getString(sSql);
		if(!sClassifyType.equals("BusinessDueBill") && !sClassifyType.equals("BusinessContract")) {
			sClassifyType = "BusinessDueBill";
        }	
		
		//如果五级分类按借据来划分
		if(sClassifyType.equals("BusinessDueBill")){
			//关联对象为借据对象
			if(sObjectType.equals("BusinessDueBill")){
				//根据申请流水号获得借据流水号
				 sSql = "select distinct ObjectNo from CLASSIFY_RECORD where SerialNo =:SerialNo ";
				 so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
				 sSerialNo =  Sqlca.getString(so); 
			}
			
			//关联对象为合同对象
			if(sObjectType.equals("BusinessContract")){
				//根据申请流水号获得借据流水号
				so = new SqlObject("select distinct ObjectNo from CLASSIFY_RECORD where SerialNo =:SerialNo ").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo =  Sqlca.getString(so);
				//根据借据流水号获得合同流水号
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
		
		//如果五级分类按照合同来划分
		if(sClassifyType.equals("BusinessContract")){
			//关联对象为合同据对象
			if(sObjectType.equals("BusinessContract")){
				//根据申请流水号获得合同流水号
				so = new SqlObject("select distinct ObjectNo from CLASSIFY_RECORD where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}//如果关联对象为借据
			if(sObjectType.equals("BusinessDueBill")){
				throw new Exception("五级分类按照合同进行，不能展示借据信息！");
			}
		}
		return sSerialNo;
	}
}
package com.amarsoft.app.accounting.util.expression.functions;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.util.expression.FunctionManager;
import com.amarsoft.app.accounting.util.expression.IFunction;
import com.amarsoft.are.util.ASValuePool;

public class GetRelativeAccount implements IFunction{
	
	private BusinessObject transaction;
	
	//设置参数
	public void setObjectPara(String objectName,Object object){
		this.transaction = (BusinessObject) object;
	}

	/**
	 * 返回该交易涉及的账户信息
	 * 格式为：
	 *  账号@账户名@账户机构@账户币种@账户类型@账户标示#账号@账户名@账户机构@账户币种@账户类型@账户标示#……
	 */
	public String run(ASValuePool functionDef, String paras) throws Exception {
		List[] paraList = FunctionManager.parseParas(paras);
		List paraValue = paraList[1];
		if(paraValue.size() != 3) throw new Exception("传入参数不正确，请重新传入！");
		
		String value = "";
		/**传入参数结构：参数一,参数二,参数三
		 * 参数一、交易处理核算对象类型
		 * 参数二、需要从交易单据中获取那些数据字段信息，排序及写法为：账号@账户名@账户机构@账户币种@账户类型@账户标示
		 * 参数三、需要从关联账户信息表中获取数据的条件，写法为：字段1@值1 例如 AccountIndicator@01 表示只取AccountIndicator=01的记录
		*/ 
		//获取单据中账户信息
		String objectType=(String)paraValue.get(0);//核算对象类型
		String fields=(String)paraValue.get(1);//获取单据账户数据
		if(fields != null && !"".equals(fields))
		{
			BusinessObject document = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
			StringTokenizer st = new StringTokenizer(fields,"@");
			String[] fieldArray = new String[st.countTokens()];
			int l = 0;
			while (st.hasMoreTokens()) {
				fieldArray[l] = st.nextToken();                
				l ++;
			}
			boolean flag = false;
			for(String field : fieldArray)
			{
				String fieldValue = document.getString(field);
				if(fieldValue!=null && !"".equals(fieldValue)) flag = true;
				if(fieldValue == null) fieldValue = "";
				fields = fields.replaceAll(field, fieldValue);
			}
			
			if(flag){
				value += fields+"#";
			}
		}
		//获取关联账户信息
		BusinessObject businessObject=null;
		ArrayList<BusinessObject> relativeObjectList = transaction.getRelativeObjects(objectType);
		if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
			if(relativeObjectList.size()==1){
				businessObject=relativeObjectList.get(0);
			}
			else{
				throw new Exception("找到多个核算业务对象{"+objectType+"}，此写法有问题！");
			}
		}
		else throw new Exception("未找到核算业务对象{"+objectType+"}");
		
		ArrayList<BusinessObject> accountList = null;
		//筛选条件
		String fiters=(String)paraValue.get(2);
		if(fiters == null || "".equals(fiters))
			accountList = businessObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		else
		{
			ASValuePool as = new ASValuePool();
			StringTokenizer st = new StringTokenizer(fiters,"@");
			String[] fiterArray = new String[st.countTokens()];
			int l = 0;
			while (st.hasMoreTokens()) {
				fiterArray[l] = st.nextToken();                
				l ++;
			}
			if(fiterArray.length%2 != 0 ) throw new Exception("表达式中筛选条件不完整或录入不对！");
			for(int i = 0; i < fiterArray.length; i +=2)
			{
				as.setAttribute(fiterArray[i], fiterArray[i+1]);
			}
			accountList = businessObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts,as); 
		}
		if(accountList!=null&&!accountList.isEmpty()){
			for(BusinessObject account:accountList)
			{
				value += account.getString("AccountNo")+"@"+account.getString("AccountName")+"@"+account.getString("AccountOrgID")+"@"+account.getString("AccountCurrency")+"@"+account.getString("AccountType")+"@"+account.getString("AccountFlag")+"#";
			}
		}
		
		if(value.length() > 0) value = value.substring(0,value.length()-1);
		
		return value;
	}
}

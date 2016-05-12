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
	
	//���ò���
	public void setObjectPara(String objectName,Object object){
		this.transaction = (BusinessObject) object;
	}

	/**
	 * ���ظý����漰���˻���Ϣ
	 * ��ʽΪ��
	 *  �˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ#�˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ#����
	 */
	public String run(ASValuePool functionDef, String paras) throws Exception {
		List[] paraList = FunctionManager.parseParas(paras);
		List paraValue = paraList[1];
		if(paraValue.size() != 3) throw new Exception("�����������ȷ�������´��룡");
		
		String value = "";
		/**��������ṹ������һ,������,������
		 * ����һ�����״�������������
		 * ����������Ҫ�ӽ��׵����л�ȡ��Щ�����ֶ���Ϣ������д��Ϊ���˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ
		 * ����������Ҫ�ӹ����˻���Ϣ���л�ȡ���ݵ�������д��Ϊ���ֶ�1@ֵ1 ���� AccountIndicator@01 ��ʾֻȡAccountIndicator=01�ļ�¼
		*/ 
		//��ȡ�������˻���Ϣ
		String objectType=(String)paraValue.get(0);//�����������
		String fields=(String)paraValue.get(1);//��ȡ�����˻�����
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
		//��ȡ�����˻���Ϣ
		BusinessObject businessObject=null;
		ArrayList<BusinessObject> relativeObjectList = transaction.getRelativeObjects(objectType);
		if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
			if(relativeObjectList.size()==1){
				businessObject=relativeObjectList.get(0);
			}
			else{
				throw new Exception("�ҵ��������ҵ�����{"+objectType+"}����д�������⣡");
			}
		}
		else throw new Exception("δ�ҵ�����ҵ�����{"+objectType+"}");
		
		ArrayList<BusinessObject> accountList = null;
		//ɸѡ����
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
			if(fiterArray.length%2 != 0 ) throw new Exception("���ʽ��ɸѡ������������¼�벻�ԣ�");
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

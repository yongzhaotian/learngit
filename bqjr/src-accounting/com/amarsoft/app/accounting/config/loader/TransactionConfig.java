package com.amarsoft.app.accounting.config.loader;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.CommonTransaction;
import com.amarsoft.app.accounting.util.expression.FunctionManager;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.xml.Attribute;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class TransactionConfig extends AbstractCache{
	private static ASValuePool transactionDefSet;//���׶��弯��
	private static Document transaction_document;
	private static Document function_document;
	
	/**
	 * ��ȡ���׵ķ�¼ģ���б�
	 * @param transCode
	 * @return
	 * @throws Exception
	 */
	public static ArrayList<ASValuePool> getDetailTemplete(String transCode) throws Exception {
		ASValuePool transactionDef = TransactionConfig.getTransactionDef(transCode);
		return (ArrayList<ASValuePool>)transactionDef.getAttribute("DetailTemplete");
	}
	
	public static ASValuePool getTransactionDef(String transactionCode) throws Exception{
		ASValuePool transactionDef = (ASValuePool) transactionDefSet.getAttribute(transactionCode);
		if(transactionDef==null) throw new Exception("��ȡ���׶���ʱ����������"+transactionCode+"�����ڣ�");
		return transactionDef;
	}
	
	public static String getTransactionDef(String transactionCode,String attributeID) throws Exception{
		String value = TransactionConfig.getTransactionDef(transactionCode).getString(attributeID);
		if(value==null||value.length()==0){
			Element e = (Element)TransactionConfig.getTransactionDef(transactionCode).getAttribute("XMLDocument");
			value = e.getAttributeValue(attributeID);
		}
		return value;
	}
	
	public static String getScriptAttribute(String transactionCode,String scriptID,String attributeID) throws Exception{
		Element e1 = (Element)TransactionConfig.getTransactionDef(transactionCode).getAttribute("XMLDocument");
		Element e = e1.getChild(scriptID);
		if(e==null) return "";
		String value = e.getAttributeValue(attributeID);
		if(value==null||value.length()==0) value = e.getChildTextTrim(attributeID);
		return value;
	}
	
	private static void regFunctions() throws Exception{
		/**
		 * ��ȡ��������˻���Ϣ��д���μ���
		 * 	'${GetOrgAccount('${jbo.app.ACCT_LOAN.AccountingOrgID}','010','${jbo.app.ACCT_LOAN.Currency}')}'
		 * �˶δ����ʾȡ�Ŵ�����������˻�
		 * ����һ������ҵ������������
		 * ����������ȡ�����������˻����ͣ��μ�����OrgAccountType
		 * ������������ҵ����������
		 */
		FunctionManager.regFunction("GetOrgAccount", "com.amarsoft.app.accounting.config.loader.OrgConfig", "getOrgAccount");
		/**
		 * ��ȡ���������������Ĵ���˻���Ϣ��д���μ���
		 *  '${GetRelativeAccount('jbo.app.ACCT_LOAN','PayAccountNo@PayAccountName@PayAccountOrgID@PayAccountCurrency@PayAccountType@PayAccountFlag','AccountIndicator@01')}'
		 *  �˶δ���ȡ�����������������Ĵ���˻���Ϣ
		 * ����һ�����״�������������
		 * ����������Ҫ�ӽ��׵����л�ȡ��Щ�����ֶ���Ϣ������д��Ϊ���˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ
		 * ����������Ҫ�ӹ����˻���Ϣ���л�ȡ���ݵ�������д��Ϊ���ֶ�1@ֵ1@�ֶ�2@ֵ2@���� ���� AccountIndicator@01 ��ʾֻȡAccountIndicator=01�ļ�¼
		 */
		FunctionManager.regFunction("GetRelativeAccount", "com.amarsoft.app.accounting.util.expression.functions.GetRelativeAccount");//��ȡ���������˻���Ϣ
		/**
		 * ��ȡ���׹����ĺ�����������ֵ���÷���һ�㲻ʹ�ã��ڱ��ʽ�п�ֱ��д���������棩��д���μ�:'${GetObjectAttribute('jbo.app.ACCT_LOAN','BusinessSum')}'
		 * 	����д��������'${jbo.app.ACCT_LOAN.BusinessSum}'������
		 *  ����һ�����״�������������
		 *  ���������������������������
		 */
		FunctionManager.regFunction("GetObjectAttribute","com.amarsoft.app.accounting.util.expression.functions.GetObjectAttribute");//��ȡ��������
		
		/**
		 * ��ȡ���׹����ĺ������������Ӷ��������ֵ��д���μ��� '${GetRelativeObjectAttribute('jbo.app.ACCT_LOAN','jbo.app.ACCT_DEPOSIT_ACCOUNTS','ACCOUNTNO','ACCOUNTINDICATOR','00')}'
		 *  ����һ�����״�������������
		 *  �������������������Ӷ���
		 *  �������������������Ӷ��������ֶ���
		 *  �����ġ����������ʹ�ã���ʾ�����������Ӷ���ɸѡ�������������ǹ����Ӷ��������ֶΣ���������ֵ
		 */
		FunctionManager.regFunction("GetRelativeObjectAttribute","com.amarsoft.app.accounting.util.expression.functions.GetRelativeObjectAttribute");//��ȡ������������
		/**
		 * ��ȡ���׹����ĺ������������Ӷ���Ľ��ֵ��д���μ��� '${GetBalance('jbo.app.ACCT_LOAN','jbo.app.ACCT_SUBSIDIARY_LEDGER','DebitBalance','AccountCodeNo','LAS10301')}'
		 *  ����һ�����״�������������
		 *  �������������������Ӷ���
		 *  �������������������Ӷ��������ֶ���
		 *  �����ġ����������ʹ�ã���ʾ�����������Ӷ���ɸѡ�������������ǹ����Ӷ��������ֶΣ���������ֵ
		 */
		FunctionManager.regFunction("GetBalance","com.amarsoft.app.accounting.util.expression.functions.GetBalance");//��ȡ������������Ϣ����Ҫ����Էֻ�����Ϣ
		/**
		 * ��ȡ��������֮�������������ȡ������д���μ��� ${GetUpMonths('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  ����һ����ʼ����
		 *  ����������������
		 */
		FunctionManager.regFunction("GetUpMonths","com.amarsoft.app.accounting.config.loader.DateFunctions","getUpMonths");//��ȡ��������֮�������������ȡ����
		/**
		 * ��ȡ��������֮�������������ȡ������д���μ��� ${GetMonths('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  ����һ����ʼ����
		 *  ����������������
		 */
		FunctionManager.regFunction("GetMonths","com.amarsoft.app.accounting.config.loader.DateFunctions","getMonths");//��ȡ��������֮�������������ȡ����
		/**
		 * ��ȡ��������֮���������д���μ��� ${GetDays('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  ����һ����ʼ����
		 *  ����������������
		 */
		FunctionManager.regFunction("GetDays","com.amarsoft.app.accounting.config.loader.DateFunctions","getDays");//��ȡ��������֮�������������ȡ����
		
		
		File f = FileTool.findFile("function_config.xml"); 
		if(f==null) return;
		function_document = new Document(f);
		List l = function_document.getRootElement().getChildren("Function");
		for(Object o:l){
			Element e = (Element)o;
			String functionID = e.getAttributeValue("functionid");
			String className = e.getAttributeValue("class");
			String methodName = e.getAttributeValue("method");
			FunctionManager.regFunction(functionID,className,methodName);//��ȡ��������֮�������������ȡ����
		}
	}
	
	public static ITransactionScript getTransactionSript(String transactionCode,AbstractBusinessObjectManager bom) throws Exception{
		ITransactionScript scriptClass=null;
		ASValuePool transactionDef = TransactionConfig.getTransactionDef(transactionCode);
		String classname=transactionDef.getString("TransactionClass");
		if(classname!=null && !"".equals(classname)){
			Class<?> c = Class.forName(classname);
			scriptClass=((ITransactionScript)c.newInstance());
		}
		else scriptClass = new CommonTransaction();
		scriptClass.setBOManager(bom);
		return scriptClass;
	}


	
	
	public ASValuePool loadConfig(Transaction sqlca) throws Exception {
		return transactionDefSet;
	}
	
	/*
	 * ��ջ������
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}
	

	/*
	 * ���ؽ��ײ���������Ϣ
	 * @see com.amarsoft.dict.als.cache.AbstractCache#load(com.amarsoft.awe.util.Transaction)
	 */
	public synchronized boolean load(Transaction transaction) throws Exception {
		try
		{
			File f=FileTool.findFile("accounting-transaction.xml"); 
			transaction_document = new Document(f);
			
			ASValuePool transactionDefSet = new ASValuePool();
			String sql = " select * from Code_Library where CodeNo = 'T_Transaction_Def' and IsInUse = '1' order by ItemNo";
			ASResultSet rs = transaction.getASResultSet(DataConvert.toString(sql));
			while(rs.next()){
				ASValuePool transactionDef=new ASValuePool();
				String transCode = rs.getString("ItemNo");
				transactionDef.setAttribute("TransCode", transCode);//���ױ��
				transactionDef.setAttribute("TransName",rs.getString("ItemName"));//��������
				transactionDef.setAttribute("FlowNo",rs.getString("BankNo"));//��������
				
				transactionDef.setAttribute("ViewTempletNo", rs.getString("attribute1"));//������ϸ��Ϣģ��
				transactionDef.setAttribute("Type", rs.getString("attribute2"));//��������
				transactionDef.setAttribute("StrikeTransID", rs.getString("attribute3"));//�����ױ��
				transactionDef.setAttribute("JSFile", rs.getString("attribute4"));//java script�ű��ļ�
				transactionDef.setAttribute("ObjectSelector",rs.getString("attribute5"));//ҵ�����ѡ����
				
				List l = transaction_document.getRootElement().getChildren("Accounting-Transaction");
				for(Object o:l){
					Element e = (Element)o;
					if(!transCode.equals(e.getAttributeValue("TransactionCode"))) continue;
					List el = e.getAttributeList();
					for(Object eo:el){
						Attribute a=(Attribute)eo;
						transactionDef.setAttribute(a.getName(),a.getValue());
					}
					transactionDef.setAttribute("XMLDocument", e);
					break;
				}
				
				ArrayList<ASValuePool> detailTemplete = new ArrayList<ASValuePool>();
				transactionDef.setAttribute("DetailTemplete", detailTemplete);
				transactionDefSet.setAttribute(rs.getString("ItemNo"),transactionDef);
			}
			rs.close();
					
			rs = transaction.getASResultSet(" select * from Trans_Entry where Status = '1' order by TransID,SortID ");
			while(rs.next()){
				String transcode=rs.getString("TransID");
				ASValuePool transactionDef =(ASValuePool) transactionDefSet.getAttribute(transcode);
				if(transactionDef==null) continue;
				ArrayList<ASValuePool> detailTempleteList=(ArrayList<ASValuePool>) transactionDef.getAttribute("DetailTemplete");
				ASValuePool businessObject=new ASValuePool();
				businessObject.setAttribute("TransCode",transcode);//������
				businessObject.setAttribute("SortID",rs.getString("SortID"));//˳���
				businessObject.setAttribute("Direction",rs.getString("Direction"));//��������
				businessObject.setAttribute("AccountNoScript",rs.getString("AccountNoScript"));//LAS��Ŀ�ű�
				businessObject.setAttribute("BookType", rs.getString("BookType"));//����
				businessObject.setAttribute("TransFlag",rs.getString("TransFlag"));//˳���
				businessObject.setAttribute("ObjectType",rs.getString("ObjectType"));//����ҵ�������ʱ����
				businessObject.setAttribute("Description",rs.getString("Remark"));
				businessObject.setAttribute("AmtScript",rs.getString("SumScript"));//���ű�
				businessObject.setAttribute("BooleanScript",rs.getString("BooleanScript"));//�Ƿ���Ч
				businessObject.setAttribute("CurrencyScript",rs.getString("CurrencyScript"));//���ֽű�
				businessObject.setAttribute("OrgIDScript",rs.getString("OrgIDScript"));//�����ű�
				businessObject.setAttribute("AdversaryScript",rs.getString("AdversaryScript"));//���׶��֣���Ϊ�˲��ֺ���ϵͳ��Ҫ��ʾ�����˻�����
				businessObject.setAttribute("ExchangeRateScript",rs.getString("ExchangeRateScript"));//���ʱ��ʽ
				
				businessObject.setAttribute("ExBookType", rs.getString("ExBookType"));//����
				//businessObject.setAttribute("GroupID", rs.getString("GroupID"));//���
				
				detailTempleteList.add(businessObject);
			}
			rs.close();
			TransactionConfig.transactionDefSet = transactionDefSet;
			
			regFunctions();
	   return true;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
}

package com.amarsoft.app.accounting.config.loader;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.compare.CompareTools;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class AccountCodeConfig extends AbstractCache{
	public static final String accountcode_type_o = "O"; //�ϻ��׼������
	public static final String accountcode_type_n = "N"; //�»��׼������
	public static final String accountcode_type_c = "C"; //�ͻ���
	public static final String accountcode_type_b = "B"; //���п�Ŀ��
	public static final String accountcode_type_s = "S"; //���ɺ�������
	public static String accountcode_type_las="N";
	public static String accountcode_type_all = "N,C,B,S"; //��ϵͳ���õ����ף�����Ѷ��ŷָ�
	public static final String accountcode_type_norm = "C"; //ϵͳ�ڲ��ö�����ʱ����ʾ�������������Ϊ׼����˸ñ�����ֵ������accountcode_type_all��
	private static ASValuePool accountCodeSet;
	private static ASValuePool accountCataLog;//������뷽��
	private static int serialno=1;//
	
	public static void setAccountCodeType(String accountcodetype){
		AccountCodeConfig.accountcode_type_all=accountcodetype;
	}
	
	/**
	 * ����ҵ���������
	 * @param businessobject
	 * @param balance
	 * @throws Exception
	 */
	public static void setBusinessObjectBalance(BusinessObject businessobject,BusinessObject attributesFilter,double balance) throws Exception{
		ArrayList<BusinessObject> subledgerList=businessobject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		if(subledgerList==null||subledgerList.isEmpty()){
			throw new LoanException("ҵ�����-"+businessobject.getObjectType()+"-"+businessobject.getObjectNo()+"-��δ�ҵ����˻���");
		}
		for(BusinessObject subledger:subledgerList){
			if(!subledger.match(attributesFilter)) continue;
			double subledgerbalance=AccountCodeConfig.getSubledgerBalance(subledger,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
			if(subledgerbalance>=balance){
				AccountCodeConfig.setSubledgerBalance(subledger, balance);
				break;
			}
			else{
				balance=balance-subledgerbalance;
			}
		}
	}
	
	/**
	 * ����ҵ���������
	 * @param businessobject
	 * @param balanceGroup
	 * @param balance
	 * @throws Exception
	 */
	public static void setBusinessObjectBalance(BusinessObject businessobject,String filterID,String filterValue,double balance) throws Exception{
		ASValuePool as = new ASValuePool();
		as.setAttribute(filterID, filterValue);
		BusinessObject attributesFilter = new BusinessObject(as);
		setBusinessObjectBalance(businessobject,attributesFilter,balance);
	}
	
	
	/**
	 * 
	 * @param businessobject
	 * @param balanceGroup
	 * @param flag:1��ǰ��2���ա�3����ĩ��4����ĩ
	 * @return
	 * @throws Exception
	 */
	public static double getBusinessObjectBalance(BusinessObject businessobject,BusinessObject attributesFilter,String flag) throws Exception{
		ArrayList<BusinessObject> subledgerList=businessobject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		return AccountCodeConfig.getBusinessObjectBalance(subledgerList, attributesFilter, flag);
	}
	
	/**
	 * 
	 * @param businessobject
	 * @param filter
	 * @return
	 * @throws Exception
	 */
	public static double getBusinessObjectBalance(BusinessObject businessobject,BusinessObject attributesFilter) throws Exception{
		ArrayList<BusinessObject> subledgerList=businessobject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		String flag = attributesFilter.getString("BalanceFlag");
		if(flag==null||flag.length()==0) flag= ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay;
		return AccountCodeConfig.getBusinessObjectBalance(subledgerList, attributesFilter, flag);
	}
	
	/**
	 * 
	 * @param businessobject
	 * @param balanceGroup
	 * @param flag:1��ǰ��2���ա�3����ĩ��4����ĩ
	 * @return
	 * @throws Exception
	 */
	public static double getBusinessObjectBalance(BusinessObject businessobject,String filterID,String filterValue,String flag) throws Exception{
		ASValuePool as = new ASValuePool();
		as.setAttribute(filterID, filterValue);
		BusinessObject attributesFilter = new BusinessObject(as);
		ArrayList<BusinessObject> subledgerList=businessobject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		return AccountCodeConfig.getBusinessObjectBalance(subledgerList, attributesFilter, flag);
	}
	
	/**
	 * 
	 * @param businessobject
	 * @param balanceGroup
	 * @param flag:1��ǰ��2���ա�3����ĩ��4����ĩ
	 * @return
	 * @throws Exception
	 */
	public static double getBusinessObjectBalance(BusinessObject businessobject,String filter,String flag) throws Exception{
		ASValuePool as = new ASValuePool();
		String[] s=filter.split(",");
		for(int i=0;i<s.length;i++){
			as.setAttribute(s[i], s[i+1]);
			i++;
		}
		BusinessObject attributesFilter = new BusinessObject(as);
		ArrayList<BusinessObject> subledgerList=businessobject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		return AccountCodeConfig.getBusinessObjectBalance(subledgerList, attributesFilter, flag);
	}
	
	/**
	 * 
	 * @param businessobject
	 * @param balanceGroup
	 * @param flag:1��ǰ��2���ա�3����ĩ��4����ĩ
	 * @return
	 * @throws Exception
	 */
	public static double getBusinessObjectBalance(List<BusinessObject> subledgerList,BusinessObject attributesFilter,String flag) throws Exception{
		double balance=0d;
		if(subledgerList==null||subledgerList.isEmpty()){
			return 0d;
			//throw new LoanException("ҵ�����-"+businessobject.objectType+"-��δ�ҵ��������Ϊ"+balanceGroup+"�����˻���");
		}
		String balanceDirection = attributesFilter.getString("BalanceDirection");
		if(balanceDirection==null||balanceDirection.length()==0) balanceDirection="B";
		String bookType = attributesFilter.getString("BookType");
		if(bookType == null || "".equals(bookType)) bookType = AccountCodeConfig.accountcode_type_norm;
		for(BusinessObject subledger:subledgerList){
			if(subledger.match( attributesFilter) && bookType.equals(subledger.getString("BookType"))){
				balance+=AccountCodeConfig.getSubledgerBalance(subledger,balanceDirection,flag);
			}
		}
		return Arith.round(balance,2);
	}
	
	/**
	 * �����˻������Ϣ
	 * @param subsidiaryledger
	 * @param balance
	 * @throws Exception 
	 */
	private static void setSubledgerBalance(BusinessObject subsidiaryledger,double balance) throws Exception{
		String accountcodeno=subsidiaryledger.getString("AccountCodeNo");
		String direction=subsidiaryledger.getString("Direction");
		if(accountcodeno==null||accountcodeno.equals("")) throw new DataException("���˻��ж�Ӧ��ҵ�����δ�ҵ���"+accountcodeno);
		if(direction.equals("D"))  subsidiaryledger.setAttributeValue("DebitBalance", balance);
		else if(direction.equals("C")) subsidiaryledger.setAttributeValue("CreditBalance", balance);
		else if(direction.equals("B")) throw new DataException("����Ϊ˫������˻�������ʹ�ô˷�����");
		else  throw new DataException("���˻���������ȷ��"+direction);
	}
	
	
	 
	/**
	 * ��ȡ�˻������Ϣ
	 * @param subledger
	 * @param balancedirection
	 * @param flag:1��ǰ��2���ա�3����ĩ��4����ĩ
	 * @return
	 * @throws Exception 
	 */
	public static double getSubledgerBalance(BusinessObject subledger,String balancedirection,String flag) throws Exception{
		String accountcodeno=subledger.getString("AccountCodeNo");
		if(accountcodeno==null||accountcodeno.equals("")) return 0d;
		
		double debitAmt=0d,creditAmt=0d;
		if(flag.equals(ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)){
		}
		else if(flag.equals(ACCOUNT_CONSTANTS.Balance_Flag_LastDay)){
			debitAmt=subledger.getDouble("DebitAmtDay");
			creditAmt=subledger.getDouble("CreditAmtDay");
		}
		else if(flag.equals(ACCOUNT_CONSTANTS.Balance_Flag_LastMonth)){
			debitAmt=subledger.getDouble("DebitAmtMonth");
			creditAmt=subledger.getDouble("CreditAmtMonth");
		}
		else if(flag.equals(ACCOUNT_CONSTANTS.Balance_Flag_LastYear)){
			debitAmt=subledger.getDouble("DebitAmtYear");
			creditAmt=subledger.getDouble("CreditAmtYear");
		}
		else  throw new DataException("����ȷ������־��"+flag);
		if(balancedirection==null||balancedirection.length()==0) balancedirection="B";
		
		if(balancedirection.equals("D")) return subledger.getDouble("DebitBalance")-subledger.getDouble("CreditBalance")-(debitAmt-creditAmt);
		else if(balancedirection.equals("C")) return subledger.getDouble("CreditBalance")-subledger.getDouble("DebitBalance")+(debitAmt-creditAmt);
		else if(balancedirection.equals("B")) {
			double b=subledger.getDouble("DebitBalance")-debitAmt-subledger.getDouble("CreditBalance")+creditAmt;
			b=Arith.round(b,2);
			return Math.abs(b);
		}
		else  throw new DataException("���˻���������ȷ��"+balancedirection);
	}
	
	/**
	 * ��ȡ�˻������Ϣ
	 * @param subledger
	 * @param flag:1��ǰ��2���ա�3����ĩ��4����ĩ
	 * @return
	 * @throws Exception 
	 */
	public static double getSubledgerBalance(BusinessObject subledger,String flag) throws Exception{
		String accountcodeno=subledger.getString("AccountCodeNo");
		if(accountcodeno==null||accountcodeno.equals("")) throw new Exception("���˻��ж�Ӧ��ҵ�����Ϊ�գ�"+subledger.getObjectNo());
		String direction=subledger.getString("Direction");
		return AccountCodeConfig.getSubledgerBalance(subledger, direction, flag);
	}
	
	/**
	 * ��ȡָ�����ס��������Ķ�����Ϣ
	 * @param bookType
	 * @param accountCodeNo
	 * @return
	 * @throws Exception
	 */
	public static ASValuePool getAccountCodeDefinition(String bookType,String accountCodeNo) throws Exception{
		ASValuePool accountCodeSetTemp = (ASValuePool) accountCodeSet.getAttribute(bookType);
    	if(accountCodeSetTemp==null) throw new LoanException("δ�ҵ�"+bookType+"��Ŀ�ţ�"+accountCodeNo+"�Ķ���,����Ŀ�Ŀ�ţ�����δ��ʼ����������!");
    	ASValuePool accountCodeDefinition=(ASValuePool) accountCodeSetTemp.getAttribute(accountCodeNo);
    	if(accountCodeDefinition==null) throw new LoanException("δ�ҵ�"+bookType+"��Ŀ�ţ�"+accountCodeNo+"�Ķ���,����Ŀ�Ŀ�ţ�����δ��ʼ����������!");
        return accountCodeDefinition;
	}
	/**
	 * ���ݺ����������ȡ���񷽰���Ϣ
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static ASValuePool getAccountingCatalog(BusinessObject bo,Transaction sqlca) throws Exception{
		if(accountCataLog == null) throw new Exception("ϵͳδ��ʼ���������������飡");
		ASValuePool as = null;
		for(Object s :accountCataLog.getKeys())
		{
			String key = (String)s;
			ASValuePool accountLibrary = (ASValuePool)accountCataLog.getAttribute(key);
			List<BusinessObject> ruleList = (List<BusinessObject>)accountLibrary.getAttribute("RULE");
			boolean flag = CompareTools.ruleAnalysis(ruleList,bo,sqlca);
			if(flag)
				as = accountLibrary;
		}
		
        return as;
	}
	
	/**
	 * ���ݺ����������ȡ���񷽰���Ϣ��ָ�������������Ŀ�Ŀ��
	 * @param bo
	 * @param accountCodeNo
	 * @return
	 * @throws Exception
	 */
	public static String getAccountingCatalog(BusinessObject bo,String accountCodeNo,Transaction sqlca) throws Exception{
		ASValuePool as = getAccountingCatalog(bo,sqlca);
		if(as!=null)
			return ((BusinessObject)as.getAttribute(accountCodeNo)).getString("SubjectNo");
		else
			return "";
	}
	
	
	
    /**
     * ���ݺ����������ȡ���񷽰���Ϣ��ָ�������������Ŀ�Ŀ��
     */
    public static String getAccountingCatalogSubjectName(BusinessObject bo,String accountCodeNo,Transaction sqlca) throws Exception{
        ASValuePool as = getAccountingCatalog(bo,sqlca);
        if(as!=null)
            return ((BusinessObject)as.getAttribute(accountCodeNo)).getString("SubjectName");
        else
            return "";
    }
	
	/**
	 * ͨ��ϵͳ�ڷ�¼��ϸ���������ۿ���Ϣ����
	 * @param details
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> toLasCore(List<BusinessObject> details,BusinessObject args,AbstractBusinessObjectManager bom) throws Exception{
		List<BusinessObject> lasCores = new ArrayList<BusinessObject>();
		List<BusinessObject> debitDetails = new ArrayList<BusinessObject>();
		List<BusinessObject> creditDetails = new ArrayList<BusinessObject>();
		for(BusinessObject detail: details)
		{
			if(detail.getDouble("DebitAmt")-detail.getDouble("CreditAmt")>0)
				debitDetails.add(detail);
			else if(detail.getDouble("CreditAmt")-detail.getDouble("DebitAmt")>0)
				creditDetails.add(detail);
		}
		List<BusinessObject> debitSplitDetails = new ArrayList<BusinessObject>();
		List<BusinessObject> creditSplitDetails = new ArrayList<BusinessObject>();
		
		List<BusinessObject> debitTemps = new ArrayList<BusinessObject>();
		//����� �跽�Ҵ���
		for(int i=0; i < debitDetails.size(); i ++)
		{
			double debitAmt = debitDetails.get(i).getDouble("DebitAmt")-debitDetails.get(i).getDouble("CreditAmt");
			List<BusinessObject> creditDetailTemps = getAggregate(creditDetails,debitAmt);
			for(BusinessObject creditDetailTemp:creditDetailTemps)
			{
				BusinessObject debitDetailTemp = debitDetails.get(i).cloneObject();
				debitDetailTemp.setAttributeValue("CreditAmt", 0.0d);
				debitDetailTemp.setAttributeValue("DebitAmt", Arith.round(creditDetailTemp.getDouble("CreditAmt")-creditDetailTemp.getDouble("DebitAmt"),2));
				debitSplitDetails.add(debitDetailTemp);
				creditSplitDetails.add(creditDetailTemp);
				creditDetails.remove(creditDetailTemp);
				if(!debitTemps.contains(debitDetails.get(i))) debitTemps.add(debitDetails.get(i));
			}
		}
		debitDetails.removeAll(debitTemps);
		//����� �����ҽ跽
		for(int i=0; i < creditDetails.size(); i ++)
		{
			double creditAmt = creditDetails.get(i).getDouble("DebitAmt")-creditDetails.get(i).getDouble("CreditAmt");
			List<BusinessObject> debitDetailTemps = getAggregate(debitDetails,creditAmt);
			for(BusinessObject debitDetailTemp:debitDetailTemps)
			{
				BusinessObject creditDetailTemp = debitDetails.get(i).cloneObject();
				creditDetailTemp.setAttributeValue("CreditAmt", Arith.round(debitDetailTemp.getDouble("DebitAmt")-debitDetailTemp.getDouble("CreditAmt"),2));
				creditDetailTemp.setAttributeValue("DebitAmt", 0.0d);
				debitSplitDetails.add(debitDetailTemp);
				creditSplitDetails.add(creditDetailTemp);
			}
		}
		
		if(debitSplitDetails.size() != creditSplitDetails.size() || debitSplitDetails.size()*2 < debitSplitDetails.size()) 
			throw new Exception("�ú��ķ�¼�޷���֣����������ã�");

		//�ж��Ƿ���Ͻ��ף����跽�ʹ�������ͬһ�˺��ҽ����ͬ����ʹ��ȫ��ۿ�ģʽ ��Ҫ��֧��ί�д���
		String deductType = args.getString("DeductType");
		if(ACCOUNT_CONSTANTS.DEDUCTTYPE_DEFICIT.equals(deductType))
		{
			for(int i = 0; i <  creditSplitDetails.size()-1; i ++)
			{
				if(Math.abs((creditSplitDetails.get(i).getDouble("DebitAmt")-creditSplitDetails.get(i).getDouble("CreditAmt"))-(debitSplitDetails.get(i+1).getDouble("CreditAmt")-debitSplitDetails.get(i+1).getDouble("DebitAmt"))) < 0.000001
						&& creditSplitDetails.get(i).getString("AccountCodeNo").equals(debitSplitDetails.get(i+1).getString("AccountCodeNo")))
				{
					deductType = ACCOUNT_CONSTANTS.DEDUCTTYPE_ENOUGH;
					break;
				}
			}
		}
		for(int i=0; i < debitSplitDetails.size(); i ++)
		{
			BusinessObject lasCore = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.BatchLasCore,bom);
			//������в���
			String[] keys = args.getAttributeIDArray();
			for(String key:keys)
			{
				lasCore.setAttributeValue(key, args.getString(key));
			}
			lasCore.setAttributeValue("SerialNoToCore", String.valueOf(serialno++));
			lasCore.setAttributeValue("InputDate", debitSplitDetails.get(i).getString("OccurDate"));
			lasCore.setAttributeValue("ObjectNo", debitSplitDetails.get(i).getString("ObjectNo"));
			lasCore.setAttributeValue("ObjectType", debitSplitDetails.get(i).getString("ObjectType"));
			lasCore.setAttributeValue("DeductSerialNo", debitSplitDetails.get(i).getString("TransSerialNo"));
			lasCore.setAttributeValue("Currency", debitSplitDetails.get(i).getString("Currency"));
			lasCore.setAttributeValue("BatchTransType", args.getString("BatchTransType"));
			lasCore.setAttributeValue("PayAmount", Arith.round(debitSplitDetails.get(i).getDouble("DebitAmt")-debitSplitDetails.get(i).getDouble("CreditAmt"),2));
			//�������˻�
			String payAccountInfo = debitSplitDetails.get(i).getString("AccountInfo");//��ʽ���˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ#�˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ#����
			String[] payAccounts = payAccountInfo.split("#");
			if(payAccounts.length <= 0) throw new Exception("�����˻���Ϣ�������飡");
			int n = 1;
			for(String payAccount:payAccounts)
			{
				StringTokenizer st = new StringTokenizer(payAccount,"@");
				lasCore.setAttributeValue("PayAccountNo"+n, st.nextToken());
				lasCore.setAttributeValue("PayAccountName"+n, st.nextToken());
				lasCore.setAttributeValue("PayAccountOrgID"+n, st.nextToken());
				lasCore.setAttributeValue("PayAccountCurrency"+n, st.nextToken());
				lasCore.setAttributeValue("PayAccountType"+n, st.nextToken());
				lasCore.setAttributeValue("PayAccountFlag"+n, st.nextToken());
				n++;
			}
			
			//�����տ��˻�
			String recieveAccountInfo = creditSplitDetails.get(i).getString("AccountInfo");//��ʽ���˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ
			String[] recieveAccounts = recieveAccountInfo.split("#");
			if(recieveAccounts.length > 1 || recieveAccounts.length <=0) throw new Exception("�տ��˻����󣬴��ڶ���򲻴��ڣ�");
			StringTokenizer st = new StringTokenizer(recieveAccounts[0],"@");
			lasCore.setAttributeValue("RecieveAccountNo", st.nextToken());
			lasCore.setAttributeValue("RecieveAccountName", st.nextToken());
			lasCore.setAttributeValue("RecieveAccountOrgID", st.nextToken());
			lasCore.setAttributeValue("RecieveAccountCurrency", st.nextToken());
			lasCore.setAttributeValue("RecieveAccountType", st.nextToken());
			lasCore.setAttributeValue("RecieveAccountFlag", st.nextToken());
			
			lasCore.setAttributeValue("DeductType", deductType);
			lasCore.setAttributeValue("AccountingOrgID", debitSplitDetails.get(i).getString("AccountingOrgID"));//�������
			lasCore.setAttributeValue("DIGEST", args.getString("DIGEST"));
			lasCore.setAttributeValue("BatchNo", args.getString("BatchNo"));
			
			lasCores.add(lasCore);
		}
		
		return lasCores;
	}
	/**
	 * ����ͨ������ƥ��ķ�ʽ�����б��н��֮���봫������ͬ�ļ���
	 * @param details ��¼��ϸ
	 * @param amt ���
	 * @param num ��������
	 * @return
	 * @throws Exception
	 */
	private static List<BusinessObject> getAggregate(List<BusinessObject> details,double amt) throws Exception
	{
		List<BusinessObject> returnDetails = new ArrayList<BusinessObject>();
		
		for(BusinessObject detail:details)
		{
			List<BusinessObject> detailTemps = new ArrayList<BusinessObject>();
			detailTemps.addAll(details);
			detailTemps.remove(detail);
			double creditAmt = detail.getDouble("CreditAmt")-detail.getDouble("DebitAmt");
			returnDetails.add(detail);
			if(Math.abs(amt - creditAmt) < 0.0000001)
			{
				return returnDetails;
			}
			else
				returnDetails.addAll(getAggregate(detailTemps,amt - creditAmt));
			
			double creditAllAmt = 0.0d;
			for(BusinessObject returnDetail:returnDetails)
			{
				creditAllAmt += returnDetail.getDouble("CreditAmt")-returnDetail.getDouble("DebitAmt");
			}
			
			if(Math.abs(amt-creditAllAmt)<0.0000001) return returnDetails;
			else returnDetails.clear();
		}
		return returnDetails;
	}
	
	/**
	 * ��ջ������
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}

	/**
	 * �����˻����Ͷ�����Ϣ
	 * @see com.amarsoft.dict.als.cache.AbstractCache#load(com.amarsoft.awe.util.Transaction)
	 */
	public synchronized boolean load(Transaction transaction) throws Exception {
		try
		{
			ASValuePool accountCodeSet = new ASValuePool();
			String sql = " select ItemNo,ItemName,Attribute2," +
					" BankNo as BookType,ItemAttribute,ItemDescribe,RelativeCode,Attribute1,Attribute3," +
					" Attribute4,Attribute5,Attribute6,Attribute7,Attribute8,Remark " +
					" from CODE_LIBRARY where  CodeNo in ('AccountCodeConfig') " +
					" and IsInUse='1' order by BankNo,ItemNo";
			ASResultSet rs = transaction.getASResultSet(sql);
	        while(rs.next()){
	        	ASValuePool accountCodeDefinition = new ASValuePool();
	        	String bookType=rs.getString("BookType");
	        	if(bookType == null) bookType = "";
	        	String accountCodeNo = rs.getString("ItemNo");
	        	accountCodeDefinition.setAttribute("AccountCodeNo", accountCodeNo);//�����˻�����
	        	accountCodeDefinition.setAttribute("AccountCodeName", rs.getString("ItemName"));//�����˻���������
	        	accountCodeDefinition.setAttribute("Direction", rs.getString("Attribute2"));//����
	        	accountCodeDefinition.setAttribute("BaseCurrency", rs.getString("Attribute5"));        	
	        	accountCodeDefinition.setAttribute("MappingScript", rs.getString("RelativeCode"));
	        	String accountCodeType =  rs.getString("ItemDescribe");
	        	accountCodeDefinition.setAttribute("AccountCodeType",accountCodeType);
	        	if(accountCodeType!=null&&accountCodeType.length()>0){
	        		if("1,2,3,4,5".indexOf(accountCodeType)>=0)
	        			accountCodeDefinition.setAttribute("OnBalanceSheetFlag", "1");
	        		if("6,7".indexOf(accountCodeType)>=0)
	        			accountCodeDefinition.setAttribute("OnBalanceSheetFlag", "2");	
	        	}
	        	
	        	for(String a :bookType.split(","))
	        	{
		        	ASValuePool accountCodeSet_Temp = (ASValuePool)accountCodeSet.getAttribute(a);
		        	if(accountCodeSet_Temp==null){
		        		accountCodeSet_Temp=new ASValuePool();
		        		accountCodeSet.setAttribute(a, accountCodeSet_Temp);
		        	}
		        	accountCodeSet_Temp.setAttribute(accountCodeNo, accountCodeDefinition);
	        	}
	        }
	        rs.close();
	        AccountCodeConfig.accountCodeSet = accountCodeSet;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		
		try
		{
			ASValuePool accountCataLog = new ASValuePool();
			String sql = " select * from ACCOUNTING_CATALOG ";
			ASResultSet rs = transaction.getASResultSet(sql);
	        while(rs.next()){
	        	ASValuePool accountLibrary = new ASValuePool();
	        	String accountingNo=rs.getString("AccountingNo");
	        	accountLibrary.setAttribute("AccountingNo", accountingNo);
	        	accountLibrary.setAttribute("AccountingName", rs.getString("AccountingName"));
	        	accountLibrary.setAttribute("RULE", new ArrayList<BusinessObject>());
	        	accountCataLog.setAttribute(accountingNo, accountLibrary);
	        }
	        rs.close();
	        
	        sql = " select * from ACCOUNTING_LIBRARY ";
			rs = transaction.getASResultSet(sql);
	        while(rs.next()){
	        	String accountingNo=rs.getString("AccountingNo");
	        	ASValuePool accountLibrary = (ASValuePool)accountCataLog.getAttribute(accountingNo);
	        	if(accountLibrary!=null)
	        	{
	        		accountLibrary.setAttribute(rs.getString("AccountCodeNo"), new BusinessObject("jbo.app.ACCOUNTING_LIBRARY",rs.rs));
	        	}
	        }
	        rs.close();
	        
	        sql = " select * from CONDITION_RULE where ObjectType = 'jbo.app.ACCOUNTING_CATALOG' order by ObjectNo,RuleID";
			rs = transaction.getASResultSet(sql);
	        while(rs.next()){
	        	String accountingNo=rs.getString("ObjectNo");
	        	ASValuePool accountLibrary = (ASValuePool)accountCataLog.getAttribute(accountingNo);
	        	if(accountLibrary!=null)
	        	{
	        		List<BusinessObject> ls = (List<BusinessObject>)accountLibrary.getAttribute("RULE");
	        		ls.add(new BusinessObject("jbo.app.CONDITION_RULE",rs.rs));
	        	}
	        }
	        rs.close();
	        
	        AccountCodeConfig.accountCataLog = accountCataLog;
	        return true;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
}

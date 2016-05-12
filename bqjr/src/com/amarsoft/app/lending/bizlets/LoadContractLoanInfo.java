package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.web.bizlets.PutOutLoanTry;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
/**
 * @parms objectNo,userID,businessType,creditCycle,replaceAccount,replaceName,businessSum
 * @author pli phe yljiang smliu huangshuo
 * @throws Exception
 * @return ��������ÿ�»����״λ���
 * @update ���º�ͬ������Ϣ
 * 
 */
public class LoadContractLoanInfo {
	
	/** ���ʽ�����ID�� **/
	private String termID;
	
	/** �������� **/
	private String objectType = BUSINESSOBJECT_CONSTATNTS.business_contract;
	
	/** �����ţ�Ŀǰһ��Ϊ��ͬ�ţ� **/
	private String objectNo;
	
	/** ��ǰ�û���� **/
	private String userID;
	
	/** ��Ʒ���� **/
	private String businessType;
	
	/** �Ƿ�Ͷ�� **/
	private String creditCycle;
	
	/** �����ʺ� **/
	private String replaceAccount;
	
	/** �����ʺ��� **/
	private String replaceName;
	
	/** ���� **/
	private int iPeriods = 0;
	
	/** ��Ʒ������ **/
	private String dMonthlyInterstRate;
	
	/** ����� **/
	private String businessSum = "";
	
	/** 0-���棻1-���棻2-���ɼƻ� **/
	private String type;
	
	/** ��ǰ�û����ڻ��� **/
	private String org;
	
	/** �Ƿ������Ļ������ **/
	private String buyPayPkgind;
	
	/** �������� **/
	private String productId;
	
	/**���۷�ʽ**/
	private String repaymentWay;
	
	/**������֧��**/
	private String openBranch;
	
	/**������**/
	private String openBank;
	
	/**���۷ſ��˺ų���**/
	private String city;
	
	/**
	 * ��ʼ����ͬ�Ļ�����Ϣ��
	 * <li>�״λ����ա��״λ����</li>
	 * <li>ÿ�»����ա�ÿ�»����</li>
	 * <li>��ͬ��Ч�ա���ͬ������</li>
	 * <li>�ſ��˺���Ϣ�������˺���Ϣ</li>
	 * @param Sqlca
	 * @retur ����������
	 */
	public String initContractLoanInfo(Transaction Sqlca){
		//У���˻������Ϣ CCS-1247 add by zty 
		String returnStr = validateAccountInfo();
		if(!"SUCCESS".equals(returnStr)){
			throw new RuntimeException(returnStr);
		}
		String company = "";
		JBOTransaction tx = null;
		try {
			// ����jbo����ע��
			tx = JBOFactory.createJBOTransaction();
			tx.join(Sqlca);// ��������ʵ��ʹ�õ���JBO�������
			//��֤��ͬ�ؼ������Ƿ��иı�
			String v_sql = "select bc.creditcycle,bci.status,bc.businesstype,bc.businesssum, bc.bugPaypkgind,i.company from  business_contract bc"
					+ " left join BUSINESS_CREDIT bci on bc.serialno=bci.contract_no left join store_info i on bc.stores=i.sno where bc.serialno=:CONTRACT_NO";
			// 6.�����Ƿ��������ɻ�����Ϣ������һ������һ�Σ�
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			String dateStr = sdf.format(date);
			String status = "";
			String oldbusinessType = "";
			String oldCreditcycle = "";
			String oldBusinesssum = "";
			String oldBugPaypkgind = "";
			ASResultSet v_rs = Sqlca.getASResultSet(new SqlObject(v_sql).setParameter("CONTRACT_NO", objectNo));
			if (v_rs.next()) {
				status = v_rs.getString("STATUS");
				oldbusinessType = v_rs.getString("businesstype");
				oldCreditcycle = v_rs.getString("creditcycle");
				oldBusinesssum = v_rs.getString("businesssum");
				oldBugPaypkgind = v_rs.getString("bugPaypkgind");
				company = v_rs.getString("company");
				if (oldbusinessType == null) {
					oldbusinessType = "";
				}
				if (oldCreditcycle == null) {
					oldCreditcycle = "";
				}
				if (oldBusinesssum == null) {
					oldBusinesssum = "";
				}
				if (oldBugPaypkgind == null) {
					oldBugPaypkgind = "";
				}
				if (company == null) {
					company = "";
				}
			}
			v_rs.getStatement().close();
			
			if (businessType == null) {
				businessType = "";
			}
			if (creditCycle == null) {
				creditCycle = "";
			}
			if (businessSum == null) {
				businessSum = "";
			}
			if (buyPayPkgind == null) {
				buyPayPkgind = "";
			}
			//�����Ʒ���� ���Ƿ�Ͷ�� ���������ı�ʱ����״̬��Ϊ�ѱ��� �������ɻ���ƻ���־Ϊ�ѱ����ͬ״̬��BUSINESS_CREDIT.STATUS��
			if (!businessType.equals(oldbusinessType) || !creditCycle.equals(oldCreditcycle) 
					|| !businessSum.equals(oldBusinesssum) || !buyPayPkgind.equals(oldBugPaypkgind)) {
				type = "1";
			}
			
			// 1.���ز�Ʒ��Ϣ
			ProductManage productManage = new ProductManage(Sqlca);;
			setTermID("RPT17");// �ȶϢ
			productManage.setAttribute("TermID",  getTermID());
			productManage.setAttribute("ObjectType", getObjectType());
			productManage.setAttribute("ObjectNo", getObjectNo());
			productManage.initObjectWithProduct();
			setTermID("RAT002");// �̶�����
			productManage.setAttribute("TermID", getTermID());
			productManage.initObjectWithProduct();
			
			// 2.���ô���
			CreateFeeList createFeeList = new CreateFeeList();
			createFeeList.setAttribute("BusinessType", getBusinessType());
			createFeeList.setAttribute("ObjectType", getObjectType());
			createFeeList.setAttribute("ObjectNo", getObjectNo());
			createFeeList.setAttribute("UserID", getUserID());
			createFeeList.setAttribute("CreditCycle", getCreditCycle());
			createFeeList.run(Sqlca);
			String sSqlBT = " select term,MONTHLYINTERESTRATE,LOWPRINCIPAL,TALLPRINCIPAL,SHOUFURATIO,SHOUFURATIOTYPE,ratetype,monthcalculationMethod,floatingManner,highestLoansProportion,whetherDiscount,producttype from business_type where typeno='"+getBusinessType()+"' ";
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSqlBT));
			while(rs.next()){
				iPeriods = rs.getInt("term");// �ڴ�
				dMonthlyInterstRate = rs.getString("MONTHLYINTERESTRATE");// ��Ʒ������
			}
			rs.getStatement().close();
			if(!"1".equals(getCreditCycle())){// ��Ͷ�������Ͷ����ط���
				String deleteFee ="DELETE from acct_fee where feetype='A12' and objecttype='jbo.app.BUSINESS_CONTRACT' and objectno='"+getObjectNo()+"'";
				Sqlca.executeSQL(new SqlObject(deleteFee));
			}else{
				// �Ƿ��б��շ�
				String productobjectno = getBusinessType()+"-V1.0";
				Double credFeeRate = 0.0;
				Double credFeeRateAll = 0.0;
				String credTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"+productobjectno+"' "));
				if(credTermID==null) credTermID = "";
				if(!"".equals(credTermID)){
					credFeeRate = DataConvert.toDouble(Sqlca.getString(new SqlObject("select defaultvalue from product_term_para where paraid='FeeRate' and termid = '"+credTermID+"' and objectno='"+productobjectno+"' ")));
					credFeeRateAll = credFeeRate*iPeriods;
				}
				ARE.getLog().debug("======CredFeeRateAll======"+credFeeRateAll);
				String updateFee = "Update ACCT_FEE set FeeRate = '"+credFeeRateAll+"' where FeeType = 'A12' and ObjectNo='"+getObjectNo()+"'";
				Sqlca.executeSQL(new SqlObject(updateFee));
			}
			
			String sql = "";
			// 3. �Ƿ������Ļ������
			if (!"1".equals(buyPayPkgind)) {		// ���������Ļ������
				sql = "DELETE FROM ACCT_FEE WHERE FEETYPE = 'A18' AND OBJECTTYPE = " 
						+ "'jbo.app.BUSINESS_CONTRACT' AND OBJECTNO = :OBJECTNO";
				Sqlca.executeSQL(new SqlObject(sql).setParameter("OBJECTNO", getObjectNo()));
			} else {
				// ��ȡ��ͬ��Ӧ��Ʒ�����Ļ�����ѵ�TermID
				String productObjectNO = getBusinessType() + "-V1.0";
				sql = "SELECT TERMID FROM PRODUCT_TERM_LIBRARY WHERE SUBTERMTYPE = 'A18' AND "
					+ "OBJECTNO = :OBJECTNO AND OBJECTTYPE = 'Product'";
				rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("OBJECTNO", productObjectNO));
				String termId = "";
				if (rs.next()) {
					termId = rs.getString("TERMID");
				}
				rs.getStatement().close();
				sql = "SELECT DEFAULTVALUE FROM PRODUCT_TERM_PARA WHERE TERMID = :TERMID "
					+ "AND PARAID = 'FeeAmount'";
				String defaultValue = "";
				rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("TERMID", termId));
				if (rs.next()) {
					defaultValue = rs.getString("DEFAULTVALUE");
				}
				sql = "UPDATE ACCT_FEE SET AMOUNT = :AMOUNT WHERE FEETYPE = 'A18' AND OBJECTNO = :OBJECTNO";
				Sqlca.executeSQL(new SqlObject(sql)
								.setParameter("AMOUNT", defaultValue)
								.setParameter("OBJECTNO", getObjectNo()));
			}
			
			// 4.�����˻���Ϣ
			accountDeposit(Sqlca);
			
			// 5.���ط��ü�����Ϣ
			InsertFeeWaive insertFeeWaive = new InsertFeeWaive();
			insertFeeWaive.setAttribute("UserID", getUserID());
			insertFeeWaive.setAttribute("BusinessType",getBusinessType());//��Ʒ����
			insertFeeWaive.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.business_contract);//��������
			insertFeeWaive.setAttribute("ObjectNo",getObjectNo());//��ͬ��
			insertFeeWaive.run(Sqlca);
			
			// 6.����������Ϣ
			SetBusinessMaturity(Sqlca);
			
			if (status != null && !"".equals(status)) {
				// ���type �����ڿ��ַ������ֵ��ʱ�򣬲���Ҫִ�и��²�����
				if (type == null || "".equals(type)) {
					// ���typeΪ��ʱ���жϴ���
					if ("0".equals(status)) {
						type = "1";
					} else {
						type = status;
					} 
				}
				
				sql = "UPDATE BUSINESS_CREDIT SET STATUS = :STATUS, UPDATE_USER = :UPDATE_USER, " 
						+ "UPDATE_ORG = :UPDATE_ORG, UPDATE_TIME = :UPDATE_TIME, COMPANY = :COMPANY " 
						+ "WHERE CONTRACT_NO = :CONTRACT_NO";
				Sqlca.executeSQL(new SqlObject(sql)
								.setParameter("STATUS", type)
								.setParameter("CONTRACT_NO", objectNo)
								.setParameter("UPDATE_USER", userID)
								.setParameter("UPDATE_ORG", org)
								.setParameter("UPDATE_TIME", dateStr)
								.setParameter("COMPANY", company)
								);
			} else {
				if (type == null || "".equals(type)) {
					type = "1";
				}
				sql = "INSERT INTO BUSINESS_CREDIT (CONTRACT_NO, STATUS, INPUT_USER, INPUT_ORG, "
						+ "INPUT_TIME, UPDATE_USER, UPDATE_ORG, UPDATE_TIME, REMARK, COMPANY) VALUES "
						+ "(:CONTRACT_NO, :STATUS, :INPUT_USER, :INPUT_ORG, :INPUT_TIME, "
						+ ":UPDATE_USER, :UPDATE_ORG, :UPDATE_TIME, :REMARK, :COMPANY)";
				Sqlca.executeSQL(new SqlObject(sql)
								.setParameter("CONTRACT_NO", objectNo)
								.setParameter("STATUS", type)
								.setParameter("INPUT_USER", userID)
								.setParameter("INPUT_ORG", org)
								.setParameter("INPUT_TIME", dateStr)
								.setParameter("UPDATE_USER", userID)
								.setParameter("UPDATE_ORG", org)
								.setParameter("UPDATE_TIME", dateStr)
								.setParameter("REMARK", "")
								.setParameter("COMPANY", company)
								);
			}
			
			String result = "SUCCESS";
			
			/*
			// �Ƴ��������㣬�������Ƶ������ɻ�����Ϣ����ť��
			// 7.��������
			String result = firstMonthPayTry(Sqlca);
			*/
			tx.commit();
			return result;
			
		} catch (Exception e) {
			e.printStackTrace();
			try {
				tx.rollback();
			} catch (JBOException e1) {
				e1.printStackTrace();
			}
			ARE.getLog().error("��ͬ����ʧ�ܣ�" + e);
			return "Error";
		}
		
	}
	
	/**
	 * �����˻���Ϣ
	 * @throws Exception 
	 */
	private void accountDeposit(Transaction Sqlca) throws Exception{
		if(getReplaceAccount()==null||getReplaceAccount().length()<=0){
			setReplaceAccount("XFD"+getObjectNo());
		}
		if(getReplaceName()==null||getReplaceName().length()<=0){
			setReplaceName("���Ѵ��ͻ�");
		}
		
		//�����˻���Ϣ
		String insertDeposit = "insert into acct_deposit_accounts (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS) "+
				" values (:sSerialno, '"+getObjectNo()+"', '"+BUSINESSOBJECT_CONSTATNTS.business_contract+"', '01', '"+getReplaceAccount()+"', '01', '"+getReplaceName()+"', '2', '1', '', :sAccountIdicator, '0')";
		//�����˻���Ϣ		
		String updateSql ="update acct_deposit_accounts set "
				+ " accountno = '"+getReplaceAccount()+"', accountname = '"+getReplaceName()+"' "
				+ " where objecttype = 'jbo.app.BUSINESS_CONTRACT' and accountindicator = :sAccountIdicator and OBJECTNO = '"+getObjectNo()+"'";
		//��ѯ�ñʺ�ͬ�����Ŀۿ���Ƿ����
		String accountIndicatorsql ="select count(1) from ACCT_DEPOSIT_ACCOUNTS " 
				+ " where ObjectNo='"+getObjectNo()+"' and ObjectType='"+BUSINESSOBJECT_CONSTATNTS.business_contract+"'"
				+ " and AccountIndicator =:accountIndicator and status = '0'";
		
		//���»����˻���Ϣ
		Double count = Sqlca.getDouble(new SqlObject(accountIndicatorsql).setParameter("accountIndicator", "01"));
		if(count>0){//�ʺŴ��ڣ������ʺ���Ϣ
			Sqlca.executeSQL(new SqlObject(updateSql).setParameter("sAccountIdicator", "01"));
		}else{//�����˺���Ϣ
			String sSerialno = DBKeyHelp.getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo");
			Sqlca.executeSQL(new SqlObject(insertDeposit).setParameter("sAccountIdicator", "01").setParameter("sSerialno", sSerialno));
		}
		
		//���·ſ��˻���Ϣ
		Double putOutCount = Sqlca.getDouble(new SqlObject(accountIndicatorsql).setParameter("accountIndicator", "00"));
		if(putOutCount>0){//�ʺŴ��ڣ����·ſ��ʺ���Ϣ
			Sqlca.executeSQL(new SqlObject(updateSql).setParameter("sAccountIdicator", "00"));
		}else{
			String sSerialno = DBKeyHelp.getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo");
			Sqlca.executeSQL(new SqlObject(insertDeposit).setParameter("sAccountIdicator", "00").setParameter("sSerialno", sSerialno));
		}	
	}
	/**
	 * ���ú�ͬ����
	 */
	public void SetBusinessMaturity(Transaction Sqlca) throws Exception{
		//��������
		String PutOutDate = "";//�ſ���
		String sFirstDueDate = "";//�״λ�����
		String sDefaultDueDay = "";//ÿ�»�����
		String temDay = "";//�м����
		
		//���ڼ���
		String businessDate = SystemConfig.getBusinessDate();//��ǰҵ��ʱ��
		//1.�ſ���ȡϵͳ��ǰҵ��ʱ��
		PutOutDate = businessDate;
		
		//2.�ж�ÿ�»��������״λ�����
		temDay = businessDate.substring(8, 10);
		if (temDay.equals("29")) {
			temDay = "02";
			sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
			sFirstDueDate = sDefaultDueDay.substring(0, 8) + temDay;
		} else if (temDay.equals("30")) {
			temDay = "03";
			sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
			sFirstDueDate = sDefaultDueDay.substring(0, 8) + temDay;
		} else if (temDay.equals("31")) {
			temDay = "04";
			sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
			sFirstDueDate = sDefaultDueDay.substring(0, 8) + temDay;
		} else {
			sDefaultDueDay = temDay;
			sFirstDueDate = DateFunctions.getRelativeDate(businessDate,	DateFunctions.TERM_UNIT_MONTH, 1);
		}
		
		//3.һ���ͻ������ͬ��������ж��״λ����գ�ȡ�ͻ�֮ǰ����ĺ�ͬ
		String sFirstNextDueDate = "";//�ͻ���ʷ�ױʺ�ͬ�¸�������
		int sDays = 0;
		String sCustomerID = Sqlca.getString("select customerid from business_contract where serialno = '"+getObjectNo()+"'");
		if(sCustomerID==null) throw new Exception("��ǰ��ͬ:["+getObjectNo()+"]��δ��ȷ����ͻ���Ϣ"); 		

		String minSerialNo = Sqlca.getString(new SqlObject("SELECT min(serialno) FROM business_contract "
				+ " where finishdate is null and CONTRACTSTATUS = '050' and customerid = :CustomerID and serialno <> :serialno ")//��ѯ��Χ��1.ͬһ�ͻ�2.��ע��3.δ����
				.setParameter("CustomerID", sCustomerID).setParameter("serialno", getObjectNo()));
		if (minSerialNo == null)			minSerialNo = "";
		if (!minSerialNo.equals("")) {
			sFirstNextDueDate = Sqlca.getString(new SqlObject(	"SELECT NEXTDUEDATE FROM acct_loan "
					+ " where loanstatus in ('0','1') and putoutno = :minSerialNo ").setParameter("minSerialNo", minSerialNo));
			if (sFirstNextDueDate == null)				sFirstNextDueDate = "";
		}
		
		if (sFirstNextDueDate.compareTo(businessDate) <= 0)	sFirstNextDueDate = sFirstDueDate;

		if (!sFirstNextDueDate.equals("")) {
			sDays = DateFunctions.getDays(businessDate,sFirstNextDueDate);//���㵱ǰ�������¸�������֮��ļ��
			if (sDays >= 14) {//������ڵ���14�죬ȡ��ʷ��ͬ���¸�������
				sFirstDueDate = sFirstNextDueDate;
			} else {//���С��14�죬ȡ���¸�������+1���¡�
				sFirstDueDate = DateFunctions.getRelativeDate(sFirstNextDueDate,DateFunctions.TERM_UNIT_MONTH, 1);
			}
			sDefaultDueDay = sFirstDueDate.substring(8, 10);
		}
		//4.���㵽����
		String sMaturity = DateFunctions.getRelativeDate(businessDate,DateFunctions.TERM_UNIT_MONTH, iPeriods);
		double dBusinessSum = Double.valueOf(getBusinessSum());
		
		//5.���»�����Ϣ����״λ����պ�ÿ�»�����
		if(sFirstDueDate.length()<=0||sDefaultDueDay.length()<=0||PutOutDate.length()<=0||sMaturity.length()<=0){
			throw new Exception("��ͬ���ڼ���ʧ�ܣ�");
		}
		String sql = "update acct_rpt_segment set FirstDueDate = '"+sFirstDueDate+"' , defaultDueDay = '"+sDefaultDueDay+"' where ObjectNo = '"+getObjectNo()+"'";
		Sqlca.executeSQL(new SqlObject(sql));
		ARE.getLog().info("���»�����Ϣ����״λ����պ�ÿ�»�����SQL:"+sql);
		//6.���º�ͬ����״λ����ա��ſ��ա���ͬ��Ч�պ͵�����
		//�������º�ͬ��Ĵ��۷�ʽ���������͡��Լ��˺������Ϣ CCS-1247 add by zty
		sql = "update BUSINESS_CONTRACT set BusinessSum = '"+dBusinessSum+"' , ORIGINALPUTOUTDATE = '"+sFirstDueDate+"' , PutOutDate = '"+PutOutDate+"', contractEffectiveDate = '"+PutOutDate+"', Maturity = '"+sMaturity;
		if("1".equals(getRepaymentWay())){
			sql = sql + "' ,openbank = '" + getOpenBank() +"',city = '" + getCity() + "' ,replaceaccount = '" + getReplaceAccount() + "' ,replacename = '" + getReplaceName();
			if("020".equals(productId)){
				sql = sql + "',openbranch = '" + getOpenBranch();
			}
		}
		sql = sql + "' where SerialNo = '"+getObjectNo()+"'";
		Sqlca.executeSQL(new SqlObject(sql));
		ARE.getLog().info("���º�ͬ����״λ����ա��ſ��ա���ͬ��Ч�պ͵�����,���۷�ʽ���������͡��Լ��˺������ϢSQL:"+sql);
		
	}

	/**
	 * ��������
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String firstMonthPayTry(Transaction Sqlca) throws Exception{
		
		JBOTransaction tx = null;
		double paymentValueMonth = 0.0;						// ÿ�»����
		double Firstpaymentend = 0.0;						// �״λ����
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		String dateStr = sdf.format(date);
		try {
			// ����jbo����ע��
			tx = JBOFactory.createJBOTransaction();
			tx.join(Sqlca);// ��������ʵ��ʹ�õ���JBO�������
			PutOutLoanTry putOutLoanTry = new PutOutLoanTry();	// ��������
			putOutLoanTry.setAttribute("ObjectNO", getObjectNo());
			String result = (String) putOutLoanTry.run(Sqlca);	// ������
			ARE.getLog().info("������������"+result);
			
			String paymentValue1 = result.split("@")[0];		// ��һ��Ӧ���ܽ��
			String paymentValue2 = result.split("@")[1];		// �ڶ���Ӧ���ܽ��
			String paymentValueEnd = result.split("@")[2];		// ���һ��Ӧ���ܽ��
			// String totalPaylAmt1 = result.split("@")[3];		// ��һ��Ӧ����Ϣ
			// String totalPaylAmt2 = result.split("@")[4];		// �ڶ���Ӧ����Ϣ
			if(Double.valueOf(paymentValueEnd) > Double.valueOf(paymentValue2)){ 
				paymentValueMonth = Double.valueOf(paymentValueEnd);
			}else{ 
				paymentValueMonth = Double.valueOf(paymentValue2);
			}
			Firstpaymentend = Double.valueOf(paymentValue1);
			paymentValueMonth = fix(paymentValueMonth);
			Firstpaymentend = fix(Firstpaymentend);
			String sFirstpaymentend = Firstpaymentend + "";		// �������ݿ��ṹ���⣬תΪ�ַ���
			if(paymentValueMonth <= 0 || Firstpaymentend < 0){
				throw new Exception("ÿ�»������״λ��������ʧ�ܣ�");
			}
			
			//���º�ͬ��ÿ�»������״λ����
			String sql = "update Business_Contract set MonthRepayment = '" + paymentValueMonth + "'" 
						 + ", FIRSTDRAWINGDATE = '" + sFirstpaymentend + "' where SerialNo = '" 
						 + getObjectNo() + "'";
			Sqlca.executeSQL(new SqlObject(sql));
			deletedbByContract(Sqlca);							// ��ɾ����ʱ��������
			updateDb(putOutLoanTry.getTransaction(), Sqlca);	// ���滹��ƻ������Ϣ����ʱ��
			
			// ���º�ͬ������ɻ���ƻ�״̬
			// 6.�����Ƿ��������ɻ�����Ϣ������һ������һ�Σ�
			sql = "SELECT COUNT(1) AS CNT FROM BUSINESS_CREDIT WHERE CONTRACT_NO = :CONTRACT_NO";
			ASResultSet rs = null;
			int cnt = 0;
			rs = Sqlca.getResultSet(new SqlObject(sql).setParameter("CONTRACT_NO", getObjectNo()));
			if (rs.next()) {
				cnt = rs.getInt("CNT");
			}
			rs.getStatement().close();
			
			if (cnt == 1) {
				sql = "UPDATE BUSINESS_CREDIT BC SET BC.STATUS = '2' WHERE BC.CONTRACT_NO = :CONTRACT_NO";
				Sqlca.executeSQL(new SqlObject(sql).setParameter("CONTRACT_NO", getObjectNo()));
			} else if (cnt == 0) {
				sql = "INSERT INTO BUSINESS_CREDIT (CONTRACT_NO, STATUS, INPUT_USER, INPUT_ORG, "
						+ "INPUT_TIME, UPDATE_USER, UPDATE_ORG, UPDATE_TIME, REMARK) VALUES "
						+ "(:CONTRACT_NO, :STATUS, :INPUT_USER, :INPUT_ORG, :INPUT_TIME, "
						+ ":UPDATE_USER, :UPDATE_ORG, :UPDATE_TIME, :REMARK)";
				Sqlca.executeSQL(new SqlObject(sql)
								.setParameter("CONTRACT_NO", objectNo)
								.setParameter("STATUS", "2")
								.setParameter("INPUT_USER", userID)
								.setParameter("INPUT_ORG", org)
								.setParameter("INPUT_TIME", dateStr)
								.setParameter("UPDATE_USER", userID)
								.setParameter("UPDATE_ORG", org)
								.setParameter("UPDATE_TIME", dateStr)
								.setParameter("REMARK", ""));
			} else {
				throw new Exception("�ҵ�����BUSINESS_CREDIT���ݣ���ͬ��Ϊ��" + getObjectNo());
			}
			
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error(e.getMessage());
			Sqlca.rollback();
			tx.rollback();
			return "Error";
		}
		
		return paymentValueMonth + "";
	}
	
	@SuppressWarnings("deprecation")
	private void updateDb(BusinessObject transaction,Transaction Sqlca) throws Exception{
		String sql ="";
		List<BusinessObject> trans = new ArrayList<BusinessObject>();
		trans.add(transaction);
		sql = businessObjectToSQL(trans);
		if (sql != null && !"".equals(sql)) {
			Sqlca.executeSQL(sql);
		}
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		List<BusinessObject> loans = new ArrayList<BusinessObject>();
		loans.add(loan);
		sql = businessObjectToSQL(loans);
		if (sql != null && !"".equals(sql)) {
			Sqlca.executeSQL(sql);
		}
		List<BusinessObject> acctPayments = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		sql = businessObjectToSQL(acctPayments);
		if (sql != null && !"".equals(sql)) {
			Sqlca.executeSQL(sql);
		}
		System.out.println(sql);
		List<BusinessObject> acctFees = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		sql = businessObjectToSQL(acctFees);
		if (sql != null && !"".equals(sql)) {
			Sqlca.executeSQL(sql);
		}
		if (acctFees != null) {
			for (BusinessObject businessObject : acctFees) {
				List<BusinessObject> psfees = businessObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
				sql = businessObjectToSQL(psfees);
				if (sql != null && !"".equals(sql)) {
					Sqlca.executeSQL(sql);
				}
			}
			System.out.println(acctFees.size());
		}
	}
	

	/**
	 * �Ѷ���ת����SQL��䣬�������������
	 * @param list
	 * @return
	 * @throws Exception
	 */
	private String businessObjectToSQL(List<BusinessObject> list) throws Exception{
		StringBuffer sql = new StringBuffer();//Ҫִ�е�SQL
		StringBuffer col = new StringBuffer();//���Ӧ����
		StringBuffer val = new StringBuffer();//���Ӧ��ֵ;
		if (list == null) {
			return "";
		}
		for(int i=0; i<list.size(); i++){
			BusinessObject bo = list.get(i);
			if(i==0){//��һ������Ҫ�� UNION ALL 
				//���ݶ������ͽ�ȡ����
				String tableName = bo.getObjectType().substring(bo.getObjectType().lastIndexOf(".")+1,bo.getObjectType().length());
				// tableName+="_contract";
				tableName = "trial_" + tableName;
				sql.append(" insert into "+ tableName);
				val.append("select ");
				//���������ԣ�ƴ��SQL���
				DataElement[] elements = bo.getBo().getAttributes();
				for(int j=0;j<elements.length;j++){
					DataElement de = elements[j];
					if(j==elements.length-1){//�ܺ�һ�����Բ���Ҫ�Ӷ���
						col.append(de.getName() +" ");
						if(de.getValue() != null){
							val.append("'"+de.getValue()+"'");
						}else{
							val.append("''");
						}
					}else{//������+����
						col.append(de.getName() +", ");
						if(de.getValue() != null){
							val.append("'"+de.getValue()+"',");
						}else{
							val.append("'',");
						}
					}
				}
				val.append(" from dual ");
			}else{//���� ����Ҫ�ӱ��Ӧ������
				val.append("\r\n");
				val.append(" UNION ALL ");
				val.append("\r\n");
				val.append("select ");
				DataElement[] elements = bo.getBo().getAttributes();
				for(int j=0;j<elements.length;j++){
					DataElement de = elements[j];
					if(j==elements.length-1){
						if(de.getValue() != null){
							val.append("'"+de.getValue()+"'");
						}else{
							val.append("''");
						}
					}else{
						if(de.getValue() != null){
							val.append("'"+de.getValue()+"',");
						}else{
							val.append("'',");
						}
					}
				}
				val.append(" from dual ");
			}
			
		}
		sql.append("(");
		sql.append(col.toString()+")");
		sql.append(val.toString());
		return sql.toString();
	}
	
	/**
	 * ���ݺ�ͬ�ţ�ɾ����ʱ����
	 * @param Sqlca
	 * @throws Exception
	 */
	private void deletedbByContract(Transaction Sqlca) throws Exception{
		String sql = "select t.serialno from trial_acct_loan t where t.putoutno='"+getObjectNo()+"'";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));
		String serialno = "";
		if(rs.next()){
			serialno = rs.getString("serialno");
			rs.getStatement().close();
		}
		sql = "delete from trial_acct_transaction where documentserialno='"+getObjectNo()+"'";
		Sqlca.executeSQL(new SqlObject(sql));
		sql = "delete from trial_acct_payment_schedule where objectno='"+serialno+"' or relativeobjectno= '"+serialno+"'";
		Sqlca.executeSQL(new SqlObject(sql));
		sql = "delete from trial_acct_loan where putoutno ='"+getObjectNo()+"'";
		Sqlca.executeSQL(new SqlObject(sql));
		sql = "delete from trial_acct_fee where objectno ='"+serialno+"'";
		Sqlca.executeSQL(new SqlObject(sql));
	}
	/**
	 * С��λ����
	 * @param d
	 * @return	
	 * @throws Exception
	 */
	private double fix(double d) throws Exception {
		double temp = d * 10;
		double value1 = Math.ceil(temp);//��λȡ��
		double finalyvalue = value1/10;
		if(d==Math.floor(d)){
			finalyvalue = d;
		}
		return finalyvalue;
	}
	
	/**
	 * ����BUSINESS_CREDIT.STATUS
	 * @param transaction
	 * @return
	 */
	public String updateBusinessCredit(Transaction transaction) {
		
		String sql = "SELECT COUNT(1) AS CNT FROM BUSINESS_CREDIT WHERE CONTRACT_NO = :CONTRACT_NO";
		ASResultSet rs = null; 
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		String dateStr = sdf.format(date);
		
		try {
			int cnt = 0;
			rs = transaction.getASResultSet(new SqlObject(sql).setParameter("CONTRACT_NO", objectNo));
			if (rs.next()) {
				cnt = rs.getInt("CNT");
			}
			
			if ("".equals(type)) {
				type = "0";
			}
			
			if (cnt != 0) {
				sql = "UPDATE BUSINESS_CREDIT SET STATUS = :STATUS, UPDATE_USER = :UPDATE_USER, " 
						+ "UPDATE_ORG = :UPDATE_ORG, UPDATE_TIME = :UPDATE_TIME " 
						+ "WHERE CONTRACT_NO = :CONTRACT_NO";
				transaction.executeSQL(new SqlObject(sql)
								.setParameter("STATUS", type)
								.setParameter("CONTRACT_NO", objectNo)
								.setParameter("UPDATE_USER", userID)
								.setParameter("UPDATE_ORG", org)
								.setParameter("UPDATE_TIME", dateStr));
			} else {
				sql = "INSERT INTO BUSINESS_CREDIT (CONTRACT_NO, STATUS, INPUT_USER, INPUT_ORG, "
						+ "INPUT_TIME, UPDATE_USER, UPDATE_ORG, UPDATE_TIME, REMARK) VALUES "
						+ "(:CONTRACT_NO, :STATUS, :INPUT_USER, :INPUT_ORG, :INPUT_TIME, "
						+ ":UPDATE_USER, :UPDATE_ORG, :UPDATE_TIME, :REMARK)";
				transaction.executeSQL(new SqlObject(sql)
								.setParameter("CONTRACT_NO", objectNo)
								.setParameter("STATUS", type)
								.setParameter("INPUT_USER", userID)
								.setParameter("INPUT_ORG", org)
								.setParameter("INPUT_TIME", dateStr)
								.setParameter("UPDATE_USER", userID)
								.setParameter("UPDATE_ORG", org)
								.setParameter("UPDATE_TIME", dateStr)
								.setParameter("REMARK", ""));
			}
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error(e.getMessage());
			try {
				transaction.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			return "FALSE";
		} finally {
			try {
				if (rs != null) {
					rs.getStatement().close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return "SUCCESS";
	}
	
	/**
	 * �ж��Ƿ���Ҫ�������ɻ���ƻ�
	 * @param transaction
	 * @return
	 */
	public String gainIsGenSchedule(Transaction transaction) {
		
		String res = "";
		String sql = "SELECT STATUS FROM BUSINESS_CREDIT WHERE CONTRACT_NO = :CONTRACT_NO";
		ASResultSet rs = null;
		try {
			rs = transaction.getASResultSet(new SqlObject(sql).setParameter("CONTRACT_NO", objectNo));
			if (rs.next()) {
				res = rs.getString("STATUS");
			}
		} catch(Exception e) {
			ARE.getLog().error(e.getMessage());
			return "";
		}
		
		return res;
	}
	/**
	 * //CCS-1247 add by zty �жϴ������ͣ����۷�ʽ�Լ��˺������Ϣ�Ƿ�Ϊ��
	 * @param Sqlca
	 * @throws SQLException
	 * @throws Exception
	 */
	public String validateAccountInfo(){
		ARE.getLog().info("��ʼУ��������ͣ����۷�ʽ�Լ��˺������Ϣ�Ƿ�Ϊ�գ�" + "productId="+productId+"repaymentWay="+repaymentWay+"city="+city+"replaceAccount="+replaceAccount+"replaceName="+replaceName);
		if(productId == null || "".equals(productId)){
			return "����������Ϣ��ʧ��";
		}
		
		if(repaymentWay == null || "".equals(repaymentWay)){
			return "���۷�ʽ��Ϣ��ʧ��";
		}
		
		if("1".equals(repaymentWay)){
			
			if(openBank == null || "".equals(openBank)){
				return "����/�ſ��˺ſ�������Ϣ��ʧ��";
			}
			
			if(city == null || "".equals(city)){
				return "����/�ſ��˺�ʡ����Ϣ��ʧ��";
			}
			
			if(replaceAccount == null || "".equals(replaceAccount)){
				return "����/�ſ��˺���Ϣ��ʧ��";
			}
			
			if(replaceName == null || "".equals(replaceName)){
				return "����/�ſ��˺Ż�����Ϣ��ʧ��";
			}
			
			if("020".equals(productId)){
				if(openBranch == null || "".equals(openBranch)){
					return "����/�ſ��˺ſ���֧����Ϣ��ʧ��";
				}
			}
		}
		
		return "SUCCESS";

	}
	
	public String getTermID() {
		return termID;
	}
	public void setTermID(String termID) {
		this.termID = termID;
	}
	public String getObjectType() {
		return objectType;
	}
	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getBusinessType() {
		return businessType;
	}
	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}
	public String getCreditCycle() {
		return creditCycle;
	}
	public void setCreditCycle(String creditCycle) {
		this.creditCycle = creditCycle;
	}
	public String getReplaceAccount() {
		return replaceAccount;
	}
	public void setReplaceAccount(String replaceAccount) {
		this.replaceAccount = replaceAccount;
	}
	public String getReplaceName() {
		return replaceName;
	}
	public void setReplaceName(String replaceName) {
		this.replaceName = replaceName;
	}

	public int getiPeriods() {
		return iPeriods;
	}

	public void setiPeriods(int iPeriods) {
		this.iPeriods = iPeriods;
	}

	public String getdMonthlyInterstRate() {
		return dMonthlyInterstRate;
	}

	public void setdMonthlyInterstRate(String dMonthlyInterstRate) {
		this.dMonthlyInterstRate = dMonthlyInterstRate;
	}

	public String getBusinessSum() {
		return businessSum;
	}

	public void setBusinessSum(String businessSum) {
		this.businessSum = businessSum;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getOrg() {
		return org;
	}

	public void setOrg(String org) {
		this.org = org;
	}

	public String getBuyPayPkgind() {
		return buyPayPkgind;
	}

	public void setBuyPayPkgind(String buyPayPkgind) {
		this.buyPayPkgind = buyPayPkgind;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getRepaymentWay() {
		return repaymentWay;
	}

	public void setRepaymentWay(String repaymentWay) {
		this.repaymentWay = repaymentWay;
	}

	public String getOpenBranch() {
		return openBranch;
	}

	public void setOpenBranch(String openBranch) {
		this.openBranch = openBranch;
	}

	public String getOpenBank() {
		return openBank;
	}

	public void setOpenBank(String openBank) {
		this.openBank = openBank;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}
	
	
	
	
}

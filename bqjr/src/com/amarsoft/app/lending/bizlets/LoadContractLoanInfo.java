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
 * @return 试算结果（每月还款额、首次还款额）
 * @update 更新合同核算信息
 * 
 */
public class LoadContractLoanInfo {
	
	/** 还款方式（组件ID） **/
	private String termID;
	
	/** 对象类型 **/
	private String objectType = BUSINESSOBJECT_CONSTATNTS.business_contract;
	
	/** 对象编号（目前一般为合同号） **/
	private String objectNo;
	
	/** 当前用户编号 **/
	private String userID;
	
	/** 产品代码 **/
	private String businessType;
	
	/** 是否投保 **/
	private String creditCycle;
	
	/** 代扣帐号 **/
	private String replaceAccount;
	
	/** 代扣帐号名 **/
	private String replaceName;
	
	/** 期限 **/
	private int iPeriods = 0;
	
	/** 产品月利率 **/
	private String dMonthlyInterstRate;
	
	/** 贷款本金 **/
	private String businessSum = "";
	
	/** 0-缓存；1-保存；2-生成计划 **/
	private String type;
	
	/** 当前用户所在机构 **/
	private String org;
	
	/** 是否购买随心还服务包 **/
	private String buyPayPkgind;
	
	/** 贷款类型 **/
	private String productId;
	
	/**代扣方式**/
	private String repaymentWay;
	
	/**开户行支行**/
	private String openBranch;
	
	/**开户行**/
	private String openBank;
	
	/**代扣放款账号城市**/
	private String city;
	
	/**
	 * 初始化合同的还款信息：
	 * <li>首次还款日、首次还款额</li>
	 * <li>每月还款日、每月还款额</li>
	 * <li>合同生效日、合同到期日</li>
	 * <li>放款账号信息、还款账号信息</li>
	 * @param Sqlca
	 * @retur 还款试算结果
	 */
	public String initContractLoanInfo(Transaction Sqlca){
		//校验账户相关信息 CCS-1247 add by zty 
		String returnStr = validateAccountInfo();
		if(!"SUCCESS".equals(returnStr)){
			throw new RuntimeException(returnStr);
		}
		String company = "";
		JBOTransaction tx = null;
		try {
			// 引入jbo对象注册
			tx = JBOFactory.createJBOTransaction();
			tx.join(Sqlca);// 本方法中实际使用的是JBO事务管理
			//验证合同关键内容是否有改变
			String v_sql = "select bc.creditcycle,bci.status,bc.businesstype,bc.businesssum, bc.bugPaypkgind,i.company from  business_contract bc"
					+ " left join BUSINESS_CREDIT bci on bc.serialno=bci.contract_no left join store_info i on bc.stores=i.sno where bc.serialno=:CONTRACT_NO";
			// 6.更新是否重新生成还款信息（保存一次重置一次）
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
			//如果产品代码 或是否投保 或贷款本金发生改变时，把状态置为已保存 重置生成还款计划标志为已保存合同状态（BUSINESS_CREDIT.STATUS）
			if (!businessType.equals(oldbusinessType) || !creditCycle.equals(oldCreditcycle) 
					|| !businessSum.equals(oldBusinesssum) || !buyPayPkgind.equals(oldBugPaypkgind)) {
				type = "1";
			}
			
			// 1.加载产品信息
			ProductManage productManage = new ProductManage(Sqlca);;
			setTermID("RPT17");// 等额本息
			productManage.setAttribute("TermID",  getTermID());
			productManage.setAttribute("ObjectType", getObjectType());
			productManage.setAttribute("ObjectNo", getObjectNo());
			productManage.initObjectWithProduct();
			setTermID("RAT002");// 固定利率
			productManage.setAttribute("TermID", getTermID());
			productManage.initObjectWithProduct();
			
			// 2.费用创建
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
				iPeriods = rs.getInt("term");// 期次
				dMonthlyInterstRate = rs.getString("MONTHLYINTERESTRATE");// 产品月利率
			}
			rs.getStatement().close();
			if(!"1".equals(getCreditCycle())){// 不投保，清除投保相关费用
				String deleteFee ="DELETE from acct_fee where feetype='A12' and objecttype='jbo.app.BUSINESS_CONTRACT' and objectno='"+getObjectNo()+"'";
				Sqlca.executeSQL(new SqlObject(deleteFee));
			}else{
				// 是否有保险费
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
			// 3. 是否购买随心还服务包
			if (!"1".equals(buyPayPkgind)) {		// 不购买随心还服务包
				sql = "DELETE FROM ACCT_FEE WHERE FEETYPE = 'A18' AND OBJECTTYPE = " 
						+ "'jbo.app.BUSINESS_CONTRACT' AND OBJECTNO = :OBJECTNO";
				Sqlca.executeSQL(new SqlObject(sql).setParameter("OBJECTNO", getObjectNo()));
			} else {
				// 获取合同对应产品的随心还服务费的TermID
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
			
			// 4.更新账户信息
			accountDeposit(Sqlca);
			
			// 5.加载费用减免信息
			InsertFeeWaive insertFeeWaive = new InsertFeeWaive();
			insertFeeWaive.setAttribute("UserID", getUserID());
			insertFeeWaive.setAttribute("BusinessType",getBusinessType());//产品代码
			insertFeeWaive.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.business_contract);//对象类型
			insertFeeWaive.setAttribute("ObjectNo",getObjectNo());//合同号
			insertFeeWaive.run(Sqlca);
			
			// 6.更新日期信息
			SetBusinessMaturity(Sqlca);
			
			if (status != null && !"".equals(status)) {
				// 如果type 不等于空字符串或空值的时候，才需要执行更新操作。
				if (type == null || "".equals(type)) {
					// 如果type为空时，判断存在
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
			// 移除还款试算，将功能移到“生成还款信息”按钮上
			// 7.还款试算
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
			ARE.getLog().error("合同保存失败：" + e);
			return "Error";
		}
		
	}
	
	/**
	 * 更新账户信息
	 * @throws Exception 
	 */
	private void accountDeposit(Transaction Sqlca) throws Exception{
		if(getReplaceAccount()==null||getReplaceAccount().length()<=0){
			setReplaceAccount("XFD"+getObjectNo());
		}
		if(getReplaceName()==null||getReplaceName().length()<=0){
			setReplaceName("消费贷客户");
		}
		
		//新增账户信息
		String insertDeposit = "insert into acct_deposit_accounts (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS) "+
				" values (:sSerialno, '"+getObjectNo()+"', '"+BUSINESSOBJECT_CONSTATNTS.business_contract+"', '01', '"+getReplaceAccount()+"', '01', '"+getReplaceName()+"', '2', '1', '', :sAccountIdicator, '0')";
		//更新账户信息		
		String updateSql ="update acct_deposit_accounts set "
				+ " accountno = '"+getReplaceAccount()+"', accountname = '"+getReplaceName()+"' "
				+ " where objecttype = 'jbo.app.BUSINESS_CONTRACT' and accountindicator = :sAccountIdicator and OBJECTNO = '"+getObjectNo()+"'";
		//查询该笔合同关联的扣款卡号是否存在
		String accountIndicatorsql ="select count(1) from ACCT_DEPOSIT_ACCOUNTS " 
				+ " where ObjectNo='"+getObjectNo()+"' and ObjectType='"+BUSINESSOBJECT_CONSTATNTS.business_contract+"'"
				+ " and AccountIndicator =:accountIndicator and status = '0'";
		
		//更新还款账户信息
		Double count = Sqlca.getDouble(new SqlObject(accountIndicatorsql).setParameter("accountIndicator", "01"));
		if(count>0){//帐号存在，更新帐号信息
			Sqlca.executeSQL(new SqlObject(updateSql).setParameter("sAccountIdicator", "01"));
		}else{//创建账号信息
			String sSerialno = DBKeyHelp.getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo");
			Sqlca.executeSQL(new SqlObject(insertDeposit).setParameter("sAccountIdicator", "01").setParameter("sSerialno", sSerialno));
		}
		
		//更新放款账户信息
		Double putOutCount = Sqlca.getDouble(new SqlObject(accountIndicatorsql).setParameter("accountIndicator", "00"));
		if(putOutCount>0){//帐号存在，更新放款帐号信息
			Sqlca.executeSQL(new SqlObject(updateSql).setParameter("sAccountIdicator", "00"));
		}else{
			String sSerialno = DBKeyHelp.getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo");
			Sqlca.executeSQL(new SqlObject(insertDeposit).setParameter("sAccountIdicator", "00").setParameter("sSerialno", sSerialno));
		}	
	}
	/**
	 * 设置合同日期
	 */
	public void SetBusinessMaturity(Transaction Sqlca) throws Exception{
		//变量定义
		String PutOutDate = "";//放款日
		String sFirstDueDate = "";//首次还款日
		String sDefaultDueDay = "";//每月还款日
		String temDay = "";//中间变量
		
		//日期计算
		String businessDate = SystemConfig.getBusinessDate();//当前业务时间
		//1.放款日取系统当前业务时间
		PutOutDate = businessDate;
		
		//2.判断每月还款日与首次还款日
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
		
		//3.一个客户多个合同的情况，判定首次还款日，取客户之前最早的合同
		String sFirstNextDueDate = "";//客户历史首笔合同下个还款日
		int sDays = 0;
		String sCustomerID = Sqlca.getString("select customerid from business_contract where serialno = '"+getObjectNo()+"'");
		if(sCustomerID==null) throw new Exception("当前合同:["+getObjectNo()+"]中未正确保存客户信息"); 		

		String minSerialNo = Sqlca.getString(new SqlObject("SELECT min(serialno) FROM business_contract "
				+ " where finishdate is null and CONTRACTSTATUS = '050' and customerid = :CustomerID and serialno <> :serialno ")//查询范围：1.同一客户2.已注册3.未结清
				.setParameter("CustomerID", sCustomerID).setParameter("serialno", getObjectNo()));
		if (minSerialNo == null)			minSerialNo = "";
		if (!minSerialNo.equals("")) {
			sFirstNextDueDate = Sqlca.getString(new SqlObject(	"SELECT NEXTDUEDATE FROM acct_loan "
					+ " where loanstatus in ('0','1') and putoutno = :minSerialNo ").setParameter("minSerialNo", minSerialNo));
			if (sFirstNextDueDate == null)				sFirstNextDueDate = "";
		}
		
		if (sFirstNextDueDate.compareTo(businessDate) <= 0)	sFirstNextDueDate = sFirstDueDate;

		if (!sFirstNextDueDate.equals("")) {
			sDays = DateFunctions.getDays(businessDate,sFirstNextDueDate);//计算当前日期与下个还款日之间的间隔
			if (sDays >= 14) {//间隔大于等于14天，取历史合同的下个还款日
				sFirstDueDate = sFirstNextDueDate;
			} else {//间隔小于14天，取“下个还款日+1个月”
				sFirstDueDate = DateFunctions.getRelativeDate(sFirstNextDueDate,DateFunctions.TERM_UNIT_MONTH, 1);
			}
			sDefaultDueDay = sFirstDueDate.substring(8, 10);
		}
		//4.计算到期日
		String sMaturity = DateFunctions.getRelativeDate(businessDate,DateFunctions.TERM_UNIT_MONTH, iPeriods);
		double dBusinessSum = Double.valueOf(getBusinessSum());
		
		//5.更新还款信息表的首次还款日和每月还款日
		if(sFirstDueDate.length()<=0||sDefaultDueDay.length()<=0||PutOutDate.length()<=0||sMaturity.length()<=0){
			throw new Exception("合同日期计算失败！");
		}
		String sql = "update acct_rpt_segment set FirstDueDate = '"+sFirstDueDate+"' , defaultDueDay = '"+sDefaultDueDay+"' where ObjectNo = '"+getObjectNo()+"'";
		Sqlca.executeSQL(new SqlObject(sql));
		ARE.getLog().info("更新还款信息表的首次还款日和每月还款日SQL:"+sql);
		//6.更新合同表的首次还款日、放款日、合同生效日和到期日
		//新增更新合同表的代扣方式、贷款类型、以及账号相关信息 CCS-1247 add by zty
		sql = "update BUSINESS_CONTRACT set BusinessSum = '"+dBusinessSum+"' , ORIGINALPUTOUTDATE = '"+sFirstDueDate+"' , PutOutDate = '"+PutOutDate+"', contractEffectiveDate = '"+PutOutDate+"', Maturity = '"+sMaturity;
		if("1".equals(getRepaymentWay())){
			sql = sql + "' ,openbank = '" + getOpenBank() +"',city = '" + getCity() + "' ,replaceaccount = '" + getReplaceAccount() + "' ,replacename = '" + getReplaceName();
			if("020".equals(productId)){
				sql = sql + "',openbranch = '" + getOpenBranch();
			}
		}
		sql = sql + "' where SerialNo = '"+getObjectNo()+"'";
		Sqlca.executeSQL(new SqlObject(sql));
		ARE.getLog().info("更新合同表的首次还款日、放款日、合同生效日和到期日,代扣方式、贷款类型、以及账号相关信息SQL:"+sql);
		
	}

	/**
	 * 还款试算
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String firstMonthPayTry(Transaction Sqlca) throws Exception{
		
		JBOTransaction tx = null;
		double paymentValueMonth = 0.0;						// 每月还款额
		double Firstpaymentend = 0.0;						// 首次还款额
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		String dateStr = sdf.format(date);
		try {
			// 引入jbo对象注册
			tx = JBOFactory.createJBOTransaction();
			tx.join(Sqlca);// 本方法中实际使用的是JBO事务管理
			PutOutLoanTry putOutLoanTry = new PutOutLoanTry();	// 还款试算
			putOutLoanTry.setAttribute("ObjectNO", getObjectNo());
			String result = (String) putOutLoanTry.run(Sqlca);	// 试算结果
			ARE.getLog().info("还款试算结果："+result);
			
			String paymentValue1 = result.split("@")[0];		// 第一期应还总金额
			String paymentValue2 = result.split("@")[1];		// 第二期应还总金额
			String paymentValueEnd = result.split("@")[2];		// 最后一期应还总金额
			// String totalPaylAmt1 = result.split("@")[3];		// 第一期应还本息
			// String totalPaylAmt2 = result.split("@")[4];		// 第二期应还本息
			if(Double.valueOf(paymentValueEnd) > Double.valueOf(paymentValue2)){ 
				paymentValueMonth = Double.valueOf(paymentValueEnd);
			}else{ 
				paymentValueMonth = Double.valueOf(paymentValue2);
			}
			Firstpaymentend = Double.valueOf(paymentValue1);
			paymentValueMonth = fix(paymentValueMonth);
			Firstpaymentend = fix(Firstpaymentend);
			String sFirstpaymentend = Firstpaymentend + "";		// 由于数据库表结构问题，转为字符型
			if(paymentValueMonth <= 0 || Firstpaymentend < 0){
				throw new Exception("每月还款额或首次还款额试算失败！");
			}
			
			//更新合同的每月还款额和首次还款额
			String sql = "update Business_Contract set MonthRepayment = '" + paymentValueMonth + "'" 
						 + ", FIRSTDRAWINGDATE = '" + sFirstpaymentend + "' where SerialNo = '" 
						 + getObjectNo() + "'";
			Sqlca.executeSQL(new SqlObject(sql));
			deletedbByContract(Sqlca);							// 先删除临时表中数据
			updateDb(putOutLoanTry.getTransaction(), Sqlca);	// 保存还款计划相关信息到临时表
			
			// 更新合同表的生成还款计划状态
			// 6.更新是否重新生成还款信息（保存一次重置一次）
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
				throw new Exception("找到多条BUSINESS_CREDIT数据，合同号为：" + getObjectNo());
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
	 * 把对象转换成SQL语句，用于批量插入表
	 * @param list
	 * @return
	 * @throws Exception
	 */
	private String businessObjectToSQL(List<BusinessObject> list) throws Exception{
		StringBuffer sql = new StringBuffer();//要执行的SQL
		StringBuffer col = new StringBuffer();//表对应的列
		StringBuffer val = new StringBuffer();//表对应的值;
		if (list == null) {
			return "";
		}
		for(int i=0; i<list.size(); i++){
			BusinessObject bo = list.get(i);
			if(i==0){//第一条不需要加 UNION ALL 
				//根据对象类型截取表名
				String tableName = bo.getObjectType().substring(bo.getObjectType().lastIndexOf(".")+1,bo.getObjectType().length());
				// tableName+="_contract";
				tableName = "trial_" + tableName;
				sql.append(" insert into "+ tableName);
				val.append("select ");
				//遍历所属性，拼成SQL语句
				DataElement[] elements = bo.getBo().getAttributes();
				for(int j=0;j<elements.length;j++){
					DataElement de = elements[j];
					if(j==elements.length-1){//嘬后一个属性不需要加逗号
						col.append(de.getName() +" ");
						if(de.getValue() != null){
							val.append("'"+de.getValue()+"'");
						}else{
							val.append("''");
						}
					}else{//属性名+逗号
						col.append(de.getName() +", ");
						if(de.getValue() != null){
							val.append("'"+de.getValue()+"',");
						}else{
							val.append("'',");
						}
					}
				}
				val.append(" from dual ");
			}else{//其他 不需要加表对应的列名
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
	 * 根据合同号，删除临时数据
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
	 * 小数位处理
	 * @param d
	 * @return	
	 * @throws Exception
	 */
	private double fix(double d) throws Exception {
		double temp = d * 10;
		double value1 = Math.ceil(temp);//进位取整
		double finalyvalue = value1/10;
		if(d==Math.floor(d)){
			finalyvalue = d;
		}
		return finalyvalue;
	}
	
	/**
	 * 更新BUSINESS_CREDIT.STATUS
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
	 * 判断是否需要重新生成还款计划
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
	 * //CCS-1247 add by zty 判断贷款类型，代扣方式以及账号相关信息是否为空
	 * @param Sqlca
	 * @throws SQLException
	 * @throws Exception
	 */
	public String validateAccountInfo(){
		ARE.getLog().info("开始校验贷款类型，代扣方式以及账号相关信息是否为空：" + "productId="+productId+"repaymentWay="+repaymentWay+"city="+city+"replaceAccount="+replaceAccount+"replaceName="+replaceName);
		if(productId == null || "".equals(productId)){
			return "贷款类型信息丢失！";
		}
		
		if(repaymentWay == null || "".equals(repaymentWay)){
			return "代扣方式信息丢失！";
		}
		
		if("1".equals(repaymentWay)){
			
			if(openBank == null || "".equals(openBank)){
				return "代扣/放款账号开户行信息丢失！";
			}
			
			if(city == null || "".equals(city)){
				return "代扣/放款账号省市信息丢失！";
			}
			
			if(replaceAccount == null || "".equals(replaceAccount)){
				return "代扣/放款账号信息丢失！";
			}
			
			if(replaceName == null || "".equals(replaceName)){
				return "代扣/放款账号户名信息丢失！";
			}
			
			if("020".equals(productId)){
				if(openBranch == null || "".equals(openBranch)){
					return "代扣/放款账号开户支行信息丢失！";
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

package com.amarsoft.proj.action;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.amarsoft.app.als.sadre.util.DateUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * P2P额度公共类
 * @author jli5
 * @version
 *   1.0.0 
 *    		2015-1-22  下午4:42:49
 * @since
 *
 */
public class P2PCreditCommon {
	
	private static final String VIRTUAL_STORE = "4403000471";	//借钱么商户编号
	private static final String EBUYFUN = "4403000403";//易佰分产品门店对应的商户编号
	private static final String REPAYMENT_NO = "755920947910212";//还款账号
	private static final String REPAYMENT_BANK = "308";//还款账号开户行
	private static final String REPAYMENT_NAME = "深圳市佰仟金融服务有限公司";//还款账号户名
	
    private String ContractSerialNo="";//合同编号
    private Transaction Sqlca = null;
    private String curDay = StringFunction.getToday();
    private String curTime = StringFunction.getTodayNow(); 
    private SimpleDateFormat df =new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    private String serialNo = "";//p2p流水号
    private double dSum = 0;//剩余可用金额
    private String sureType = "";
    
    public P2PCreditCommon(String _ContractSerialNo,Transaction _Sqlca) {
        // TODO Auto-generated constructor stub
       this.setContractSerialNo(_ContractSerialNo);
       this.setSqlca(_Sqlca);
    }
    
    /**
     * 判断是否使用P2P
     * @throws SQLException 
     * @throws ParseException 
     */
    public synchronized boolean isUseP2P() throws Exception{
        ARE.getLog().debug("已进入P2P检查阶段。。。"+StringFunction.getNow());
        
        String sOperatormode = "";
        String sProductType = "";
        String sSubProductType = "";
        String stores = "";
        String sCustomerId = "";
		String sSureType = "";
        String sSql = "select bc.operatormode,bc.productid as productType,bc.SubProductType,bc.stores,bc.customerid,bc.suretype from business_contract bc where bc.serialno='" + ContractSerialNo + "'";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	sOperatormode = rs.getString("operatormode");
        	sProductType = rs.getString("productType");
        	sSubProductType = rs.getString("SubProductType");
        	stores = rs.getString("stores");
        	sCustomerId = rs.getString("customerid");
			sSureType = rs.getString("suretype");
        }
        rs.getStatement().close();
        
        String sRetailNo = "";
        sSql = "SELECT ri.rno FROM store_info si,retail_info ri where si.rserialno=ri.serialno and si.sno=:sno";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno", stores));
        if(rs.next()){
        	sRetailNo = rs.getString("rno");
        }
        
        //易佰分产品只做普通POS贷
        if( EBUYFUN.equals(sRetailNo) && "030".equals(sProductType) && "0".equals(sSubProductType) ){
        	sureType = "EBF";
        	this.addP2pBC(sCustomerId,sSubProductType,stores);
        	return true;
        }
        
        //虚拟门店 现金贷的预约现金贷和车主现金贷 为p2p合同
        if( VIRTUAL_STORE.equals(sRetailNo) && "020".equals(sProductType) 
        		&& ("1".equals(sSubProductType) || "3".equals(sSubProductType)) ){
        	sureType = "JQM";
        	this.addP2pBC(sCustomerId,sSubProductType,stores);	//虚拟门店也是p2p，走另外一套逻辑。
        	return true;
        }
        
        if("01".equals(sOperatormode)){
        	 ARE.getLog().debug("中域的单不做p2p");
             return false;
        }
		
        //zhangzhi
        if("JCC".equals(sSureType)){
        	ARE.getLog().debug("聚诚财富不用P2P额度");
        	return false;
        }
		        if( !"030".equals(sProductType) || !"0".equals(sSubProductType) ){
        	 ARE.getLog().debug("p2p只做普通消费贷");
             return false;
        }
        
        String ServiceProvidersSerialno = "";
        sSql ="select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName "+
        	  "from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '"+sSubProductType+"' "+
        	  "and pc.serialno=sp.serialno and sp.loaner = '020' and pc.areacode=(select si.city from store_info si where si.sno=:sno)";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno", stores));
        if(rs.next()){
        	ServiceProvidersSerialno = rs.getString("serialno");
        }else {
        	ARE.getLog().debug("门店所在城市没有p2p贷款人");
            return false;
		}
        rs.getStatement().close();
        
        //锁表
    	sSql = "update P2PCREDIT_INFO set totalsum=totalsum where EFFECTIVEDATE='"+curDay+"'";
    	Sqlca.executeSQL(new SqlObject(sSql));
        
        double dTotalSum = 0;	//总金额
        double dHaveUseSum = 0;	//已用金额
        double dUnsignedTotalSum = 0; //未签署P2P合同总金额
        String sUnsignedTotalSum = null;
        String sSerialNo = "";//P2P额度流水号
        sSql = "select TOTALSUM,HAVEUSESUM,UNSIGNEDTOTALSUM,SERIALNO from P2PCREDIT_INFO where EFFECTIVEDATE='"+curDay+"'";
        rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	dTotalSum = rs.getDouble("TOTALSUM");
        	dHaveUseSum = rs.getDouble("HAVEUSESUM");
            sSerialNo = DataConvert.toString(rs.getString("SERIALNO"));
            dUnsignedTotalSum = rs.getDouble("UNSIGNEDTOTALSUM");
            sUnsignedTotalSum = rs.getString("UNSIGNEDTOTALSUM");
        }
        rs.getStatement().close();
        
        
        //P2P贷款金额
        if(dTotalSum<=0){
        	Sqlca.commit();//提交 ，解除表锁定
        	ARE.getLog().debug("不存在当天P2P金额");
            return false;
        }
        //是否超过下午4点
        if(df.parse(curTime).getHours()>=16){
        	Sqlca.commit();//提交 ，解除表锁定
            ARE.getLog().debug("现在已过16点"+StringFunction.getNow());
        	return false;
        }
        
        // 表P2PCREDIT_INFO.UNSIGNEDTOTALSUM 没值，则取得今天之前未签署P2P合同的总金额，保存到UNSIGNEDTOTALSUM中
        if( sUnsignedTotalSum == null || "".equals(sUnsignedTotalSum) ){
        	//String now = DateUtil.getNowTime();
        	sSql = "SELECT sum(sum) as SUM FROM (SELECT sum(BC.Businesssum) as SUM FROM BUSINESS_CONTRACT BC, BUSINESS_CONTRACT_OTHERS BCO where bc.serialno = bco.serialno and bc.isp2p = '1' and (bc.suretype='PC' or bc.suretype='APP') and bc.contractStatus in ('020', '050') and bco.p2p_export_time is null union all SELECT sum(BC.Businesssum) as SUM FROM BUSINESS_CONTRACT BC where bc.isp2p = '1' and (bc.suretype='PC' or bc.suretype='APP') and bc.contractStatus in ('070', '080'))";
        	rs = Sqlca.getASResultSet(new SqlObject(sSql));
            if(rs.next()){
            	dUnsignedTotalSum = rs.getDouble("SUM");
            }
            rs.getStatement().close();
            
            sSql = "UPDATE  P2PCREDIT_INFO  SET UNSIGNEDTOTALSUM=:UNSIGNEDTOTALSUM   WHERE SERIALNO='"+sSerialNo+"'";
            Sqlca.executeSQL(new SqlObject(sSql).setParameter("UNSIGNEDTOTALSUM", dUnsignedTotalSum));
        }
        
        //根据合同里的门店信息，查询贷款人，判断是否存在P2P类型的贷款人
        //sSql = "select bc. from service_providers sp ,store_info si ,business_contract bc  where sp.city(+)=si.city and si.sno(+)=bc.stores and bc.serialNo='"+ContractSerialNo+"' ";
        double dBCSum = 0;
        String sCreditID = "";
        String sOldCreditID = "";
        String sStores = "";//门店编号
        String sIsP2p = "";
        sSql = "SELECT BUSINESSSUM,CREDITID,STORES,CUSTOMERID,ISP2P,SURETYPE FROM BUSINESS_CONTRACT WHERE SERIALNO='"+ContractSerialNo+"'";
        rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
            dBCSum = rs.getDouble("BUSINESSSUM");
            sOldCreditID = DataConvert.toString(rs.getString("CREDITID"));
            sStores = DataConvert.toString(rs.getString("STORES"));
            sCustomerId = DataConvert.toString(rs.getString("CUSTOMERID"));
            sIsP2p = DataConvert.toString(rs.getString("ISP2P"));
            sureType = DataConvert.toString(rs.getString("SURETYPE"));
        }
        rs.getStatement().close();
        
        if( "1".equals(sIsP2p) ){
        	Sqlca.commit();//提交 ，解除表锁定
        	ARE.getLog().debug("已是p2p");
            return false;
        }
        //合同金额大于可用金额
        if( dBCSum > dTotalSum-dHaveUseSum-dUnsignedTotalSum ){
        	Sqlca.commit();//提交 ，解除表锁定
            ARE.getLog().debug("当天P2P可用金额不足");
            return false;
        }
        ARE.getLog().debug("已确定该合同可使用P2P来源，开始同步P2P贷款人信息。。。"+StringFunction.getNow());
        
        dSum =Arith.add(dHaveUseSum, dBCSum); 
        
        sCreditID = ServiceProvidersSerialno;
        
        //获取贷款人的相关信息
        String RepaymentNo = "";//还款账号
        String RepaymentBank = "";//还款账号开户行
        String RepaymentName = "";//还款账号户名
        String RepaymentBankName = "";
        String sCreditPerson = "";
        /*sSql = "select backAccountPrefix,turnAccountName,turnAccountBlank,getItemName('BankCode',turnAccountBlank) as RepaymentBankName,Serviceprovidersname from Service_Providers where SerialNo =:SerialNo";*/
        sSql = "select pc.backAccountPrefix,pc.turnAccountName,pc.turnAccountBlank,getItemName('BankCode',pc.turnAccountBlank) as RepaymentBankName,sp.Serviceprovidersname from "+ 
        	   "Service_Providers sp, ProvidersCity pc where sp.SerialNo =:SerialNo and pc.serialno = sp.serialno and sp.loaner = '020' and sp.customertype1 = '06' and pc.ProductType = '"+sSubProductType+"' "+
        	   "and pc.areacode =(select si.city from store_info si where si.sno=:sno)";
        SqlObject soSer = new SqlObject(sSql).setParameter("SerialNo", sCreditID).setParameter("sno", stores);
        rs = Sqlca.getASResultSet(soSer);
        if(rs.next()){
            RepaymentNo = rs.getString("backAccountPrefix");
            RepaymentBank = rs.getString("turnAccountBlank");
            RepaymentName = rs.getString("turnAccountName");
            RepaymentBankName = rs.getString("RepaymentBankName");
            sCreditPerson = rs.getString("Serviceprovidersname");
        }
        rs.getStatement().close();
        
        if(RepaymentNo == null || RepaymentNo == "") RepaymentNo = REPAYMENT_NO; 
        if(RepaymentBank == null || RepaymentBank == "") RepaymentBank = REPAYMENT_BANK;
        if(RepaymentName == null || RepaymentName == "") RepaymentName = REPAYMENT_NAME;
        if(sCreditPerson == null || sCreditPerson == "") sCreditPerson = "P2P";
      
        RepaymentNo += sCustomerId;
        
        sSql = "Update Business_Contract set  ISP2P='1',RepaymentNo='"+RepaymentNo+"',RepaymentBank='"+RepaymentBank+"',RepaymentName='"+RepaymentName+"',creditid='"+sCreditID+"',creditperson='"+sCreditPerson+"'  where  SerialNo='"+ContractSerialNo+"'";
        Sqlca.executeSQL(new SqlObject(sSql));
        
        sSql = "UPDATE  P2PCREDIT_INFO  SET HAVEUSESUM=:HAVEUSESUM   WHERE SERIALNO='"+sSerialNo+"'";
        Sqlca.executeSQL(new SqlObject(sSql).setParameter("HAVEUSESUM", dSum));
        
        sSql = "insert when (not exists (select 1 from business_contract_others where serialno = :SERIALNO)) then into business_contract_others(serialno) select :SERIALNO from dual";
        Sqlca.executeSQL(new SqlObject(sSql).setParameter("SERIALNO", ContractSerialNo));
        
        Sqlca.commit();//提交 ，解除表锁定
        ARE.getLog().debug("P2P贷款人信息同步完毕。。。"+StringFunction.getNow());
        
        return true;
    }
    
    public void addP2pBC(String sCustomerId,String sSubProductType,String stores) throws Exception{
    	
    	//获取贷款人的相关信息
        String RepaymentNo = "";//还款账号
        String RepaymentBank = "";//还款账号开户行
        String RepaymentName = "";//还款账号户名
        String sCreditID = "";
        String sCreditPerson = "";
        /*String sSql = "select serialno,backAccountPrefix,turnAccountName,turnAccountBlank,getItemName('BankCode',turnAccountBlank) as RepaymentBankName,Serviceprovidersname from Service_Providers where producttype='070'";*/
        
        String sSql = "select max(serialno) as serialno from Service_Providers where loaner = '020'";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sSubProductType", sSubProductType).setParameter("sno", stores));
        if(rs.next()){
        	sCreditID = rs.getString("serialno");
        	/*RepaymentNo = rs.getString("backAccountPrefix");
            RepaymentBank = rs.getString("turnAccountBlank");
            RepaymentName = rs.getString("turnAccountName");
            sCreditPerson = rs.getString("Serviceprovidersname");*/
        }
        rs.getStatement().close();
    
        if(RepaymentNo == null || RepaymentNo == "") RepaymentNo = REPAYMENT_NO; 
        if(RepaymentBank == null || RepaymentBank == "") RepaymentBank = REPAYMENT_BANK;
        if(RepaymentName == null || RepaymentName == "") RepaymentName = REPAYMENT_NAME;
        if(sCreditPerson == null || sCreditPerson == "") sCreditPerson = "P2P";
        
        RepaymentNo += sCustomerId;
        sSql = "Update Business_Contract set  ISP2P='1',RepaymentNo='"+RepaymentNo+"',RepaymentBank='"+RepaymentBank+"',RepaymentName='"+RepaymentName+"',creditid='"+sCreditID+"',creditperson='"+sCreditPerson+"',sureType='"+sureType+"'  where  SerialNo='"+ContractSerialNo+"'";
        Sqlca.executeSQL(new SqlObject(sSql));
    	
    	sSql = "insert when (not exists (select 1 from business_contract_others where serialno = :SERIALNO)) then into business_contract_others(serialno) select :SERIALNO from dual";
        Sqlca.executeSQL(new SqlObject(sSql).setParameter("SERIALNO", ContractSerialNo));
    }
    
    /**
     * 取消合同时，检查是否需要返回p2p额度
     * @author Dahl
     * @date 2015年5月6日
     */
    public void checkReturnP2pSum() throws Exception{
    	ARE.getLog().debug("检查是否需要返回p2p额度开始:" + ContractSerialNo);
    	double dBusinesssum = 0;//贷款金额
    	String sSureType = "";//贷款类型
    	String sContractStatus = "";//合同状态
    	String sIsp2p = "";
    	String sSql = "select bc.Businesssum,bc.SureType,bc.ContractStatus,bc.isp2p from business_contract bc where bc.serialno='" + ContractSerialNo + "'";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	dBusinesssum = rs.getDouble("Businesssum");
        	sSureType = rs.getString("SureType");
        	sContractStatus = rs.getString("ContractStatus");
        	sIsp2p = DataConvert.toString(rs.getString("isp2p"));
        }
        rs.getStatement().close();
        ARE.getLog().debug(dBusinesssum+"----"+sIsp2p+"----"+sSureType+"----"+sContractStatus);
        
        if( "1".equals(sIsp2p) && ("PC".equals(sSureType) || "APP".equals(sSureType)) ){
        	returnP2pSum(dBusinesssum);//返回p2p额度
        }
        ARE.getLog().debug("检查是否需要返回p2p额度结束:" + ContractSerialNo);
    }
    
    /**
     * 返回p2p额度
     * @author Dahl
     * @date 2015年5月6日
     */
    public synchronized void returnP2pSum(double dBusinesssum) throws Exception{
    	ARE.getLog().debug("返回p2p额度开始:" + ContractSerialNo);
    	String sSerialNo = "";
    	double dHaveUseSum = 0;//已用金额
    	double dUnsignedTotalSum = 0;//未签署金额
    	String sUnsignedTotalSum = "";
    	//锁表
    	String sSql = "update P2PCREDIT_INFO set totalsum=totalsum where EFFECTIVEDATE='"+curDay+"'";
    	Sqlca.executeSQL(new SqlObject(sSql));
    	
    	sSql = "select SERIALNO,HAVEUSESUM,UNSIGNEDTOTALSUM from P2PCREDIT_INFO where EFFECTIVEDATE='"+curDay+"'";
    	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	sSerialNo = DataConvert.toString(rs.getString("SERIALNO"));
        	dHaveUseSum = rs.getDouble("HAVEUSESUM");
        	dUnsignedTotalSum = rs.getDouble("UNSIGNEDTOTALSUM");
        	sUnsignedTotalSum = rs.getString("UNSIGNEDTOTALSUM");
        }
        
        String sSubmitTime = "";//合同提交时间
        sSql = "SELECT endTime as submitTime FROM flow_task t where t.phaseno='0010' and t.objectno='"+ContractSerialNo+"'";
        		//"SELECT submitTime FROM RULE_RUN_LOG where bcserialno='"+ContractSerialNo+"'";
        rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	sSubmitTime = DataConvert.toString(rs.getString("submitTime"));
        }
        
       //提交日期是今天的，则扣减已用额度
        if( sSubmitTime != null && sSubmitTime.contains(curDay) ){
        	dHaveUseSum = Arith.sub(dHaveUseSum, dBusinesssum) ;
        	if( dHaveUseSum < 0 ){
        		dHaveUseSum = 0;//已用额度不能小于0
        	}
        	sSql = "UPDATE  P2PCREDIT_INFO  SET HAVEUSESUM=:HAVEUSESUM   WHERE SERIALNO='"+sSerialNo+"'";
        	Sqlca.executeSQL(new SqlObject(sSql).setParameter("HAVEUSESUM", dHaveUseSum));
        }else{ //提交日期不是今天的，则扣减未签署金额	
        	//未签署金额未赋值，则说明未计算p2p未签署金额,必须有值才扣额度
        	if ( sUnsignedTotalSum != null && !"".equals(sUnsignedTotalSum) ){
        		dUnsignedTotalSum = Arith.sub(dUnsignedTotalSum, dBusinesssum) ;
        		if( dUnsignedTotalSum < 0 ){
        			dUnsignedTotalSum = 0;//未签署不能小于0
        		}
        		sSql = "UPDATE  P2PCREDIT_INFO  SET UNSIGNEDTOTALSUM=:UNSIGNEDTOTALSUM   WHERE SERIALNO='"+sSerialNo+"'";
        		Sqlca.executeSQL(new SqlObject(sSql).setParameter("UNSIGNEDTOTALSUM", dUnsignedTotalSum));
        	}
        }
        
        ARE.getLog().debug("返回p2p额度结束:" + ContractSerialNo);
    }
    
    public String getContractSerialNo() {
        return ContractSerialNo;
    }

    public void setContractSerialNo(String contractSerialNo) {
        ContractSerialNo = contractSerialNo;
    }

    public Transaction getSqlca() {
        return Sqlca;
    }

    public void setSqlca(Transaction sqlca) {
        Sqlca = sqlca;
    }
    
}

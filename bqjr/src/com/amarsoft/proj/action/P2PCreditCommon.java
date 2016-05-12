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
 * P2P��ȹ�����
 * @author jli5
 * @version
 *   1.0.0 
 *    		2015-1-22  ����4:42:49
 * @since
 *
 */
public class P2PCreditCommon {
	
	private static final String VIRTUAL_STORE = "4403000471";	//��Ǯô�̻����
	private static final String EBUYFUN = "4403000403";//�װ۷ֲ�Ʒ�ŵ��Ӧ���̻����
	private static final String REPAYMENT_NO = "755920947910212";//�����˺�
	private static final String REPAYMENT_BANK = "308";//�����˺ſ�����
	private static final String REPAYMENT_NAME = "�����а�Ǫ���ڷ������޹�˾";//�����˺Ż���
	
    private String ContractSerialNo="";//��ͬ���
    private Transaction Sqlca = null;
    private String curDay = StringFunction.getToday();
    private String curTime = StringFunction.getTodayNow(); 
    private SimpleDateFormat df =new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    private String serialNo = "";//p2p��ˮ��
    private double dSum = 0;//ʣ����ý��
    private String sureType = "";
    
    public P2PCreditCommon(String _ContractSerialNo,Transaction _Sqlca) {
        // TODO Auto-generated constructor stub
       this.setContractSerialNo(_ContractSerialNo);
       this.setSqlca(_Sqlca);
    }
    
    /**
     * �ж��Ƿ�ʹ��P2P
     * @throws SQLException 
     * @throws ParseException 
     */
    public synchronized boolean isUseP2P() throws Exception{
        ARE.getLog().debug("�ѽ���P2P���׶Ρ�����"+StringFunction.getNow());
        
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
        
        //�װ۷ֲ�Ʒֻ����ͨPOS��
        if( EBUYFUN.equals(sRetailNo) && "030".equals(sProductType) && "0".equals(sSubProductType) ){
        	sureType = "EBF";
        	this.addP2pBC(sCustomerId,sSubProductType,stores);
        	return true;
        }
        
        //�����ŵ� �ֽ����ԤԼ�ֽ���ͳ����ֽ�� Ϊp2p��ͬ
        if( VIRTUAL_STORE.equals(sRetailNo) && "020".equals(sProductType) 
        		&& ("1".equals(sSubProductType) || "3".equals(sSubProductType)) ){
        	sureType = "JQM";
        	this.addP2pBC(sCustomerId,sSubProductType,stores);	//�����ŵ�Ҳ��p2p��������һ���߼���
        	return true;
        }
        
        if("01".equals(sOperatormode)){
        	 ARE.getLog().debug("����ĵ�����p2p");
             return false;
        }
		
        //zhangzhi
        if("JCC".equals(sSureType)){
        	ARE.getLog().debug("�۳ϲƸ�����P2P���");
        	return false;
        }
		        if( !"030".equals(sProductType) || !"0".equals(sSubProductType) ){
        	 ARE.getLog().debug("p2pֻ����ͨ���Ѵ�");
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
        	ARE.getLog().debug("�ŵ����ڳ���û��p2p������");
            return false;
		}
        rs.getStatement().close();
        
        //����
    	sSql = "update P2PCREDIT_INFO set totalsum=totalsum where EFFECTIVEDATE='"+curDay+"'";
    	Sqlca.executeSQL(new SqlObject(sSql));
        
        double dTotalSum = 0;	//�ܽ��
        double dHaveUseSum = 0;	//���ý��
        double dUnsignedTotalSum = 0; //δǩ��P2P��ͬ�ܽ��
        String sUnsignedTotalSum = null;
        String sSerialNo = "";//P2P�����ˮ��
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
        
        
        //P2P������
        if(dTotalSum<=0){
        	Sqlca.commit();//�ύ �����������
        	ARE.getLog().debug("�����ڵ���P2P���");
            return false;
        }
        //�Ƿ񳬹�����4��
        if(df.parse(curTime).getHours()>=16){
        	Sqlca.commit();//�ύ �����������
            ARE.getLog().debug("�����ѹ�16��"+StringFunction.getNow());
        	return false;
        }
        
        // ��P2PCREDIT_INFO.UNSIGNEDTOTALSUM ûֵ����ȡ�ý���֮ǰδǩ��P2P��ͬ���ܽ����浽UNSIGNEDTOTALSUM��
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
        
        //���ݺ�ͬ����ŵ���Ϣ����ѯ�����ˣ��ж��Ƿ����P2P���͵Ĵ�����
        //sSql = "select bc. from service_providers sp ,store_info si ,business_contract bc  where sp.city(+)=si.city and si.sno(+)=bc.stores and bc.serialNo='"+ContractSerialNo+"' ";
        double dBCSum = 0;
        String sCreditID = "";
        String sOldCreditID = "";
        String sStores = "";//�ŵ���
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
        	Sqlca.commit();//�ύ �����������
        	ARE.getLog().debug("����p2p");
            return false;
        }
        //��ͬ�����ڿ��ý��
        if( dBCSum > dTotalSum-dHaveUseSum-dUnsignedTotalSum ){
        	Sqlca.commit();//�ύ �����������
            ARE.getLog().debug("����P2P���ý���");
            return false;
        }
        ARE.getLog().debug("��ȷ���ú�ͬ��ʹ��P2P��Դ����ʼͬ��P2P��������Ϣ������"+StringFunction.getNow());
        
        dSum =Arith.add(dHaveUseSum, dBCSum); 
        
        sCreditID = ServiceProvidersSerialno;
        
        //��ȡ�����˵������Ϣ
        String RepaymentNo = "";//�����˺�
        String RepaymentBank = "";//�����˺ſ�����
        String RepaymentName = "";//�����˺Ż���
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
        
        Sqlca.commit();//�ύ �����������
        ARE.getLog().debug("P2P��������Ϣͬ����ϡ�����"+StringFunction.getNow());
        
        return true;
    }
    
    public void addP2pBC(String sCustomerId,String sSubProductType,String stores) throws Exception{
    	
    	//��ȡ�����˵������Ϣ
        String RepaymentNo = "";//�����˺�
        String RepaymentBank = "";//�����˺ſ�����
        String RepaymentName = "";//�����˺Ż���
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
     * ȡ����ͬʱ������Ƿ���Ҫ����p2p���
     * @author Dahl
     * @date 2015��5��6��
     */
    public void checkReturnP2pSum() throws Exception{
    	ARE.getLog().debug("����Ƿ���Ҫ����p2p��ȿ�ʼ:" + ContractSerialNo);
    	double dBusinesssum = 0;//������
    	String sSureType = "";//��������
    	String sContractStatus = "";//��ͬ״̬
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
        	returnP2pSum(dBusinesssum);//����p2p���
        }
        ARE.getLog().debug("����Ƿ���Ҫ����p2p��Ƚ���:" + ContractSerialNo);
    }
    
    /**
     * ����p2p���
     * @author Dahl
     * @date 2015��5��6��
     */
    public synchronized void returnP2pSum(double dBusinesssum) throws Exception{
    	ARE.getLog().debug("����p2p��ȿ�ʼ:" + ContractSerialNo);
    	String sSerialNo = "";
    	double dHaveUseSum = 0;//���ý��
    	double dUnsignedTotalSum = 0;//δǩ����
    	String sUnsignedTotalSum = "";
    	//����
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
        
        String sSubmitTime = "";//��ͬ�ύʱ��
        sSql = "SELECT endTime as submitTime FROM flow_task t where t.phaseno='0010' and t.objectno='"+ContractSerialNo+"'";
        		//"SELECT submitTime FROM RULE_RUN_LOG where bcserialno='"+ContractSerialNo+"'";
        rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	sSubmitTime = DataConvert.toString(rs.getString("submitTime"));
        }
        
       //�ύ�����ǽ���ģ���ۼ����ö��
        if( sSubmitTime != null && sSubmitTime.contains(curDay) ){
        	dHaveUseSum = Arith.sub(dHaveUseSum, dBusinesssum) ;
        	if( dHaveUseSum < 0 ){
        		dHaveUseSum = 0;//���ö�Ȳ���С��0
        	}
        	sSql = "UPDATE  P2PCREDIT_INFO  SET HAVEUSESUM=:HAVEUSESUM   WHERE SERIALNO='"+sSerialNo+"'";
        	Sqlca.executeSQL(new SqlObject(sSql).setParameter("HAVEUSESUM", dHaveUseSum));
        }else{ //�ύ���ڲ��ǽ���ģ���ۼ�δǩ����	
        	//δǩ����δ��ֵ����˵��δ����p2pδǩ����,������ֵ�ſ۶��
        	if ( sUnsignedTotalSum != null && !"".equals(sUnsignedTotalSum) ){
        		dUnsignedTotalSum = Arith.sub(dUnsignedTotalSum, dBusinesssum) ;
        		if( dUnsignedTotalSum < 0 ){
        			dUnsignedTotalSum = 0;//δǩ����С��0
        		}
        		sSql = "UPDATE  P2PCREDIT_INFO  SET UNSIGNEDTOTALSUM=:UNSIGNEDTOTALSUM   WHERE SERIALNO='"+sSerialNo+"'";
        		Sqlca.executeSQL(new SqlObject(sSql).setParameter("UNSIGNEDTOTALSUM", dUnsignedTotalSum));
        	}
        }
        
        ARE.getLog().debug("����p2p��Ƚ���:" + ContractSerialNo);
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

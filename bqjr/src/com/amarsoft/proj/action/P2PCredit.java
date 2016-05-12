package com.amarsoft.proj.action;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * P2P贷款类
 * @author Dahl
 *
 */
public class P2PCredit {

	private String ContractSerialNo="";//合同编号
	private String p2pType = "";
	
	public String updateP2pExportTime(Transaction sqlca) throws Exception {
    	try {
    		String sWhereClause = "";
    		if( "AirtualStore".equals(p2pType) ){	//借钱么虚拟门店的p2p合同
    			sWhereClause += " and RI.RNO = '4403000471' ";
    		}else if( "EBuyFun".equals(p2pType) ){	//”易佰分“的商户编号为“4403000403”
    			sWhereClause += " and RI.RNO = '4403000403' ";
    		}else{	//普通消费贷的p2p合同
    			sWhereClause += " and RI.RNO <> '4403000471' ";	//不包含借钱么虚拟门店的p2p合同。
    			sWhereClause += " and RI.RNO <> '4403000403' ";	//不包含”易佰分“的商户编号为“4403000403”
    		}//CCS-1157 导出时会往已撤销合同中插入导出时间,因下面sql条件中少了210已撤销这种状态的合同导致。 update huzp 
    		String sSQL = "update business_contract_others set p2p_export_time=:p2pExportTime where serialno in ( select BC.Serialno from business_contract BC ,business_contract_others BCO,STORE_INFO SI , RETAIL_INFO RI where BC.Serialno=BCO.Serialno and BC.Stores=SI.Sno and SI.Rserialno=RI.Serialno and BC.ISP2P = '1' and BC.ContractStatus not in ('060','070','080','090','100','010','210') " + sWhereClause + "and BCO.P2p_Export_Time is null  ) ";
        	String inputTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
        	sqlca.executeSQL(new SqlObject(sSQL).setParameter("p2pExportTime", inputTime));
		} catch (Exception e) {
			e.printStackTrace();
			sqlca.rollback();
			return "Failure";
		}
    	
    	return "";
    }
	
	/**
     * 取消合同时，检查是否需要返回p2p额度
     * @author Dahl
     * @date 2015年5月6日
     */
    public void checkReturnP2pSum(Transaction Sqlca) throws Exception{
    	ARE.getLog().debug("检查是否需要返回p2p额度开始:" + ContractSerialNo);
    	double dBusinesssum = 0;//贷款金额
    	String sSureType = "";//贷款类型
    	String sContractStatus = "";//合同状态
    	String sIsp2p = "";
    	String sSql = "select bc.Businesssum,bc.SureType,bc.ContractStatus,bc.isp2p from business_contract bc ,store_info si ,retail_info ri where bc.stores=si.sno and si.rserialno=ri.serialno and bc.serialno='" + ContractSerialNo + "'";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	dBusinesssum = rs.getDouble("Businesssum");
        	sSureType = rs.getString("SureType");
        	sContractStatus = rs.getString("ContractStatus");
        	sIsp2p = DataConvert.toString(rs.getString("isp2p"));
        }
        rs.getStatement().close();
        
        if( "1".equals(sIsp2p) && ("PC".equals(sSureType) || "APP".equals(sSureType)) && ( "070".equals(sContractStatus) || "080".equals(sContractStatus) ) ){
        	returnP2pSum(dBusinesssum,Sqlca);//返回p2p额度
        }
        
        ARE.getLog().debug("检查是否需要返回p2p额度结束:" + ContractSerialNo);
    }
    
    /**
     * 返回p2p额度
     * @author Dahl
     * @date 2015年5月6日
     */
    public synchronized void returnP2pSum(double dBusinesssum,Transaction Sqlca) throws Exception{
    	ARE.getLog().debug("返回p2p额度开始:" + ContractSerialNo);
    	String sSerialNo = "";
    	double dHaveUseSum = 0;//已用金额
    	double dUnsignedTotalSum = 0;//未签署金额
    	String sUnsignedTotalSum = "";
    	String curDay = StringFunction.getToday();
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
        if(rs !=null) rs.close();
        String sSubmitTime = "";//合同提交时间
        sSql = "SELECT endTime as submitTime FROM flow_task t where t.phaseno='0010' and t.objectno='"+ContractSerialNo+"'";
        rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	sSubmitTime = DataConvert.toString(rs.getString("submitTime"));
        }
        if(rs !=null) rs.close();
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
        
        Sqlca.commit();//额度返回完成，提交 ，解除表锁定
        ARE.getLog().debug("返回p2p额度结束:" + ContractSerialNo);
    }
	
    public void checkIsUseP2p(Transaction Sqlca) throws Exception{
    	//判断P2P占用
		P2PCreditCommon p2p = new P2PCreditCommon(ContractSerialNo, Sqlca);
		boolean b = p2p.isUseP2P();
		ARE.getLog().debug("P2P判断结束,合同"+ContractSerialNo+"是否为P2P合同"+b+"，结束时间为："+StringFunction.getNow());
    }
    
	public String getContractSerialNo() {
		return ContractSerialNo;
	}

	public void setContractSerialNo(String contractSerialNo) {
		ContractSerialNo = contractSerialNo;
	}

	public String getP2pType() {
		return p2pType;
	}

	public void setP2pType(String p2pType) {
		this.p2pType = p2pType;
	}

}

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
 * P2P������
 * @author Dahl
 *
 */
public class P2PCredit {

	private String ContractSerialNo="";//��ͬ���
	private String p2pType = "";
	
	public String updateP2pExportTime(Transaction sqlca) throws Exception {
    	try {
    		String sWhereClause = "";
    		if( "AirtualStore".equals(p2pType) ){	//��Ǯô�����ŵ��p2p��ͬ
    			sWhereClause += " and RI.RNO = '4403000471' ";
    		}else if( "EBuyFun".equals(p2pType) ){	//���װ۷֡����̻����Ϊ��4403000403��
    			sWhereClause += " and RI.RNO = '4403000403' ";
    		}else{	//��ͨ���Ѵ���p2p��ͬ
    			sWhereClause += " and RI.RNO <> '4403000471' ";	//��������Ǯô�����ŵ��p2p��ͬ��
    			sWhereClause += " and RI.RNO <> '4403000403' ";	//���������װ۷֡����̻����Ϊ��4403000403��
    		}//CCS-1157 ����ʱ�����ѳ�����ͬ�в��뵼��ʱ��,������sql����������210�ѳ�������״̬�ĺ�ͬ���¡� update huzp 
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
     * ȡ����ͬʱ������Ƿ���Ҫ����p2p���
     * @author Dahl
     * @date 2015��5��6��
     */
    public void checkReturnP2pSum(Transaction Sqlca) throws Exception{
    	ARE.getLog().debug("����Ƿ���Ҫ����p2p��ȿ�ʼ:" + ContractSerialNo);
    	double dBusinesssum = 0;//������
    	String sSureType = "";//��������
    	String sContractStatus = "";//��ͬ״̬
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
        	returnP2pSum(dBusinesssum,Sqlca);//����p2p���
        }
        
        ARE.getLog().debug("����Ƿ���Ҫ����p2p��Ƚ���:" + ContractSerialNo);
    }
    
    /**
     * ����p2p���
     * @author Dahl
     * @date 2015��5��6��
     */
    public synchronized void returnP2pSum(double dBusinesssum,Transaction Sqlca) throws Exception{
    	ARE.getLog().debug("����p2p��ȿ�ʼ:" + ContractSerialNo);
    	String sSerialNo = "";
    	double dHaveUseSum = 0;//���ý��
    	double dUnsignedTotalSum = 0;//δǩ����
    	String sUnsignedTotalSum = "";
    	String curDay = StringFunction.getToday();
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
        if(rs !=null) rs.close();
        String sSubmitTime = "";//��ͬ�ύʱ��
        sSql = "SELECT endTime as submitTime FROM flow_task t where t.phaseno='0010' and t.objectno='"+ContractSerialNo+"'";
        rs = Sqlca.getASResultSet(new SqlObject(sSql));
        if(rs.next()){
        	sSubmitTime = DataConvert.toString(rs.getString("submitTime"));
        }
        if(rs !=null) rs.close();
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
        
        Sqlca.commit();//��ȷ�����ɣ��ύ �����������
        ARE.getLog().debug("����p2p��Ƚ���:" + ContractSerialNo);
    }
	
    public void checkIsUseP2p(Transaction Sqlca) throws Exception{
    	//�ж�P2Pռ��
		P2PCreditCommon p2p = new P2PCreditCommon(ContractSerialNo, Sqlca);
		boolean b = p2p.isUseP2P();
		ARE.getLog().debug("P2P�жϽ���,��ͬ"+ContractSerialNo+"�Ƿ�ΪP2P��ͬ"+b+"������ʱ��Ϊ��"+StringFunction.getNow());
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

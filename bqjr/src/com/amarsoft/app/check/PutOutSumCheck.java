package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ��ҵ��Ʒ��Ϊ�жһ�Ʊ�����߻�Ʊ����ʱ�����������г���Ʊ�ݵ��ܶ��Ƿ���ڻ�Ʊ�ܶ
 * ������ڻ�Ʊ�ܶ��˱�ҵ�������
 * @author cbsu 2009-11-10<br>
 *			History Log: sxjiang 2010/08/04  ��ӻ��ʽ��м��㣬��ERATE_INFOȡֵ
 */
public class PutOutSumCheck extends AlarmBiz {
    
    public Object run(Transaction Sqlca) throws Exception {
        
        double dAllBillSum = 0.0;
        double dPutOutSum = 0.0;

        String sPutOutSerialNo = (String)this.getAttribute("ObjectNo");
        String sBusinessType = (String)this.getAttribute("BusinessType");
        String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");

        if (sPutOutSerialNo == null) sPutOutSerialNo = "";
        if (sBusinessType == null) sBusinessType = "";
        if (sContractSerialNo == null) sContractSerialNo = "";

        /* ֻ�����µ�ҵ��Ʒ����Ҫ�������顣
         * 2010�����гжһ�Ʊ 1020010�����гжһ�Ʊ���� 1020020����ҵ�жһ�Ʊ���� 1
         * 020030��Э�鸶ϢƱ������ 1020040����ҵ�жһ�Ʊ���� 
         */
        if ("2010".equals(sBusinessType) || "1020010".equals(sBusinessType) || "1020020".equals(sBusinessType)
            || "1020030".equals(sBusinessType) || "1020040".equals(sBusinessType)) {
            
            //�õ���������Ʊ�ݵ��ܶ�
            dAllBillSum = getAllBillSum(sContractSerialNo, sPutOutSerialNo, Sqlca);
            //�õ����˵��ܶ��
            dPutOutSum = getPutOutSum(sPutOutSerialNo, Sqlca);
            
            if (dAllBillSum > dPutOutSum) {
                putMsg("����Ʊ���ܽ����ڻ�Ʊ�������¼�顣");
                setPass(false);
            } else {
                setPass(true);
            }
        } else {
            setPass(true);
        }
        return null;
    }
    
    /**
     * �õ���ͬ���µ����д���Ʊ�ݵ��ܽ�
     * @param sObjectNo ��ͬ��ˮ��
     * @param sPutOutSerialNo ������ˮ��
     * @return ���˺�ͬ���µ�Ʊ���ܽ��
     * @throws Exception
     */
    public double getAllBillSum(String sContractSerialNo, String sPutOutSerialNo, Transaction Sqlca) throws Exception{
        
        double dAllBillSum = 0.0,dBillTemp = 0.0,sExchangeValue = 0.0;
        ASResultSet rs = null;
        //��BILL_INFO,PUTOUT_RELATIVE,ERATE_INFO���������ҳ�����˹�����Ʊ���ܶ��Լ�����
        String sSql = " select BI.BillSum,EI.ExchangeValue from BILL_INFO BI,PUTOUT_RELATIVE PR,ERATE_INFO EI" +
                      " where BI.ObjectNo = :ObjectNo" +
                      " and EI.Currency = BI.LCCurrency"+
                      " and BI.ObjectType = 'BusinessContract'" +
                      " and BI.SerialNo = PR.SerialNo" +
                      " and PR.PutOutNo = :PutOutNo";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("PutOutNo", sPutOutSerialNo).setParameter("ObjectNo", sContractSerialNo));
        while(rs.next()) {
        	dBillTemp = rs.getDouble(1);
            sExchangeValue = rs.getDouble(2);
            dAllBillSum += (dBillTemp * sExchangeValue);
        }
        rs.getStatement().close();
        return dAllBillSum;
    }
    
    /**
     * �õ������ܶ��
     * @param sPutOutSerialNo ������ˮ��
     * @return ����ĳ�����ˮ�ż�¼�µĳ����ܶ��
     * @throws Exception
     */
    public double getPutOutSum(String sPutOutSerialNo, Transaction Sqlca) throws Exception{
        
        double dPutOutSum = 0.0,sExchangeValue = 0.0;
        ASResultSet rs;
        String sSql = " select BP.BusinessSum,EI.ExchangeValue from BUSINESS_PUTOUT BP, ERATE_INFO EI where BP.SerialNo = :SerialNo and EI.Currency = BP.BusinessCurrency ";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sPutOutSerialNo));
        while(rs.next()){
        	dPutOutSum = rs.getDouble(1);
        	sExchangeValue = rs.getDouble(2);
        }
        rs.getStatement().close();
        dPutOutSum = dPutOutSum * sExchangeValue;
        return dPutOutSum;
    }
}

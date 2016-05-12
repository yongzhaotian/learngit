package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 当业务品种为承兑汇票，或者汇票贴现时，必须检查所有出账票据的总额是否大于汇票总额。
 * 如果大于汇票总额，则此笔业务不予办理。
 * @author cbsu 2009-11-10<br>
 *			History Log: sxjiang 2010/08/04  添加汇率进行计算，在ERATE_INFO取值
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

        /* 只有以下的业务品种需要做本项检查。
         * 2010：银行承兑汇票 1020010：银行承兑汇票贴现 1020020：商业承兑汇票贴现 1
         * 020030：协议付息票据贴现 1020040：商业承兑汇票保贴 
         */
        if ("2010".equals(sBusinessType) || "1020010".equals(sBusinessType) || "1020020".equals(sBusinessType)
            || "1020030".equals(sBusinessType) || "1020040".equals(sBusinessType)) {
            
            //得到出账所有票据的总额
            dAllBillSum = getAllBillSum(sContractSerialNo, sPutOutSerialNo, Sqlca);
            //得到出账的总额度
            dPutOutSum = getPutOutSum(sPutOutSerialNo, Sqlca);
            
            if (dAllBillSum > dPutOutSum) {
                putMsg("出账票据总金额大于汇票金额，请重新检查。");
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
     * 得到合同项下的所有处长票据的总金额。
     * @param sObjectNo 合同流水号
     * @param sPutOutSerialNo 出账流水号
     * @return 出账合同项下的票据总金额
     * @throws Exception
     */
    public double getAllBillSum(String sContractSerialNo, String sPutOutSerialNo, Transaction Sqlca) throws Exception{
        
        double dAllBillSum = 0.0,dBillTemp = 0.0,sExchangeValue = 0.0;
        ASResultSet rs = null;
        //从BILL_INFO,PUTOUT_RELATIVE,ERATE_INFO三个表中找出与出账关联的票据总额以及汇率
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
     * 得到出账总额度
     * @param sPutOutSerialNo 出账流水号
     * @return 输入的出账流水号记录下的出账总额度
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

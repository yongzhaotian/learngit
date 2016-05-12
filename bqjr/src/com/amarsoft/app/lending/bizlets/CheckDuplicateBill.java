package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 在票据业务新增出账票据操作中，对用户输入的票据号进行检验。如果此票据号已存在并且在此合同项下，则直接引入到出账详情中。
 * 如果此票据已经存在出账详情中，则不允许再次引入。如果票据号不存在，则可用执行新增操作。
 * @author cbsu 2009-11-03
 */
public class CheckDuplicateBill extends Bizlet {

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    private static final String IMPORT = "Import";
    
    /**
     * 根据票据号，合同流水号及出账流水号来判断返回的状态。
     * @param BillNo 票据号
     * @param ContractSerialNo 合同流水号
     * @param PutOutNo 出账流水号
     * @return "Failed": 票据号已经引入到出账流水号项下或者此票据号已经存在BILL_INFO表中时返回
     *         "Import": 票据号在合同项下但是不在流水号项下
     *         "Success": 票据号不存在BILL_INFO表中，可以进行新增操作
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String State = FAILED;
        //票据号
        String sBillNo = (String)this.getAttribute("BillNo");
        //合同流水号
        String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
        //出账流水号
        String sPutOutNo = (String)this.getAttribute("PutOutNo");
        
        if (sBillNo == null) sBillNo = "";
        if (sContractSerialNo == null) sContractSerialNo = "";
        if (sPutOutNo == null) sPutOutNo = "";
        
        /* 由以下三个条件来判断处理的结果：1.票据号是否已经存在BILL_INFO中，2.票据号是否存在合同项下，3.票据号是否在出账项下。
         * 满足条件1，2，3则此票据号不能新增；
         * 满足条件1，2但不满足条件3则需引入；
         * 满足条件1，但不满足条件2，3则不能新增；
         * 不满足条件1，则可用新增。
         */
        if (isInBillInfo(sBillNo, Sqlca)) {
            if (isInContractInfo(sBillNo, sContractSerialNo, Sqlca)) {
                if (isInPutOut(sBillNo, sPutOutNo, Sqlca)) {
                    State = FAILED;
                } else {
                    State = IMPORT;
                }
            } else {
                State = FAILED;
            }
        } else {
            State = SUCCESS;
        }
        
        return State;
    }
    
    /**
     * 判断输入的票据号是否在出账流水号项下。
     * @param sBillNo 票据号
     * @param sPutOutNo 出账流水号
     * @return 如果票据号已经存在出账信息中，则返回false，否则返回true。
     */
    private boolean isInPutOut(String sBillNo, String sPutOutNo, Transaction Sqlca) throws Exception{
        
        boolean isInPutOutList = false;
        String sBillSerialNo = "";
        int iCount = 0;
        ASResultSet rs;
        SqlObject so ;//声明对象
        
        //得到票据号对应的票据流水号
        String sSql = " select SerialNo from BILL_INFO where BillNo =:BillNo ";
        so = new SqlObject(sSql).setParameter("BillNo", sBillNo);
        sBillSerialNo = Sqlca.getString(so);
        
        if (sBillSerialNo == null) sBillSerialNo = "";
        sSql = " select count(*) from PUTOUT_RELATIVE" +
        " where SerialNo =:SerialNo " +
        " and PutOutNo =:PutOutNo ";
        so = new SqlObject(sSql).setParameter("SerialNo", sBillSerialNo).setParameter("PutOutNo", sPutOutNo);
         rs = Sqlca.getResultSet(so);
        if(rs.next()) {
            iCount = rs.getInt(1);
        }
        rs.getStatement().close();
        
        if (iCount > 0) {
            isInPutOutList = true;
        }
        return isInPutOutList;
    }
    
    /**
     * 判断输入的票据号是否在合同项下。
     * @param sBillNo 票据号
     * @param sContractSerialNo 合同流水号
     * @return 如果合同下已经存在此票据号，则返回false，否则返回true。
     */
    private boolean isInContractInfo(String sBillNo, String sContractSerialNo, Transaction Sqlca) throws Exception{
        
        boolean isInContractInfoList = false;
        int iCount = 0;
        ASResultSet rs;
        String sSql = " select count(*) from BILL_INFO" +
        " where ObjectType = 'BusinessContract' " +
        " and ObjectNo =:ObjectNo" +
        " and BillNo =:BillNo ";
        SqlObject so = new SqlObject(sSql).setParameter("ObjectNo", sContractSerialNo).setParameter("BillNo", sBillNo);
        rs = Sqlca.getResultSet(so);
        if(rs.next()) {
            iCount = rs.getInt(1);
        }
        rs.getStatement().close();
        
        if (iCount > 0) {
            isInContractInfoList = true;
        }
        
        return isInContractInfoList;
    }
    
    /**
     * 判断输入的票据号是否已经存在BILL_INFO表中。
     * @param sBillNo 票据号
     * @return 如果BILL_INFO表中已经存在此票据号，则返回false，否则返回true。
     */
    private boolean isInBillInfo(String sBillNo, Transaction Sqlca) throws Exception {
        
        boolean isInBillInfoList = false;
        int iCount = 0;
        ASResultSet rs;
        String sSql = " select count(*) from BILL_INFO" +
        " where BillNo =:BillNo ";
        SqlObject so = new SqlObject(sSql).setParameter("BillNo", sBillNo);
        rs = Sqlca.getResultSet(so);
        if(rs.next()) {
            iCount = rs.getInt(1);
        }
        rs.getStatement().close();
        
        if (iCount > 0) {
            isInBillInfoList = true;
        }
        return isInBillInfoList;
    }
}

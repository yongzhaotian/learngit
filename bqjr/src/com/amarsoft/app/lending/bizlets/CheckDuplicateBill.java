package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ��Ʊ��ҵ����������Ʊ�ݲ����У����û������Ʊ�ݺŽ��м��顣�����Ʊ�ݺ��Ѵ��ڲ����ڴ˺�ͬ���£���ֱ�����뵽���������С�
 * �����Ʊ���Ѿ����ڳ��������У��������ٴ����롣���Ʊ�ݺŲ����ڣ������ִ������������
 * @author cbsu 2009-11-03
 */
public class CheckDuplicateBill extends Bizlet {

    private static final String SUCCESS = "Success";
    private static final String FAILED = "Failed";
    private static final String IMPORT = "Import";
    
    /**
     * ����Ʊ�ݺţ���ͬ��ˮ�ż�������ˮ�����жϷ��ص�״̬��
     * @param BillNo Ʊ�ݺ�
     * @param ContractSerialNo ��ͬ��ˮ��
     * @param PutOutNo ������ˮ��
     * @return "Failed": Ʊ�ݺ��Ѿ����뵽������ˮ�����»��ߴ�Ʊ�ݺ��Ѿ�����BILL_INFO����ʱ����
     *         "Import": Ʊ�ݺ��ں�ͬ���µ��ǲ�����ˮ������
     *         "Success": Ʊ�ݺŲ�����BILL_INFO���У����Խ�����������
     */
    public Object run(Transaction Sqlca) throws Exception {
        
        String State = FAILED;
        //Ʊ�ݺ�
        String sBillNo = (String)this.getAttribute("BillNo");
        //��ͬ��ˮ��
        String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
        //������ˮ��
        String sPutOutNo = (String)this.getAttribute("PutOutNo");
        
        if (sBillNo == null) sBillNo = "";
        if (sContractSerialNo == null) sContractSerialNo = "";
        if (sPutOutNo == null) sPutOutNo = "";
        
        /* �����������������жϴ���Ľ����1.Ʊ�ݺ��Ƿ��Ѿ�����BILL_INFO�У�2.Ʊ�ݺ��Ƿ���ں�ͬ���£�3.Ʊ�ݺ��Ƿ��ڳ������¡�
         * ��������1��2��3���Ʊ�ݺŲ���������
         * ��������1��2������������3�������룻
         * ��������1��������������2��3����������
         * ����������1�������������
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
     * �ж������Ʊ�ݺ��Ƿ��ڳ�����ˮ�����¡�
     * @param sBillNo Ʊ�ݺ�
     * @param sPutOutNo ������ˮ��
     * @return ���Ʊ�ݺ��Ѿ����ڳ�����Ϣ�У��򷵻�false�����򷵻�true��
     */
    private boolean isInPutOut(String sBillNo, String sPutOutNo, Transaction Sqlca) throws Exception{
        
        boolean isInPutOutList = false;
        String sBillSerialNo = "";
        int iCount = 0;
        ASResultSet rs;
        SqlObject so ;//��������
        
        //�õ�Ʊ�ݺŶ�Ӧ��Ʊ����ˮ��
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
     * �ж������Ʊ�ݺ��Ƿ��ں�ͬ���¡�
     * @param sBillNo Ʊ�ݺ�
     * @param sContractSerialNo ��ͬ��ˮ��
     * @return �����ͬ���Ѿ����ڴ�Ʊ�ݺţ��򷵻�false�����򷵻�true��
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
     * �ж������Ʊ�ݺ��Ƿ��Ѿ�����BILL_INFO���С�
     * @param sBillNo Ʊ�ݺ�
     * @return ���BILL_INFO�����Ѿ����ڴ�Ʊ�ݺţ��򷵻�false�����򷵻�true��
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

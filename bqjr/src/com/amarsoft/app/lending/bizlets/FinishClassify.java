package com.amarsoft.app.lending.bizlets;

import java.util.regex.Pattern;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ���弶�����������һ���ύʱ�������յ��϶�������µ�CLASSIFY_RECORD��BUSINESS_DUEBILL��BUSINESS_CONTRACT���ű��С�
 * �����弶����ʱ��Ϊ���֣��Խ�����弶���࣬�Ժ�ͬ���弶���ࡣ
 * 1. �Խ�����弶���ࣺ��ʱ��Ҫ����BUSINESS_DUEBILL���ClassifyResult�ֶΣ����ҽ��˽���������ĺ�ͬ��¼�еĵ��弶����
 *    �������Ϊ�˺�ͬ�����н��������弶��������
 * 2. �Ժ�ͬ���弶���ࣺ��ʱ��Ҫ����BUSINESS_CONTRACT���ClassifyResult�ֶΣ����ҽ��˺�ͬ�����������н�ݵĵ��弶����
 *    �������Ϊ��ǰ�ĺ�ͬ�����
 * @author cbsu
 * @date 2009-10-15
 */
public class FinishClassify extends Bizlet {
    
    private static final String BUSINESS_DUEBILL = "BusinessDueBill";
    private static final String BUSINESS_CONTRACT = "BusinessContract";
    protected Log logger = ARE.getLog();

    public Object run(Transaction Sqlca) throws Exception {
        
        //Flow_Opinion���е�ObjectNo
        String sObjectNo = (String)this.getAttribute("ObjectNo");
        //Flow_Opinion���е�ObjectType
        String sObjectType = (String)this.getAttribute("ObjectType");
        //�������׶ε������ˮ���
        String sFOSerialNo ="";
        //�˹��϶����
        String sPhaseOpinion = "";
        //�˹��϶�ԭ��
        String sPhaseOpinionReason = "";
        //����ʱ��
        String sInputTime = "";
        String sSql = "";
        ASResultSet rs=null;
        SqlObject so;
        //����ֵת��Ϊ���ַ���
        if(sObjectNo == null) sObjectNo = "";
        if(sObjectType == null) sObjectNo = "";
        
        //��ѯ�����϶��˵���������������
        sSql = " select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
        " where ObjectType=:ObjectType" +
        " and ObjectNo=:ObjectNo";
        so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
        rs = Sqlca.getASResultSet(so);
        if(rs.next()){
            sFOSerialNo=rs.getString("OpinionNo");
        }
        if(sFOSerialNo==null)sFOSerialNo="";
        rs.getStatement().close();
        logger.debug("Executed SQL: " + sSql);

        //��FLOW_OPINION����ȡ "�����϶����","�˹��϶�����","�϶�����"
        sSql = " select PhaseOpinion," +
        " InputTime," +
        " PhaseOpinion2" +
        " from Flow_Opinion" +
        " where OpinionNo=:OpinionNo ";
        so = new SqlObject(sSql).setParameter("OpinionNo", sFOSerialNo);
        rs = Sqlca.getASResultSet(so);
        if(rs.next()){
            sPhaseOpinion=rs.getString("PhaseOpinion");
            sPhaseOpinionReason=rs.getString("PhaseOpinion2");
            sInputTime =rs.getString("InputTime");
        }        
        if(sPhaseOpinion==null) sPhaseOpinion = "";
        if(sPhaseOpinionReason==null) sPhaseOpinionReason =  "";
        if(sInputTime==null) sInputTime = "";
        rs.getStatement().close();
        logger.debug("Executed SQL: " + sSql);
        
        //��ǰ����·�
        String sCurrentAccontMonth = "";
        //��ݺŻ��ͬ��
        String sDueBillNo = "";
        //���
        double dBalance = 0.0;        
        //�弶�����ǽ�ݻ��ͬ
        String sResultType = "";
        //�ϸ�����·�
        String sLastAccountMonth = "";
        //�������µ�CLASSIFY_RECORD����ֶ���
        String balanceColumn = "";
        
        //��CLASSIFY_RECORD����ȡ�õ��ڵĻ���·�,��ݻ��ͬ��,��ݻ��ͬ���
        sSql = " select AccountMonth,ObjectNo,BusinessBalance,ObjectType from CLASSIFY_RECORD where SerialNo=:SerialNo";
        so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
        rs = Sqlca.getASResultSet(so);
        if(rs.next()){
            sCurrentAccontMonth = rs.getString("AccountMonth");
            sDueBillNo = rs.getString("ObjectNo");
            dBalance = rs.getDouble("BusinessBalance");
            sResultType = rs.getString("ObjectType");
        }
        if ( sCurrentAccontMonth == null ) sCurrentAccontMonth = "";
        if ( sDueBillNo == null ) sDueBillNo = "";
        if ( sResultType == null ) sResultType = "";
        rs.getStatement().close();
        
        //���ݵõ��ĵ�ǰ����·������һ������·�
        try {
            sLastAccountMonth = getLastAccountMonth(sCurrentAccontMonth);
        } catch (Exception e) {
            throw new Exception("����ȷ�Ļ���·ݸ�ʽ�������¼��������"); 
        }
        
        //�õ���һ������·ݵ��弶������
        String lastClassifyResult = "";
        sSql = " select FinallyResult" +
        " from CLASSIFY_RECORD" +
        " where ObjectNo=:ObjectNo and AccountMonth=:AccountMonth and ObjectType =:ObjectType " ;
        so = new SqlObject(sSql).setParameter("ObjectNo", sDueBillNo).setParameter("AccountMonth", sLastAccountMonth).setParameter("ObjectType", sResultType);
        lastClassifyResult = Sqlca.getString(so);
        if (lastClassifyResult == null) lastClassifyResult = "";
        
        //ȷ����������CLASSIFY_RECORD����ֶ���
        try {
            balanceColumn = getBalanceColumn(sPhaseOpinion);
        } catch (Exception e) {
            throw new Exception("����ȷ������϶������ʽ�������¼��������"); 
        }
        if (balanceColumn == null) balanceColumn = "";
        
        //����CLASSIFY_RECORD����������˹��϶�����������϶�ʱ�䣬��һ������·ݵ��϶����
        sSql= " UPDATE CLASSIFY_RECORD SET " + balanceColumn + "=:dBalance," +
        " FinallyResult=:FinallyResult,FinishDate=:FinishDate," +
        " LastResult=:LastResult" +
        " WHERE SerialNo=:SerialNo";
        so = new SqlObject(sSql);
        so.setParameter("dBalance", dBalance).setParameter("FinallyResult", sPhaseOpinion)
        .setParameter("FinishDate", sInputTime).setParameter("LastResult", lastClassifyResult).setParameter("SerialNo", sObjectNo);
        Sqlca.executeSQL(so);
        
        //����sResultType��ȷ���ǶԽ�ݻ��ǶԺ�ͬ�����弶����,�ɴ������в�ͬ�ĸ��²���
        if (BUSINESS_DUEBILL.equals(sResultType)) {
            updateDueBill(sPhaseOpinion, sDueBillNo, Sqlca);
        }
        if (BUSINESS_CONTRACT.equals(sResultType)) {
            updateContract(sPhaseOpinion, sDueBillNo, Sqlca);
        }
        
        return "1";
    }
    
    
    /**
     * ����Ժ�ͬ���弶���࣬��Ҫ�������弶���������µ���ͬ����.
     * @param sContractNo ��ͬ��
     * @param sClassifyReult �����弶������
     * @return
     */
    private void updateContract (String sClassifyResult, String sContractNo, Transaction Sqlca) throws Exception {
        
        //���º�ͬ��
    	String sSql = " update BUSINESS_CONTRACT set ClassifyResult =:ClassifyResult " +
        " where SerialNo =:SerialNo";
    	SqlObject so = new SqlObject(sSql).setParameter("ClassifyResult", sClassifyResult).setParameter("SerialNo", sContractNo);
    	Sqlca.executeSQL(so);
        //���´˺�ͬ���µĽ�ݼ�¼
        setResultToBatchDueBill(sContractNo, sClassifyResult, Sqlca);
    }
    
    
    /**
     * ����Խ�����弶���࣬��Ҫ�������弶���������µ���ݱ���.
     * @param sDueBillNo ��ݺ�
     * @param sDueBillNo sClassifyReult �����弶������
     * @return
     */
    private void updateDueBill (String sClassifyResult, String sDueBillNo, Transaction Sqlca) throws Exception {
        
        //���½�ݱ�
    	 String sSql = " update BUSINESS_DUEBILL set ClassifyResult =:ClassifyResult " +
         " where SerialNo =:SerialNo ";
    	 SqlObject so = new SqlObject(sSql).setParameter("ClassifyResult", sClassifyResult).setParameter("SerialNo", sDueBillNo);
    	 Sqlca.executeSQL(so);
        //���˽�������ĺ�ͬ��¼�е��弶�����϶��������Ϊ����
        setWorstResultToContract(sDueBillNo, Sqlca);
    }
    
    
    /**
     * ����ǶԺ�ͬ���弶���࣬����Ҫ���˺�ͬ�����������н�ݵĵ��弶����������Ϊ��ǰ�ĺ�ͬ���.
     * @param sContractNo ��ͬ��
     * @param sClassifyReult�����弶������
     * @return
     */
    private void setResultToBatchDueBill(String sContractNo, String sClassifyResult, Transaction Sqlca) throws Exception {
        
        String sSql = "";
        
        //����ͬ���弶���������µ���ݱ���
        
        sSql = " update BUSINESS_DUEBILl set ClassifyResult =:ClassifyResult" +
        " where RelativeSerialNo2 =:RelativeSerialNo2";
       SqlObject so = new SqlObject(sSql).setParameter("ClassifyResult", sClassifyResult).setParameter("RelativeSerialNo2", sContractNo);
        Sqlca.executeSQL(so);
        
    }    
    
    
    /**
     * ����ǶԽ�����弶���࣬����Ҫ���˽���������ĺ�ͬ��¼�еĵ��弶����������Ϊ�˺�ͬ�����н��������弶������.
     * @param sDueBillNo: ��ݺ�
     * @return 
     */
    private void setWorstResultToContract(String sDueBillNo, Transaction Sqlca) throws Exception {
        
        String sContractSerialNo = "";
        String sWorstResult = "";
        String sSql = "";
        SqlObject so=null;
        //�õ���������ĺ�ͬ��
        sSql = " select RelativeSerialNo2" +
        " from BUSINESS_DUEBILL" +
        " where SerialNo =:SerialNo";
        so = new SqlObject(sSql).setParameter("SerialNo", sDueBillNo);
        sContractSerialNo = Sqlca.getString(so);
        
        //�õ��˺�ͬ�����µĽ�ݵ��弶��������
        sSql = " select MAX(ClassifyResult)" +
        " from BUSINESS_DUEBILL" +
        " where RelativeSerialNo2 =:RelativeSerialNo2";
        so = new SqlObject(sSql).setParameter("RelativeSerialNo2", sContractSerialNo);
        sWorstResult = Sqlca.getString(so);
        
        //���������µ���ͬ����
        sSql = " update BUSINESS_CONTRACT set ClassifyResult =:ClassifyResult" +
        " where SerialNo =:SerialNo";
        so = new SqlObject(sSql).setParameter("ClassifyResult", sWorstResult).setParameter("SerialNo", sContractSerialNo);
        Sqlca.executeSQL(so);
    }
    
    
     /**
     * �ɱ��ڵĻ���·ݵõ����ڵĻ���·�ֵ.
     * @param sCurrentAccountMonth �����弶����Ļ���·�
     * @return �����弶����Ļ���·�
     */
    private String getLastAccountMonth(String sCurrentAccountMonth) throws Exception{
        
        String sLastAccountMonth = "";
        int lastYear=0, lastMonth=0;
        
        try {
            if (!"".equals(sCurrentAccountMonth) && sCurrentAccountMonth != null) {
            	//�������ַ������зָ�
                String[] currentDate = sCurrentAccountMonth.split("/");
                
                if (currentDate.length > 1) {
                    String year = currentDate[0];
                    String month = currentDate[1];
                    
                    //����������ʽ���ж���ݺ��·��Ƿ���ȷ
                    boolean isYear, isMonth;
                    isYear = Pattern.matches("^[1-9]{1}[0-9]{3}", year);
                    isMonth = Pattern.matches("^[0-1]{1}[0-9]{1}", month);
                    
                    //�õ��ϸ�����·�
                    if (isYear && isMonth) {
                    	int iYear = DataConvert.toInt(year);
                        int iMonth = DataConvert.toInt(month);
                        if (iMonth == 1) {
                            lastMonth = 12;
                            lastYear = iYear - 1;
                        } else {
                            lastMonth = iMonth - 1;
                            lastYear = iYear;
                        }
                    } else {
                        throw new Exception();
                    }
                    
                    //�ϳ�Ϊ���յ��ַ���
                    if (lastMonth < 10) {
                        sLastAccountMonth = String.valueOf(lastYear) + "/0" + String.valueOf(lastMonth);
                    } else {
                        sLastAccountMonth = String.valueOf(lastYear) + "/" + String.valueOf(lastMonth);
                    }
                } else {
                	//����ָ����ַ����������С��1�������쳣
                    throw new Exception();
                }
            } else {
            	//����ַ���Ϊnull��գ������쳣
                throw new Exception();
            }
            return sLastAccountMonth;
        } catch (Exception e) {
        	//�õ��κ��쳣��ֱ������һ���׳�
            throw e;
        }
    }
    
    
    /**
     * ���������˹��϶������ȷ��ʹ��Classify_Record���е�SUM1-SUM5�ĸ��ֶ����������.
     * �˹��϶������SUM1-SUM5��Ӧ��ϵ���£�
     * �˹��϶����:�ֶ���
     *    "01":SUM1, "02":SUM2, "03":SUM3, "04":SUM4, "05":SUM5
     * @param sPhaseOpinion �����˹��϶����
     * @return Classify_Record�����ֶ���
     */
    private String getBalanceColumn(String sPhaseOpinion) throws Exception {
        
        String balanceColumn = "";
        boolean isCorrectReuslt = false;
        
        try {
            if (!"".equals(sPhaseOpinion) && sPhaseOpinion != null) {
                
                //��������ʽ�ж�sPhaseOpinion�Ƿ�Ϊ��ȷ�ĸ�ʽ
            	//��һλΪ0���ڶ�λΪ1��5֮���һ����
                isCorrectReuslt = Pattern.matches("^0[1-5]{1}$", sPhaseOpinion); 
                
                if (isCorrectReuslt) {
                	//����ַ�������������ʽ����������
                    int iPhaseOpinion = DataConvert.toInt(sPhaseOpinion);
                    balanceColumn = "SUM" + String.valueOf(iPhaseOpinion);
                } else {
                	//����ַ��������ϸ�ʽ�������쳣
                    throw new Exception();
                }
            } else {
            	//����ַ���Ϊnull��գ������쳣
                throw new Exception();
            }
        } catch (Exception e) {
            throw e;
        }
        return balanceColumn;
    }
}

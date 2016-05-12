package com.amarsoft.app.lending.bizlets;


/*
Author: --zhuang 2010-03-25
Tester:
Describe: --���ڲ���ҵ�����ݵ���Ϣ��ʵʱ��ѯ
Input Param:
        OrgID: ������
        ValueType: ����ֵ������       
Output Param:
        
HistoryLog:
*/

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReinforceStatisticNow extends Bizlet{

    public Object run(Transaction Sqlca) throws Exception {
        //��ȡ����
        String OrgID = (String)this.getAttribute("OrgID");
        String ValueType = (String)this.getAttribute("ValueType");//����ֵ������
        
        //����ֵת���ɿ��ַ���        
        if(OrgID == null) OrgID = "";       
        if(ValueType == null) ValueType = "";
        
        //�������
        ASResultSet rs = null;//��ѯ�����
        String sSqlFinish = "";//��ѯ������ɵ�ҵ�����
        String sSqlUnFinish = "";//��ѯ����δ��ɵ�ҵ�����
        String sSqlOrgName = "";//��ѯ��������
        String sOrgName = "";//��������
        int dFinishCounts = 0;//������ɵ�ҵ�����
        int dUnFinishCounts = 0;//������ɵ�ҵ�����    
        SqlObject so;
           
        sSqlOrgName = "select OrgName from ORG_INFO where OrgID=:OrgID";
        so = new SqlObject(sSqlOrgName).setParameter("OrgID", OrgID);
        sOrgName = Sqlca.getString(so);
        
        sSqlFinish = " select count(*) from BUSINESS_CONTRACT " +
	     " where ManageOrgID =:ManageOrgID and ReinforceFlag='010' ";
        so = new SqlObject(sSqlFinish).setParameter("ManageOrgID", OrgID);
        dUnFinishCounts = DataConvert.toInt(Sqlca.getString(so));
        sSqlUnFinish = " select count(*) from BUSINESS_CONTRACT " +
        " where ManageOrgID =:ManageOrgID and ReinforceFlag='020' ";
        so = new SqlObject(sSqlUnFinish).setParameter("ManageOrgID", OrgID);
        dFinishCounts = DataConvert.toInt(Sqlca.getString(so));
        
        if(ValueType.equals("Counts")){   
            return sOrgName+"@,"+dFinishCounts+"@"+dUnFinishCounts+"@,"+"�������@����δ���@";          
        }else if(ValueType.equals("Percents")){ 
            double dCounts = dFinishCounts + dUnFinishCounts;//����ҵ������
            if(dCounts==0){
                return sOrgName+"@,"+"0.0@0.0@,�������@����δ���@";//���û����޲��Ǽ�¼ʱ������ ���������δ��ɵ�ҵ�����İٷֱȾ�Ϊ0.0
            }else{
                double dFinishPercents = 100*dFinishCounts/dCounts;//������ɵ�ҵ�����İٷֱ�
                return sOrgName+"@,"+dFinishPercents+"@"+(100-dFinishPercents)+"@,"+"������ɰٷֱ�@����δ��ɰٷֱ�@";
            }           
        }       
        return null;      
    }  
}

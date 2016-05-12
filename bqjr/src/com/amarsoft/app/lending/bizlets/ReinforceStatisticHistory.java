package com.amarsoft.app.lending.bizlets;


/*
Author: --zhuang 2010-03-25
Tester:
Describe: --���ڲ���ҵ�����ݵ���Ϣ����ʷ��ѯ
Input Param:
        OrgIDArray: �������ַ���
        ValueType: ����ֵ������       
Output Param:
              
HistoryLog:
*/

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReinforceStatisticHistory extends Bizlet{

    public Object run(Transaction Sqlca) throws Exception {
        //��ȡ����      
        String OrgIDArrayStr = (String)this.getAttribute("OrgIDArray");//�������ַ���       
        String ValueType = (String)this.getAttribute("ValueType");//����ֵ������
        
        //����ֵת���ɿ��ַ���            
        if(OrgIDArrayStr == null) OrgIDArrayStr = "";
        if(ValueType == null) ValueType = "";
        //��ֵ�ж�Ӧ�ڲ���֮ǰ
        String[] OrgIDArray = OrgIDArrayStr.split(";");//����������
        
        //�������
        String sSqlFinishCounts = "";//��ѯ�������ҵ�����
        String sSqlUnFinishCounts = "";//��ѯ����δ���ҵ�����
        String sSqlFinishPercents = "";//��ѯ�������ҵ��ٷֱ� 
                
        StringBuffer sOrgIDs = new StringBuffer("");//���л����ŵ��ַ���
        String sOrgID = "";//���л����ŵ��ַ���
        String sSqlOrgName = "";//OrgIDArray�����л����Ŷ�Ӧ�Ļ��������Ƶ��ַ���
        String[] sFinishCounts = new String[OrgIDArray.length];//������ɵ�ҵ�����
        String[] sUnFinishCounts = new String[OrgIDArray.length];;//����δ��ɵ�ҵ�����       
        String[] sFinishPercents =  new String[OrgIDArray.length];//������ɵ�ҵ�����İٷֱ�
        
        StringBuffer sReturnPercentsOrgName = new StringBuffer("");//���еĻ�������
        StringBuffer sReturnCounts =new StringBuffer("");//����ҵ������ֵ����
        StringBuffer sReturnFinishCounts = new StringBuffer("");//�������ҵ������ֵ����
        StringBuffer sReturnUnFinishCounts = new StringBuffer("");//����δ���ҵ������ֵ����
        StringBuffer sReturnPercents = new StringBuffer("");//����ҵ��ٷֱ���ֵ����
        StringBuffer sReturnFinishPercents = new StringBuffer("");//�������ҵ��ٷֱ���ֵ����
        StringBuffer sReturnUnFinishPercents = new StringBuffer("");//����δ���ҵ��ٷֱ���ֵ����
        
        for (int i = 0; i < OrgIDArray.length; i++) {        
            sOrgIDs.append("'"+OrgIDArray[i]+"',");                           
        }
        sOrgID = sOrgIDs.substring(0, sOrgIDs.length()-1);
              
        sSqlOrgName = "select OrgName from ORG_INFO where OrgID in ("+ sOrgID +")";
        String[] sOrgName = Sqlca.getStringArray(sSqlOrgName);//��ȡ���л������Ƶ��ַ�������
        
        sSqlFinishCounts = "select FinishedBC from REINFORCE_ACCOUNT where OrgID in ("+sOrgID+")";
        sFinishCounts = Sqlca.getStringArray(sSqlFinishCounts);//����ɱ���ת��Ϊ�ַ�����
        sSqlUnFinishCounts = "select UnfinishBC from REINFORCE_ACCOUNT where OrgID in ("+sOrgID+")";
        sUnFinishCounts = Sqlca.getStringArray(sSqlUnFinishCounts);//��δ��ɱ���ת��Ϊ�ַ�����
      //��ȡ��ѡ���������ҵ������İٷֱȣ��ֶ�"FinishedRatio"�ڱ�"REINFORCE_ACCOUNT"��������ʽΪ"��ɱ���/(��ɱ���+δ��ɱ���)"
        sSqlFinishPercents= "select FinishedRatio from REINFORCE_ACCOUNT where OrgID in ("+sOrgID+")";
        sFinishPercents = Sqlca.getStringArray(sSqlFinishPercents);//����ɰٷֱ�ת��Ϊ�ַ�����

        for (int i = 0; i < OrgIDArray.length; i++) {               
            if(ValueType.equals("Counts")){//�������Ϊ����չʾ��ƴ���ַ���Ϊ"sFinishCount[i]@sUnFinishCounts[i]@"����ʽ
                sReturnFinishCounts.append(sFinishCounts[i]+"@"); 
                sReturnUnFinishCounts.append(sUnFinishCounts[i]+"@");
            }else if(ValueType.equals("Percents")){
            	double FinishPercents = DataConvert.toDouble(sFinishPercents[i]);
            	double FinishCounts = DataConvert.toDouble(sFinishCounts[i]);
            	double UnFinishCounts = DataConvert.toDouble(sUnFinishCounts[i]);
            	sReturnFinishPercents.append(100*FinishPercents+"@");//����100ʹ��ָ��ת��Ϊ�ٷ���
            	if(FinishCounts+UnFinishCounts==0){//�жϹ��˵�����һ��İٷֱ�Ϊ0.00������һ��Ϊ100.00�����
            		sReturnUnFinishPercents.append(0.00+"@");
            	}else{
            		sReturnUnFinishPercents.append(100*(1-FinishPercents)+"@");
            	}
            }                   
            sReturnPercentsOrgName.append(sOrgName[i]+"@");//���ӻ�������
        }
        
        sReturnCounts = sReturnFinishCounts.append(sReturnUnFinishCounts);//׼����Ҫ�����������ַ�������ʽ��"10@10@"
        sReturnPercents = sReturnFinishPercents.append(sReturnUnFinishPercents);//׼����Ҫ���ذٷֱȵ��ַ�������ʽ��"0.00@0.00@"
        if(ValueType.equals("Counts")){           
            return sReturnPercentsOrgName.toString()+","+sReturnCounts+","+"������ɱ���@����δ��ɱ���@";          
        }else if(ValueType.equals("Percents")){    
            return sReturnPercentsOrgName.toString()+","+sReturnPercents+","+"������ɰٷֱ�@����δ��ɰٷֱ�@";
        }                 
        return null;      
    }   
}
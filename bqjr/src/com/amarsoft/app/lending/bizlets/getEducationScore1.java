package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class getEducationScore1 extends Bizlet {
    /**
     * �������ڼ���Ͷ�ʹ������õȼ�����ģ���ж�ѧ���÷���Ŀֵ�ļ���
     * ���㷽����ѧ���÷� = (�Ƹ�ѧ�����������Ȩ��/������5) 
     * @param SerialNo ���õȼ�����������ˮ��
     * @return Ͷ�ʹ���ѧ���÷�(��Ŀֵ)
     * @author yxzhang
     * @date 2010-04-07
     */
    public Object run(Transaction Sqlca) throws Exception { 
        String sSerialNo = (String)this.getAttribute("SerialNo");
        if (sSerialNo == null) sSerialNo = "";
       
        String sSqlGra = "";
        String sSqlUnGra = "";
        String sSqlJunior = "";
        ASResultSet rs=null;
        
        double dItemValueGra = 0.0;//�о�������
        double dItemValueUnGra = 0.0;//����������
        double dItemValueJunior = 0.0;//��ר������
        double dItemValue = 0.0;//������
        
        double dCoefficient_Gra = 1.2;//�о������õȼ�����Ȩֵ
        double dCoefficient_UnGra = 1.0;//���������õȼ�����Ȩֵ
        double dCoefficient_Junior = 0.8;//��ר�����õȼ�����Ȩֵ
        
        double dScore_Gra = 0.0;//�о������õȼ������÷�
        double dScore_UnGra = 0.0;//���������õȼ������÷�
        double dScore_Junior = 0.0;//��ר�����õȼ������÷�
        double dScore_Edu = 0.0;//ѧ���÷֣�������������֮��   
        
        sSqlGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
                   "where ER.SerialNo='"+ sSerialNo +"'  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.3.1'";          
        dItemValueGra = (Sqlca.getDouble(sSqlGra)).doubleValue();
        
        sSqlUnGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
                  "where ER.SerialNo='"+ sSerialNo +"'  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.3.2'";
        dItemValueUnGra = Sqlca.getDouble(sSqlUnGra).doubleValue();
        
        sSqlJunior = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
              "where ER.SerialNo='"+ sSerialNo +"'  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.3.3'";       
        dItemValueJunior = Sqlca.getDouble(sSqlJunior).doubleValue();
      
        
        dItemValue = dItemValueGra + dItemValueUnGra + dItemValueJunior;
            
        if(dItemValueGra != 0){
            dScore_Gra =  dItemValueGra * dCoefficient_Gra / dItemValue * 5;   
        }
        if(dItemValueUnGra != 0){
            dScore_UnGra =  dItemValueUnGra * dCoefficient_UnGra / dItemValue * 5;    
        }
        if(dItemValueJunior != 0){
            dScore_Junior =  dItemValueJunior * dCoefficient_Junior / dItemValue * 5; 
        }

        dScore_Edu = dScore_Gra + dScore_UnGra + dScore_Junior;
        return Double.toString(dScore_Edu);
    }
}

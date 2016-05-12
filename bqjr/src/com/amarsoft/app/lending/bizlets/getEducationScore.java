package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class getEducationScore extends Bizlet {
    /**
     * �������ڼ����ڸ����õȼ�����ģ���ж�ѧ���÷���Ŀֵ�ļ���
     * ���㷽����ѧ���÷� = (�Ƹ�ѧ�����������Ȩ��/������2) + �ܾ����Ƿ�ʿ�÷�   
     * @param SerialNo ���õȼ�����������ˮ��
     * @return ѧ���÷�(��Ŀֵ)
     * @author zhuang
     * @date 2010-03-24
     */
    public Object run(Transaction Sqlca) throws Exception { 
        String sSerialNo = (String)this.getAttribute("SerialNo");
        if (sSerialNo == null) sSerialNo = "";
       
        String sSqlGra = "";
        String sSqlUnGra = "";
        String sSqlJunior = "";
        String sSqlTec = ""; 
        String sSqlDoc = "";
        ASResultSet rs=null;
        
        double dItemValueGra = 0.0;//�о�������
        double dItemValueUnGra = 0.0;//����������
        double dItemValueJunior = 0.0;//��ר������
        double dItemValueTec = 0.0;//��ר������
        double dItemValue = 0.0;//������
        
        double dCoefficient_Gra = 1.2;//�о������õȼ�����Ȩֵ
        double dCoefficient_UnGra = 1.0;//���������õȼ�����Ȩֵ
        double dCoefficient_Junior = 0.8;//��ר�����õȼ�����Ȩֵ
        double dCoefficient_Tec = 0.5;//��ר�����õȼ�����Ȩֵ
        
        double dScore_Gra = 0.0;//�о������õȼ������÷�
        double dScore_UnGra = 0.0;//���������õȼ������÷�
        double dScore_Junior = 0.0;//��ר�����õȼ������÷�
        double dScore_Tec = 0.0;//��ר�����õȼ������÷�
        double dScore_Doc = 0.0;//�ܾ����Ƿ�ʿ�÷�
        double dScore_Edu = 0.0;//ѧ���÷֣�������������֮��   
        
        SqlObject so,so1,so2,so3,so4 ;
        sSqlGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
        "where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.1'";
        so = new SqlObject(sSqlGra).setParameter("SerialNo", sSerialNo);
        dItemValueGra = DataConvert.toDouble(Sqlca.getString(so));
        
        sSqlUnGra = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
        "where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.2'";
        so1 = new SqlObject(sSqlUnGra).setParameter("SerialNo", sSerialNo);
        dItemValueUnGra = DataConvert.toDouble(Sqlca.getString(so1));
        
        sSqlJunior = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
        "where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.3'"; 
        so2 = new SqlObject(sSqlJunior).setParameter("SerialNo", sSerialNo);
        dItemValueJunior = DataConvert.toDouble(Sqlca.getString(so2));
        
        sSqlTec = " select ItemValue from EVALUATE_DATA  ED,EVALUATE_RECORD ER,EVALUATE_MODEL EM " +
		"where ER.SerialNo=:SerialNo  and ED.SerialNo=ER.SerialNo and ER.ModelNo = EM.ModelNo and ED.ItemNo = EM.ItemNo and ED.ItemNo='1.1.1.4'";
        so3 = new SqlObject(sSqlTec).setParameter("SerialNo",sSerialNo);
        dItemValueTec = DataConvert.toDouble(Sqlca.getString(so3));
        dItemValue = dItemValueGra + dItemValueUnGra + dItemValueJunior + dItemValueTec;
        
        //ȡ���ܾ����Ƿ�ʿ�ķ�ֵ
        sSqlDoc = "select EvaluateScore from EVALUATE_DATA where SerialNo=:SerialNo  and ItemNo = '1.1.1.5'";
        so4 = new SqlObject(sSqlDoc).setParameter("SerialNo", sSerialNo);
        dScore_Doc = DataConvert.toDouble(Sqlca.getString(so4));
                
        //�������ѧ����ε���������        
        if( dItemValueGra==0 && dItemValueUnGra==0 && dItemValueJunior==0 && dItemValueTec==0 ){
            return Double.toString(dScore_Doc);           
        }        
        if(dItemValueGra != 0){
            dScore_Gra =  dItemValueGra * dCoefficient_Gra / dItemValue * 2;     
        }
        if(dItemValueUnGra != 0){
            dScore_UnGra =  dItemValueUnGra * dCoefficient_UnGra / dItemValue * 2;     
        }
        if(dItemValueJunior != 0){
            dScore_Junior =  dItemValueJunior * dCoefficient_Junior / dItemValue * 2;     
        }
        if(dItemValueTec != 0){
            dScore_Tec =  dItemValueTec * dCoefficient_Tec / dItemValue * 2;     
        }

        dScore_Edu = dScore_Gra + dScore_UnGra + dScore_Junior + dScore_Tec + dScore_Doc;
        return Double.toString(dScore_Edu);
    }
}

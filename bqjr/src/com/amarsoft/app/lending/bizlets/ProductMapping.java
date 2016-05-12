package com.amarsoft.app.lending.bizlets;


import com.amarsoft.app.util.DataConvertTools;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.proj.action.SubProductMapping;



public class ProductMapping extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception {
		//��ȡ��������ͬ���������ֵΪnull,��ת�ɿ��ַ���
		String businessContractSerialNo = DataConvertTools.nullToEmptyString((String)this.getAttribute("SerialNo"));
		String flag = "";
		String ruleReturnSql ="select PostWorkflowCode from cashpost_data where serialno = (select Max(SerialNo) from cashpost_data where applyno = :ObjectNo)";
		String ruleReturn=Sqlca.getString(new SqlObject(ruleReturnSql).setParameter("ObjectNo", businessContractSerialNo));
		ARE.getLog().info("20150524------------------ybpan-----1----"+ruleReturn);
		if("APPROVE".equals(ruleReturn)||"CreditExpert".equals(ruleReturn)){
			ARE.getLog().info("20150524------------------ybpan-----2----"+ruleReturn);
			//���ú�ͬ���������Ƿ�����ԤԼ�ֽ��,�������ֽ�����߸���������
			String subProductTypeSql = "select subproducttype from business_contract where serialno = :ObjectNo";
			String subProductType=Sqlca.getString(new SqlObject(subProductTypeSql).setParameter("ObjectNo", businessContractSerialNo));
			if(!"2".equals(subProductType)){
				return flag="";
			}

			//ProductMapping prd = new ProductMapping();
			SubProductMapping prd = new SubProductMapping();
			//���������Ƿ񷵻����������
			String existPrincipalPeriodOrNot = prd.existPrincipalPeriodOrNot(Sqlca, businessContractSerialNo);
			if("false".equals(existPrincipalPeriodOrNot)){
				return "";
			}
			//
			String subConditionCapitalPeriod[] = prd.subConditionCapitalPeriod(Sqlca, businessContractSerialNo).split("@");
			int sPostCapital = Integer.parseInt(subConditionCapitalPeriod[0]);//�������淵�ؽ��
			int sPostPeriod = Integer.parseInt(subConditionCapitalPeriod[1]);//�������淵�ص�����
			int sBCCapital = Integer.parseInt(subConditionCapitalPeriod[2]);//��ͬ��׼�Ľ��
			int sBCPeriod = Integer.parseInt(subConditionCapitalPeriod[3]);//��ͬ���е�����
			String sBCBusinessType = subConditionCapitalPeriod[4];//��ͬ���еĲ�Ʒ���
			String sProductSerialNO = "";//��Ʒϵ��
			int sCprincipalNew = sBCCapital+sPostCapital;//�����������Ľ��
			int sPeriodNew = sBCPeriod+sPostPeriod;//�����������Ľ��
			String cprincipalMapping = prd.cprincipalMapping(Sqlca, sBCBusinessType, sCprincipalNew);
			if("FAIL".equals(cprincipalMapping)){
				flag = "REJECT";
				return flag;
			}else{
				sProductSerialNO=cprincipalMapping.split("@")[2];
			}
			String sPostBusinessType = prd.checkBusinessType(Sqlca, sCprincipalNew, sPeriodNew, sProductSerialNO);
			ARE.getLog().info("20150524------------------ybpan----3-----"+ruleReturn);
			if("".equals(sPostBusinessType)){
				flag = "REJECT";
				return flag;
			}else{
				ARE.getLog().info("20150524------------------ybpan----4-----"+ruleReturn);
				if("APPROVE".equals(ruleReturn)){
					flag="SUBEXAMINE";
				}else if("CreditExpert".equals(ruleReturn)){
					flag="";
				}
				return flag;
			}
		}
		return flag;
		
	}
}

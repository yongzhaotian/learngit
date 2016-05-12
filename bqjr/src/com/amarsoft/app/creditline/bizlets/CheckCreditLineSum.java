package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 在授信总额更改时，检查缩小总额时，配额是否满足要求。
 * @author jgao1
 * @date 2008-09-27
 * History Log:
 */
public class CheckCreditLineSum extends Bizlet {

	/**
	 * @param ObjectType 对象类型
	 * @param ObjectNo 对象编号
	 * @param BusinessSum 授信额度协议金额
	 * @return flag
	 *         1."00":表示正常；
	 *         2."01":子额度授信限额 > 子额度敞口限额；
	 *         3."02":子额度授信限额 > 额度协议金额
	 */
    public Object run(Transaction Sqlca) throws Exception {
	 	//对象类型，
	 	String sObjectType = (String)this.getAttribute("ObjectType");
	 	//对象编号，用来查找授信总额
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//授信额度协议金额
	 	String sBusinessSum = (String)this.getAttribute("BusinessSum");
	 	if(sBusinessSum==null||sBusinessSum.equals("")) sBusinessSum = "0";
	 	double dLineSum = Double.parseDouble(sBusinessSum);
	 	
	 	//返回值标志：1."00":表示正常；2."01":子额度授信限额 > 子额度敞口限额；3."02":子额度授信限额 > 额度协议金额
		String flag = "00";
		SqlObject so = null;//声明对象
		
		String sSql = "";
		//授信额度ID
		String sParentLineID = "";
		String sCurrency="";//授信额度币种
		ASResultSet rs = null;
		
		//不同的对象类型它的取值也不同
		if(sObjectType.equals("CreditApply"))
		{   
			sSql = " select LineID,Currency from CL_INFO where ApplySerialNo =:ApplySerialNo order by LineID";
			so = new SqlObject(sSql);
			so.setParameter("ApplySerialNo", sObjectNo);
			rs=Sqlca.getASResultSet(so);
			
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID"); 
				sCurrency=rs.getString("Currency"); 
			}
			rs.getStatement().close();
		}
		
		if(sObjectType.equals("BusinessContract"))
		{
			sSql = " select LineID,Currency from CL_INFO where BCSerialNo =:BCSerialNo order by LineID ";
			so = new SqlObject(sSql);
			so.setParameter("BCSerialNo", sObjectNo);
			rs=Sqlca.getASResultSet(so);
			
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID");
				sCurrency=rs.getString("Currency");
			}
			rs.getStatement().close();
		}
		
	 	//子额度个数
	 	int iCount =0;
	 	sSql = " select LineSum1,LineSum2,GetERate1(Currency,'"+sCurrency+"') as ERateValue from CL_INFO where ParentLineID=:ParentLineID ";
		so = new SqlObject(sSql).setParameter("ParentLineID", sParentLineID);
		String[][] sArray =Sqlca.getStringMatrix(so);
		iCount = sArray.length;
		
		for(int i=0;i<iCount;i++){
			if(Double.valueOf(sArray[i][0])*Double.valueOf(sArray[i][2])//授信限额*汇率转换值
					<Double.valueOf(sArray[i][1])*Double.valueOf(sArray[i][2])//敞口限额*汇率转换值
					) flag="01";//子额度授信限额<子额度敞口限额
			if(Double.valueOf(sArray[i][0])*Double.valueOf(sArray[i][2])>dLineSum) flag="02";//子额度授信限额>额度协议金额
		}
		return flag;
	}
}

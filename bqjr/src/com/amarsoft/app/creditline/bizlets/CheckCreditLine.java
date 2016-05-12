package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 检查授信额度分配中单笔授信限额，单笔敞口限额是否大于授信总额，检查是否已分配该子额度业务类型及其项下业务品种。
 * @author jgao1
 * date: 2008-09-26
 * History Log: 2009/07/07 修改校验逻辑,只校验授信额度分配中单笔授信限额、敞口限额是否大于授信合同金额
 *              cbsu 2009/10/28 更正第一次新增子额度时会抛出异常的SQL语句，并更正注释
 */
 
public class CheckCreditLine extends Bizlet {

	/**
	 * 检查授信额度分配中单笔授信限额，单笔敞口限额是否大于授信总额，检查是否已分配该子额度业务类型及其项下业务品种。
	 * @param LineSum1 授信限额
	 * @param LineSum2 敞口限额
	 * @param ParentLineID 授信总额LineID
	 * @param BusinessType 业务类型
	 * @param LineID 当前分配子额度ID
	 * @param Currency 当前分配子额度币种
	 * @return flag3 "00": 表示正常；
	 *               "01": 表示当前敞口限额大于授信限额；
	 *               "10"：表示授信限额之和大于授信总额；
	 *               "11"：表示敞口限额大于授信限额和授信限额之和大于授信总额
	 *               "99": 已分配该业务类型子额度
	 * 
	 */
 public Object  run(Transaction Sqlca) throws Exception {
	 	//获得授信总额的LineID
	 	String sParentLineID = (String)this.getAttribute("ParentLineID");
	 	if(sParentLineID == null) sParentLineID = "";
	 	//获得当前子额度的LineID
	 	String sLineID = (String)this.getAttribute("LineID");
	 	if(sLineID == null) sLineID = "";
	 	//获得子额度业务品种
	 	String sBusinessType = (String)this.getAttribute("BusinessType");
	 	if(sBusinessType == null) sBusinessType = "";
	 	//获得子额度币种
	 	String sCurrency = (String)this.getAttribute("Currency");
	 	if(sCurrency == null) sCurrency = "";
	 	//已分配的子额度业务类型数组,用于存放已分配的子额度业务类型
	 	String[] sBusinessTypes = null;
		//获得当前输入的子额度授信限额
		String sLineSum1 = (String)this.getAttribute("LineSum1");
		if(sLineSum1==null||sLineSum1.equals("")) sLineSum1 = "0";
		//并把当然授信限额从String型转化为double型，当前授信限额变量为dSubLineSum1
		double dSubLineSum1 = Double.parseDouble(sLineSum1);
		//获得当前输入的子额度敞口限额
		String sLineSum2 = (String)this.getAttribute("LineSum2");
		if(sLineSum2==null||sLineSum2.equals("")) sLineSum2 = "0";
		//并把当然敞口限额从String型转化为double型，当前敞口限额变量为dSubLineSum2
		double dSubLineSum2 = Double.parseDouble(sLineSum2);
		//子额度数量
		int iCount=0;
		double dERateValue=0;//子额度币种转成授信额度币种后汇率值
		//当前输入的授信限额大于授信总额的标志：1.false表示正常;2.true表示超额.
		boolean flag1 = false;
		//当前输入的敞口限额大于当前输入的授信限额的标志：1.false表示正常；2.true表示超过.
		boolean flag2 = false;
		//返回值标志：1."00":表示正常；
		//           2."01":表示当前敞口限额大于当前授信限额；
		//           3."10"：表示授信限额大于授信总额；
		//           4."11"：表示当前敞口限额大于当前授信限额和授信限额大于授信总额。
		//           5."99":已分配该业务类型子额度
		String flag3 = "00";
		
		String sSql = "";
		ASResultSet rs = null;
		
		//授信总额sLineSum
		double dLineSum = 0;
		//在CL_INFO表中取到授信总额
		sSql = "select LineSum1,getERate1('"+sCurrency+"',Currency) as ERateValue from CL_INFO where LineID=:LineID";
	    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("LineID", sParentLineID));
		while(rs.next())
		{
			dLineSum = rs.getDouble("LineSum1");
			dERateValue = rs.getDouble("ERateValue");
		}
		rs.getStatement().close();
		
		//查找已分配的子额度业务类型
		sSql = "select BusinessType from CL_INFO where LineID <> :LineID and ParentLineID = :ParentLineID";
		sBusinessTypes = Sqlca.getStringArray(new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("LineID", sLineID));
	    iCount = sBusinessTypes.length;
		for(int i=0;i<iCount;i++)
		{
			if(sBusinessType.equals(sBusinessTypes[i]) || sBusinessType.startsWith(sBusinessTypes[i])){
				flag3 = "99";
			}
		}
				
		//如果当前敞口限额大于当前授信限额，则超额
		if(dSubLineSum2 > dSubLineSum1) flag2 = true;
		//对授信限额进行汇率控制
		dSubLineSum1=dSubLineSum1*dERateValue;
		//如果授信限额大于授信总额，则超额
		if(dSubLineSum1 > dLineSum) flag1 = true;
		
		//判断返回值
		if(!"99".equals(flag3))//没有分配相同业务类型或者比当前分配的业务类型范围
		{
			if(flag1 == false)//授信限额小于授信总额
			{
				if(flag2 == false) flag3 = "00";//当前敞口限额小于等于当前授信限额
				else flag3 = "01";
			}
			else
			{
				if(flag2 == false) flag3 = "10";
				else flag3 = "11";
			}
		}
		return flag3;
	    
	}

}

package com.amarsoft.app.check;

import java.text.DecimalFormat;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 集团授信总额度检查（检查项下的申请是否超过集团总额度）
 * @author syang
 * @since 2009/12/19
 * @updatesuer:yhshan
 * @updatedate:2012/09/11
 * 说明：	1.找出该笔申请关联的额度信息
 *			2.找出该笔额度项下的申请
 *			3.计算计算是否超出集授信总额度
 *
 */
public class ApplyGroupCreditLineCheck extends AlarmBiz {
	

	public Object run(Transaction Sqlca) throws Exception {
		
		/* 取参数 */
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//取出申请JBO对象
		
		
		/* 变量定义 */
		boolean bPass = true;
		double creditSum  = 0.0;			//集团授信总额度
		double underLineSum  = 0.0;			//集团授信额度项下申请总金额
		String sApplyNo = jboApply.getAttribute("SerialNo").getString();		//取出业务申请号
		
		/* 程序体 */
		//1.找出集团授信申请号
		//	找出申请关联的子额度协议号

		SqlObject so=null; //声明对象
		String sSql = "select LineNo from CREDITLINE_RELA where ObjectNo =:ObjectNo and ObjectType='CreditApply'";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo", sApplyNo);
		String sLineNo = Sqlca.getString(so);
		
		// 查找子额度授信协议信息，主要查找关联的集团授信额度号
		sSql = "select GroupLineID from CL_INFO where LineID =:LineID ";
		so = new SqlObject(sSql);
		so.setParameter("LineID", sLineNo);
		String sGroupLineID = Sqlca.getString(so);
		if(sGroupLineID != null){
			// 查找集团授信信息
			//sSql = "select LineSum1 from CL_INFO where LineID='"+sGroupLineID+"'";
			//creditSum = Sqlca.getDouble(sSql).doubleValue();
			sSql = "select LineSum1 from CL_INFO where LineID =:LineID";
			so = new SqlObject(sSql);
			so.setParameter("LineID", sGroupLineID);	
			creditSum = Sqlca.getDouble(so);

			DecimalFormat df = new DecimalFormat("###.##");
			String sCreditSum = df.format(creditSum);
			putMsg("集团额度授信协议号:"+sGroupLineID+",集团授信额度："+sCreditSum);
			//2.找出授信额度项下申请
			sSql = "select BA.CustomerID as CustomerID,BA.CustomerName as CustomerName,BA.SerialNo as ApplyNo,BA.BusinessSum as BusinessSum "
					+" from CL_INFO CI,CREDITLINE_RELA CR,BUSINESS_APPLY BA "
					+" where CI.LineID=CR.LineNo"
					+" and CR.ObjectNo=BA.SerialNo"
					+" and CR.ObjectType='CreditApply'"
					+" and CI.GroupLineID=:GroupLineID"
					;
			so = new SqlObject(sSql);
			so.setParameter("GroupLineID", sGroupLineID);
			ASResultSet rs = Sqlca.getASResultSet(so);
			while(rs.next()){
				String rsCustomerID = rs.getString("CustomerID");
				String rsCustomerName = rs.getString("CustomerName");
				String rsApplyNo = rs.getString("ApplyNo");
				double rsBusinessSum = rs.getDouble("BusinessSum");
				putMsg("客户号："+rsCustomerID+"，客户名:"+rsCustomerName+"，申请号："+rsApplyNo+"，申请金额:"+rsBusinessSum);
				underLineSum += rsBusinessSum;		//金额累加
			}
			rs.getStatement().close();
			rs = null;
			//判断是否超出总金额
			if(underLineSum > creditSum){
				putMsg("集团授信项下业务总额大于集团授信额度");
				bPass = false;
			}else{
				bPass = true;
			}
		}else{
			putMsg("数据不完整，没找到相关集团授信额度信息");
			bPass = false;
		}
		/* 返回结果处理 */
		setPass(bPass);
		return null;
	}
}

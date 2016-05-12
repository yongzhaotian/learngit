package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 *  复核通过的放贷申请，在演示模式下，支持手动转入贷后
 * @author syang
 * 
 */
public class TransToAfterLoan extends Bizlet {
	
	/**
	 * 对象类型
	 * <dt>目前系统支持的对象类型有</dt>
	 * <li>CreditApply 授信及其额度申请</li>
	 * <li>ApproveApply 最终审批意见登记</li>
	 * <li>PutOutApply 放贷申请</li>
	 * <li>Customer 信用等级评估申请</li>
	 * <li>Classify 五级分类申请</li>
	 * <li>Reserve 单项计提减值准备认定申请</li>
	 * <li>SMEApply 中小企业资格认定申请</li>
	 */
	private String sObjectType = "";
	/**
	 * 对象编号
	 */
	private String sObjectNo = "";
	
	/**
	 * 数据库连接对象
	 */
	private Transaction Sqlca = null;

	/**
	 * bizlet入口
	 * @param 参数说明
	 * 		<li>ObjectType 对象类型</li>
	 * 		<li>ObjectNo　对象编号</li>
	 * cbsu 2009/11/17 在向表BUSINESS_DUEBILL新增记录时新增了ActualMaturity(执行到期日),UpdateDate(更新日期),
     *                 PaymentType(信用证付款期限),ClassifyResult(五级分类结果)四个字段的值。
	 */
	public Object run(Transaction Sqlca) throws Exception{
		this.sObjectType = (String)this.getAttribute("ObjectType");
		this.sObjectNo = (String)this.getAttribute("ObjectNo");
		this.Sqlca = Sqlca; 
		//String sUserID = (String)this.getAttribute("UserID");
		//String sOrgID = (String)this.getAttribute("OrgID");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";		
		//if(sUserID == null) sUserID = "";
		//if(sOrgID == null) sOrgID = "";
		String sDuebillNo ="";//借据号
		try{
			sDuebillNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL","SerialNo","",Sqlca);
			//第1步：生成借据
			insertBusinessDuebill(sDuebillNo);
			//第2步：生成流水表记录
			insertBusinessWaste(sDuebillNo);
			//第3步：更新合同
			updateBusinessContract();
			//第4步：出账归档
			updateBusinessPutout();
			
			return "1";
		}catch(Exception e){
			ARE.getLog().error("转至贷后出错，对象类型："+sObjectType+"对象编号："+sObjectNo, e);
			return "0";
		}
	}
	
	/**
	 * 复制借据信息
	 * @throws Exception
	 */

	private void insertBusinessDuebill(String sDuebillNo) throws Exception{

	    String sSql = "";
	    ASResultSet rs = null;
		
		//五级分类结果
		String sClassifyResult = "";
		//信用证付款期限，用来抽取征信代码
		String sLCtermType = "";
		//更新日期，赋值为当前日期
		String sUpdateDate = StringFunction.getToday();
		//从合同表中取出五级分类结果和信用证付款期限值
		sSql = " Select ClassifyResult,LCtermType from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		while (rs.next()) {
		    sClassifyResult = rs.getString("ClassifyResult");
		    sLCtermType = rs.getString("LCtermType");
		}
		if (sClassifyResult == null) sClassifyResult = "";
		if (sLCtermType == null) sLCtermType = "";
		
		//将得到的信用证付款期限的值转化为对应的征信代码，详情见代码表LCTermType
		if (!"".equals(sLCtermType)) {
		    if ("01".equals(sLCtermType)) {
		        sLCtermType = "1";
		    } else {
		        sLCtermType = "2";
		    }
		}
		
		sSql = " INSERT INTO BUSINESS_DUEBILL("
			+" SerialNO,"
			+" RelativeSerialNO1,"
			+" RelativeSerialNO2,"
			+" SubjectNO,"
			+" CustomerID,"
			+" CustomerName,"
			+" BusinessSum,"
			+" OccurDate,"
			+" OperateOrgID,"
			+" OperateUserID,"
			+" BusinessType,"
			+" BusinessCurrency,"
			+" ActualBusinessRate,"
			+" PutoutDate,"
			+" Maturity,"
			+" ActualMaturity,"
			+" NormalBalance,"
			+" Balance,"
			+" OverdueBalance,"
			+" DullBalance,"
			+" BadBalance,"
			+" UpdateDate,"
			+" ClassifyResult,"
			+" PaymentType"
			+" )"
			+" SELECT "
			+"'"+sDuebillNo+"',"
			+" SerialNO,"
			+" ContractSerialNO,"
			+" SubjectNO,"
			+" CustomerID,"
			+" CustomerName,"
			+" BusinessSum,"
			+" OccurDate,"
			+" OperateOrgID,"
			+" OperateUserID,"
			+" BusinessType,"
			+" BusinessCurrency,"
			+" BusinessRate,"
			+" PutoutDate,"
			+" Maturity,"
			+" Maturity,"
			+" BusinessSum,"
			+" BusinessSum,"
			+" 0,"
			+" 0,"
			+" 0,"
			+"'"+sUpdateDate+"',"
			+"'"+sClassifyResult+"',"
			+"'"+sLCtermType+"'"
			+" FROM BUSINESS_PUTOUT"
			+" WHERE SerialNo='"+sObjectNo+"'"
			;
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 复制流水信息
	 * @throws Exception
	 */
	private void insertBusinessWaste(String sDuebillNo) throws Exception{
		String sWasteBoolNo = DBKeyHelp.getSerialNo("BUSINESS_WASTEBOOK","SerialNo","",Sqlca);
		String sSql = "INSERT INTO BUSINESS_WASTEBOOK("
			+" SerialNO,"
			+" RelativeSerialNo,"
			+" RelativeContractNO,"
			+" OccurDate,"
			+" ActualdebitSum,"
			+" OccurType,"
			+" TransactionFlag,"
			+" OccurDirection,"
			+" OccurSubject,"
			+" BackType,"
			+" OrgID,"
			+" UserID"
			+")"
			+" SELECT "
			+" '"+sWasteBoolNo+"',"
			+" '"+sDuebillNo+"',"
			+" ContractSerialNO,"
			+" OccurDate,"
			+" BusinessSum,"
			+" '0',"
			+" '0',"
			+" '1',"
			+" '0',"
			+" '3001',"
			+" InputOrgID,"
			+" InputUserID"
			+" FROM BUSINESS_PUTOUT"
			+" WHERE SerialNo='"+sObjectNo+"'"
			;
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 更新出账信息
	 * @throws Exception
	 */
	private void updateBusinessPutout() throws Exception{
		String sSql = "update BUSINESS_PUTOUT set PigeonholeDate =:PigeonholeDate where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("PigeonholeDate", StringFunction.getToday()).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
	/**
	 * 更新合同信息
	 * @throws Exception 
	 */
	private void updateBusinessContract() throws Exception{
		String sSql = "select ContractSerialNo,BusinessSum from business_putout where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getResultSet(so);
		String sContractNo = "";
		double businessSum = 0.0;
		if(rs.next()){
			sContractNo = rs.getString("ContractSerialNo");
			businessSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		rs = null;
		if(sContractNo == null) sContractNo = "";
		if(!sContractNo.equals("")){
			sSql = "update BUSINESS_CONTRACT set Balance = nvl(Balance,0)+"+businessSum+" where SerialNo =:SerialNo ";
			so = new SqlObject(sSql).setParameter("SerialNo", sContractNo);
			Sqlca.executeSQL(so);
		}else{
			throw new Exception("数据异常，此出账记录，没找到相关合同信息！");
		}
	}
	
}
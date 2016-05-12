package com.amarsoft.app.lending.bizlets;
/**
 * 权限判断
 * @author 王业罡 2005-08-11
 * 			syang 整理此类，修正结果集关闭可能存在的问题
 */
import java.sql.SQLException;
import java.util.ArrayList;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class ASObjectRight extends Bizlet 
{

	/**
	 * @param
	 * 	<li>MethodName 方法名</li>
	 * 	<li>ObjectType 对象类型</li>
	 * 	<li>ObjectNo 对象编号</li>
	 * 	<li>ViewID 视图ID</li>
	 * 	<li>UserID 用户ID</li>
	 */
	public Object  run(Transaction Sqlca) throws Exception
	{
		//获取参数：方法名、对象编号，视图ID，用户编号		
		String sMethodName = (String)this.getAttribute("MethodName");	
		String sObjectType=(String)this.getAttribute("ObjectType");
		String sObjectNo=(String)this.getAttribute("ObjectNo");
		String sViewID=(String)this.getAttribute("ViewID");
		String sUserID=(String)this.getAttribute("UserID");
		if(sMethodName == null) sMethodName = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sViewID == null) sViewID = "";
		if(sUserID == null) sUserID = "";
		
		String sReturn="";
		if(sMethodName.equals("rightOfCustomer")){
			sReturn=rightOfCustomer(Sqlca,sObjectNo,sViewID,sUserID,sObjectType);
		}else if(sMethodName.equals("rightOfApply")){
			sReturn=rightOfApply(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfApprove")){
			sReturn=rightOfApprove(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfContract")){
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfCreditLine")){
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfPutOut")){
			sReturn=rightOfPutOut(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.endsWith("rightOfPayment")){
			sReturn=rightOfPutOut(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}
		//核算添加或修改-start
		else if(sMethodName.endsWith("rightOfTrans")){
			sReturn=rightOfTrans(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}
		//核算添加或修改-end
		else{
			sReturn=rightOfViewId(sObjectNo,sViewID,sUserID);
		}
		
		return sReturn;
	}
	
    //  按照ViewID判断,001可编辑，其余只读
	public String rightOfViewId(String pObjectNo, String pViewID, String pUserID) {
		if (pViewID.equals("001"))
			return "All";
		else
			return "ReadOnly";
	}
	
	/**
	 * 客户对象权限判断
	 * @param 参数：
	 * 	<li>Sqlca　数据库连接</li>
	 * 	<li>pCustomerID 客户ID</li>
	 * 	<li>pUserID 用户ID</li>
	 * 	<li>pViewID 视图ID
	 * 		000返回ALL,
	 * 		不为001返回ReadOnly,
	 * 		001根据用户角色信息维护权判断
	 * 	</li>
	 */
    public String rightOfCustomer(Transaction Sqlca,String pCustomerID, String pViewID, String pUserID, String sObjectType) throws Exception {
    	String sReturn = "ReadOnly";
    	/*String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//先获取预先处理结果，如果预先处理结果不为Continue,则返回权限，否则继续运行
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //管户人可以进行数据维护
        String sBelongAttribute1 = ""; //信息查看权
        String sBelongAttribute2 = ""; //信息维护权
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BelongAttribute1,BelongAttribute2 from CUSTOMER_BELONG " +
        		"where CustomerID = :CustomerID and UserID = :UserID").setParameter("CustomerID", pCustomerID).setParameter("UserID", pUserID));
        if (rs.next()) {
        	sBelongAttribute1 = rs.getString("BelongAttribute1");
        	sBelongAttribute2 = rs.getString("BelongAttribute2");
        	//将空值转化为空字符串
        	if(sBelongAttribute1 == null) sBelongAttribute1 = "";
        	if(sBelongAttribute2 == null) sBelongAttribute2 = "";
        	if(sBelongAttribute2.equals("1")){
        		sReturn = "All";
        	}else if(sBelongAttribute1.equals("1")){
        		sReturn = "ReadOnly";
        	
        }
        
        // for customer view
        
        rs.getStatement().close();
        rs = null;}*/
    	/*String sPhaseNo = "";
    	String sContractNo = "";
    	ASResultSet rs = null;
    	if(sObjectType.equals("Customer")){
    		//用客户获取最新的合同
        	rs = Sqlca.getASResultSet("Select PhaseNo From Flow_Object Where Objectno "+
        			"in(select serialno from Business_Contract where CustomerID = '"+pCustomerID+"') and UserID = '"+pUserID+"' and PhaseNo = '0010'");
        	if(rs.next()){
        		sReturn = "All";
        	}
        	
    	}else{
    		sPhaseNo = Sqlca.getString(new SqlObject("Select PhaseNo From Flow_Object Where Objectno=:ObjectNo and UserID =:UserID")
        	.setParameter("ObjectNo", pCustomerID).setParameter("UserID", pUserID));
    		if ("0010".equals(sPhaseNo)) sReturn = "All";
    	}*/
    	
    	sReturn = "All";
    	
        return sReturn;
    }

    /**
     * 申请对象权限判断
	 * @param 参数：
	 * 	<li>Sqlca　数据库连接</li>
	 * 	<li>pObjectType 对象类型</li>
	 * 	<li>pObjectNo 对象编号</li>
	 * 	<li>pUserID 用户ID</li>
	 * 	<li>pViewID 视图ID
	 * 		000返回ALL,
	 * 		不为001返回ReadOnly,
	 * 		001根据用户角色信息维护权判断
	 * 	</li>
     */
	public String rightOfApply(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception {
        String sReturn = "ReadOnly";
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//先获取预先处理结果，如果预先处理结果不为Continue,则返回权限，否则继续运行
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //申请登记人可以在申请未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ObjectNo from FLOW_OBJECT " +
        		"where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId " +
        		"and  (PhaseNo='0010' or PhaseNo='3000' or PhaseType='1010')").setParameter("ObjectType", pObjectType)
        		.setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next())  {
        	sReturn = "All";
        }
        rs.getStatement().close();
        rs = null;
        return sReturn;
    }
	
	/**
	 * 最终审批意见对象权限判断
	 * @param 参数：
	 * 	<li>Sqlca　数据库连接</li>
	 * 	<li>pObjectType 对象类型</li>
	 * 	<li>pObjectNo 对象编号</li>
	 * 	<li>pUserID 用户ID</li>
	 * 	<li>pViewID 视图ID
	 * 		000返回ALL,
	 * 		不为001返回ReadOnly,
	 * 		001根据用户角色信息维护权判断
	 * 	</li>
	 */
	public String rightOfApprove(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception {
        String sReturn = "ReadOnly";
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//先获取预先处理结果，如果预先处理结果不为Continue,则返回权限，否则继续运行
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //最终审批意见登记人可以在最终审批意见未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo='0010' or PhaseNo='3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", pObjectType).setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()) {
        	sReturn = "All";
        	rs.getStatement().close(); // add by cbsu 2009-10-20
        	return sReturn;
        }
        rs.getStatement().close();
        rs = null;
        return sReturn;
    }
	
	/**
	 * 合同权限判断
	 * 1.用户预先权限判断，是否超级用户，视图号
	 * 2.合同在补登标志为未补等，且当前用户为所辖机构时都可以维护数据
	 * 3.合同为综合授信协议时，如果已经被别的授信项下业务申请占用，也不能进行修改
	 * 4.合同管户人、登记人、保全管户人在合同没有提请放贷且合同项下没有借据时可以维护数据
	 * @param 参数：
	 * 	<li>Sqlca　数据库连接</li>
	 * 	<li>pObjectType 对象类型</li>
	 * 	<li>pObjectNo 对象编号</li>
	 * 	<li>pUserID 用户ID</li>
	 * 	<li>pViewID 视图ID
	 * 		000返回ALL,
	 * 		不为001返回ReadOnly,
	 * 		001根据用户角色信息维护权判断
	 * 	</li>
	 */
	public String rightOfContract(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        /*boolean bContinue = true;

    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//先获取预先处理结果，如果预先处理结果不为Continue,则返回权限，否则继续运行
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
       
        ASResultSet rs = null;
        //实例化用户
        ASUser CurUser = ASUser.getUser(pUserID,Sqlca);
        //合同在补登标志为未补等，且当前用户为所辖机构时都可以维护数据
        rs = Sqlca.getASResultSet(new SqlObject("select ReinforceFlag from BUSINESS_CONTRACT where SerialNo=:SerialNo and ManageOrgID like :OrgID")
        		.setParameter("SerialNo", pObjectNo).setParameter("OrgID", CurUser.getOrgID()+"%"));
        if (rs.next()){
        	String sReinforceFlag = rs.getString("ReinforceFlag");
        	if (sReinforceFlag==null) sReinforceFlag="";
        	if (sReinforceFlag.equals("010")){ //补登标志ReinforceFlag（010：未补登；020：已补登）
        		sReturn = "All";
        		bContinue = false;
        	}
        }
        rs.getStatement().close();
        //如果不能继续，则返回结果
        if(!bContinue){	
        	return sReturn;
        }
        
        //合同为综合授信协议时，如果已经被别的授信项下业务申请占用，也不能进行修改
        String sBusinessType = "";
        rs = Sqlca.getASResultSet(new SqlObject("select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo ").setParameter("SerialNo", pObjectNo));
        if (rs.next()) {
        	sBusinessType = rs.getString("BusinessType");
        	if(sBusinessType == null) sBusinessType = "";
        }
        rs.getStatement().close();
        
        if(sBusinessType.length() >=1 && sBusinessType.substring(0,1).equals("3")){ //额度
        	rs = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_APPLY where CreditAggreement = :CreditAggreement").setParameter("CreditAggreement", pObjectNo));
        	if (!rs.next()){        		
    			sReturn = "All";
    			bContinue = false;
        	}
        	rs.getStatement().close();
        	//如果不能继续，则返回结果
        	if(!bContinue){
        		return sReturn;
        	}
        }else{        
	        //合同管户人、登记人、保全管户人在合同没有提请放贷且合同项下没有借据时可以维护数据
	        String sSql = "select SerialNo from BUSINESS_CONTRACT where SerialNo=:SerialNo and (InputUserID = :InputUserID or ManageUserID = :ManageUserID) and (PigeonholeDate is null or PigeonholeDate=' ')";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", pObjectNo).setParameter("InputUserID", pUserID).setParameter("ManageUserID", pUserID));
	        if (rs.next()){        	
	        	rs.getStatement().close();
	        	rs = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ContractSerialNo = :ContractSerialNo").setParameter("ContractSerialNo", pObjectNo));
	        	if(!rs.next()){
	        		rs.getStatement().close();
	        		rs = Sqlca.getASResultSet(new SqlObject("select RelativeSerialNo2  from BUSINESS_DUEBILL where RelativeSerialNo2=:RelativeSerialNo2").setParameter("RelativeSerialNo2", pObjectNo));
	        		if (!rs.next()){
	        			sReturn = "All";
	        			bContinue = false;
	        			return sReturn;
	        		}
        			rs.getStatement().close();
        			//如果不能继续，则返回结果
        			if(!bContinue){
        				return sReturn;
        			}
	        	}else{
	        		rs.getStatement().close();
	        	}
	        }else{
	        	rs.getStatement().close();
	        }
        }*/
        //String sPhaseNo = Sqlca.getString(new SqlObject("Select PhaseNo From Flow_Object Where Objectno=:ObjectNo and UserID =:UserID").setParameter("ObjectNo", pObjectNo).setParameter("UserID", pUserID));
        //if ("0010".equals(sPhaseNo)) sReturn = "All";
        // 如果合同状态为已经签署， 只读
        String sContractStatus = Sqlca.getString(new SqlObject("SELECT CONTRACTSTATUS from BUSINESS_CONTRACT where SERIALNO=:ObjectNo").setParameter("ObjectNo", pObjectNo));
        if ("060".equals(sContractStatus)) sReturn = "All";
        
        return sReturn;
    }
	
	/**
	 * 出帐对象权限判断
	 * @param 参数：
	 * 	<li>Sqlca　数据库连接</li>
	 * 	<li>pObjectType 对象类型</li>
	 * 	<li>pObjectNo 对象编号</li>
	 * 	<li>pUserID 用户ID</li>
	 * 	<li>pViewID 视图ID
	 * 		000返回ALL,
	 * 		不为001返回ReadOnly,
	 * 		001根据用户角色信息维护权判断
	 * 	</li>
	 */
	public String rightOfPutOut(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//先获取预先处理结果，如果预先处理结果不为Continue,则返回权限，否则继续运行
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //出帐登记人可以在出帐未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo = '0010' or PhaseNo = '3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", pObjectType).setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()){
        	sReturn = "All";
        }
        rs.getStatement().close();
       
        return sReturn;
    }
	
	/**
	 * 支付对象权限判断
	 * @param 参数：
	 * 	<li>Sqlca　数据库连接</li>
	 * 	<li>pObjectType 对象类型</li>
	 * 	<li>pObjectNo 对象编号</li>
	 * 	<li>pUserID 用户ID</li>
	 * 	<li>pViewID 视图ID
	 * 		000返回ALL,
	 * 		不为001返回ReadOnly,
	 * 		001根据用户角色信息维护权判断
	 * 	</li>
	 */
	public String rightOfPayment(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception
	{
		String sReturn = "ReadOnly";
        
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//先获取预先处理结果，如果预先处理结果不为Continue,则返回权限，否则继续运行
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //支付登记人可以在支付未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo = '0010' or PhaseNo = '3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", pObjectType).setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()){
        	sReturn = "All";
        }
        rs.getStatement().close();
       
        return sReturn;
	}
	
	//核算添加或修改-start
	/**
	 * 交易对象权限判断
	 * @param 参数：
	 * 	<li>Sqlca　数据库连接</li>
	 * 	<li>pObjectType 对象类型</li>
	 * 	<li>pObjectNo 对象编号</li>
	 * 	<li>pUserID 用户ID</li>
	 * 	<li>pViewID 视图ID
	 * 		000返回ALL,
	 * 		不为001返回ReadOnly,
	 * 		001根据用户角色信息维护权判断
	 * 	</li>
	 */
	public String rightOfTrans(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//先获取预先处理结果，如果预先处理结果不为Continue,则返回权限，否则继续运行
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //出帐登记人可以在出帐未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo = '0010' or PhaseNo = '3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", "TransactionApply").setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()){
        	sReturn = "All";
        }
        rs.getStatement().close();
       
        return sReturn;
    }
	//核算添加或修改-end
	
	/**
	 * 权限预先处理
	 * <p>
	 * <li>pViewID　为000 则直接返回ALL</li>
	 * <li>pViewID　为001 执行后面的检查，Continue</li>
	 * <li>pViewID　不为001 执行后面的检查，返回ReadOnly</li>
	 * </p>
	 * <p>
	 * 如果当前用户为超级用户则返回ALL,否则Continue
	 * </p>
	 * @param Sqlca
	 * @param pViewID
	 * @param pUserID
	 * @return
	 * @throws Exception 
	 * @throws SQLException 
	 */
	private String rightPreCheck(Transaction Sqlca,String pViewID,String pUserID) throws SQLException, Exception{
        String sReturn = "Continue";
        
		if (pViewID.equals("000")){
			sReturn = "All";
			return sReturn;
		}else if (!pViewID.equals("001")){
			sReturn = "ReadOnly";
			return sReturn;
		}
        ASResultSet rs = null;

        //如果是超级用户，则直接返回所有权限
        rs = Sqlca.getASResultSet(new SqlObject("select RoleID from USER_ROLE where RoleID = '000' and UserID = :UserID").setParameter("UserID", pUserID));
        if (rs.next()) {
        	sReturn = "All";
        }
        rs.getStatement().close();
        rs = null;
	    return sReturn;
	}
}

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.aa.AuthorizationException;
import com.amarsoft.app.aa.AuthorizationPoint;
import com.amarsoft.app.aa.Policy;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.res.AppBizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author William
 * 本Bizlet用于检查授权<br>
 * 本方法是一个授权检查的示例，假设<br>
 *  - 授权的维度为：流程阶段、机构、产品、担保方式<br>
 *  - 授权的度量为：单笔业务总金额上限、利率下限进行授权<br>
 *  - 未考虑多币种的问题<br>
 *  - 担保方式编码是有层次感的<br>
 *  - 产品定义（BUSINESS_TYPE）的SortNo是有层次感的<br>
 * 请项目组自行调整。<br>
 */
public class CheckCreditApplyAuthorization extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sFlowNo = (String)this.getAttribute("FlowNo");
		String sPhaseNo = (String)this.getAttribute("PhaseNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sPolicyID = (String)this.getAttribute("PolicyID");
		String sOrgID = (String)this.getAttribute("OrgID");
		
		if(sObjectType==null || !sObjectType.equals("CreditApply")){
			throw new Exception("错误的对象类型:"+sObjectType);
		}
		AppBizObject bo = new AppBizObject(Sqlca,sObjectType,sObjectNo);
		
		if(sPolicyID==null){
			SqlObject so = new SqlObject("select AAPolicy from FLOW_CATALOG where FlowNo=:FlowNo ").setParameter("FlowNo", sFlowNo);
			sPolicyID = Sqlca.getString(so);
		}

		//第一步：取业务数据
		initBizObjectData(Sqlca,bo);
		
		//第二步：查找与该业务、该流程对应的权限点
		Policy policy = new Policy(Sqlca,sPolicyID);
		
		AuthorizationPoint point = null;
		AuthorizationPoint[] aapoints = policy.getAuthPoints(Sqlca);
		
		//从后向前找，以找到的第一个授权点为准
		for(int i=aapoints.length-1;i>=0;i--){
			//注意：下列进行授权点匹配的机构号是当前审批人所在机构,并非业务机构
			if(checkFlowPhaseCompliance(aapoints[i],sFlowNo,sPhaseNo)
				&& checkProductCompliance(aapoints[i],(String)bo.getAttribute("BusinessType"))
				&& checkVouchTypeCompliance(aapoints[i],(String)bo.getAttribute("VouchType"))
				&& checkOrgCompliance(aapoints[i],sOrgID)){
				point =  aapoints[i];
			}
		}
		if(point == null) return "没有找到对该类业务的授权定义（流程:"+sFlowNo+",阶段:"+sPhaseNo+",产品:"+bo.getAttribute("ProductSortNo")+",担保方式类别:"+bo.getAttribute("VouchType")+"）。";
		
		//第三步：根据授权点定义和例外条件定义，取得该授权点的终批单笔金额上限、终批单笔敞口授权上限、终批单户金额授权上限、终批单户敞口授权上限、终批利率下限
		double dBizBalanceCeiling = 0;
		double dBizExposureCeiling = 0;
		double dCustBalanceCeiling = 0;
		double dCustExposureCeilin = 0;
		double dInterestRateFloor = 0;
		
		/*
		 * 按顺序逐项判断例外条件，只要任意一项例外条件满足，
		 * 则以该例外条件的终批单笔金额上限、终批单笔敞口授权上限、
		 * 终批单户金额授权上限、终批单户敞口授权上限、授权利率作为授权点的授权金额、授权利率
		 */
		AuthorizationException matchedException = null;
		for(int i=0;i<point.countExceptions();i++){
			if(matchExceptionType(Sqlca,point,point.getException(i),bo)){
				matchedException=(AuthorizationException)point.getException(i);
				break;
			}
		}

		/*如果满足例外条件，则以例外条件定义的终批单笔金额上限、终批单笔敞口授权上限、
		 * 终批单户金额授权上限、终批单户敞口授权上限、授权利率为准，
		 * 否则以授权点的终批单笔金额上限、终批单笔敞口授权上限、
		 * 终批单户金额授权上限、终批单户敞口授权上限、授权利率为准*/
		if(matchedException!=null){
			dBizBalanceCeiling = toDouble(matchedException.getAttribute("AE.BizBalanceCeiling"));
			dBizExposureCeiling = toDouble(matchedException.getAttribute("AE.BizExposureCeiling"));
			dCustBalanceCeiling = toDouble(matchedException.getAttribute("AE.CustBalanceCeiling"));
			dCustExposureCeilin = toDouble(matchedException.getAttribute("AE.CustExposureCeilin"));
			dInterestRateFloor = toDouble(matchedException.getAttribute("AE.InterestRateFloor"));
		}else{
			dBizBalanceCeiling = toDouble(point.getAttribute("BizBalanceCeiling"));
			dBizExposureCeiling = toDouble(point.getAttribute("AE.BizExposureCeiling"));
			dCustBalanceCeiling = toDouble(point.getAttribute("AE.CustBalanceCeiling"));
			dCustExposureCeilin = toDouble(point.getAttribute("AE.CustExposureCeilin"));
			dInterestRateFloor = toDouble(point.getAttribute("InterestRateFloor"));
		}

		/*第四步：判终批单笔金额上限、终批单笔敞口授权上限、
		 * 终批单户金额授权上限、终批单户敞口授权上限、授权利率*/
		if(toDouble(bo.getAttribute("BusinessSum")) > dBizBalanceCeiling) return "金额超过授权终批单笔金额上限";
		if(toDouble(bo.getAttribute("Exposure")) > dBizExposureCeiling) return "金额超过授权终批单笔敞口金额上限";
		if(toDouble(bo.getAttribute("TotalSum")) > dCustBalanceCeiling) return "金额超过授权终批单户金额上限";
		if(toDouble(bo.getAttribute("ExposureSum")) > dCustExposureCeilin) return "金额超过授权终批单户敞口金额上限";
		if(toDouble(bo.getAttribute("BusinessRate")) > dInterestRateFloor) return "利率超过授权终批利率下限";

		/*第五步：判终申请的经办机构是否满足审批条件*/
		if(!(checkOrgCompliance(point,(String)bo.getAttribute("OperateOrgID")))) return "申请的经办机构超出授权机构范围";

		/*第六步：判终申请的产品是否满足审批条件*/
		if(!(checkProductCompliance(point,(String)bo.getAttribute("BusinessType")))) return "申请的产品超出授权产品范围";
			
		/*第七步：判终申请的主要担保方式是否满足审批条件*/
		if(!(checkVouchTypeCompliance(point,(String)bo.getAttribute("VouchType")))) return "申请的主要担保方式超出授权担保方式范围";

		/*第八步：判终申请的经办机构是否满足审批条件*/
		if(!(checkFlowPhaseCompliance(point,sFlowNo,sPhaseNo))) return "申请所处的流程和阶段超出授权流程和阶段范围";
		
		/*如果项目组需要增加其他授权口径，请在此进行自行扩展*/
		//------------------------------begin--------------------
		

		
		//------------------------------end----------------------
		//如果通过授权判断，则返回空字符串
		return "Pass";
	}
	
	
	private void initBizObjectData(Transaction Sqlca,AppBizObject bo) throws Exception{
		SqlObject so ;//声明对象
		String sSql = 	" select CustomerID,BusinessType,VouchType,OperateOrgID,OperateUserID,RiskRate, "+
		" BusinessSum*getERate(BusinessCurrency,'01','') as BusinessSum,BailSum,BusinessRate "+
		" from BUSINESS_APPLY where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", bo.getObjKey());
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			String sCustomerID = rs.getString("CustomerID");
			String sBusinessType = rs.getString("BusinessType");
			String sVouchType = rs.getString("VouchType");
			String sOperateOrgID = rs.getString("OperateOrgID");
			String sOperateUserID = rs.getString("OperateUserID");
			String sRiskRate = rs.getString("RiskRate");
			String sBusinessSum = rs.getString("BusinessSum");
			String sBailSum = rs.getString("BailSum");
			String sBusinessRate = rs.getString("BusinessRate");
			
			//将空值转化为空字符串
			if(sCustomerID == null) sCustomerID = "";
			if(sBusinessType == null) sBusinessType = "";
			if(sVouchType == null) sVouchType = "";
			if(sOperateOrgID == null) sOperateOrgID = "";
			if(sOperateUserID == null) sOperateUserID = "";
			if(sRiskRate == null) sRiskRate = "0.0";
			if(sBusinessSum == null) sBusinessSum = "0.0";
			if(sBailSum == null) sBailSum = "0.0";
			if(sBusinessRate == null) sBusinessRate = "0.0";
			
			//将查询到的申请信息赋给bo对象
			bo.setAttribute("CustomerID",sCustomerID);
			bo.setAttribute("BusinessType",sBusinessType);
			bo.setAttribute("VouchType",sVouchType);
			bo.setAttribute("OperateOrgID",sOperateOrgID);
			bo.setAttribute("OperateUserID",sOperateUserID);			
			bo.setAttribute("RiskRate",sRiskRate);			
			bo.setAttribute("BusinessSum",sBusinessSum);
			bo.setAttribute("BailSum",sBailSum);
			bo.setAttribute("BusinessRate",sBusinessRate);
			/*该笔申请业务的敞口金额=该笔申请业务的申请金额－该笔申请业务的保证金金额
			 * 如果有些银行是输入保证金比率，请在申请保存时将保证金金额计算出来并存放在BailSum中
			 */
			bo.setAttribute("Exposure",String.valueOf(rs.getDouble("BusinessSum")-rs.getDouble("BailSum")));
			/*
			 * 目前原型系统中输入的是执行年利率，可以直接进行判断。
			 * 如果项目组不是直接输入执行年利率，请在此处根据输入的信息自行计算。
			 */
			bo.setAttribute("BusinessRate",String.valueOf(rs.getDouble("BusinessRate")));
			/*获取该客户的单户金额
			 * 目前原型系统是在业务合同表中获取该客户累计的发放金额
			 * 如果项目组计算单户金额不同，请修改该方法
			 */
			bo.setAttribute("TotalSum",String.valueOf(getTotalSum(Sqlca,rs.getString("CustomerID"))));
			/*获取该客户的单户敞口金额
			 * 目前原型系统是在业务合同表中获取该客户累计的发放金额－保证金金额
			 * 如果项目组计算单户敞口金额不同，请修改该方法
			 */
			bo.setAttribute("Exposure",String.valueOf(getExposureSum(Sqlca,rs.getString("CustomerID"))));
			
		}else{
			rs.getStatement().close();
			throw new Exception("没有找到对象:["+bo.getType().getObjectType()+":"+bo.getObjKey()+"]");
		}
		rs.getStatement().close();
		
		so = new SqlObject("select SortNo from BUSINESS_TYPE where TypeNo=:TypeNo ").setParameter("TypeNo", (String)bo.getAttribute("BusinessType"));
		String sProductSortNo = Sqlca.getString(so);
		bo.setAttribute("ProductSortNo",sProductSortNo);
	}
	
	/**
	 * 单户发放金额
	 * @param Sqlca 数据库连接
	 * @param sCustomerID 客户编号
	 * @return 单户发放金额
	 * @throws Exception
	 */
	private double getTotalSum(Transaction Sqlca,String sCustomerID) throws Exception{
		double dTotalSum = 0.0;
		String sSql = " select sum(BusinessSum*getERate(BusinessCurrency,'01','')) as BusinessSum "+
		" from BUSINESS_CONTRACT where CustomerID =:CustomerID and BusinessType not like  '3%' ";//除额度之外
		SqlObject so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			dTotalSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		return dTotalSum;
	}
	
	/**
	 * 单户发放敞口金额
	 * @param Sqlca 数据库连接
	 * @param sCustomerID 客户编号
	 * @return 单户发放敞口金额
	 * @throws Exception
	 */
	private double getExposureSum(Transaction Sqlca,String sCustomerID) throws Exception{
		double dExposureSum = 0.0;
		String sSql = " select sum(BusinessSum*getERate(BusinessCurrency,'01','')-BailSum) as ExposureSum "+
		" from BUSINESS_CONTRACT where CustomerID =:CustomerID and BusinessType not like  '3%' ";//除额度之外
		SqlObject so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			dExposureSum = rs.getDouble("ExposureSum");
		}
		rs.getStatement().close();
		
		return dExposureSum;
	}
	
	/**
	 * 产品类别匹配
	 * @param authPoint 授权点
	 * @param sProductSortNo 业务的产品排序号
	 * @return 是否匹配
	 * @throws Exception
	 */
	private boolean checkProductCompliance(AuthorizationPoint authPoint,String sProductSortNo) throws Exception{
		String sAuthProduct = (String)authPoint.getAttribute("ProductID");
		if(sAuthProduct==null || sAuthProduct.equals("")) return true;
		else if(sProductSortNo.indexOf(sAuthProduct)>=0) return true;
		else return false;
	}

	/**
	 * 担保类别匹配
	 * @param authPoint 授权点
	 * @param sGuarantyType 业务的担保类型
	 * @return 是否匹配
	 * @throws Exception
	 */
	private boolean checkVouchTypeCompliance(AuthorizationPoint authPoint,String sGuarantyType) throws Exception{
		String sAuthGuarantyCategory = (String)authPoint.getAttribute("GuarantyCategory");
		if(sAuthGuarantyCategory==null || sAuthGuarantyCategory.equals("")) return true;
		else if(sGuarantyType.indexOf(sAuthGuarantyCategory)>=0) return true;
		else return false;
	}

	/**
	 * 机构匹配
	 * @param authPoint 授权点
	 * @param sOrgID 当前审批人的机构号
	 * @return 是否匹配
	 * @throws Exception
	 */
	private boolean checkOrgCompliance(AuthorizationPoint authPoint,String sOrgID) throws Exception{
		String sAuthOrg = (String)authPoint.getAttribute("OrgID");
		if(sAuthOrg==null || sAuthOrg.equals("")) return true;
		else if(sOrgID.equals(sAuthOrg)) return true;
		else return false;
	}

	/**
	 * 流程阶段匹配
	 * @param authPoint 授权点
	 * @param sFlowNo 流程编号
	 * @param sPhaseNo 阶段编号
	 * @return 是否匹配
	 * @throws Exception
	 */
	private boolean checkFlowPhaseCompliance(AuthorizationPoint authPoint,String sFlowNo,String sPhaseNo) throws Exception{
		String sAuthFlow = (String)authPoint.getAttribute("FlowNo");
		String sAuthPhase = (String)authPoint.getAttribute("PhaseNo");
		if(sAuthFlow==null || sAuthFlow.equals("") || sAuthPhase==null || sAuthPhase.equals("")) return true;
		else if(sAuthFlow.equals(sFlowNo) && sAuthPhase.equals(sPhaseNo)) return true;
		else return false;
	}
	
	/**
	 * 授权点例外项匹配
	 * @param Sqlca
	 * @param ae
	 * @param bo
	 * @return
	 * @throws Exception 
	 */
	private boolean matchExceptionType(Transaction Sqlca,AuthorizationPoint point,AuthorizationException ae,AppBizObject bo) throws Exception{
		String sExpression = (String)ae.getAttribute("AET.ExceptionExpr");
		Any aReturn = null;
		boolean bReturn = false;
		if(sExpression!=null){
			try{
	        	sExpression = Expression.pretreatConstant(sExpression,ae.getConstants());
	        	sExpression = Expression.pretreatConstant(sExpression,bo.getConstants());
	        	sExpression = Expression.pretreatConstant(sExpression,point.getConstants());
		        aReturn = Expression.getExpressionValue(sExpression,Sqlca);
			}catch(Exception ex){
	        	throw new Exception("例外类型公式解析错误。公式："+sExpression+ex.getMessage());
	        }
			try{
	        	bReturn = aReturn.booleanValue();
	        	return bReturn;
			}catch(Exception ex){
	        	throw new Exception("例外类型公式返回值类型错误。公式："+sExpression);
	        }
		}
		return false;
	}
	
	private double toDouble(Object o){
		if(o==null) return 0;
		if(o.getClass().getName().equals("java.lang.String")){
			try{
				return DataConvert.toDouble((String)o);
			}catch(Exception e){
				return 0;
			}
		}else if(o.getClass().getName().equals("java.lang.Double")){
			return ((Double)o).doubleValue();
		}
		return 0;
	}
}

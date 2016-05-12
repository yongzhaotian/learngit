package com.amarsoft.app.bizmethod;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class BizSort {
	
	private boolean liquidity ;//流动资金贷款标志位
	private boolean fixed ;//固定资产贷款标志位
	private boolean project ;//项目融资标志位
	private boolean bizSort ;//产品分类标志位
	private String sSql = "";
	private Transaction Sqlca = null;
	private ASResultSet rs = null;//查询结果集
	
	/**
	 * @author smiao 2011-5-31
	 * <p>
	 * 	当知道业务品种编号时，不知道具体业务号时，使用该构造方法获取BUSINESS_TYPE中产品分类标志位。
	 * </p>
	 * @param Sqlca
	 * @param typeNo
	 * @throws Exception
	 */
	public BizSort(Transaction Sqlca ,String typeNo)throws Exception{
		this.Sqlca = Sqlca;
		updateSortValue(typeNo);
	}
	
	/**
	 * <p>
	 * 	在批复、合同、放贷等阶段，使用该构造方法，获取申请阶段中的IsLiquidity,IsFixed,IsProject的值
	 * </p>
	 * @param Sqlca
	 * @param objectType
	 * @param objectNo
	 * @param approveNeed
	 * @param typeNo
	 * @throws Exception 
	 * @throw Exception
	 */		
	public BizSort(Transaction Sqlca ,String objectType,String objectNo,String approveNeed,String typeNo)throws Exception{

		this.Sqlca = Sqlca;
		
		/**
		 * 获取BUSINESS_TYPE中产品分类标志位
		 */
		updateSortValue(typeNo);
		
		//如果不属于贷款新规管理范围，则置默认值
		if(this.bizSort == false){
			liquidity = false;
			fixed = false;
			project = false;
		}else{
			//计算SortAttributes
			calculateSortAttributesValue(this.Sqlca,objectType,objectNo,approveNeed,typeNo);
		}
	}

	/**
	 * 根据objecttype等信息判断sortAttributes取值
	 */
	private void calculateSortAttributesValue(Transaction Sqlca ,String objectType,String objectNo,String approveNeed,String typeNo) throws Exception{
		String bAPSerialNo = "";//BUSINESS_APPROVE的SerialNo
		String bASerialNo = "";//BUSINESS_APPLY的SerialNo
		
		//objectType为合同或者贷后合同
		if(objectType.equals("BusinessContract")||objectType.equals("AfterLoan"))
		{
			//根据approveNeed来判断业务是否需要审批
			if(approveNeed.equals("true"))
			{
				//获取BUSINESS_APPROVE的SerialNo
				sSql = "select RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = :SerialNo";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", objectNo));
				if(rs.next())
				{
					bAPSerialNo = rs.getString("RelativeSerialNo");
				}
				rs.getStatement().close();
				//获取BUSINESS_APPLY的SerialNo
				sSql = "select RelativeSerialNo from BUSINESS_APPROVE where SerialNo = :SerialNo";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", bAPSerialNo));
				if(rs.next())
				{
					bASerialNo = rs.getString("RelativeSerialNo");
				}
				rs.getStatement().close();
			}else
			{
				//获取BUSINESS_APPLY的SerialNo
				sSql = "select RelativeSerialNo from BUSINESS_CONTRACT where SerialNo = :SerialNo";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", objectNo));
				if(rs.next())
				{
					bASerialNo = rs.getString("RelativeSerialNo");
				}
				rs.getStatement().close();
			}
			updateSortAttributesValueFromBA(bASerialNo);	
		}else if(objectType.equals("ApproveApply"))   //objectType为最终审批意见
		{
			//获取BUSINESS_APPLY的SerialNo
			sSql = "select RelativeSerialNo from BUSINESS_APPROVE where SerialNo = :SerialNo";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", objectNo));
			if(rs.next())
			{
				bASerialNo = rs.getString("RelativeSerialNo");
			}
			rs.getStatement().close();
			updateSortAttributesValueFromBA(bASerialNo);	
		}else if(objectType.equals("CreditApply")) //objectType为授信申请
		{
			bASerialNo = objectNo;
			
			if(isDetailInCreditApply(bASerialNo)){
				updateSortAttributesValueFromBA(bASerialNo);	//如果为详情页面时，三个标志位从BUSINESS_APPLY中取值
			}else{
				updateSortAttributesValueFromBS(typeNo);//如果为新增页面时，三个标志位从BUSINESS_SORT中去默认值
			}
		}else 
		{
			//如果objectType是除了上述类型的其他类型，则从BUSINESS_SORT取系统默认值
			updateSortAttributesValueFromBS(typeNo);
		}
	}
	
	/**
	 * 获取申请阶段的IsLiquidity,IsFixed,IsProject
	 */
	private void updateSortAttributesValueFromBA(String serialNo) throws Exception{
		sSql = "select IsLiquidity,IsFixed,IsProject from BUSINESS_APPLY where SerialNo = :SerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", serialNo));
		if(rs.next())
		{		
				if(rs.getString("IsLiquidity") == null || rs.getString("IsFixed") == null || rs.getString("IsProject") == null ){
					throw new AmarBizMethodException("该笔业务贷款新规相关字段数据无值！");
				}else{
					liquidity = rs.getString("IsLiquidity").equals("1") ? true : false;
					fixed = rs.getString("IsFixed").equals("1") ? true : false;
					project = rs.getString("IsProject").equals("1") ? true : false;
				}		
		}
		rs.getStatement().close();	
	}
	
	/**
	 * 获取BUSINESS_SORT的IsLiquidity,IsFixed,IsProject,做为默认值
	 */
	private void updateSortAttributesValueFromBS(String typeNo) throws Exception{
		sSql = "select IsLiquidity,IsFixed,IsProject from BUSINESS_SORT where TypeNo = :TypeNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TypeNo", typeNo));
		if(rs.next())
		{
			if(rs.getString("IsLiquidity") == null || rs.getString("IsFixed") == null || rs.getString("IsProject") == null ){
				throw new AmarBizMethodException("该业务品种贷款新规属性无值！");
			}else{
				liquidity = rs.getString("IsLiquidity").equals("1") ? true : false;
				fixed = rs.getString("IsFixed").equals("1") ? true : false;
				project = rs.getString("IsProject").equals("1") ? true : false;
			}			
		}
		rs.getStatement().close();
	}
	
	
	/**
	 * 
	 * 获取BUSINESS_TYPE中产品分类标志位
	 */
	private void updateSortValue(String typeNo) throws Exception{
		//获取BUSINESS_TYPE的Attribute3（产品分类标志位）
		sSql = "select Attribute3 from BUSINESS_TYPE where TypeNo=:TypeNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("TypeNo", typeNo));
		if(rs.next()){
			if(rs.getString("Attribute3") == null){
				throw new AmarBizMethodException("该业务品种字段：是否属于贷款新规无值！");
			}else{
				bizSort = rs.getString("Attribute3").equals("1") ? true : false;
			}
		}
		rs.getStatement().close();
	}	
	
	/**
	 * 判断申请阶段是新增申请还是查看那详情页面
	 */
	private boolean isDetailInCreditApply(String serialNo) throws Exception{
		
		boolean isDetail = false;
		sSql = "select IsLiquidity,IsFixed,IsProject from BUSINESS_APPLY where SerialNo = :SerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", serialNo));
		if(rs.next())
		{		
				if(rs.getString("IsLiquidity") == null || rs.getString("IsFixed") == null || rs.getString("IsProject") == null ){
					isDetail = false;
				}else{
					isDetail = true;
				}		
		}else{//如果只有流水号，而没有对应记录
			isDetail = false;
		}
		rs.getStatement().close();	
		return isDetail;
		
	}
	
	
	/**
	 * 是否流动资金贷款
	 * 在使用构造方法BizSort(Transaction Sqlca ,String typeNo)新建对象时，不建议使用。
	 * @return liquidity
	 */
	public boolean isLiquidity() {
		return liquidity;
	}

	/**
	 * 是否固定资产贷款
	 * 在使用构造方法BizSort(Transaction Sqlca ,String typeNo)新建对象时，不建议使用。
	 * @return fixed
	 */
	public boolean isFixed() {
		return fixed;
	}

	/**
	 * 是否项目贷款
	 * 在使用构造方法BizSort(Transaction Sqlca ,String typeNo)新建对象时，不建议使用。
	 * @return project
	 */
	public boolean isProject() {
		return project;
	}
	
	/**
	 * 是否属于贷款新规管理范围
	 * @return bizSort
	 */
	public boolean isBizSort() {
		return bizSort;
	}
}

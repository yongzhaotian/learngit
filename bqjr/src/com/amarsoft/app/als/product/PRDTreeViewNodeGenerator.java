/**
 * 
 */
package com.amarsoft.app.als.product;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.bizmethod.BizSort;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 授信方案管理模块:详情—树图节点生成
 * 
 * @author yzheng
 * @date 2013/05/23
 * 
 * @history 			
 * 		2013.05.25 yzheng 修改树图节点生成方式, 针对CreditView
 * 		2013.06.14 yzheng 合并CreditLineView
 * 		2013.06.27 yzheng 合并InputCreditView
 */
public class PRDTreeViewNodeGenerator 
{
/*	private String businessType;  //产品编号
	private String objectType;      //阶段类型
	private String occurType;       //发生类型—针对额度项下/单笔
	private String applyType;      //申请类型—针对额度项下/单笔*/	
	private String approveNeed;   //一笔业务申请后，是否需要经过审批到合同阶段—针对额度项下/单笔授信
	private int schemeType;         //主综合授信编号—授信额度申请
	private String creditLineID;     //授信方案类型  0:授信额度申请(补登+非补登) 1: 额度项下/单笔授信申请(补登+非补登)
	
	/**
	 * 构造函数
	 * @param approveNeed  一笔业务申请后，是否需要经过审批到合同阶段—针对额度项下/单笔授信
	 * @param schemeType
	 * @param creditLineID
	 */
	public PRDTreeViewNodeGenerator(String approveNeed) {
		this.approveNeed = approveNeed;
		this.schemeType= 0; 
		this.creditLineID = "";
	}

	/**
	 * @param objectType  阶段类型
	 * @param objectNo     流水号
	 * 
	 * @return sSqlTreeView SQL从句条件，用于限定选取的节点用于生成树图
	 * @throws Exception 
	 */
	public String generateSQLClause(Transaction Sqlca, String  objectType, String objectNo) throws Exception
	{
		//String customerID = "";
		String businessType = "";  //产品类型
		String occurType = "";  //发生类型—额度项下/单笔
		String applyType="";  //申请类型 —额度项下/单笔
		String table="";
		
		//根据sObjectType的不同，得到不同的关联表名和模版名
		String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",objectType));
		if(rs.next()){ 
			table=DataConvert.toString(rs.getString("ObjectTable"));
		}
		rs.getStatement().close(); 
		
		sSql="select CustomerID,OccurType,ApplyType,ProductID from "+table+" where SerialNo= :SerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",objectNo));
		if(rs.next()){
			//customerID=DataConvert.toString(rs.getString("CustomerID"));  //授信额度|补登
			businessType=DataConvert.toString(rs.getString("ProductID"));  //授信额度|补登
			occurType=DataConvert.toString(rs.getString("OccurType"));  //额度项下/单笔
			applyType=DataConvert.toString(rs.getString("ApplyType"));  //额度项下/单笔
		}
		rs.getStatement().close(); 
		
		//if(occurType == null) occurType = "";
		if(applyType == null) applyType = "";
		
		//生成树图节点语句
		String sSqlTreeView  = "from PRD_NODEINFO, PRD_NODECONFIG where PRD_NODEINFO.NODEID = PRD_NODECONFIG.NODEID and PrdId = '" + businessType + "' and";
		
		//针对授信额度申请
		if(objectType.equals(CreditConst.CREDITOBJECT_REINFORCECONTRACT_VIRTUAL)){   //补登
			sSql = " select LineID from CL_INFO where BCSerialNo =:BCSerialNo order by LineID";
			creditLineID = Sqlca.getString(new SqlObject(sSql).setParameter("BCSerialNo",objectNo));
			sSqlTreeView += " Fac4 = '1' ";  //(补登作贷后处理)
		}
		else{  //4大阶段
			if(objectType.equals(CreditConst.CREDITOBJECT_APPLY_REAL)){
				sSql = " select LineID from CL_INFO where ApplySerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac1 = '1' ";  //申请
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_APPROVE_REAL)){
				sSql = " select LineID from CL_INFO where ApproveSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac2 = '1' ";  //审批
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_REAL)){
				sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac3 = '1' ";  //合同
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_QUERY)){
				sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac5 = '8' ";  //合同
			}
			else if(objectType.equals(CreditConst.CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL)){
				sSql = " select LineID from CL_INFO where BCSerialNo =:ObjectNo and (Parentlineid is null or Parentlineid = ' ') order by LineID";
				sSqlTreeView += " Fac4 = '1' ";  //贷后
			}
			creditLineID = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo",objectNo));
		}
		
		if(creditLineID == null){  //额度项下/单笔(补登+非补登)
			schemeType = 1;
			creditLineID = "";
		}
		
		//判定阶段
/*	    if(objectType.equals(CreditConst.CREDITOBJECT_APPLY_REAL)){  
	    	sSqlTreeView += " Fac1 = '1' ";  //申请
	    }
	    else if(objectType.equals(CreditConst.CREDITOBJECT_APPROVE_REAL)){      
	    	sSqlTreeView += " Fac2 = '1' ";  //审批
        }
	    else if(objectType.equals(CreditConst.CREDITOBJECT_CONTRACT_REAL)){  
	    	sSqlTreeView += " Fac3 = '1' ";  //合同
	    }
	    else if(objectType.equals(CreditConst.CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL) || objectType.equals(CreditConst.CREDITOBJECT_REINFORCECONTRACT_VIRTUAL)){  
	    	sSqlTreeView += " Fac4 = '1' ";  //贷后(补登作贷后处理)
	    }*/
	    
	    //判断授信方案类型
	    if(schemeType == 0){  //授信额度
/*	    	if(businessType.startsWith("3020")){ 
	    		sSql += " and PRD_NODECONFIG.NodeID <> '080'";  //集团综合授信额度类型不展示风险度评估节点(ID: '080')  该节点已经停用
	    	}*/
	    	//预留
	    }
	    else if(schemeType == 1){  //额度项下/单笔授信(补登+非补登)
			//判断发生类型
/*			if(occurType.equals("010")){ //018被停用，统一由借据信息代替
				sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '018'";  //新发生不展示关联业务信息节点(ID: '018')
			}*/
	    	if(!occurType.equals("015")){
	    		if(!objectType.equals(CreditConst.CREDITOBJECT_REINFORCECONTRACT_VIRTUAL) && !objectType.equals(CreditConst.CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL)){
	    			sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '050'";  //展期4个阶段都展示借据信息(ID: '050')
	    		}
			}
			//修改额度项下业务树图生成方式
			if(applyType.equals(CreditConst.APPLYTYPE_INDEPENDENT)){
				sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '019'";  //单笔单批类型不展示关联额度信息节点(ID: '019')
			}
			BizSort bs = new BizSort(Sqlca,objectType,objectNo,approveNeed,businessType);
		    //如果不是流动资金贷款，则不显示"贷款需求量测算"节点    (ID: '090')
			if(bs.isLiquidity() != true){
				sSqlTreeView += " and PRD_NODECONFIG.NodeID <> '090'";
			}
	    }
		
		return sSqlTreeView;
	}
	
	/** 
	 * @return creditLineID 主综合授信编号
	 */
	public String getCreditLineID(){
		return creditLineID;
	}
	
	/**
	 * @return schemeType 授信类型
	 */
	public int getSchemeType(){
		return schemeType;
	}
}
package com.amarsoft.app.lending.bizlets;

import java.util.Hashtable;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 *  Description:  中小企业客户认定模型匹对检查,根据输入的职工人数，销售额，资产总额自动计算客户规模
 *  			<p>
 *  				<h1>处理逻辑</h1>
 *  				<ol>
 *  					<li>根据行业类型,找到中型/小型企业相关配置参数</li>
 *  					<li>根据销售额、资产总额、企业规模,匹配中型企业，然后匹配小型企业，否则匹配大型企业</li>
 *  					<li>小型企业只要有其中一项匹配上了就认定为小型，大/中型必需严格匹配</li>
 *  				</ol>
 *  			</p>
 *         Time:  2009/10/15   
 *       @author  pwang
 *       @history syang 2009/11/02 修改其传入参数，判断方式
 */
public class CheckSMECustomerAction extends Bizlet 
{
	/**
	 * 调用入口
	 * @param
	 * 	<li>IndustryType 中小型企业行业类型</li>
	 * 	<li>EmployeeNum 职工人数</li>
	 * 	<li>SaleSum 销售额</li>
	 * 	<li>AssetSum 资产总额</li>
	 * @return 
	 * 	<li>3 中型企业</li>
	 * 	<li>4 小型企业</li>
	 * 	<li>0 大型企业（系统中目前未使用）</li>
	 * 	<li>9 其它（中型，小型均不满足）</li>
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * 获取参数
		 */
		String sIndustryType = (String)this.getAttribute("IndustryType");	
		String sEmployeeNum = (String)this.getAttribute("EmployeeNum");	
		String sSaleSum = (String)this.getAttribute("SaleSum");	
		String sAssetSum = (String)this.getAttribute("AssetSum");	
	
		if(sIndustryType == null) sIndustryType = "";
		if(sEmployeeNum == null) sEmployeeNum = "";
		if(sSaleSum == null) sSaleSum = "";
		if(sAssetSum == null) sAssetSum = "";
		
		
		/*
		 * 定义变量
		 */
		String sReturn = "9";
		String sScope = "";
		Hashtable htIndustType = new Hashtable();	//有些特殊行业需要对资产总额作匹配
		//参数进行转换后的变量
		int iEmployeeNum = Integer.parseInt(sEmployeeNum);	//职工人数
		double dSaleSum = Double.parseDouble(sSaleSum);		//销售额
		double dAssetSum = Double.parseDouble(sAssetSum);	//资产总额
		//数据库中查出的数据存放变量
		int iWorkerULimit = 0;
		int iWorkerDLimit = 0;
		double dSaleULimit = 0.0;
		double dSaleDLimit = 0.0;
		double dAssetULimit = 0.0;
		double dAssetDLimit = 0.0;
		String sSql = "";
		ASResultSet rs  = null;
		
		/*
		 * 程序逻辑
		 * 以前当数据作为游标对：小型、中型、大型企业挨个匹配
		 * 1.若小型则上长升能中型
		 * 2.中型不匹配则上升到大型（目前只有中型，小型，不支持大型）
		 * 3.此三者空间连续，不存在断点问题
		 * 
		 */
		htIndustType.put("0130010", "1");	//工业
		htIndustType.put("0130020", "1");	//建筑业
		sSql = "select "
			+" EntScope,"			//企业类型（3 中型企业，4  小型企业）
			+" WorkerULimit,"		//职工人数上限(人)
			+" WorkerDLimit,"		//职工人数下限(人)
			+" SaleULimit,"			//销售额上限（元）
			+" SaleDLimit,"			//销售额下限（元）
			+" AssetULimit,"		//资产总额上限（元）
			+" AssetDLimit"			//资产总额下限（元）
			+" from SME_CONFMODE"
			+" where EntKind=:sIndustryType"
			+" order by EntScope desc"		//降序排列：小型、中型挨个匹配，如果都匹配不上，则默认为大型
			;
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sIndustryType", sIndustryType));			
		while(rs.next()){
			boolean bMatched1 = false,bMatched2 = false,bMatched3 = false;
			boolean bIndustType = false;						//特殊行业标识
			iWorkerDLimit = (int)rs.getDouble("WorkerDLimit");	//职工人数下限(人)
			iWorkerULimit = (int)rs.getDouble("WorkerULimit");	//职工人数上限(人)
			dSaleDLimit = rs.getDouble("SaleDLimit");			//销售额下限（元）
			dSaleULimit = rs.getDouble("SaleULimit");			//销售额上限（元
			dAssetDLimit = rs.getDouble("AssetDLimit");			//资产总额下限（元）
			dAssetULimit = rs.getDouble("AssetULimit");			//资产总额上限（元）
			sScope = rs.getString("EntScope");
			//1.匹配职工人数(上限包括，下限不包括)
			if(iEmployeeNum>iWorkerDLimit&&iEmployeeNum<=iWorkerULimit){
				bMatched1 = true;
			}
			//2.匹配销售额（上限包括，下限不包括）
			if(dSaleSum>dSaleDLimit&&dSaleSum<=dSaleULimit){
				bMatched2 = true;
			}
			//特殊行业需要匹配资产总额
			if(htIndustType.containsKey(sIndustryType)){
				bIndustType = true;
				//3.资产总额匹配（上限包括，下限不包括）
				if(dAssetSum>dAssetDLimit&&dAssetSum<=dAssetULimit){
					bMatched3 = true;
				}
			//不为特殊行业，则默认资产总额是匹配的
			}
			
			if(sScope == null) sScope = "";
			
			//检查是否能和小型企业匹配
			//小型企业只需要其中一项匹配上了就认定为小型企业了
			if(sScope.equals("4")){
				//如果为特殊行业，需要匹配第三项（资产总额）
				if(bIndustType){
					if(bMatched1 || bMatched2 || bMatched3){
						sReturn = sScope;
						break;
					}
				}else{
					if(bMatched1 || bMatched2){
						sReturn = sScope;
						break;
					}
				}
			//否则全部匹配
			}else{
				//如果为特殊行业，需要匹配第三项（资产总额）
				if(bIndustType){
					if(bMatched1 && bMatched2 && bMatched3){
						sReturn = sScope;
						break;
					}
				}else{
					if(bMatched1 && bMatched2){
						sReturn = sScope;
						break;
					}
				}
			}
		}
		rs.getStatement().close();
		rs = null;
		return sReturn;
	}
}


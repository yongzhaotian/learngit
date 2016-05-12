/**
 * 		Author: --zywei 2005-08-13
 * 		Tester:
 * 		Describe: --探测合同风险
 * 		Input Param:
 * 				ObjectType: 对象类型
 * 				ObjectNo: 对象编号
 * 		Output Param:
 * 				Message：风险提示信息
 * 		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckContractRisk extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
				
		//定义变量：提示信息、SQL语句、业务金额、产品类型
		String sMessage = "",sSql = "",sBusinessSum = "",sBusinessType = "";
		//定义变量：主要担保方式、主体表名、关联表名
		String sVouchType = "",sMainTable = "",sRelativeTable = "";
		//定义变量：暂存标志,继续检查标志
		String sTempSaveFlag = "",sContinueCheckFlag = "TRUE";		
		//定义变量：票据张数
		int iBillNum = 0,iNum = 0;
		//定义变量：查询结果集
		ASResultSet rs = null,rs1 = null;			
		
		//根据对象类型获取主体表名
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = :ObjectType ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType));
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//将空值转化成空字符串
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------第一步：检查合同信息是否全部输入---------------
			//从相应的对象主体表中获取金额、产品类型、票据张数、担保类型
			sSql = 	" select TempSaveFlag,BusinessSum,BusinessType,BillNum,VouchType "+
					" from "+sMainTable+" where SerialNo = :SerialNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				sBusinessSum = rs.getString("BusinessSum");				
				sBusinessType = rs.getString("BusinessType");
				iBillNum = rs.getInt("BillNum");
				sVouchType = rs.getString("VouchType");
				
				//将空值转化成空字符串
				if (sTempSaveFlag == null) sTempSaveFlag = "";
				if (sBusinessSum == null) sBusinessSum = "";
				if (sBusinessType == null) sBusinessType = "";
				if (sVouchType == null) sVouchType = "";
								
				if (sTempSaveFlag.equals("010")) {			
					sMessage = "合同基本信息为暂存状态，请先填写完合同基本信息并点击保存按钮！"+"@";
					sContinueCheckFlag = "FALSE";							
				}			
			}
			rs.getStatement().close(); 
		}
		
		if(sContinueCheckFlag.equals("TRUE"))
		{					
			//--------------第二步：检查担保合同是否全部输入---------------
			//假如业务基本信息中的主要担保方式为信用，则判断是否输入担保信息，如果输入了担保信息给出提示
			if (sVouchType.equals("005")) {
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType='GuarantyContract') having count(SerialNo) > 0";

				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum > 0)
					sMessage  += "在业务中选择的主要担保方式为信用，不应该输入担保信息！请调整主要担保方式或删除担保信息！"+"@";
			}else //假如业务基本信息中的主要担保方式为保证、或抵押、或质押，则判断是否输入担保信息
			{
				if(sVouchType.length()>=3) {
					//假如业务基本信息中的主要担保方式为保证,必须输入保证担保信息
					if(sVouchType.substring(0,3).equals("010"))
					{
						//检查担保合同信息中是否存在保证担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '010%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "在业务中选择的主要担保方式为保证，可没有输入与保证有关的担保信息！请调整主要担保方式或输入保证担保信息！"+"@";
					}
					
					//假如业务基本信息中的主要担保方式为抵押,必须输入抵押担保信息，并且还需要有相应的抵押物信息
					if(sVouchType.substring(0,3).equals("020"))	{
						//检查担保合同信息中是否存在抵押担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '050%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "在业务中选择的主要担保方式为抵押，可没有输入与抵押有关的担保信息！请调整主要担保方式或输入抵押担保信息！"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= :SerialNo and ObjectType = 'GuarantyContract') and GuarantyType in ('050')";
							rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
							while(rs.next()) //循环判断每个抵押合同
							{
								String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType=:ObjectType"+
								       " and ObjectNo =:ObjectNo and ContractNo = :ContractNo) "; 
								rs1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("ObjectType", sObjectType).
										setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sGCNo));
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//判断担保合同项下是否有对应的
								if (iNum <= 0)
								{
								    sMessage="担保合同编号为:"+sGCNo+"的担保合同项下无对应的抵押信息！@";
								}
						     }
						     rs.getStatement().close();
						}										
					}
					
					//假如业务基本信息中的主要担保方式为质押,必须输入质押担保信息，并且还需要有相应的质物信息
					if(sVouchType.substring(0,3).equals("040"))	{
						//检查担保合同信息中是否存在质押担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '060%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						if(iNum == 0)								
							sMessage  += "在业务中选择的主要担保方式为质押，可没有输入与质押有关的担保信息！请调整主要担保方式或输入质押担保信息！"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from CONTRACT_RELATIVE where "+
						       " SerialNo= :SerialNo and ObjectType = 'GuarantyContract') and GuarantyType in ('060')";
							rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
							while(rs.next()) //循环判断每个质押合同
							{
								String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType=:ObjectType"+
								       " and ObjectNo =:ObjectNo and ContractNo = :ContractNo) "; 
								rs1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("ObjectType", sObjectType)
										.setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sGCNo));
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//判断担保合同项下是否有对应的
								if (iNum <= 0)
								{
								    sMessage="担保合同编号为:"+sGCNo+"的担保合同项下无对应的质押信息！@";
								}
						     }
						     rs.getStatement().close();
						}												
					}	
				}else{
					if(!sBusinessType.substring(0,4).equals("1020")){
						sMessage  += "该笔合同没有填写主要担保方式！"+"@";
					}
					//sMessage  += "代码表中定义的主要担保方式编号小于3位（CODE_LIBRARY.VouchType:"+sVouchType+"），申请的某些风险要素不能探测出来，请核对后再重新探测！"+"@";
				}
			}
			
			//--------------第三步：检查贴现业务和其票据业务信息一致---------------
			if(sBusinessType.length()>=4) {
				//如果产品类型为贴现业务
				if(sBusinessType.substring(0,4).equals("1020"))	{
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = :ObjectType and ObjectNo = :ObjectNo "+
							" having sum(BillSum) = :BusinessSum ";
					rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType)
							.setParameter("ObjectNo", sObjectNo).setParameter("BusinessSum", sBusinessSum));
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage  += "业务金额和票据金额总和不符！"+"@";
										
					sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = :ObjectType and ObjectNo = :ObjectNo "+
							" having count(SerialNo) = :BillNum ";
					rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType)
							.setParameter("ObjectNo", sObjectNo).setParameter("BillNum", iBillNum));
					if(rs.next()) 
						iNum = rs.getInt(1);
					rs.getStatement().close();
					
					if(iNum == 0)
						sMessage += "业务中输入的票据张数和输入的票据张数不符！"+"@";
				}					
			}else{
				sMessage  += "产品表中定义的产品编号小于4位（BUSINESS_TYPE.TypeNo:"+sBusinessType+"），申请的某些风险要素不能探测出来，请核对后再重新探测！"+"@";
			}	
		}
		
		return sMessage;
	 }
	 

}

package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.als.credit.model.CreditObjectAction;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;

/**
 * <li>该类主要为获得额度与分配的信息
 * <li>额度与业务的信息
 * @author cjyu
 *
 */
public class CLRelativeAction {

	/**
	 * 查找下级切分
	 * @param fatherDivide 上级切分
	 * @return
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	private static List<CLDivide> getSonDivideList(CLDivide fatherDivide) throws JBOException{
		String sSerialNo=fatherDivide.getAttribute("SerialNo").getString();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_DIVIDE");
		List<CLDivide>  lstSon=m.createQuery(" RelativeSerialNo=:serialNo") 
									.setParameter("serialNo", sSerialNo)
									.getResultList(false);
		return lstSon;
	}

	/**
	 * 通业务编号和对象类型找到对应的额度
	 * @param sObjectNo
	 * @param objectType
	 * @return
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public static List<String>  getCreditNo(String objectType,String sObjectNo) throws JBOException
	{
		List<String> lst=new ArrayList<String>();
		String sLineNo="";//cjyu 获得额度的编号
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_OCCUPY");
		List<BizObject> lstbiz=m.createQuery("select distinct O.RelativeSerialNo as v.SerialNo from O ,jbo.app.BUSINESS_CONTRACT BC" +
						" where  O.RelativeSerialNo = BC.SerialNo and  ObjectNo=:objectNo and ObjectType=:objectType")
		                .setParameter("objectNo", sObjectNo)
		                .setParameter("objectType", objectType)
		                .getResultList(true);
		if(lstbiz==null)  return lst; 
		for(BizObject biz:lstbiz)
		{
			sLineNo=biz.getAttribute("SerialNo").getString();
			List<BizObject> lstRelative=CLRelativeAction.getReplaceLine(sLineNo,objectType);
			addReplace(lstRelative,lstbiz,lst);
			lst.add(sLineNo);
		} 
	
		return lst;
	}
 
	/**
	 * 获得额度被替换的额度，
	 * <li>接续的额度，可能存在不能立即生效，因此需要等待老额度到期后生效
	 * <li>该方法是通过老额度找到对应的新额度
	 * @param oldline 原额度
	 * @return
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public static List<BizObject> getReplaceLine(String objectNo,String objectType) throws JBOException
	{
		  
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_Replace");
		List<BizObject> lst=m.createQuery("select ObjectNo as v.SerialNo from O  where  RelativeSerialNo=:serialNo and ObjectType=:objectType")
							 .setParameter("serialNo", objectNo)
							 .setParameter("objectType", "BusinessContract").getResultList(true);
		return lst;
	}
	/**
	 * 将未能产生替换的额度进行关联
	 * @param lstReplace
	 * @param lstOccupy
	 * @param lst
	 * @return
	 * @throws JBOException
	 */
	public static int   addReplace(List<BizObject> lstReplace,List<BizObject> lstOccupy,List<String> lst) throws JBOException
	{
		String sLineNo="";
		int icount=0;
		for(BizObject bizReplace:lstReplace)
		{
			sLineNo=bizReplace.getAttribute("SerialNO").getString();
			if(!bexistReplace(lstOccupy,"SerialNo",sLineNo)){
				lst.add(sLineNo);
				icount++;
			}
		}
		return icount;
	}
	/**
	 * 检查额度编号在占用关系中是否存在
	 * @param lstOccupy
	 * @param attributeName
	 * @param attributeValue
	 * @return
	 * @throws JBOException
	 */
	public static boolean bexistReplace(List<BizObject> lstOccupy,String attributeName,String attributeValue) throws JBOException
	{
		for(BizObject biz:lstOccupy)
		{
			if(attributeValue.equalsIgnoreCase(biz.getAttribute(attributeName).getString()))
			{
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 建立额度与业务的关联关系
	 * <li>查找额度下的切分，如果业务在额度下有切分，则建立关系
	 * <li>如果没有切分，则建立与协议的关联关系
	 * <li>递归实现：如果额度有存在接续或调整未能生效的额度，仍然将业务与额度关联
	 * @param line  关联额度
	 * @param contract 合同
	 * @param tx
	 * @author cjyu
	 * @throws Exception 
	 */ 
	public  static int newCLOccupy(CreditObjectAction line,BizObject contract,JBOTransaction tx) throws Exception
	{
		int i=0;
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_OCCUPY");
		tx.join(m);
		String objectNo=contract.getAttribute("SerialNo").getString();
		String objectType=CLRelativeAction.getObjectType(contract);
		String lineNo=line.getCreditObjectNo();
		BizObject newBiz=m.createQuery("ObjectNo=:objectNo and ObjectType=:objectType and Relativeserialno=:lineNo")
						 .setParameter("objectNo", objectNo)
						 .setParameter("objectType", objectType)
						 .setParameter("lineNo",lineNo).getSingleResult(true);
		if(newBiz==null) newBiz=m.newObject(); 
		
		//获取与contract相关的切分额度编号组
 		List<BizObject> lst=line.getAppendList(CreditConst.APPENDTYPE_DIVIDELINE);
 		List<CLDivide> clDivideList = new ArrayList<CLDivide>();
 		for(BizObject boDivide:lst){
 			CLDivide clDivide = new CLDivide(boDivide);
 			clDivideList.add(clDivide);
 		}
 		String sdivideNo=CLRelativeAction.getDivideNo(clDivideList, contract); 
 		
		newBiz=insertDivide(newBiz,line.getCreditObjectNo(),sdivideNo,contract);
		m.saveObject(newBiz); 
		//TODO 额度替换暂时不做处理
/*		List<BizObject> replaceLine=getReplaceLine(line);
		for(BizObject repalceBiz:replaceLine)//cjyu 查询将要被替换的额度，将业务与将生效的新额度关联
		{
			CreditObjectAction credObject=new CreditObjectAction(repalceBiz.getAttribute("SerialNO").getString(),"BusinessContract"); //授信额度也属于授信对象---合同的一种。
			i=newCLOccupy(credObject,contract,tx);
		}*/
		return i;
	}
	
	/**
	 * 建立业务与额度的占用关系
	 * @param newBiz 新的占用关系
	 * @param sCreditLineNo 额度协议编号
	 * @param sDivideNo  切分额度编号
	 * @param biz  业务对象
	 * @return
	 * @throws JBOException
	 */
	private static BizObject insertDivide(BizObject newBiz,String sCreditLineNo,String sDivideNo,BizObject biz) throws JBOException
	{ 
		 String sObjectType=newBiz.getAttribute("ObjectType").getString();
		 if(sObjectType==null) sObjectType="BusinessContract";
		 newBiz.setAttributeValue("ObjectType",sObjectType);
		 newBiz.setAttributeValue("ObjectNo",biz.getAttribute("SerialNo"));
		 newBiz.setAttributeValue("RelativeSerialNo",sCreditLineNo);
		 newBiz.setAttributeValue("RelativeDivNo",sDivideNo);
		 newBiz.setAttributeValue("Currency",biz.getAttribute("BusinessCurrency"));
		 newBiz.setAttributeValue("BusinessSum",biz.getAttribute("BusinessSum"));
		 newBiz.setAttributeValue("ExposureSum",biz.getAttribute("ExposureSum"));
		 newBiz.setAttributeValue("BusinessRate",biz.getAttribute("BusinessRate"));
		 newBiz.setAttributeValue("Remark","add"+StringFunction.getTodayNow());
		 newBiz.setAttributeValue("InputUserID",biz.getAttribute("InputUserID"));
		 newBiz.setAttributeValue("InputOrgID",biz.getAttribute("InputOrgID"));
		 newBiz.setAttributeValue("InputDate",DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		 newBiz.setAttributeValue("UpdateDate",DateX.format(new java.util.Date(), "yyyy/MM/dd")); 
		return newBiz;
	}
 
	/**
	 * 查看有无是否属于该切分额度
	 * @return
	 * @throws JBOException 
	 */
	public  static boolean bizDivide(CLDivide divide,BizObject biz) throws JBOException
	{
		boolean bfalg=false;
		String sDivideType= divide.getAttribute("DivideType").getString();
		String sDivideCode=divide.getAttribute("Dividecode").getString();  
		String sBusinessType=biz.getAttribute("BusinessType").getString(); 
		String sCustomerID=biz.getAttribute("CustomerID").getString();
		if(sDivideType.equals("1"))
		{
			if(sDivideCode.indexOf(sBusinessType)>=0)
			{
				bfalg=true;
			}
		}else if(sDivideType.equals("2")){
			if(sDivideCode.indexOf(sCustomerID)>=0)
			{
				bfalg=true;
			}
		} 
		return bfalg;
	}
	
	
	/**
	 * 通过jbo对象找到对应的ObjectType
	 * @param biz
	 * @return
	 */
	public static String getObjectType(BizObject biz)
	{
		String sTableName=biz.getBizObjectClass().getName();
		sTableName=sTableName.toLowerCase();
		if(sTableName.startsWith("business_apply")) return "CreditApply";
		else if(sTableName.startsWith("business_approve")) return "ApproveApply";
		else if(sTableName.startsWith("business_contract")) return "BusinessContract";
		else if(sTableName.startsWith("business_putout")) return "PutOutApply";
		return "BusinessContract";
	}
	
	

	
	/**
	 * 获得额度被替换的额度，
	 * <li>接续的额度，可能存在不能立即生效，因此需要等待老额度到期后生效
	 * <li>该方法是通过老额度找到对应的新额度
	 * @param oldline 原额度
	 * @return
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public static List<BizObject> getReplaceLine(CreditObjectAction oldline) throws JBOException
	{
		 
		String sObjectType= oldline.getRealCreditObjectType();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		List<BizObject> lst=m.createQuery("SerialNo in(select C.ObjectNo from jbo.app.CL_REPLACE C where C.RelativeSerialNo=:serialNo and C.ObjectType=:objectType)")
							 .setParameter("serialNo", oldline.getCreditObjectNo())
							 .setParameter("objectType", sObjectType).getResultList(false);
		return lst;
	}
	
	/**
	 * 获得业务所属切分额度列表
	 * @return
	 * @throws JBOException 
	 */
	public static List<CLDivide> getDivideList(List<CLDivide> lstDiv,BizObject biz) throws JBOException
	{
		List<CLDivide> ldivide=new ArrayList<CLDivide>();
		for(CLDivide divide:lstDiv)
		{
			boolean bexists=CLRelativeAction.bizDivide(divide, biz);
			if(bexists) ldivide.add(divide);
			if(getSonDivideList(divide).size()>0 && bexists)//在上层中存在，才在下层中检查
			{
				List<CLDivide> lstCldiv=getDivideList(getSonDivideList(divide),biz);
				for(CLDivide div:lstCldiv)
				{
					bexists=CLRelativeAction.bizDivide(div, biz);
					if(bexists) ldivide.add(div);
				}
			}
		}
		return ldivide;
	}
	
	/**
	 * 建立新老额度的替换关系
	 * <li>取出老额度下的业务
	 * <li>将业务与新额度建立关联关系
	 * @param line
	 * @param biz
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public  static int  newReplace(CreditObjectAction newLine,CreditLine oldLine,JBOTransaction tx) throws Exception
	{
		AccountManager accountManager= oldLine.getAccountManager();
		int i=0;
		for(LmtAccountInfo tempBussinfo:accountManager.getLmtAccountList())
		{
			BusinessContractAccount binfo = (BusinessContractAccount) tempBussinfo;
			BizObject biz=binfo.getBizObject();
			i+=newCLOccupy(newLine,biz,tx);
		}
		 return i; 
	}
	
	/**
	 * 获得所属额度的编号
	 * @param lstDiv
	 * @param biz
	 * @return
	 * @throws JBOException
	 */
	public static String getDivideNo(List<CLDivide> lstDiv,BizObject biz) throws JBOException
	{
		List<CLDivide> ldivide=getDivideList(lstDiv,biz);
		String sdivideNo=""; 
		for(CLDivide divide:ldivide)
		{
			if(sdivideNo.equals("")) sdivideNo=divide.getAttribute("SerialNo").getString();
			else sdivideNo=sdivideNo+","+divide.getAttribute("SerialNo").getString();  
		} 
		return sdivideNo;
	}
	
}

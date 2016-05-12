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
 * <li>������ҪΪ��ö����������Ϣ
 * <li>�����ҵ�����Ϣ
 * @author cjyu
 *
 */
public class CLRelativeAction {

	/**
	 * �����¼��з�
	 * @param fatherDivide �ϼ��з�
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
	 * ͨҵ���źͶ��������ҵ���Ӧ�Ķ��
	 * @param sObjectNo
	 * @param objectType
	 * @return
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public static List<String>  getCreditNo(String objectType,String sObjectNo) throws JBOException
	{
		List<String> lst=new ArrayList<String>();
		String sLineNo="";//cjyu ��ö�ȵı��
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
	 * ��ö�ȱ��滻�Ķ�ȣ�
	 * <li>�����Ķ�ȣ����ܴ��ڲ���������Ч�������Ҫ�ȴ��϶�ȵ��ں���Ч
	 * <li>�÷�����ͨ���϶���ҵ���Ӧ���¶��
	 * @param oldline ԭ���
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
	 * ��δ�ܲ����滻�Ķ�Ƚ��й���
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
	 * ����ȱ����ռ�ù�ϵ���Ƿ����
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
	 * ���������ҵ��Ĺ�����ϵ
	 * <li>���Ҷ���µ��з֣����ҵ���ڶ�������з֣�������ϵ
	 * <li>���û���з֣�������Э��Ĺ�����ϵ
	 * <li>�ݹ�ʵ�֣��������д��ڽ��������δ����Ч�Ķ�ȣ���Ȼ��ҵ�����ȹ���
	 * @param line  �������
	 * @param contract ��ͬ
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
		
		//��ȡ��contract��ص��зֶ�ȱ����
 		List<BizObject> lst=line.getAppendList(CreditConst.APPENDTYPE_DIVIDELINE);
 		List<CLDivide> clDivideList = new ArrayList<CLDivide>();
 		for(BizObject boDivide:lst){
 			CLDivide clDivide = new CLDivide(boDivide);
 			clDivideList.add(clDivide);
 		}
 		String sdivideNo=CLRelativeAction.getDivideNo(clDivideList, contract); 
 		
		newBiz=insertDivide(newBiz,line.getCreditObjectNo(),sdivideNo,contract);
		m.saveObject(newBiz); 
		//TODO ����滻��ʱ��������
/*		List<BizObject> replaceLine=getReplaceLine(line);
		for(BizObject repalceBiz:replaceLine)//cjyu ��ѯ��Ҫ���滻�Ķ�ȣ���ҵ���뽫��Ч���¶�ȹ���
		{
			CreditObjectAction credObject=new CreditObjectAction(repalceBiz.getAttribute("SerialNO").getString(),"BusinessContract"); //���Ŷ��Ҳ�������Ŷ���---��ͬ��һ�֡�
			i=newCLOccupy(credObject,contract,tx);
		}*/
		return i;
	}
	
	/**
	 * ����ҵ�����ȵ�ռ�ù�ϵ
	 * @param newBiz �µ�ռ�ù�ϵ
	 * @param sCreditLineNo ���Э����
	 * @param sDivideNo  �зֶ�ȱ��
	 * @param biz  ҵ�����
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
	 * �鿴�����Ƿ����ڸ��зֶ��
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
	 * ͨ��jbo�����ҵ���Ӧ��ObjectType
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
	 * ��ö�ȱ��滻�Ķ�ȣ�
	 * <li>�����Ķ�ȣ����ܴ��ڲ���������Ч�������Ҫ�ȴ��϶�ȵ��ں���Ч
	 * <li>�÷�����ͨ���϶���ҵ���Ӧ���¶��
	 * @param oldline ԭ���
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
	 * ���ҵ�������зֶ���б�
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
			if(getSonDivideList(divide).size()>0 && bexists)//���ϲ��д��ڣ������²��м��
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
	 * �������϶�ȵ��滻��ϵ
	 * <li>ȡ���϶���µ�ҵ��
	 * <li>��ҵ�����¶�Ƚ���������ϵ
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
	 * ���������ȵı��
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

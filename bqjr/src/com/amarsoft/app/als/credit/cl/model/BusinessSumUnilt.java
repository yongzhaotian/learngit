package com.amarsoft.app.als.credit.cl.model;

import java.util.List;

import com.amarsoft.app.als.dict.ALSConst;
import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;

public class BusinessSumUnilt {

	private static String BUSINESS="BUSINESSSUM";
	private static String BALANCE="BALANCE";
	/**
	 * 获得业务的名义金额
	 * <table border="1"><tr><td>&nbsp;</td><td>可循环授信额度</td><td>非循环授信额度</td></tr>
	 * <tr><td>循环合同</td><td><li>合同期限内 合同占用金额=合同金额
	 *	<li>合同期限外 合同占用金额=合同余额
	 *	</td><td>&nbsp;&nbsp;</td></tr>
	 * <tr><td>非循环合同</td><td><li>合同期限内  合同占用金额=合同金额-合同下累计收回
	 * <br>注：合同下累计收回=合同下借据发放金额-合同下借据余额
	 *	<li>合同期限外   合同占用金额=合同余额
	 *	</td><td>&nbsp;占用金额=合同金额</td></tr>
	 * </table>
	 * @param bcycfalg 额度循环，用业务的金额
	 * @return
	 * @throws JBOException 
	 */
	public static double getBusinessSum(boolean bcycfalg,BizObject bizObject) throws JBOException
	{
		String sSerialNo=bizObject.getAttribute("SerialNo").getString();
		String sCycleflag=bizObject.getAttribute("Cycleflag").getString();//业务是否循环	
		String sObjectType=CLRelativeAction.getObjectType(bizObject); 
		String sToday=StringFunction.getToday(); 
		if(sCycleflag==null) sCycleflag="2";//为空默认为不循环
		double dmyBusinessSum=0;
		double dBusinessSum=bizObject.getAttribute("BusinessSum").getDouble();
		String sCurrency=bizObject.getAttribute("BusinessCurrency").getString();
		dBusinessSum*=GetCompareERate.getConvertToRMBERate(sCurrency);//cjyu 计算汇率
		//cjyu 循环额度直接使用金额
		if(!bcycfalg) return dBusinessSum;
		if(!sObjectType.equalsIgnoreCase("BusinessContract"))//cjyu  非合同阶段，名义金额为申请金额
		{
			return dBusinessSum;
		}
		String  sMaturity=bizObject.getAttribute("Maturity").getString();
		
		/**去掉该补丁，由项目组根据具体需求处理@jschen20130109**/
		//if(bizObject.getAttribute("Maturity").isNull()) sMaturity="2001/01/01";//到期日为空则视为已到期，
		
		int ioverDay=sMaturity.compareTo(sToday);//比当前日期小 则为-1 比当前日期大则 1
		if(getInvideBusiness(bizObject))  return 0;  
		double dBalace=dBusinessSum; 
		//cjyu 合同阶段 需要获得余额;
		
		if(!bizObject.getAttribute("Balance").isNull())//余额为NULL 则为未发放，否则已发放
		{
			dBalace=bizObject.getAttribute("Balance").getDouble();
			dBalace=dBalace*GetCompareERate.getConvertToRMBERate(sCurrency);// 计算汇率
		}
		boolean bcycleFlag=sCycleflag.equals(ALSConst.CYCLEFLAG_CYCLE);
		dmyBusinessSum=dBusinessSum;
		if(bcycfalg) //循环额度
		{
			if(bcycleFlag)//合同循环
			{
				if(ioverDay<0)//在业务合同的期限外，即合同已到期
				{
					dmyBusinessSum=dBalace;
				}
			}else{//非循环合同
				if(ioverDay>0)//期限内 合同金额-收回
				{
					dmyBusinessSum=dBusinessSum-getBackSum(sSerialNo);
				}else{
					dmyBusinessSum=dBalace;
				}
			}
		}
		return dmyBusinessSum;
	}
	/**
	 * 获得业务是否已经失效，如银行承兑汇票到期后，贴现到期后，业务有终结日期
	 * @return
	 * @throws JBOException 
	 */
	public static boolean getInvideBusiness(BizObject bizObject) throws JBOException
	{
		String sObjectType=CLRelativeAction.getObjectType(bizObject);
		if(!sObjectType.equalsIgnoreCase("businessContract")) return false;//cjyu 如果
 		String sFinishDate=bizObject.getAttribute("FinishDate").getString();//业务是否循环
		String sBusinessType=bizObject.getAttribute("BusinessType").getString();//业务品种
  		if(sFinishDate==null) sFinishDate="";
		if(!"".equals(sFinishDate)) return true;//cjyu 业务已结清，则不计算名义金额
		String  sMaturity=bizObject.getAttribute("Maturity").getString();
		if(bizObject.getAttribute("Maturity").isNull()) sMaturity="1900/01/01";
		int ioverDay=sMaturity.compareTo(StringFunction.getToday());//比当前日期小 则为-1 比当前日期大则 1
		//已到期的银行承兑汇票 不计算在内
		//if(ioverDay<0 && (sBusinessType.startsWith("1050") || sBusinessType.startsWith("1060") || sBusinessType.startsWith("1090") || sBusinessType.startsWith("1100"))) return true; 
		return false;
	}
	/**
	 *合同下借据收回金额
	 * @param contractNo
	 * @return
	 * @throws JBOException 
	 */
	public static double  getBackSum(String contractNo) throws JBOException
	{
		double dbackSum=0;//cjyu 收回金额
		BizObject biz=getDueBillInfo(contractNo);
		if(biz==null) return 0;
		double dBusinessSum=biz.getAttribute("BusinessSum").getDouble();
		double dBalance=biz.getAttribute("Balance").getDouble();
		dbackSum=dBusinessSum-dBalance;
		return dbackSum;
	}
	
	/**
	 * 获得借据金额汇总信息
	 * @param contractNo 合同流水号
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getDueBillInfo(String contractNo) throws JBOException
	{
 		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		BizObject bo=m.createQuery("select sum(BusinessSum) as v.BusinessSum,sum(Balance) as v.Balance,sum(Bailsum) as v.BailSum from o where O.RelativeSerialNo2=:contract")
					.setParameter("contract", contractNo).getSingleResult(false);
		
		return bo;
	}
	 
	/**
	 * 获得合同下解决信息
	 * @param contractNo 合同流水号
	 * @return
	 * @throws JBOException
	 */
	public static List<BizObject> getDueBillList(String contractNo) throws JBOException
	{
 		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		List<BizObject> bo=m.createQuery("O.RelativeSerialNo2=:contract")
						.setParameter("contract", contractNo).getResultList(false); 
		return bo;
	}
	
}

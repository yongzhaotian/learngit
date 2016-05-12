package com.amarsoft.app.als.credit.cl.action;

import java.util.List;

import com.amarsoft.app.als.credit.cl.model.AccountManager;
import com.amarsoft.app.als.credit.cl.model.BusinessContractAccount;
import com.amarsoft.app.als.credit.cl.model.CLDivide;
import com.amarsoft.app.als.credit.cl.model.LmtAccountInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;

public class CreditShow {

	private  int   icount=0;
	private    String  sdivideList="";
	private   StringBuffer bufferUse=new StringBuffer();
	public String getDetail(AccountManager accountManager,String stableName,String stips) throws Exception
	{
		StringBuffer stemp=new StringBuffer();  
		stemp.append("<div contentEditable><table><tr style='background-color:#CAD9EA;border:1px solid #9db3c5;color:#666;'>" +
					"<th width='120px'>合同流水号</th>");
		stemp.append("<th>名义金额</th>");
		stemp.append("<th>合同余额</th>");
		stemp.append("<th>现金类担保品金额</th>");
		stemp.append("<th>保证金</th>");
		stemp.append("<th>到期日</th>");
		stemp.append("<th>是否循环</th>");
		stemp.append("<th>币种</th>");
		stemp.append("<th>占用名义金额</th>");
		stemp.append("<th>占用敞口金额</th>");
		stemp.append("</tr>");
		int j=0;
		double duseSum1=0,duseSum2=0;
		for(LmtAccountInfo tempBussinfo:accountManager.getLmtAccountList())
		{ 
			BusinessContractAccount binfo = (BusinessContractAccount) tempBussinfo;
			j++;
			String sSerialNo=binfo.getCreditObject().getAttribute("SerialNo").getString();
			stemp.append(" <tr class=\"a1\"><td><a href=\"javascript:showContract('"+sSerialNo+"')\">"+sSerialNo+"</a></td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(binfo.getCreditObject().getAttribute("BusinessSum").getDouble())+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(binfo.getCreditObject().getAttribute("Balance").getDouble())+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(binfo.getGuarantyManager().getGCExposureSum())+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(binfo.getBailSum())+"</td>");
			stemp.append("<td align=\"right\">"+binfo.getCreditObject().getAttribute("Maturity").getString()+"</td>");
			stemp.append("<td align=\"right\">"+binfo.getCycleName()+"</td>");

			String sCurrency=binfo.getCreditObject().getAttribute("BusinessCurrency").getString();
			sCurrency=getItemName("Currency",sCurrency);
			stemp.append("<td>"+sCurrency+"</td>"); 
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(binfo.getUseBusinessSum())+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(binfo.getUseExposureSum())+"</td>");
			stemp.append("</tr>"); 
			duseSum1+=binfo.getUseBusinessSum();
			duseSum2+=binfo.getUseExposureSum();
			
		}
		if(j==0) stemp.append("<tr><td colspan='9' align='center'>["+stips+"]<br><br>项下未发生业务</td></tr>");
		
		stemp.append(" <tr style='background-color:#cad9ea;'><td colspan='8'>合计</td>"); 
		stemp.append("<td>"+DataConvert.toMoney(duseSum1)+"</td>");
		stemp.append("<td>"+DataConvert.toMoney(duseSum2)+"</td>"); 
		stemp.append("</tr>"); 
		
		stemp.append("</table></div>");
		return stemp.toString();
	}

	
	public String getDivideUse(List<CLDivide> lstDivide,String fatherNum) throws Exception
	{
		StringBuffer stemp=new StringBuffer();
		String sclassName="",snextNum=""; 
		int inextNum=1;
		for(CLDivide clDivide:lstDivide)
		{
			if(fatherNum.equals("")){
				icount=icount+1;
				snextNum=String.valueOf(icount);
			}else{
				snextNum=fatherNum+"."+String.valueOf(inextNum);
				inextNum++;
			}
		 	if(sdivideList=="") sdivideList=clDivide.getSerialNo();
	 	 	else sdivideList=sdivideList+"@"+clDivide.getSerialNo();
			double dBusinessSum=clDivide.getBusinessSum();
			double dExposuresum=clDivide.getExposureSum();
			
			double dUseBusinessSum=0;
			dUseBusinessSum=clDivide.getUseBusinessSum();
			double  dUseExposuresum=0; 
			dUseExposuresum=clDivide.getUseExposuresum(); 
			
			if(icount%2==0) sclassName="class=\"a1\"";
			 
			stemp.append("<tr "+sclassName+">");
			stemp.append("<td>"+snextNum+"</td>"); 
			stemp.append("<td>"+clDivide.getDivideName()+"</td>");//分配名称
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(dBusinessSum)+"</td>");//名义金额
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(dExposuresum)+"</td>");//敞口金额
			stemp.append("<td>"+clDivide.getCycleName()+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(dUseBusinessSum)+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(dUseExposuresum)+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(dBusinessSum-dUseBusinessSum)+"</td>");
			stemp.append("<td align=\"right\">"+DataConvert.toMoney(dExposuresum-dUseExposuresum)+"</td>");
			stemp.append("<td><a href='#' onclick=\"javascript:showDetail('"+clDivide.getSerialNo()+"',this)\">查看</a></td>");
			stemp.append("</tr>");  
			bufferUse.append("<div id='"+clDivide.getSerialNo()+"'  style='display:none'>"+getDetail(clDivide.getAccountManager(),clDivide.getSerialNo(),clDivide.getAttribute("dividename").getString())+"</div>");
	 		stemp.append(getDivideUse(clDivide.getRelativeDivide(),snextNum));
		
		} 
		return stemp.toString();
	}

	public   String  getList()
	{
		return this.sdivideList;
	}

	public String getUseInfo()
	{
		return this.bufferUse.toString();
	}
	
	private static String getItemName(String codeNo, String itemNo){
		BizObjectManager bm;
		String itemName = "";
		try {
			bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
			BizObject bo = bm.createQuery("select ItemName from O where CodeNo =:CodeNo and ItemNo =:ItemNo")
							.setParameter("CodeNo", codeNo)
							.setParameter("ItemNo", itemNo)
							.getSingleResult(false);
			itemName = bo.getAttribute("ItemName").getString();
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return itemName;
	}

}

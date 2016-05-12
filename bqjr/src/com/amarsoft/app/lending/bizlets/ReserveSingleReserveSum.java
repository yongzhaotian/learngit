package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.reserve.batch.RCUnitForPage;



/**
 * 调用PRH单元，计算单项计提金额
 * @author syang 2009/11/16
 *
 */
public class ReserveSingleReserveSum extends Bizlet {
	
	private String sAccountMonth = "";
	private String sDuebillNo = "";
	private String sFlag = "";
	
	/**
	 * @param AccountMonth 会计月份,通过this.setAttribute("AccountMonth","会计月份")设置值
	 * @param DuebillNo 借据号,通过this.setAttribute("DuebillNo","借据号")设置值
	 * @return 1 成功
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * 获取参数
		 */
		sAccountMonth = (String)this.getAttribute("AccountMonth");	//会计月份
		sDuebillNo = (String)this.getAttribute("DuebillNo");			//借据号
		sFlag = (String)this.getAttribute("Flag");			//传入参数记录是否自动转组合
		
		if(sDuebillNo == null){
			sDuebillNo = "";
		}
		if(sAccountMonth == null){
			sAccountMonth = "";
		}
		if(sFlag == null){
			sFlag = "false";//默认是关闭自动转组合的情况
		}
		String sReturn = "1";
		ARE.setProperty("autoSingle2Comp", sFlag);//关闭单项计提完成后，自动转组合的情况
		RCUnitForPage.calculateSingleReserve(sAccountMonth, sDuebillNo, Sqlca.getConnection(), !sFlag.equalsIgnoreCase("false"));
		return sReturn;
	}
}

package com.amarsoft.app.als.credit.cl.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.credit.cl.model.CLDivide;
import com.amarsoft.app.als.credit.cl.model.CLRelativeAction;
import com.amarsoft.app.als.credit.cl.model.CreditLine;
import com.amarsoft.app.als.credit.cl.model.LmtAccountInfo;
import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;

/**
 * 额度占用检查
 * @author jschen
 * @date:2012-12-21
 * 
 */
public class CheckCLOccupy {
	
	private StringBuffer checkLog = new StringBuffer(); //检查日志以“@”分割
	
	public StringBuffer getCheckLog() {
		return checkLog;
	}

	boolean passFlag=true; 
	
	private void setPassFlag(boolean passFlag) {
		if(this.passFlag == true) this.passFlag = passFlag; //只要命中一条规则返回结果就是false，但检查继续执行
	}
	
	public boolean checkDependentValidity(CreditLine line, LmtAccountInfo lmtAccountInfo) throws Exception{
		double dDependentBusinessSum = 0.0;
		double dDependentExposureSum = 0.0;
		List<BizObject> lst=line.getCurCreditObject().getAppendList(CreditConst.APPENDTYPE_DIVIDELINE);
	 
		dDependentBusinessSum+=lmtAccountInfo.getUseBusinessSum();//获取额度项下业务申请名义金额
		dDependentExposureSum+=lmtAccountInfo.getUseExposureSum();//获取额度项下业务申请敞口金额 
		if(!line.getCycleFlag() && lmtAccountInfo.getCycleflag())
		{
			checkLog.append("@综合授信额度为非循环,而申请业务["+lmtAccountInfo.getCreditObject().getAttribute("SerialNo").getString()+"]为循环，请检查！");
			this.setPassFlag(false);
		}
		
		//获取与lmtAccountInfo相关的切分额度
 		List<CLDivide> clDivideList = new ArrayList<CLDivide>();
 		for(BizObject boDivide:lst){
 			CLDivide clDivide = new CLDivide(boDivide);
 			clDivideList.add(clDivide);
 		}
	 	List<CLDivide>  applst=CLRelativeAction.getDivideList(clDivideList, lmtAccountInfo.getCreditObject());
	 	
		if(applst.size()==0 && lst.size()>0){
			this.setPassFlag(false);
			checkLog.append("@额度项下业务申请["+lmtAccountInfo.getCreditObject().getAttribute("SerialNO").getString()+"]无对应的额度分配，请检查！");
		}
		if(this.passFlag)
		{
			for(CLDivide app : applst)
			{
				boolean passFlagTemp=checkLastDivide(app,lmtAccountInfo);
				this.setPassFlag(passFlagTemp);
				if(!app.getCycleflag() && lmtAccountInfo.getCycleflag())
				{
					this.setPassFlag(false);
					checkLog.append("@额度项下业务["+lmtAccountInfo.getCreditObject().getAttribute("SerialNo").getString()+"]为循环,而所在额度分配["+app.getDivideName()+"]为非循环，请检查！");
				}
			}
		}
		
		if(isXLessThanY(line.getUsableBusinessSum(), dDependentBusinessSum) && line.bchBusinessSum) //切分名义金额与额度项下业务汇总后的申请金额比较
		{
			this.setPassFlag(false);
			checkLog.append("@额度项下业务申请金额["+DataConvert.toMoney(dDependentBusinessSum)+"]超过额度可用名义金额["+DataConvert.toMoney(line.getUsableBusinessSum())+"]，请检查！");
		}
		if(isXLessThanY(line.getUsableExposureSum(), dDependentExposureSum) && line.bchExposureSum) //切分敞口金额与额度项下业务汇总后的敞口金额比较
		{
			this.setPassFlag(false);
			checkLog.append("@额度项下业务敞口金额["+DataConvert.toMoney(dDependentExposureSum)+"]超过额度可用敞口金额["+DataConvert.toMoney(line.getUsableExposureSum())+"]，请检查！");
		}
		
		return this.passFlag;
	}
	
	/**
	 * 循环检查额度下业务分配
	 * @param divide
	 * @param lmtAccountInfo 
	 * @return
	 * @throws JBOException
	 */
	private boolean  checkLastDivide(CLDivide divide,LmtAccountInfo lmtAccountInfo) throws JBOException
	{
		boolean passFlag=true;
		List<CLDivide>  nextDivide=divide.getRelativeDivide();
		BizObject biz=lmtAccountInfo.getCreditObject();
		List<CLDivide>  applst=CLRelativeAction.getDivideList(nextDivide, biz);//查看额度下是否有切分
		if(divide.bchBusinessSum && divide.getBusinessSum()<lmtAccountInfo.getUseBusinessSum())
		{
			passFlag=false;
			checkLog.append("@额度项下业务["+biz.getAttribute("SerialNo").getString()+"]申请金额["+DataConvert.toMoney(lmtAccountInfo.getUseBusinessSum())+"]超过额度["+divide.getDivideName()+"]分配名义金额["+DataConvert.toMoney(divide.getBusinessSum())+"]，请检查！");
			//checkLog.append("@额度分配["+ndivide.getDivideName()+"]项下业务申请["+biz.getAttribute("SerialNO").getString()+"]的额度分配，请检查!");
		}
		if(divide.getExposureSum() < lmtAccountInfo.getUseExposureSum() && divide.bchExposureSum) //切分敞口金额与额度项下业务汇总后的敞口金额比较
		{
			passFlag=false;
			checkLog.append("@额度项下业务["+biz.getAttribute("SerialNo").getString()+"]敞口金额["+DataConvert.toMoney(lmtAccountInfo.getUseExposureSum())+"]超过额度["+divide.getDivideName()+"]分配敞口金额["+DataConvert.toMoney(divide.getExposureSum())+"]，请检查！");
		} 
		
		if(applst.size()==0 && nextDivide.size()>0)
		{
			checkLog.append("@额度分配["+divide.getDivideName()+"]下层无项下业务申请["+biz.getAttribute("SerialNO").getString()+"]的额度分配，请检查!");
			passFlag=false; 
		} 
		 
		for(CLDivide ndivide:applst)
		{ 	
			if(!passFlag) continue;
			if(ndivide.bchBusinessSum && ndivide.getBusinessSum()<lmtAccountInfo.getUseBusinessSum())
			{
				passFlag=false;
				checkLog.append("@额度项下业务["+biz.getAttribute("SerialNo").getString()+"]申请金额["+DataConvert.toMoney(lmtAccountInfo.getUseBusinessSum())+"]超过额度["+ndivide.getDivideName()+"]分配名义金额["+DataConvert.toMoney(ndivide.getBusinessSum())+"]，请检查！");
				//checkLog.append("@额度分配["+ndivide.getDivideName()+"]项下业务申请["+biz.getAttribute("SerialNO").getString()+"]的额度分配，请检查!");
			}
			if(ndivide.getExposureSum() < lmtAccountInfo.getUseExposureSum() && ndivide.bchExposureSum) //切分敞口金额与额度项下业务汇总后的敞口金额比较
			{
				passFlag=false;
				checkLog.append("@额度项下业务["+biz.getAttribute("SerialNo").getString()+"]敞口金额["+DataConvert.toMoney(lmtAccountInfo.getUseExposureSum())+"]超过额度["+ndivide.getDivideName()+"]分配敞口金额["+DataConvert.toMoney(ndivide.getExposureSum())+"]，请检查！");
			} 
			
			if(!passFlag) passFlag=checkLastDivide(ndivide,lmtAccountInfo); 
		} 
		return passFlag;
	}
	
	/**
	 * 在考虑精度的情况下，判断x是否小于y
	 * @param x
	 * @param y
	 * @return
	 */
	private boolean isXLessThanY(double x, double y){
		boolean result = true;
		double d = Arith.sub(x, y);
		if(d > 0.0){
			result = false;
		}else{
			if(Math.abs(d) < CreditConst.LINE_PRECISION) result = false;
			else result = true;
		}
		return result;
	}

}

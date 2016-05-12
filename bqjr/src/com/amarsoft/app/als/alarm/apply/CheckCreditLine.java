package com.amarsoft.app.als.alarm.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.als.credit.cl.model.CLDivide;
import com.amarsoft.app.als.credit.cl.model.CreditLine;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;

public class CheckCreditLine extends AlarmBiz {

	boolean passFlag=true; 
	
	private void setPassFlag(boolean passFlag) {
		if(this.passFlag == true) this.passFlag = passFlag;//只要命中一条规则就返回false
	}

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		/**取参数**/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//取出申请JBO对象  
		CreditLine line=new CreditLine(jboApply);
		line.check();
		
		
		checkLineValidity(line); //额度自身有效性检查
		List<CLDivide> lst=line.getDivideList();
		boolean passFlagTemp=checkDivide(lst); //额度分配有效性检查
		this.setPassFlag(passFlagTemp);
		
		//设置探测规则通过与否
		this.setPass(passFlag);  
		return null;
	}
	
	
	/**
	 * 检查额度自身的有效性校验
	 * @param line 额度
	 * @throws Exception
	 */
	private void checkLineValidity(CreditLine line) throws Exception{
 		String sBusinessType=line.getAttribute("BusinessType").getString();
		List<CLDivide> lst=line.getDivideList();
		if(sBusinessType.equals("3005") || sBusinessType.equals("3008") )
		{
			if(lst.size()==0)
			{
				this.setPassFlag(false);
				this.putMsg("该综合授信额度未进行分配!");
			}
		}
		 
		double divBusinessSum=0;
		double divExposureSum=0; 
		for(CLDivide divide:lst)
		{
			divBusinessSum+=divide.getBusinessSum();
			divExposureSum+=divide.getExposureSum();
			//校验综合授信与同时申请的额度项下业务是否满足条件  
			if(!line.getCycleFlag() && divide.getCycleflag())
			{
				this.setPassFlag(false);
				this.putMsg("该额度为非循环而额度分配["+divide.getDivideName()+"]为循环");
			 }
			
		}
		if(lst.size()>0)
		{
			if(line.getAttribute("BusinessSum").getDouble()<divBusinessSum && line.bchBusinessSum)
			{
				this.setPassFlag(false);
				this.putMsg("额度分配名义金额汇总["+DataConvert.toMoney(divBusinessSum)+"]大于了额度名义金额["+DataConvert.toMoney(line.getAttribute("BusinessSum").getDouble())+"]");
			}else if(divBusinessSum < line.getAttribute("BusinessSum").getDouble() && line.bchBusinessSum ){
				this.putMsg("[提示]额度分配名义金额汇总["+DataConvert.toMoney(divBusinessSum)+"]小于了额度名义金额["+DataConvert.toMoney(line.getAttribute("BusinessSum").getDouble())+"]");

			}
			if(line.getAttribute("ExposureSum").getDouble()<divExposureSum && line.bchExposureSum)
			{
				this.setPassFlag(false);
				this.putMsg("额度分配敞口金额汇总["+DataConvert.toMoney(divExposureSum)+"]大于了额度敞口金额["+DataConvert.toMoney(line.getAttribute("ExposureSum").getDouble())+"]");
			} else if(divExposureSum < line.getAttribute("ExposureSum").getDouble() && line.bchBusinessSum ){
				this.putMsg("[提示]额度分配敞口金额汇总["+DataConvert.toMoney(divExposureSum)+"]小于了额度敞口金额["+DataConvert.toMoney(line.getAttribute("ExposureSum").getDouble())+"]");

			}
		}
	}
	
	/**
	 * 检查分配额度和当前业务
	 * @param lstdivide
	 * @return
	 * @throws JBOException
	 */
	private boolean  checkDivide(List<CLDivide> lstdivide) throws JBOException
	{
		boolean passFlag=true;
		for(CLDivide divide:lstdivide)
		{
			double dBusinessSum=divide.getBusinessSum();
			double dExposuresum=divide.getExposureSum();
			double dBusinessSum1=0;
			double dExposuresum1=0;
			//cjyu 检查下层额度
			if(divide.getRelativeDivide().size()>0)
			{ 
				for(CLDivide div:divide.getRelativeDivide())
				{
					dBusinessSum1+=div.getBusinessSum();
					dExposuresum1+=div.getExposureSum();
					if(!divide.getCycleflag() && div.getCycleflag())
					{
						passFlag=false;
						putMsg("下层["+divide.getDivideName()+"]额度分配为循环，而上层["+div.getDivideName()+"]为非循环，请检查！");
					}
				}
				if(dBusinessSum<dBusinessSum1)
				{
					passFlag=false;//上层额度分配["+divide.getDivideName()+"]的
					putMsg("下层名义金额汇总["+DataConvert.toMoney(dBusinessSum1)+"]超过上层["+divide.getDivideName()+"]的名义金额["+DataConvert.toMoney(dBusinessSum)+"]，请检查！");
				}
				if(dExposuresum<dExposuresum1)
				{
					passFlag=false;
					putMsg("下层敞口金额汇总["+DataConvert.toMoney(dExposuresum1)+"]超过上层["+divide.getDivideName()+"]的敞口金额["+DataConvert.toMoney(dExposuresum)+"]，请检查！");
				}
				
				
				 boolean passFlag2=checkDivide(divide.getRelativeDivide());
				 if(passFlag) passFlag=passFlag2;
			}
		}
		return passFlag; 
	}

}

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
 * ���ռ�ü��
 * @author jschen
 * @date:2012-12-21
 * 
 */
public class CheckCLOccupy {
	
	private StringBuffer checkLog = new StringBuffer(); //�����־�ԡ�@���ָ�
	
	public StringBuffer getCheckLog() {
		return checkLog;
	}

	boolean passFlag=true; 
	
	private void setPassFlag(boolean passFlag) {
		if(this.passFlag == true) this.passFlag = passFlag; //ֻҪ����һ�����򷵻ؽ������false����������ִ��
	}
	
	public boolean checkDependentValidity(CreditLine line, LmtAccountInfo lmtAccountInfo) throws Exception{
		double dDependentBusinessSum = 0.0;
		double dDependentExposureSum = 0.0;
		List<BizObject> lst=line.getCurCreditObject().getAppendList(CreditConst.APPENDTYPE_DIVIDELINE);
	 
		dDependentBusinessSum+=lmtAccountInfo.getUseBusinessSum();//��ȡ�������ҵ������������
		dDependentExposureSum+=lmtAccountInfo.getUseExposureSum();//��ȡ�������ҵ�����볨�ڽ�� 
		if(!line.getCycleFlag() && lmtAccountInfo.getCycleflag())
		{
			checkLog.append("@�ۺ����Ŷ��Ϊ��ѭ��,������ҵ��["+lmtAccountInfo.getCreditObject().getAttribute("SerialNo").getString()+"]Ϊѭ�������飡");
			this.setPassFlag(false);
		}
		
		//��ȡ��lmtAccountInfo��ص��зֶ��
 		List<CLDivide> clDivideList = new ArrayList<CLDivide>();
 		for(BizObject boDivide:lst){
 			CLDivide clDivide = new CLDivide(boDivide);
 			clDivideList.add(clDivide);
 		}
	 	List<CLDivide>  applst=CLRelativeAction.getDivideList(clDivideList, lmtAccountInfo.getCreditObject());
	 	
		if(applst.size()==0 && lst.size()>0){
			this.setPassFlag(false);
			checkLog.append("@�������ҵ������["+lmtAccountInfo.getCreditObject().getAttribute("SerialNO").getString()+"]�޶�Ӧ�Ķ�ȷ��䣬���飡");
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
					checkLog.append("@�������ҵ��["+lmtAccountInfo.getCreditObject().getAttribute("SerialNo").getString()+"]Ϊѭ��,�����ڶ�ȷ���["+app.getDivideName()+"]Ϊ��ѭ�������飡");
				}
			}
		}
		
		if(isXLessThanY(line.getUsableBusinessSum(), dDependentBusinessSum) && line.bchBusinessSum) //�з���������������ҵ����ܺ��������Ƚ�
		{
			this.setPassFlag(false);
			checkLog.append("@�������ҵ��������["+DataConvert.toMoney(dDependentBusinessSum)+"]������ȿ���������["+DataConvert.toMoney(line.getUsableBusinessSum())+"]�����飡");
		}
		if(isXLessThanY(line.getUsableExposureSum(), dDependentExposureSum) && line.bchExposureSum) //�зֳ��ڽ����������ҵ����ܺ�ĳ��ڽ��Ƚ�
		{
			this.setPassFlag(false);
			checkLog.append("@�������ҵ�񳨿ڽ��["+DataConvert.toMoney(dDependentExposureSum)+"]������ȿ��ó��ڽ��["+DataConvert.toMoney(line.getUsableExposureSum())+"]�����飡");
		}
		
		return this.passFlag;
	}
	
	/**
	 * ѭ���������ҵ�����
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
		List<CLDivide>  applst=CLRelativeAction.getDivideList(nextDivide, biz);//�鿴������Ƿ����з�
		if(divide.bchBusinessSum && divide.getBusinessSum()<lmtAccountInfo.getUseBusinessSum())
		{
			passFlag=false;
			checkLog.append("@�������ҵ��["+biz.getAttribute("SerialNo").getString()+"]������["+DataConvert.toMoney(lmtAccountInfo.getUseBusinessSum())+"]�������["+divide.getDivideName()+"]����������["+DataConvert.toMoney(divide.getBusinessSum())+"]�����飡");
			//checkLog.append("@��ȷ���["+ndivide.getDivideName()+"]����ҵ������["+biz.getAttribute("SerialNO").getString()+"]�Ķ�ȷ��䣬����!");
		}
		if(divide.getExposureSum() < lmtAccountInfo.getUseExposureSum() && divide.bchExposureSum) //�зֳ��ڽ����������ҵ����ܺ�ĳ��ڽ��Ƚ�
		{
			passFlag=false;
			checkLog.append("@�������ҵ��["+biz.getAttribute("SerialNo").getString()+"]���ڽ��["+DataConvert.toMoney(lmtAccountInfo.getUseExposureSum())+"]�������["+divide.getDivideName()+"]���䳨�ڽ��["+DataConvert.toMoney(divide.getExposureSum())+"]�����飡");
		} 
		
		if(applst.size()==0 && nextDivide.size()>0)
		{
			checkLog.append("@��ȷ���["+divide.getDivideName()+"]�²�������ҵ������["+biz.getAttribute("SerialNO").getString()+"]�Ķ�ȷ��䣬����!");
			passFlag=false; 
		} 
		 
		for(CLDivide ndivide:applst)
		{ 	
			if(!passFlag) continue;
			if(ndivide.bchBusinessSum && ndivide.getBusinessSum()<lmtAccountInfo.getUseBusinessSum())
			{
				passFlag=false;
				checkLog.append("@�������ҵ��["+biz.getAttribute("SerialNo").getString()+"]������["+DataConvert.toMoney(lmtAccountInfo.getUseBusinessSum())+"]�������["+ndivide.getDivideName()+"]����������["+DataConvert.toMoney(ndivide.getBusinessSum())+"]�����飡");
				//checkLog.append("@��ȷ���["+ndivide.getDivideName()+"]����ҵ������["+biz.getAttribute("SerialNO").getString()+"]�Ķ�ȷ��䣬����!");
			}
			if(ndivide.getExposureSum() < lmtAccountInfo.getUseExposureSum() && ndivide.bchExposureSum) //�зֳ��ڽ����������ҵ����ܺ�ĳ��ڽ��Ƚ�
			{
				passFlag=false;
				checkLog.append("@�������ҵ��["+biz.getAttribute("SerialNo").getString()+"]���ڽ��["+DataConvert.toMoney(lmtAccountInfo.getUseExposureSum())+"]�������["+ndivide.getDivideName()+"]���䳨�ڽ��["+DataConvert.toMoney(ndivide.getExposureSum())+"]�����飡");
			} 
			
			if(!passFlag) passFlag=checkLastDivide(ndivide,lmtAccountInfo); 
		} 
		return passFlag;
	}
	
	/**
	 * �ڿ��Ǿ��ȵ�����£��ж�x�Ƿ�С��y
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

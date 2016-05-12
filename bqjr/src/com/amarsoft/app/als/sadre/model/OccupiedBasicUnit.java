/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.app.als.sadre.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.amarsoft.app.als.sadre.DefaultSynonymnImpl;
import com.amarsoft.app.als.sadre.simplebo.BusinessContract;
import com.amarsoft.app.als.sadre.simplebo.ICustomer;
import com.amarsoft.app.als.sadre.simplebo.RelativeMember;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.sadre.SADREException;

/**
 * <p>Title: OccupiedBasicUnit.java </p>
 * <p>Description: 本类作为计算合同的单户总额的抽象类DEMO,完成子类公用部分实现: </br>
 * 		&nbsp;&nbsp;数据涵盖范围:单笔+额度(未终结/已终结)  --只包含合同阶段
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-11 上午10:58:21</p>
 *
 * logs: 1. add init runtime map at 20110617</p>
 */
public abstract class OccupiedBasicUnit implements OccupiedCalcUnit {
	
	protected DefaultSynonymnImpl synonymn = null;
	
	public double calculate() throws SADREException {
		
		double occupiedSum = 0.0D;
		try {
			occupiedSum += occurIndependence();
		} catch (SADREException e) {
			ARE.getLog().debug(e);
			throw e;
		}
		
		try {
			occupiedSum += occurValidCreditLine();
		} catch (SADREException e) {
			ARE.getLog().debug(e);
			throw e;
		}
		
		ARE.getLog().debug("合同占用敞口金额="+DataConvert.toMoney(occupiedSum));
		
		return occupiedSum;
	}
	
	/**
	 * 数据范围过滤:由子类实现判断传入的合同是否满足,单户业务汇总余额的数据范围
	 * @return
	 * @throws Exception
	 */
	abstract public boolean filterContract(BusinessContract contract) throws SADREException;
	
	/**
	 * 统计单笔业务的单户汇总金额
	 * @return
	 * @throws Exception
	 */
	protected double occurIndependence() throws SADREException{
		double independenceSum = 0.0D;
		// 1. 计算申请人本人的单笔汇总占用
		List<BusinessContract> contracts = scanByFilter(synonymn.getContracts(getCustomer().getId()));
		Iterator<BusinessContract> tk = contracts.iterator();
		while(tk.hasNext()){
			BusinessContract bc = tk.next();
			// 累计单户敞口金额=单笔敞口+未出帐合同金额
			independenceSum += calcIndependence(bc);
		}
		
		// 2. 集团成员/家庭成员的单笔汇总占用
		if(getCustomer().belongRelativeUnit()){			//如果属于某个家庭/集团
			Iterator<RelativeMember> mbs = filterGroupMember().iterator();
			while(mbs.hasNext()){
				RelativeMember member = mbs.next();		//集团/家庭成员
				//--------过滤获取指定担保方式的业务
				Iterator<BusinessContract> memberBCs = scanByFilter(synonymn.getContracts(member.getId())).iterator();
				while(memberBCs.hasNext()){
					BusinessContract memberBC = memberBCs.next();
					//---------叠加家庭成员
					independenceSum += calcIndependence(memberBC);
				}
			}
		}
		ARE.getLog().debug("["+getCustomer().getName()+" 1/3] 表内余额+表外单户敞口="+DataConvert.toMoney(independenceSum)+" <"+this.getClass().getName()+">");
		
		return independenceSum;
	}
	
	/**
	 * 计算单笔合同的敞口金额
	 * @return
	 * @throws Exception
	 */
	protected double calcIndependence(BusinessContract bc) throws SADREException{
		double riskgapSum = 0.0D;
		if(!bc.getBusinessType().startsWith("3")){		//不含额度
//			ARE.getLog().info(bc);
			//demo简单实现:计算合同余额-保证金
			double bailSum = bc.getConvertedBalance()*bc.getBailRatio();
			riskgapSum = bc.getConvertedBalance()>bailSum?(bc.getConvertedBalance()-bailSum):0;
			
			//累计单户敞口金额=单笔合同余额敞口(额度/未放款合同金额+已出帐合同余额)+(已出帐合同项下的)未出帐金额
			riskgapSum += bc.getUnPutoutedSum2RMB();
		}
		
		return riskgapSum;
	}
	
	/**
	 * 统计有效额度的单户汇总金额:<br>
	 * 
	 * <br>
	 * @return
	 * @throws Exception
	 */
	protected double occurValidCreditLine() throws SADREException{
		double validCreditLineSum = 0.0D;
		
		// 1. 本笔申请人自身的额度总额
		List<BusinessContract> contracts = scanByFilter(synonymn.getContracts(getCustomer().getId()));
		Iterator<BusinessContract> tk = contracts.iterator();
		
		while(tk.hasNext()){
			BusinessContract bc = tk.next();
			
			validCreditLineSum += calcValidCreditLine(bc);
		}
		
		// 2. 集团/家庭成员的单笔汇总占用
		if(getCustomer().belongRelativeUnit()){			//如果属于某个家庭
			//1. 个人经营性贷款考虑所有家庭成员:父母,子女,配偶
			//2. 家庭成员贷款不包含按揭类业务
			Iterator<RelativeMember> mbs = filterGroupMember().iterator();
			while(mbs.hasNext()){
				RelativeMember member = mbs.next();		//集团/家庭成员
				
				//--------过滤获取指定担保方式的业务
				Iterator<BusinessContract> memberBCs = scanByFilter(synonymn.getContracts(member.getId())).iterator();
				while(memberBCs.hasNext()){
					BusinessContract memberBC = memberBCs.next();
					//---------叠加家庭成员
					validCreditLineSum += calcValidCreditLine(memberBC);
				}
			}
		}
		
		ARE.getLog().debug("["+getCustomer().getName()+" 2/3] 已占用额度单户金额="+DataConvert.toMoney(validCreditLineSum)+" <"+this.getClass().getName()+">");
		
		return validCreditLineSum;
	}
	
	protected double calcValidCreditLine(BusinessContract bc) throws SADREException{
		double dOccurpiedCLSum = 0.0D;
		
		if(bc.getBusinessType().startsWith("3")){		//只有额度
			dOccurpiedCLSum = bc.getBusinessSum();
		}
		
		return dOccurpiedCLSum;
		
	}
	
	/**
	 * 根据Filter过滤器从客户项下合同中过滤指定的业务范围
	 * @param bcs
	 * @return
	 * @throws Exception 
	 */
	protected List<BusinessContract> scanByFilter(List<BusinessContract> bcs) throws SADREException{
		
		List<BusinessContract> scantmp = new ArrayList<BusinessContract>();
		
		Iterator<BusinessContract> tk = bcs.iterator();
		while(tk.hasNext()){
			BusinessContract bc = tk.next();
			if(filterContract(bc)){		//filter action
//				ARE.getLog().debug(" >> "+bc);
				scantmp.add(bc);
			}
		}
	
		return scantmp;
	}
	
	/**
	 * 根据业务申请授信品种的不同在计算单户金额时，允许子类调整控制所涉及的集团/家庭成员范围<br>
	 * 1. 个人类业务：当申请的业务为个人经营性贷款时,统计所有家庭成员作为关联人；其余个人贷款仅统计配偶<br>
	 * <br>
	 * @return
	 * @throws Exception 
	 */
	protected List<RelativeMember> filterGroupMember() throws SADREException{
		
		return getCustomer().getRelativeMembers();
	}
	
	public ICustomer getCustomer(){
		return synonymn.getCustomer();
	}
}

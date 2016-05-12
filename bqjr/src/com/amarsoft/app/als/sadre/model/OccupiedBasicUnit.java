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
 * <p>Description: ������Ϊ�����ͬ�ĵ����ܶ�ĳ�����DEMO,������๫�ò���ʵ��: </br>
 * 		&nbsp;&nbsp;���ݺ��Ƿ�Χ:����+���(δ�ս�/���ս�)  --ֻ������ͬ�׶�
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-11 ����10:58:21</p>
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
		
		ARE.getLog().debug("��ͬռ�ó��ڽ��="+DataConvert.toMoney(occupiedSum));
		
		return occupiedSum;
	}
	
	/**
	 * ���ݷ�Χ����:������ʵ���жϴ���ĺ�ͬ�Ƿ�����,����ҵ������������ݷ�Χ
	 * @return
	 * @throws Exception
	 */
	abstract public boolean filterContract(BusinessContract contract) throws SADREException;
	
	/**
	 * ͳ�Ƶ���ҵ��ĵ������ܽ��
	 * @return
	 * @throws Exception
	 */
	protected double occurIndependence() throws SADREException{
		double independenceSum = 0.0D;
		// 1. ���������˱��˵ĵ��ʻ���ռ��
		List<BusinessContract> contracts = scanByFilter(synonymn.getContracts(getCustomer().getId()));
		Iterator<BusinessContract> tk = contracts.iterator();
		while(tk.hasNext()){
			BusinessContract bc = tk.next();
			// �ۼƵ������ڽ��=���ʳ���+δ���ʺ�ͬ���
			independenceSum += calcIndependence(bc);
		}
		
		// 2. ���ų�Ա/��ͥ��Ա�ĵ��ʻ���ռ��
		if(getCustomer().belongRelativeUnit()){			//�������ĳ����ͥ/����
			Iterator<RelativeMember> mbs = filterGroupMember().iterator();
			while(mbs.hasNext()){
				RelativeMember member = mbs.next();		//����/��ͥ��Ա
				//--------���˻�ȡָ��������ʽ��ҵ��
				Iterator<BusinessContract> memberBCs = scanByFilter(synonymn.getContracts(member.getId())).iterator();
				while(memberBCs.hasNext()){
					BusinessContract memberBC = memberBCs.next();
					//---------���Ӽ�ͥ��Ա
					independenceSum += calcIndependence(memberBC);
				}
			}
		}
		ARE.getLog().debug("["+getCustomer().getName()+" 1/3] �������+���ⵥ������="+DataConvert.toMoney(independenceSum)+" <"+this.getClass().getName()+">");
		
		return independenceSum;
	}
	
	/**
	 * ���㵥�ʺ�ͬ�ĳ��ڽ��
	 * @return
	 * @throws Exception
	 */
	protected double calcIndependence(BusinessContract bc) throws SADREException{
		double riskgapSum = 0.0D;
		if(!bc.getBusinessType().startsWith("3")){		//�������
//			ARE.getLog().info(bc);
			//demo��ʵ��:�����ͬ���-��֤��
			double bailSum = bc.getConvertedBalance()*bc.getBailRatio();
			riskgapSum = bc.getConvertedBalance()>bailSum?(bc.getConvertedBalance()-bailSum):0;
			
			//�ۼƵ������ڽ��=���ʺ�ͬ����(���/δ�ſ��ͬ���+�ѳ��ʺ�ͬ���)+(�ѳ��ʺ�ͬ���µ�)δ���ʽ��
			riskgapSum += bc.getUnPutoutedSum2RMB();
		}
		
		return riskgapSum;
	}
	
	/**
	 * ͳ����Ч��ȵĵ������ܽ��:<br>
	 * 
	 * <br>
	 * @return
	 * @throws Exception
	 */
	protected double occurValidCreditLine() throws SADREException{
		double validCreditLineSum = 0.0D;
		
		// 1. ��������������Ķ���ܶ�
		List<BusinessContract> contracts = scanByFilter(synonymn.getContracts(getCustomer().getId()));
		Iterator<BusinessContract> tk = contracts.iterator();
		
		while(tk.hasNext()){
			BusinessContract bc = tk.next();
			
			validCreditLineSum += calcValidCreditLine(bc);
		}
		
		// 2. ����/��ͥ��Ա�ĵ��ʻ���ռ��
		if(getCustomer().belongRelativeUnit()){			//�������ĳ����ͥ
			//1. ���˾�Ӫ�Դ�������м�ͥ��Ա:��ĸ,��Ů,��ż
			//2. ��ͥ��Ա�������������ҵ��
			Iterator<RelativeMember> mbs = filterGroupMember().iterator();
			while(mbs.hasNext()){
				RelativeMember member = mbs.next();		//����/��ͥ��Ա
				
				//--------���˻�ȡָ��������ʽ��ҵ��
				Iterator<BusinessContract> memberBCs = scanByFilter(synonymn.getContracts(member.getId())).iterator();
				while(memberBCs.hasNext()){
					BusinessContract memberBC = memberBCs.next();
					//---------���Ӽ�ͥ��Ա
					validCreditLineSum += calcValidCreditLine(memberBC);
				}
			}
		}
		
		ARE.getLog().debug("["+getCustomer().getName()+" 2/3] ��ռ�ö�ȵ������="+DataConvert.toMoney(validCreditLineSum)+" <"+this.getClass().getName()+">");
		
		return validCreditLineSum;
	}
	
	protected double calcValidCreditLine(BusinessContract bc) throws SADREException{
		double dOccurpiedCLSum = 0.0D;
		
		if(bc.getBusinessType().startsWith("3")){		//ֻ�ж��
			dOccurpiedCLSum = bc.getBusinessSum();
		}
		
		return dOccurpiedCLSum;
		
	}
	
	/**
	 * ����Filter�������ӿͻ����º�ͬ�й���ָ����ҵ��Χ
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
	 * ����ҵ����������Ʒ�ֵĲ�ͬ�ڼ��㵥�����ʱ��������������������漰�ļ���/��ͥ��Ա��Χ<br>
	 * 1. ������ҵ�񣺵������ҵ��Ϊ���˾�Ӫ�Դ���ʱ,ͳ�����м�ͥ��Ա��Ϊ�����ˣ�������˴����ͳ����ż<br>
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

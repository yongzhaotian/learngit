package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 补登合同担保信息完整性检查
 * @author jschen
 * @since 2010/03/24
 */
public class ContractGuarantyCheck extends AlarmBiz {
	
	
	String sCount="";	
	String sSql="";
	SqlObject so = null;//声明对象
	
	
	public Object run(Transaction Sqlca) throws Exception {
		
		BizObject jboContract = (BizObject)this.getAttribute("BusinessContract");		//取出合同JBO对象
		String sContractSerialNo = jboContract.getAttribute("SerialNo").getString();
		String sVouchType = jboContract.getAttribute("VouchType").getString();
		
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sVouchType == null) sVouchType = "";
		if(sVouchType.length()>=3) {
			//假如业务基本信息中的主要担保方式为保证,必须输入保证担保信息
			if(sVouchType.substring(0,3).equals("010")){
				//检查担保合同信息中是否存在保证担保
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from Contract_RELATIVE where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '010%' having count(SerialNo) > 0 ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sContractSerialNo);
		        sCount = Sqlca.getString(so);
				
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("合同信息中主要担保方式为保证，可没有输入与保证有关的担保信息");	
					//保证信息检查是否通过设置到场景中，如果保证信息没有填写，则不允许作保证人信息检查（模型010910-010970）
				}
			}
			
			//假如业务基本信息中的主要担保方式为抵押,必须输入抵押担保信息，并且还需要有相应的抵押物信息
			if(sVouchType.substring(0,3).equals("020"))	{
				//检查担保合同信息中是否存在抵押担保
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from Contract_RELATIVE where SerialNo=:SerialNo and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '050%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sContractSerialNo);
		        sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("合同信息中主要担保方式为抵押，可没有输入与抵押有关的担保信息");						
				}else{							
					sSql = 	" select count(GuarantyID) from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
							" from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo =:ObjectNo) "+
							" and GuarantyType like '010%' ";
					so = new SqlObject(sSql);
					so.setParameter("ObjectNo", sContractSerialNo);
			        sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("合同信息中主要担保方式为抵押，可输入的抵押担保信息没有抵押物信息");						
					}
				}												
			}
			
			
			//假如业务基本信息中的主要担保方式为质押,必须输入质押担保信息，并且还需要有相应的质物信息
			if(sVouchType.substring(0,3).equals("040"))	{
				//检查担保合同信息中是否存在质押担保
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from Contract_RELATIVE where SerialNo=:SerialNo  and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '060%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sContractSerialNo);
		        sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("合同信息中主要担保方式为质押，可没有输入与质押有关的担保信息");						
				}else{
					sSql = 	" select count(GuarantyID) from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
							" from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo =:ObjectNo ) "+
							" and GuarantyType like '020%' ";
					so = new SqlObject(sSql);
					so.setParameter("ObjectNo", sContractSerialNo);
			        sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("合同信息中主要担保方式为质押，可输入的质押担保信息没有质物信息");						
					}							
				}						
			}
		}
		
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}

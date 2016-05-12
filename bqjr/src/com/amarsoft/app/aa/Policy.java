package com.amarsoft.app.aa;

import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class Policy {
	private ASValuePool attributes = new ASValuePool();
	private AuthorizationPoint[] points = null;

	public void setAttribute(String sKey,Object oValue) throws Exception{
		this.attributes.setAttribute(sKey,oValue);
	}
	public Object getAttribute(String sKey)throws Exception{
		return this.attributes.getAttribute(sKey);
	}
	public Policy(Transaction Sqlca,String sPolicyID) throws Exception{
	}
	
	public String[][] getConstants() throws Exception{
		String[][] constants;
		Object[] sKeys = this.attributes.getKeys();
		constants = new String[sKeys.length][2];
		for(int i=0;i<constants.length;i++){
			if(sKeys[i]==null) continue;
			constants[i][0] = "#"+(String)sKeys[i];
			constants[i][1] = (String)this.getAttribute((String)sKeys[i]);
		}
		return constants; 
	}
	
	public AuthorizationPoint[] getAuthPoints(Transaction Sqlca) throws Exception{
		
		//如果有了，就返回
		if(this.points!=null) return this.points;
		//否则从数据库读取所有的授权点定义
		String[] sKeysPoint = {"AuthID",
        		"PolicyID",
        		"FlowNo",
        		"PhaseNo",
        		"OrgLevel",
        		"OrgID",
        		"ProductSetID",
        		"ProductID",
        		"GuarantyCategory",
        		"GuarantyType",
        		"Attribute1",
        		"Attribute2",
        		"Attribute3",
        		"Attribute4",
        		"BizBalanceCeiling",
        		"BizExposureCeiling",
        		"CustBalanceCeiling",
        		"CustExposureCeilin",
        		"InterestRateFloor"
        		};
        
        StringBuffer sbSelectPoint = new StringBuffer("");
        sbSelectPoint.append("select ");
        for(int i=0;i<sKeysPoint.length;i++) sbSelectPoint.append(sKeysPoint[i]+",");
        sbSelectPoint.deleteCharAt(sbSelectPoint.length()-1);
        sbSelectPoint.append(" from AA_AUTHPOINT where EffStatus='1' order by SortNo");
       
        SqlObject so = new SqlObject(sbSelectPoint.toString());
        String[][] sValueMatrixPoint = Sqlca.getStringMatrix(so);
        
        //从数据库中读取所有的例外点定义
        String[] sKeysException = {"AE.AuthID",
        		"AE.ExceptionID",
        		"AE.TypeID",
        		"AET.ExceptionExpr",
        		"AE.VariableA",
        		"AE.VariableB",
        		"AE.SortNo",
        		"AE.BizBalanceCeiling",
        		"AE.BizExposureCeiling",
        		"AE.CustBalanceCeiling",
        		"AE.CustExposureCeilin",
        		"AE.InterestRateFloor"
        		};
		
        StringBuffer sbSelectException = new StringBuffer("");
        sbSelectException.append("select ");
        for(int i=0;i<sKeysException.length;i++) sbSelectException.append(sKeysException[i]+",");
        sbSelectException.deleteCharAt(sbSelectException.length()-1);
        sbSelectException.append(" from AA_EXCEPTION AE,AA_EXCEPTIONTYPE AET where AE.TypeID=AET.TypeID and AE.IsInUse='1' order by SortNo");
        
        SqlObject sbo = new SqlObject(sbSelectException.toString());
        String[][] sValueMatrixException = Sqlca.getStringMatrix(sbo);
          
        this.points = new AuthorizationPoint[sValueMatrixPoint.length];
        
        
        
        for(int i=0;i<sValueMatrixPoint.length;i++){
        	this.points[i] = new AuthorizationPoint();
        	for(int j=0;j<sKeysPoint.length;j++){
        		this.points[i].setAttribute(sKeysPoint[j],sValueMatrixPoint[i][j]);
        	}
        	
        	//为该授权点初始化例外定义
        	for(int j=0;j<sValueMatrixException.length;j++){
        		if(sValueMatrixException[j][0]!=null && sValueMatrixException[j][0].equals(this.points[i].getAttribute("AuthID"))){
        			AuthorizationException aeTemp = new AuthorizationException();
        			for(int k=0;k<sKeysException.length;k++){
        				aeTemp.setAttribute(sKeysException[k],sValueMatrixException[j][k]);
        			}
        			this.points[i].setException(aeTemp);
        		}
        	}
        }
        
		return this.points;
	}
	
}

package com.amarsoft.app.aa;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.web.ui.HTMLTreeView;

public class ProductManageTree {
	public static HTMLTreeView getTree(Transaction Sqlca,Component CurComp,String sServletURL,String sResourcesPath) throws Exception{
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"产品管理","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		//tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		//tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
		int i=0;
		int iLeaf=1;
		String sTypeNo,sTypeName;
//		String sFolderEnt = tviTemp.insertPage("root","公司业务","javascript:parent.openPhase(\"ENT\",\"公司业务\")",i++);
		String sFolderEnt = tviTemp.insertFolder("root","公司业务","javascript:parent.openPhase(\"ENT\",\"公司业务\")",i++);
		String sSql =  " select TypeNo,TypeName,SortNo from BUSINESS_TYPE "+
        " where isinuse='1' and (TypeNo like '1%' or TypeNo like '2%') and  TypeNo not like '111%' "+
        " And length(SortNo)=4 "+
        " Order by SortNo ";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		while (rs.next()){
			sTypeNo  =   DataConvert.toString(rs.getString("TypeNo"));
		    sTypeName = DataConvert.toString(rs.getString("TypeName"));
		     
		    //将空值转换成空字符串        
		    if(sTypeNo == null) sTypeNo = ""; 
		    if(sTypeName == null) sTypeName = "";         
		    
		    tviTemp.insertPage(sFolderEnt,sTypeName,"javascript:parent.openPhase(\""+ sTypeNo +"\",\""+ sTypeName +"\")",iLeaf++);
		}
		rs.getStatement().close();
		tviTemp.insertPage("root","个人业务","javascript:parent.openPhase(\"1110\",\"个人业务\")",i++);
		tviTemp.insertPage("root","授信额度","javascript:parent.openPhase(\"3\",\"授信额度\")",i++);
		return tviTemp;
	}
}
package com.amarsoft.app.aa;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.web.ui.HTMLTreeView;

public class ProductManageTree {
	public static HTMLTreeView getTree(Transaction Sqlca,Component CurComp,String sServletURL,String sResourcesPath) throws Exception{
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,"��Ʒ����","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		//tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		//tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
		int i=0;
		int iLeaf=1;
		String sTypeNo,sTypeName;
//		String sFolderEnt = tviTemp.insertPage("root","��˾ҵ��","javascript:parent.openPhase(\"ENT\",\"��˾ҵ��\")",i++);
		String sFolderEnt = tviTemp.insertFolder("root","��˾ҵ��","javascript:parent.openPhase(\"ENT\",\"��˾ҵ��\")",i++);
		String sSql =  " select TypeNo,TypeName,SortNo from BUSINESS_TYPE "+
        " where isinuse='1' and (TypeNo like '1%' or TypeNo like '2%') and  TypeNo not like '111%' "+
        " And length(SortNo)=4 "+
        " Order by SortNo ";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		while (rs.next()){
			sTypeNo  =   DataConvert.toString(rs.getString("TypeNo"));
		    sTypeName = DataConvert.toString(rs.getString("TypeName"));
		     
		    //����ֵת���ɿ��ַ���        
		    if(sTypeNo == null) sTypeNo = ""; 
		    if(sTypeName == null) sTypeName = "";         
		    
		    tviTemp.insertPage(sFolderEnt,sTypeName,"javascript:parent.openPhase(\""+ sTypeNo +"\",\""+ sTypeName +"\")",iLeaf++);
		}
		rs.getStatement().close();
		tviTemp.insertPage("root","����ҵ��","javascript:parent.openPhase(\"1110\",\"����ҵ��\")",i++);
		tviTemp.insertPage("root","���Ŷ��","javascript:parent.openPhase(\"3\",\"���Ŷ��\")",i++);
		return tviTemp;
	}
}
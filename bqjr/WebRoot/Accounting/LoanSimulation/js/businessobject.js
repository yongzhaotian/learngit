function saveBusinessObjectToSession(businessObjectType,parentObjectType,parentObjectNo){
	if(businessObjectType=="jbo.app.BUSINESS_PUTOUT"){
		var r = checkSave();
		if(r==1){
			return;
		}
	}	
	var colCount = DZ[0][1].length;//����
	var paraStr = "RowCount="+getRowCount(0);
	var colnames="";
	for(var i=0;i<DZ[0][1].length;i++){
		var updateable=DZ[0][1][i][5];
		//alert(updateable+"--"+getColName(0,i));
		if(updateable==0) continue;
		colnames+=getColName(0,i)+",";
	}
	for(var j=1;j<=getRowCount(0);j++){
		for(var i=0;i<colCount;i++){
			var updateable=DZ[0][1][i][5];
			if(updateable==0) continue;
			var value=getItemValueByIndex(0,j-1,i);
			if(typeof(value)=="undefined"||value==null || value.length==0||value=="null"||value=="Null") continue;
			paraStr += "&"+getColName(0,i)+j+"="+value;
		}
	}
	if(typeof(parentObjectType)=="undefined"||parentObjectType==null ||parentObjectType=="null"||parentObjectType=="Null") 
		parentObjectType="";
	if(typeof(parentObjectNo)=="undefined"||parentObjectNo==null ||parentObjectNo=="null"||parentObjectNo=="Null") 
		parentObjectNo="";
	paraStr+="&ParentObjectType="+parentObjectType;
	paraStr+="&ParentObjectNo="+parentObjectNo;
	paraStr+="&BusinessObjectType="+businessObjectType+"&ColNames="+colnames;
	//���в����棬�ٴ�ˢ�º��޿��г���
	var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
	if(returnValue=="true"){
		alert("����ɹ���");
		if(businessObjectType=="jbo.app.BUSINESS_PUTOUT"){
			parent.tt();
		}		
		reloadSelf();
	}
	else alert("����ʧ�ܣ�");
}

function deleteBusinessObjectFromSession(businessObjectType,keyCol){
	var serialNo = getItemValue(0,getRow(),keyCol);
	if (typeof(serialNo)=="undefined" || serialNo.length==0){
		alert("��ѡ��һ����¼��");
		return;
	}
	var paraStr="BusinessObjectType="+businessObjectType+"&SerialNo="+serialNo;
	//���в����棬�ٴ�ˢ�º��޿��г���
	var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectDelete.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
	if(returnValue=="true"){
		alert("ɾ���ɹ���");
		reloadSelf();
	}
	else alert("ɾ��ʧ�ܣ�");
	
}

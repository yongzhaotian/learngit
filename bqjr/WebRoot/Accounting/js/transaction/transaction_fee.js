/*~[Describe=����ǰУ�鷽��;InputParam=��;OutPutParam=��;]~*/
function beforeSave(){
	var transDate = getItemValue(0,getRow(),"TransDate");
	if(transDate < businessDate){
		alert("��Ч���ڲ������ڵ�ǰ����");
		return false;
	}
	var transCode = getItemValue(0,getRow(),"TransCode");
	if(transCode == "3508")
	{
		var actualFeeAmount = getItemValue(0,getRow(),"ActualFeeAmount");
		var waiveType = getItemValue(0,getRow(),"WaiveType");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		var calFeeAmount = "";
		if(waiveType == "0"){//���ս�����
			var waiveAmount = getItemValue(0,getRow(),"WaiveAmount");
			calFeeAmount = parseFloat(feeAmount)+parseFloat(waiveAmount);
		}
		else if(waiveType == "1")//���ձ�������
		{
			var waivePercent = getItemValue(0,getRow(),"WaivePercent");
			calFeeAmount = parseFloat(feeAmount)*(1+parseFloat(waivePercent)/100.0);
		}
		
		if(actualFeeAmount>calFeeAmount){
			alert("ʵ�շ��ý��ܳ����������õ�ʵ�շ��ý�"+calFeeAmount);
			return false;
		}
		
		if(actualFeeAmount <= 0)
		{
			alert("ʵ�շ��ý���С�ڵ���0��");
			return false;
		}
	}
	else if(transCode == "3520")
	{
		var actualFeeAmount = getItemValue(0,getRow(),"ActualFeeAmount");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(feeAmount < actualFeeAmount)
		{
			alert("ʵ�շ��ý��ܳ���Ӧ�շ��ý�");
			return false;
		}
		if(actualFeeAmount <= 0)
		{
			alert("ʵ�շ��ý���С�ڵ���0��");
			return false;
		}
	}
	else if(transCode == "3530")
	{
		var waiveType = getItemValue(0,getRow(),"WaiveType");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		var WaiveAmount = getItemValue(0,getRow(),"WaiveAmount");
		if(parseFloat(WaiveAmount)<=0)
		{
			alert("����ķ��ý��������0��");
			return false;
		}
		if(parseFloat(feeAmount) <parseFloat(WaiveAmount))
		{
			alert("����ķ��ý��ܴ�����߿ɼ����");
			return false;
		}
		var calFeeAmount = "";
		if(waiveType == "0"){//���ս�����
			var waiveAmount = getItemValue(0,getRow(),"WaiveAmount");
			calFeeAmount = parseFloat(feeAmount)+parseFloat(waiveAmount);
		}
		else if(waiveType == "1")//���ձ�������
		{
			var waivePercent = getItemValue(0,getRow(),"WaivePercent");
			calFeeAmount = parseFloat(feeAmount)*(1+parseFloat(waivePercent)/100.0);
		}
		if(calFeeAmount < 0)
		{
			alert("������ķ��ý���Ϊ���������飡");
			return false;
		}
	}
	else if(transCode == "3540")
	{
		var actualFeeAmount = getItemValue(0,getRow(),"ActualFeeAmount");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(feeAmount > actualFeeAmount)
		{
			alert("ʵ�˷��ý���С��Ӧ�˷��ý�");
			return false;
		}
		if(actualFeeAmount >= 0)
		{
			alert("ʵ�˷��ý��ܴ��ڵ���0��");
			return false;
		}
	}
	return true;
}

/*~[Describe=��������߼�;InputParam=��;OutPutParam=��;]~*/
function afterSave(){
	calcFeeAmount();
}

/*~[Describe=��ʼ��;InputParam=��;OutPutParam=��;]~*/
function initRow(){
	if (getRowCount(0)==0) {
		as_add("myiframe0");//������¼
	}
	setItemValue(0,getRow(),"INPUTUSERID",curUserID);
	setItemValue(0,getRow(),"INPUTUSERNAME",curUserName);
	setItemValue(0,getRow(),"INPUTORGID",curOrgID);
	setItemValue(0,getRow(),"INPUTORGNAME",curOrgName);
	setItemValue(0,getRow(),"INPUTDATE",businessDate);
	setItemValue(0,getRow(),"UPDATEUSERID",curUserID);
	setItemValue(0,getRow(),"UPDATEUSERNAME",curUserName);
	setItemValue(0,getRow(),"UPDATEORGID",curOrgID);
	setItemValue(0,getRow(),"UPDATEORGNAME",curOrgName);
	setItemValue(0,getRow(),"UPDATEDATE",businessDate);
	calcFeeAmount();
}

function selectFeeScheduleSerialNo(sFeeFlag)
{
	var feeSerialNo = getItemValue(0,getRow(),"FeeSerialNo");
	setObjectValue("SelectFeeSchedule","ObjectType,jbo.app.ACCT_FEE,ObjectNo,"+feeSerialNo+",FeeFlag,"+sFeeFlag,"@FeeScheduleSerialno@0@FeeAmount@1",0,0,"");
}

/*~[Describe=��������ķ���;InputParam=�����¼�;OutPutParam=��;]~*/
function calcFeeAmount(){
	var waiveType = getItemValue(0,getRow(),"WaiveType");
	if(waiveType == "0")//���ս�����
	{
		setItemRequired(0,getRow(),"WaivePercent",false);
		setItemRequired(0,getRow(),"WaiveAmount",true);
		setItemDisabled(0,getRow(),"WaivePercent",true);
		setItemDisabled(0,getRow(),"WaiveAmount",false);
		var waiveAmount = getItemValue(0,getRow(),"WaiveAmount");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(typeof(waiveAmount) == "undefined" || waiveAmount.length == 0) waiveAmount = 0.0;
		setItemValue(0,getRow(),"WaivePercent",waiveAmount/feeAmount*100);
		
	}
	else if(waiveType == "1")//���ձ�������
	{
		setItemRequired(0,getRow(),"WaivePercent",true);
		setItemRequired(0,getRow(),"WaiveAmount",false);
		setItemDisabled(0,getRow(),"WaivePercent",false);
		setItemDisabled(0,getRow(),"WaiveAmount",true);
		var waivePercent = getItemValue(0,getRow(),"WaivePercent");
		var feeAmount = getItemValue(0,getRow(),"FeeAmount");
		if(typeof(waivePercent) == "undefined" || waivePercent.length == 0) waivePercent = 0.0;
		setItemValue(0,getRow(),"WaiveAmount",feeAmount*waivePercent/100.0);
	}
}

/*~[Describe=������߿ɼ�����;InputParam=�����¼�;OutPutParam=��;]~*/
function changeFeeAmount(){
	var sFeeSerialNo = getItemValue(0,getRow(),"FeeSerialNo");
	var sSeqID = getItemValue(0,getRow(),"SeqID");
	
	var sParaString=sFeeSerialNo+","+sSeqID;
	var dMaxFeeAmount=RunMethod("BusinessManage","SelectWaiveFeeAmount",sParaString);
	if(dMaxFeeAmount=="Null"){
		dMaxFeeAmount=0.00;
	}
	setItemValue(0,getRow(),"FeeAmount",dMaxFeeAmount);
		
	
}
 //�ո���ʽ
    function calcDecuctType(){
    	var sDecuctType = getItemValue(0,getRow(),"DecuctType");
    	if(sDecuctType=="0"){//�����ʱһ������ȡ
    		setItemValue(0,getRow(),"DEDUCTDATE","<%=StringFunction.getToday()%>");
    		setItemValue(0,getRow(),"FeeFrequency","3");
    	}
    }
 //收付方式
    function calcDecuctType(){
    	var sDecuctType = getItemValue(0,getRow(),"DecuctType");
    	if(sDecuctType=="0"){//贷款发放时一次性收取
    		setItemValue(0,getRow(),"DEDUCTDATE","<%=StringFunction.getToday()%>");
    		setItemValue(0,getRow(),"FeeFrequency","3");
    	}
    }
 function calcRepaymentCycle(){
    	
    	sRepaymentMethod = getItemValue(0,getRow(),"RePaymentMethod");
    	changeRepaymentCycle(sRepaymentMethod);
    }
    
    function calcRepayDay(){
    	var sRepayDay = getItemValue(0,getRow(),"RepayDay");
    	checkRepayDay(sRepayDay);
    }
    
    
//页面初始化加载
function initRow()
{
	
}
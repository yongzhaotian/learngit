/*********************************
 *功能说明：跑马灯插件
 *日期：2009/12/10
 *作者：杨松
 *备注：目前仅支持向上滚动
 *********************************/

$.fn.extend({
	ScrollAction:function(speed,isSeries){
		var seHeight ;			//滚动元素的高度
		var parentHeight;		//父元素的高度
		var scrollHeight;		//已滚动高度
		var timeID = '';		//记录setInterval的标记id
		var scrolElement = $(this);

		//取滚动节点，父节点高度
		sh = $(this).height();																						//scrollHeight
		ph = $(this).parent("div").height();															//parentHeight
		offsetTop = (!isSeries)?ph:4;																										//顶部偏移量
		scrolElement.css('top',offsetTop);
		start();
		//
		//向上滚动
		//
		function scrollUp(){
			offsetTop --;
			if(!isSeries) {						//isSeries变量控制是否连续滚动，false不连续，true连续
				if(offsetTop == -sh) {	//偏移等于元素高度负值，说明滚完了；不连续，重设偏移量
					offsetTop = ph;
				};
			}else{
				if(offsetTop == -scrolElement.children().eq(0).height()) {	//连续滚动
					firstItem = scrolElement.children().eq(0).remove();				//记录下被删除的节点
					scrolElement.append(firstItem);														//添加到尾部
					offsetTop = 4;
				};
			};
			scrolElement.css({'top': offsetTop});
		};
		//
		//鼠标事件
		//
		function hover(id){
			scrolElement.hover(function() {
					clearInterval(id);
				},function(){
					id = setInterval(scrollUp, speed);
				});
		}
		//
		//开始滚动
		//
		function start(){
			id = setInterval(scrollUp,speed);
			hover(id);
		}
	}
});
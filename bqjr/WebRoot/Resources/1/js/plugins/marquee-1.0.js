/*********************************
 *����˵��������Ʋ��
 *���ڣ�2009/12/10
 *���ߣ�����
 *��ע��Ŀǰ��֧�����Ϲ���
 *********************************/

$.fn.extend({
	ScrollAction:function(speed,isSeries){
		var seHeight ;			//����Ԫ�صĸ߶�
		var parentHeight;		//��Ԫ�صĸ߶�
		var scrollHeight;		//�ѹ����߶�
		var timeID = '';		//��¼setInterval�ı��id
		var scrolElement = $(this);

		//ȡ�����ڵ㣬���ڵ�߶�
		sh = $(this).height();																						//scrollHeight
		ph = $(this).parent("div").height();															//parentHeight
		offsetTop = (!isSeries)?ph:4;																										//����ƫ����
		scrolElement.css('top',offsetTop);
		start();
		//
		//���Ϲ���
		//
		function scrollUp(){
			offsetTop --;
			if(!isSeries) {						//isSeries���������Ƿ�����������false��������true����
				if(offsetTop == -sh) {	//ƫ�Ƶ���Ԫ�ظ߶ȸ�ֵ��˵�������ˣ�������������ƫ����
					offsetTop = ph;
				};
			}else{
				if(offsetTop == -scrolElement.children().eq(0).height()) {	//��������
					firstItem = scrolElement.children().eq(0).remove();				//��¼�±�ɾ���Ľڵ�
					scrolElement.append(firstItem);														//��ӵ�β��
					offsetTop = 4;
				};
			};
			scrolElement.css({'top': offsetTop});
		};
		//
		//����¼�
		//
		function hover(id){
			scrolElement.hover(function() {
					clearInterval(id);
				},function(){
					id = setInterval(scrollUp, speed);
				});
		}
		//
		//��ʼ����
		//
		function start(){
			id = setInterval(scrollUp,speed);
			hover(id);
		}
	}
});
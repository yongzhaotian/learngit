
//
WorkFlowWorkSpace.build();

//
function init() {
	//
    var workFlow = new WorkFlow(Toolkit.getElementByID("designer"));

	//
    document.body.onbeforeunload = function () {
        if (workFlow.getWrapper().isChanged()) {
        	//���Թ�������ͼ�ı༭��δ���棬�뿪��ҳ�潫�˳�ϵͳ!
            window.event.returnValue = "\u60a8\u5bf9\u5de5\u4f5c\u6d41\u7a0b\u56fe\u7684\u7f16\u8f91\u5c1a\u672a\u4fdd\u5b58\uff0c\u79bb\u5f00\u8be5\u9875\u9762\u5c06\u9000\u51fa\u7cfb\u7edf!";
        }
    };

    //
    workFlow.getToolBar().setButtonEnable(false);

	//
    var searchStr = window.location.search;
    var params = searchStr.substring(searchStr.indexOf("?") + 1);
    var paramsArray = params.split("&");
    var name = null;
    for (var i = 0; i < paramsArray.size(); i++) {
        var tempStr = paramsArray.get(i);
        var key = tempStr.substring(0, tempStr.indexOf("=")).toLowerCase();
        var value = tempStr.substring(tempStr.indexOf("=") + 1);
        if (key == "name") {
            name = value;
            break;
        }
    }

    //
    if (name) {
        var getProcess = new GetProcess(workFlow.getWrapper(), workFlow.getTableViewer(), workFlow.getToolBar());
        getProcess.getProcess(name);
    } else {
    	//����Ҫ�༭�Ĺ�������ͼ����Ϊ�գ��޷����б༭��ϵͳ�Զ�ת�����ģʽ��
        alert("\u60a8\u6240\u8981\u7f16\u8f91\u7684\u5de5\u4f5c\u6d41\u7a0b\u56fe\u540d\u5b57\u4e3a\u7a7a\uff0c\u65e0\u6cd5\u8fdb\u884c\u7f16\u8f91\u3002\u7cfb\u7edf\u81ea\u52a8\u8f6c\u6210\u6dfb\u52a0\u6a21\u5f0f\u3002");
        document.title = "\u589e\u52a0";
        workFlow.getToolBar().setButtonEnable(true);
    }
}


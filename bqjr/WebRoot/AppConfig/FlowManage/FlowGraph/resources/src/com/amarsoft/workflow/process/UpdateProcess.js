
/**
 * <p>Title:  </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function UpdateProcess(wrapper, toolbar) {
    this.base = Ajax;
    this.base();
    this.wrapper = wrapper;
    this.toolbar = toolbar;
}
UpdateProcess.prototype = new Ajax();
UpdateProcess.prototype.setButtonEnable = function (b) {
    if (this.toolbar) {
        this.toolbar.setButtonEnable(b);
    }
};
UpdateProcess.prototype.updateProcess = function () {
    var model = this.wrapper.getModel();
    var name = model.getName();
    if (!name) {
        this.name = null;
    	//��������ͼ����Ϊ�գ�
        alert("\u5de5\u4f5c\u6d41\u7a0b\u56fe\u540d\u5b57\u4e3a\u7a7a\uff01");
        return false;
    }
    this.name = name;//add by ymqiao 20101227
    //
    this.setButtonEnable(false);

    //
    var doc = WorkFlowModelConverter.convertModelToXML(model);
    if (!doc) {
    	//����������ͼת����xmlʱ����
        alert("\u5c06\u5de5\u4f5c\u6d41\u7a0b\u56fe\u8f6c\u5316\u6210xml\u65f6\u51fa\u9519\uff01");
        this.setButtonEnable(true);
        return false;
    }

    //
    var url = WorkFlowWorkSpace.URL_UPDATE_PROCESS;
    var method = "POST";
    var params = "name=" + name;
    params += "&xml=" + doc.xml;

    //
    this.loadXMLHttpRequest(url, method, params);
};
UpdateProcess.prototype.onReadyStateChange = function (httpRequest) {
    if (httpRequest.readyState == 4) {
        if (httpRequest.status == 200) {
            this.processXMLHttpRequest(httpRequest);
        } else {
        	//������̳��ִ���
            alert("\u5904\u7406\u8fc7\u7a0b\u51fa\u73b0\u9519\u8bef\uff01");
            this.setButtonEnable(true);
        }
    }
};
UpdateProcess.prototype.processXMLHttpRequest = function (httpRequest) {
    var doc = httpRequest.responseXML;
    if (!doc) {
    	//����������δ֪��������������
        alert("\u64cd\u4f5c\u7ed3\u675f\uff0c\u672a\u77e5\u670d\u52a1\u5668\u5904\u7406\u7ed3\u679c\uff01");
        this.setButtonEnable(true);
        return false;
    }

    //
    var responseNode = doc.getElementsByTagName("Response")[0];
    var statusValue = eval(responseNode.getAttribute("status"));
    var alertStr = "";
    switch (statusValue) {
      case WorkFlowWorkSpace.STATUS_SUCCESS:
      	//���³ɹ���
        alertStr = "\u66f4\u65b0\u6210\u529f\u3002";
        this.wrapper.getModel().setName(this.name);
        this.wrapper.setChanged(false);
        break;
      case WorkFlowWorkSpace.STATUS_FAIL:
      	//����ʧ�ܡ�
        alertStr = "\u66f4\u65b0\u5931\u8d25\u3002";
        break;
      case WorkFlowWorkSpace.STATUS_XML_PARSER_ERROR:
      	//����ʧ�ܣ�xml��������
        alertStr = "\u66f4\u65b0\u5931\u8d25\uff0cxml\u89e3\u6790\u51fa\u9519\u3002";
        break;
      case WorkFlowWorkSpace.STATUS_FILE_NOT_FOUND:
      	//����ʧ�ܣ��ļ�δ�ҵ���ϵͳ�Զ�ת�����ģʽ��
        document.title = "\u589e\u52a0";
        alertStr = "\u66f4\u65b0\u5931\u8d25\uff0c\u6587\u4ef6\u672a\u627e\u5230\u3002\u7cfb\u7edf\u81ea\u52a8\u8f6c\u6210\u6dfb\u52a0\u6a21\u5f0f\u3002";
        break;
      case WorkFlowWorkSpace.STATUS_IO_ERROR:
      	//����ʧ�ܣ�IO����
        alertStr = "\u66f4\u65b0\u5931\u8d25\uff0cIO\u9519\u8bef\u3002";
        break;
      default:
        //����ʧ�ܣ�δ֪����
        alertStr = "\u66f4\u65b0\u5931\u8d25\uff0c\u672a\u77e5\u9519\u8bef\u3002";
        break;
    }
    this.setButtonEnable(true);
    alert(alertStr);
};


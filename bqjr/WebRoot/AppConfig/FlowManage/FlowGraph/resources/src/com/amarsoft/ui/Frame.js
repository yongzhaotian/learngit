
/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function Frame(ui) {
    this.base = Component;
    if (ui) {
        this.base(ui);
    } else {
        this.base(Toolkit.newLayer());
    }

    //
    this.contentTableUI = Toolkit.newTable();
    this.ui.appendChild(this.contentTableUI);
    this.contentTableUI.cellPadding = 0;
    this.contentTableUI.cellSpacing = 0;
    this.setClassName("NAME_XIO_UI_FONT NAME_XIO_UI_FRAME");
    this.contentTableUI.className = "NAME_XIO_UI_FONT NAME_XIO_UI_FRAME";
}
Frame.prototype = new Component();
Frame.prototype.toString = function () {
    return "[Component,Frame]";
};
/**
 * ��������
 * Ĭ��ʹ���в��֣�ÿ���һ��������������Ϊһ����ӣ�Ĭ���и�Ϊ���������ĸߡ�
 */
Frame.prototype.add = function (component) {
    var componentUI = component.getUI ? component.getUI() : component;
    var height = componentUI.height ? componentUI.height : componentUI.style.height;
    var row = this.contentTableUI.insertRow(-1);
    var cell = row.insertCell(-1);
    if (height) {
        cell.height = height;
    }
    cell.appendChild(componentUI);
    return row;
};



/**
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) amarsoft.com 2011</p>
 * @author
 */
function XMLDocument() {
}
XMLDocument.newDomcument = function () {
    if (window.ActiveXObject) {
        return new ActiveXObject("Microsoft.XMLDOM");
    } else {
        //alert("Your browser cannot handle this script");
    }
    //TODO firefox ...
};


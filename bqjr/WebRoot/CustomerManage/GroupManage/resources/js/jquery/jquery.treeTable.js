/* ==============================================
 * treeTable���
 * --------------------------------
 * @author syang
 * @date 2011/07/26
 * @describe 
 *  �˲����Դ�ڿ�ԴjQuery���treeTable
 *  2011/07/26�ڻ���֮ǰ����Ļ����Ͻ������ع� 
 * 
 *============================================== */
(function($) {
  var options = {};
  var defaultPaddingLeft=null;

  $.fn.treeTable = function(opts) {
    //Ĭ������
    var defaults = {
            childPrefix: "child-of-",
            clickableNodeNames: false,
            expandable: true,
            indent: 19,
            initialState: "collapsed",
            treeColumn: 0
          };
    options = $.extend(defaults, opts);  //Ӧ�ò���
    return this.each(function() {
      $(this).addClass("treeTable").find("tbody tr").each(function() {
        //�����������£�ֻ��ʼ�����ڵ�
        if(!options.expandable || $(this)[0].className.search(options.childPrefix) == -1) {
          // To optimize performance of indentation, I retrieve the padding-left
          // value of the first root node. This way I only have to call +css+
          // once.
          if (!defaultPaddingLeft) {
            defaultPaddingLeft = parseInt($($(this).children("td")[options.treeColumn]).css('padding-left'), 10);
          }
          initialize($(this));
        } else if(options.initialState == "collapsed") {
          this.style.display = "none"; // ��ס! ʹ��$(this).hide()������£����н���
        }
      });
    });
  };

  // ����ǰ�ڵ�
  $.fn.collapse = function() {
	if($(this).hasClass("parent")&&!$(this).hasClass("collapsed")){
		$(this).addClass("collapsed");
	}

    childrenOf($(this)).each(function() {
      if($(this).hasClass("parent")&&!$(this).hasClass("collapsed")) {
        $(this).collapse();
      }
      $(this).hide();
    });

    return this;
  };

  // չ����ǰ�ڵ�
  $.fn.expand = function() {
    if($(this).is(".parent")){
    	$(this).removeClass("collapsed").addClass("expanded");
    }

    childrenOf($(this)).each(function() {
        initialize($(this));
        if($(this).is(".expanded.parent")) {
            $(this).expand();
        }
        if(!$(this).attr("hidden"))$(this).show();
    });
    return this;
  };

  //�ҳ��������Ƚڵ�
  $.fn.ancestors = function(){
	  return ancestorsOf($(this));
  };
  //�ѵ�ǰ�ڵ������destination�ڵ��£���Ϊ����һ����֧
  $.fn.appendBranchTo = function(destination) {
    var node = $(this);
    var parent = parentOf(node);

    var ancestorNames = $.map(ancestorsOf($(destination)), function(a) {return a.id;});

    if($.inArray(node[0].id, ancestorNames) == -1 && (!parent || (destination.id != parent[0].id)) && destination.id != node[0].id) {
      indent(node, ancestorsOf(node).length * options.indent * -1); // Remove indentation

      if(parent) {node.removeClass(options.childPrefix + parent[0].id);}

      node.addClass(options.childPrefix + destination.id);
      move(node, destination); // Recursively move nodes to new location
      indent(node, ancestorsOf(node).length * options.indent);
    }

    return this;
  };
  //�ѵ�ǰ(�½�)�ڵ������destination�ڵ��£���Ϊ����һ����֧
  $.fn.appendNewBranchTo = function(destination){
    var node = $(this);
    var parent = parentOf(node);
    if(parent) node.removeClass(options.childPrefix + parent[0].id);
    node.addClass(options.childPrefix + destination[0].id);
    node.removeClass("initialized parent expanded");
    
    node.insertAfter(destination);
    initialize($(destination).removeClass("initialized").addClass("expanded"));
    return node;
  };
  //�Ƴ�һ����֧
  $.fn.removeBranch = function(){
      var branch = $(this);
      var parent = parentOf(branch);
      branch.progeny().each(function(){
          $(this).remove();
      });
      branch.remove();
      //���¼��㸸�ڵ�
      if(parent!=null&&parent.size()>0){
          parent.removeClass("initialized parent expanded collapsed");
          initialize(parent);
      }
      return branch;
  };
  //�ѵ�ǰ�ڵ���½ڵ�
  $.fn.parent = function(){
      return parentOf($(this));
  },
  // ��ȡ��������㣬������������
  $.fn.progeny = function (){
    var childrenCollection = [];
    var rowContext = $(this);
    var tbody = $(this).parents("tbody");
    var children = $("tr.child-of-"+rowContext.attr("id"),tbody);
    if(children.size()>0){
        children.each(function(){
            childrenCollection.push($(this));
            var sub = $(this).progeny();
            for(var i=0;i<sub.length;i++){
                childrenCollection.push(sub[i]);
            }
        });
    }
    return $(childrenCollection);
  };  
  // Add reverse() function from JS Arrays
  $.fn.reverse = function() {
    return this.pushStack(this.get().reverse(), arguments);
  };

  // Toggle an entire branch
  $.fn.toggleBranch = function() {
    if($(this).hasClass("collapsed")) {
      $(this).expand();
    } else {
      $(this).removeClass("expanded").collapse();
    }

    return this;
  };

  //��node�ڵ㿪ʼ���ϻ��ݣ��ҵ��������Ƚڵ㣬�������飬�����������δ���ɵͱ����߱��Ľڵ�
  function ancestorsOf(node) {
    var ancestors = [];
    while(node = parentOf(node)) {
      ancestors[ancestors.length] = node[0];
    }
    return ancestors;
  };
  //ȡnode�ڵ���ӽڵ��б�
  function childrenOf(node) {
    var tbody = node.parents("tbody");
    return $("tr." + options.childPrefix + node[0].id,tbody);
  };
  //����node�ڵ�paddingLeft
  function getPaddingLeft(node) {
    var paddingLeft = parseInt(node[0].style.paddingLeft, 10);
    return (isNaN(paddingLeft)) ? defaultPaddingLeft : paddingLeft;
  }
  //����node�ڵ��ƫ����,valueΪ����λ�ã��̶�ֵ��
  function indent(node, value) {
    var cell = $(node.children("td")[options.treeColumn]);
    cell[0].style.paddingLeft = getPaddingLeft(cell) + value + "px";

    childrenOf(node).each(function() {
      indent($(this), value);
    });
  };
  //���ĺ�����ִ�г�ʼ��treeTable
  function initialize(node) {
    if(!node.hasClass("initialized")) {
      node.addClass("initialized");

      var childNodes = childrenOf(node);

      if(!node.hasClass("parent") && childNodes.length > 0) {
        node.addClass("parent");
      }

      var cell = $(node.children("td")[options.treeColumn]);
      if($("span.icon",cell).size()==0)cell.prepend('<span class="icon"></span>');
      if(node.hasClass("parent")) {
        var padding = getPaddingLeft(cell) + options.indent;
        childNodes.each(function() {
          $(this).children("td")[options.treeColumn].style.paddingLeft = padding + "px";
        });

        if(options.expandable) {
          var expander = $('<span style="margin-left: -' + options.indent + 'px; padding-left: ' + options.indent + 'px" class="expander"></span>');
          cell.prepend(expander);
          expander.hover(function(){
        	  $(this).addClass("hover");
          },function(){
        	  $(this).removeClass("hover");
          });
          $(cell[0].firstChild).click(function() {node.toggleBranch();});

          if(options.clickableNodeNames) {
            cell[0].style.cursor = "pointer";
            $(cell).click(function(e) {
              // Don't double-toggle if the click is on the existing expander icon
              if (e.target.className != 'expander') node.toggleBranch();
            });
          }

          // Check for a class set explicitly by the user, otherwise set the default class
          if(!(node.hasClass("expanded") || node.hasClass("collapsed"))) node.addClass(options.initialState);
          if(node.hasClass("expanded")) node.expand();
        }
      }
    }
  };
  //��node�ڵ�����destination֮��
  function move(node, destination) {
    node.insertAfter(destination);
    childrenOf(node).reverse().each(function() {move($(this), node[0]);});
  };
  //ȡnode�ڵ�ĸ��ڵ�
  function parentOf(node) {
    var classNames = node[0].className.split(' ');
    for(var i=0;i<classNames.length;i++) {
      var className = classNames[i];
      if(className.match(options.childPrefix)) {
        return $("#" + className.substring(options.childPrefix.length));
      }
    }
  };
})(jQuery);
/* ==============================================
 * treeTable插件
 * --------------------------------
 * @author syang
 * @date 2011/07/26
 * @describe 
 *  此插件来源于开源jQuery插件treeTable
 *  2011/07/26在基于之前代码的基础上进行了重构 
 * 
 *============================================== */
(function($) {
  var options = {};
  var defaultPaddingLeft=null;

  $.fn.treeTable = function(opts) {
    //默认设置
    var defaults = {
            childPrefix: "child-of-",
            clickableNodeNames: false,
            expandable: true,
            indent: 19,
            initialState: "collapsed",
            treeColumn: 0
          };
    options = $.extend(defaults, opts);  //应用参数
    return this.each(function() {
      $(this).addClass("treeTable").find("tbody tr").each(function() {
        //在允许的情况下，只初始化根节点
        if(!options.expandable || $(this)[0].className.search(options.childPrefix) == -1) {
          // To optimize performance of indentation, I retrieve the padding-left
          // value of the first root node. This way I only have to call +css+
          // once.
          if (!defaultPaddingLeft) {
            defaultPaddingLeft = parseInt($($(this).children("td")[options.treeColumn]).css('padding-left'), 10);
          }
          initialize($(this));
        } else if(options.initialState == "collapsed") {
          this.style.display = "none"; // 记住! 使用$(this).hide()相比这下，运行较慢
        }
      });
    });
  };

  // 收起当前节点
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

  // 展开当前节点
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

  //找出所有祖先节点
  $.fn.ancestors = function(){
	  return ancestorsOf($(this));
  };
  //把当前节点添加至destination节点下，作为它的一个分支
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
  //把当前(新节)节点添加至destination节点下，作为它的一个分支
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
  //移除一个分支
  $.fn.removeBranch = function(){
      var branch = $(this);
      var parent = parentOf(branch);
      branch.progeny().each(function(){
          $(this).remove();
      });
      branch.remove();
      //重新计算父节点
      if(parent!=null&&parent.size()>0){
          parent.removeClass("initialized parent expanded collapsed");
          initialize(parent);
      }
      return branch;
  };
  //把当前节点的新节点
  $.fn.parent = function(){
      return parentOf($(this));
  },
  // 获取所有子孙点，由上至下排列
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

  //从node节点开始往上回溯，找到所有祖先节点，返回数组，数组数据依次存放由低辈至高辈的节点
  function ancestorsOf(node) {
    var ancestors = [];
    while(node = parentOf(node)) {
      ancestors[ancestors.length] = node[0];
    }
    return ancestors;
  };
  //取node节点的子节点列表
  function childrenOf(node) {
    var tbody = node.parents("tbody");
    return $("tr." + options.childPrefix + node[0].id,tbody);
  };
  //计算node节点paddingLeft
  function getPaddingLeft(node) {
    var paddingLeft = parseInt(node[0].style.paddingLeft, 10);
    return (isNaN(paddingLeft)) ? defaultPaddingLeft : paddingLeft;
  }
  //计算node节点的偏移量,value为基础位置（固定值）
  function indent(node, value) {
    var cell = $(node.children("td")[options.treeColumn]);
    cell[0].style.paddingLeft = getPaddingLeft(cell) + value + "px";

    childrenOf(node).each(function() {
      indent($(this), value);
    });
  };
  //核心函数，执行初始化treeTable
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
  //把node节点移至destination之下
  function move(node, destination) {
    node.insertAfter(destination);
    childrenOf(node).reverse().each(function() {move($(this), node[0]);});
  };
  //取node节点的父节点
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
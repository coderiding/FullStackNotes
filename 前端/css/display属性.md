https://www.jianshu.com/p/65f99387fa5f

display:none 把 display 设置成 none 不会保留元素本该显示的空间，但是 visibility: hidden;还会保留
display:none 通常被 JavaScript 用来在不删除元素的情况下隐藏或显示元素

/* CSS 1 */
display: none;
display: inline; 行内元素
display: block;  块级元素
display: list-item;  此元素会作为列表显示。

/* CSS 2.1 */
display: inline-block; 行内块元素

display: table;
display: inline-table;
display: table-cell;
display: table-column;
display: table-column-group;
display: table-footer-group;
display: table-header-group;
display: table-row;
display: table-row-group;
display: table-caption;
/* CSS 2.1 */

/* CSS 3 */
display: inline-list-item;
display: flex;
display: box;
display: inline-flex;

display: grid;
display: inline-grid;

display: ruby;
display: ruby-base;
display: ruby-text;
display: ruby-base-container;
display: ruby-text-container;
/* CSS 3 */

/* Experimental values */
display: contents;
display: run-in; 此元素会根据上下文作为块级元素或内联元素显示。
/* Experimental values */

/* Global values */
display: inherit;
display: initial;
display: unset;


---
以下属性是实验性质的，支持度都很低，不建议使用，知道就行。

* run-in: 此元素会根据上下文作为块级元素或内联元素显示；
* grid: 栅格模型，类似block
* inline-grid: 栅格模型，类似inline-block
* ruby, ruby-base, ruby-text, ruby-base-container, ruby-text-container
* contents


参考
https://segmentfault.com/a/1190000006047872  https://app.yinxiang.com/shard/s35/nl/9757212/5c30e6ef-a06e-4bf7-a441-f8f92b8d7230 
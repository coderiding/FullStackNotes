https://developer.mozilla.org/zh-CN/docs/Web/CSS/text-decoration

text-decoration 这个 CSS 属性是用于设置文本的修饰线外观的（下划线、上划线、贯穿线/删除线  或 闪烁）它是 text-decoration-line, text-decoration-color, text-decoration-style, 和新出现的 text-decoration-thickness 属性的缩写。

---
组合的值，多个效果写在一起
```css
.under {
  text-decoration: underline red;
}

.over {
  text-decoration: wavy overline lime;
}

.line {
  text-decoration: line-through;
}

.plain {
  text-decoration: none;
}

.underover {
  text-decoration: dashed underline overline;
}

.blink {
  text-decoration: blink;
}
```


text-decoration-line
文本修饰的位置, 如下划线underline，删除线line-through

text-decoration-color
文本修饰的颜色

text-decoration-style
文本修饰的样式, 如波浪线wavy实线solid虚线dashed

text-decoration-thickness
文本修饰线的粗细
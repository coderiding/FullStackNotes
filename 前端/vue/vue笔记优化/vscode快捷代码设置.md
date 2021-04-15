https://segmentfault.com/a/1190000014653201

打开编辑器，点击文件 —— 首选项 —— 用户代码片段，会弹出来一个输入框。

在输入框输入vue，回车，会打开一个vue.json文件。

模板内容可按自己的喜好自行修改。

然后新建一个.vue文件，输入vue然后按tab键。

```
{
  "Print to console": {
      "prefix": "vue",
      "body": [
          "<template>",
          "  <div class=\"container\">\n",
          "  </div>",
          "</template>\n",
          "<script>",
          "export default {",
          "  data() {",
          "    return {\n",
          "    }",
          "  },",
          "  components: {\n",
          "  }",
          "}",
          "</script>\n",
          "<style scoped lang=\"scss\">\n",
          "</style>",
          "$2"
      ],
      "description": "Log output to console"
  }
}
```
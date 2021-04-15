vue-style-loader 是基于 style-loader 的，与 style-loader 相似，你可以链式的加在 css-loader 后面，通过 <style> 标签动态的将 css 注入到 document 中。因为它会作为一个内置的依赖被vue-loader 使用，所以通常你不需要自己手动的配置它。
但是如果要支持 Vue SSR 的话，你最好使用 vue-style-loader。当我们以 node 为 target 打包，所有渲染的组件里的 样式会被收集起来并且以 context.styles 暴露给 Vue render context。这样你就可以简单的把样式插入到 <head> 标签中了。
 
A：标准base64可参考wiki文档实现。对于使用PHP语言的开发者，可以直接使用base64_encode/base64_decode内置函数实现。

判断base64是否符合要求，可以参考下述2种方式进行。

对比PHP的base64_encode内置函数的输出结果，如果一致，说明是正确的。
<?php
// 输出/path/to/data文件的base64编码结果
$data = file_get_contents('/path/to/data');
echo base64_encode($data);
?>
对比Linux的base64内置工具的输出结果，如果一致，说明是正确的。
$ ## 输出/path/to/data的base64编码结果
$ base64 -w0 /path/to/data
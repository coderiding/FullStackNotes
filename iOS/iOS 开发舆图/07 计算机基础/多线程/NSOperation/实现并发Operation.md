必须实现的步骤是

重写isConcurrent函数, 返回YES, 这个告诉系统各单位注意了我这个operation是要并发的.

重写start()函数.

重写isExecuting和isFinished函数
# Android面试

##### 34.组件化原理
* 参考回答：
* 引入组件化的原因：项目随着需求的增加规模变得越来越大，规模的增大导致了各种业务错中复杂的交织在一起, 每个业务模块之间，代码没有约束，带来了代码边界的模糊，代码冲突时有发生, 更改一个小问题可能引起一些新的问题, 牵一发而动全身，增加一个新需求，需要熟悉相关的代码逻辑，增加开发时间
* 避免重复造轮子，可以节省开发和维护的成本。
* 可以通过组件和模块为业务基准合理地安排人力，提高开发效率。
* 不同的项目可以共用一个组件或模块，确保整体技术方案的统一性。
* 为未来插件化共用同一套底层模型做准备。
* 组件化开发流程就是把一个功能完整的App或模块拆分成多个子模块（Module），每个子模块可以独立编译运行，也可以任意组合成另一个新的 App或模块，每个模块即不相互依赖但又可以相互交互，但是最终发布的时候是将这些组件合并统一成一个apk，遇到某些特殊情况甚至可以升级或者降级
* App是主application，ModuleA和ModuleB是两个业务模块（相对独立，互不影响），Library是基础模块，包含所有模块需要的依赖库，以及一些工具类：如网络访问、时间工具等
* 注意：提供给各业务模块的基础组件，需要根据具体情况拆分成 aar 或者 library，像登录，基础网络层这样较为稳定的组件，一般直接打包成 aar，减少编译耗时。而像自定义 View 组件，由于随着版本迭代会有较多变化，就直接以源码形式抽离成 Library

##### 33.插件化原理分析

参考回答：

* 插件化是指将 APK 分为宿主和插件的部分。把需要实现的模块或功能当做一个独立的提取出来，在 APP 运行时，我们可以动态的载入或者替换插件部分，减少宿主的规模
* 宿主： 就是当前运行的APP。
* 插件： 相对于插件化技术来说，就是要加载运行的apk类文件。
* 而热修复则是从修复bug的角度出发，强调的是在不需要二次安装应用的前提下修复已知的bug。能
* [外链图片转存失败(img-hsLkqr1O-1565963215425)(https://upload-images.jianshu.io/upload_images/16595031-1e588c91db34ddc2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)]

---

* 类加载机制
* Android中常用的两种类加载器，DexClassLoader和PathClassLoader，它们都继承于BaseDexClassLoader，两者区别在于PathClassLoader只能加载内部存储目录的dex/jar/apk文件。DexClassLoader支持加载指定目录(不限于内部)的dex/jar/apk文件
* 插件通信：通过给插件apk生成相应的DexClassLoader便可以访问其中的类，可分为单DexClassLoader和多DexClassLoader两种结构。
* 若使用多ClassLoader机制，主工程引用插件中类需要先通过插件的ClassLoader加载该类再通过反射调用其方法。插件化框架一般会通过统一的入口去管理对各个插件中类的访问，并且做一定的限制。
* 若使用单ClassLoader机制，主工程则可以直接通过类名去访问插件中的类。该方式有个弊端，若两个不同的插件工程引用了一个库的不同版本，则程序可能会出错

---

* 资源加载
* 原理在于通过反射将插件apk的路径加入AssetManager中并创建Resource对象加载资源，有两种处理方式：
* 合并式：addAssetPath时加入所有插件和主工程的路径；由于AssetManager中加入了所有插件和主工程的路径，因此生成的Resource可以同时访问插件和主工程的资源。但是由于主工程和各个插件都是独立编译的，生成的资源id会存在相同的情况，在访问时会产生资源冲突。
* 独立式：各个插件只添加自己apk路径，各个插件的资源是互相隔离的，不过如果想要实现资源的共享，必须拿到对应的Resource对象。

##### 32.如何通过Gradle配置多渠道包？

* 参考回答：
* 首先要了解设置多渠道的原因。在安装包中添加不同的标识，配合自动化埋点，应用在请求网络的时候携带渠道信息，方便后台做运营统计，比如说统计我们的应用在不同应用市场的下载量等信息
* 这里以友盟统计为例
	* 首先在manifest.xml文件中设置动态渠道变量：
	* 接着在app目录下的build.gradle中配置productFlavors，也就是配置打包的渠道：
	* 最后在编辑器下方的Teminal输出命令行
		* 执行./gradlew assembleRelease ，将会打出所有渠道的release包；
		* 执行./gradlew assembleVIVO，将会打出VIVO渠道的release和debug版的包；
		* 执行./gradlew assembleVIVORelease将生成VIVO的release包。

##### 31.Apk的大小如何压缩 ？

* 参考回答：
* 3.1一个完整APK包含以下目录（将APK文件拖到Android Studio）：

* META-INF/：包含CERT.SF和CERT.RSA签名文件以及MANIFEST.MF 清单文件。
* assets/：包含应用可以使用AssetManager对象检索的应用资源。
* res/：包含未编译到的资源 resources.arsc。
* lib/：包含特定于处理器软件层的编译代码。该目录包含了每种平台的子目录，像armeabi，armeabi-v7a， arm64-v8a，x86，x86_64，和mips
* resources.arsc：包含已编译的资源。该文件包含res/values/ 文件夹所有配置中的XML内容。打包工具提取此XML内容，将其编译为二进制格式，并将内容归档。此内容包括语言字符串和样式，以及直接包含在*resources.arsc8文件中的内容路径 ，例如布局文件和图像。
* classes.dex：包含以Dalvik / ART虚拟机可理解的DEX文件格式编译的类。
* AndroidManifest.xml：包含核心Android清单文件。该文件列出应用程序的名称，版本，访问权限和引用的库文件。该文件使用Android的二进制XML格式。
* lib、class.dex和res占用了超过90%的空间，所以这三块是优化Apk大小的重点（实际情况不唯一）

---

* 3.2 减少res，压缩图文文件
* 图片文件压缩是针对jpg和png格式的图片。我们通常会放置多套不同分辨率的图片以适配不同的屏幕，这里可以进行适当的删减。在实际使用中，只保留一到两套就足够了（保留一套的话建议保留xxhdpi，两套的话就加上hdpi），然后再对剩余的图片进行压缩(jpg采用优图压缩，png尝试采用pngquant压缩)

---

* 3.3.减少dex文件大小
* 添加资源混淆
* shrinkResources为true表示移除未引用资源，和代码压缩协同工作。
* minifyEnabled为true表示通过ProGuard启用代码压缩，配合proguardFiles的配置对代码进行混淆并移除未使用的代码。
* 代码混淆在压缩apk的同时，也提升了安全性。

---

* 3.4.减少lib文件大小
* 由于引用了很多第三方库，lib文件夹占用的空间通常都很大，特别是有so库的情况下。很多so库会同时引入armeabi、armeabi-v7a和x86这几种类型，这里可以只保留armeabi或armeabi-v7a的其中一个就可以了，实际上微信等主流app都是这么做的。
* 只需在build.gradle直接配置即可，NDK配置同理

##### 30.Android中如何查看一个对象的回收情况 ？

* 参考回答：
* 首先要了解Java四种引用类型的场景和使用（强引用、软引用、弱引用、虛引用）
* 举个场景例子：SoftReference对象是用来保存软引用的，但它同时也是一个Java对象，所以当软引用对象被回收之后，虽然这个SoftReference对象的get方法返回null，但SoftReference对象本身并不是null，而此时这个SoftReference对象已经不再具有存在的价值，需要一个适当的清除机制，避免大量SoftReference对象带来的内存泄露
* 因此，Java提供ReferenceQueue来处理引用对象的回收情况。当SoftReference所引用的对象被GC后，JVM会先将softReference对象添加到ReferenceQueue这个队列中。当我们调用ReferenceQueue的poll()方法，如果这个队列中不是空队列，那么将返回并移除前面添加的那个Reference对象。

##### 29.如何进行单元测试，如何保证App稳定 ？

* 参考回答：
* 要测试Android应用程序，通常会创建以下类型自动单元测试
* 本地测试：只在本地机器JVM上运行，以最小化执行时间，这种单元测试不依赖于Android框架，或者即使有依赖，也很方便使用模拟框架来模拟依赖，以达到隔离Android依赖的目的，模拟框架如Google推荐的Mockito；
* 检测测试：真机或模拟器上运行的单元测试，由于需要跑到设备上，比较慢，这些测试可以访问仪器（Android系统）信息，比如被测应用程序的上下文，一般地，依赖不太方便通过模拟框架模拟时采用这种方式；
* 注意：单元测试不适合测试复杂的UI交互事件
* App的稳定主要决定于整体的系统架构设计，同时也不可忽略代码编程的细节规范，正所谓“千里之堤，溃于蚁穴”，一旦考虑不周，看似无关紧要的代码片段可能会带来整体软件系统的崩溃，所以上线之前除了自己本地化测试之外还需要进行Monkey压力测试
* 少部分面试官可能会延伸，如Gradle自动化测试、机型适配测试等

##### 28.ContentProvider了解多少？
* 参考回答：
* ContentProvider作为四大组件之一，其主要负责存储和共享数据。与文件存储、SharedPreferences存储、SQLite数据库存储这几种数据存储方法不同的是，后者保存下的数据只能被该应用程序使用，而前者可以让不同应用程序之间进行数据共享，它还可以选择只对哪一部分数据进行共享，从而保证程序中的隐私数据不会有泄漏风险。

##### 27.广播有几种形式 ? 都有什么特点 ？

* 参考回答：
* 普通广播：开发者自身定义 intent的广播（最常用），所有的广播接收器几乎会在同一时刻接受到此广播信息，接受的先后顺序随机；
* 有序广播：发送出去的广播被广播接收者按照先后顺序接收，同一时刻只会有一个广播接收器能够收到这条广播消息，当这个广播接收器中的逻辑执行完毕后，广播才会继续传递，且优先级（priority）高的广播接收器会先收到广播消息。有序广播可以被接收器截断使得后面的接收器无法收到它；
* 本地广播：仅在自己的应用内发送接收广播，也就是只有自己的应用能收到，数据更加安全，效率更高，但只能采用动态注册的方式；
* 粘性广播：这种广播会一直滞留，当有匹配该广播的接收器被注册后，该接收器就会收到此条广播；

##### 26.谈一谈Service的生命周期？

* 参考回答：Service的生命周期涉及到六大方法
* onCreate()：如果service没被创建过，调用startService()后会执行onCreate()回调；如果service已处于运行中，调用startService()不会执行onCreate()方法。也就是说，onCreate()只会在第一次创建service时候调用，多次执行startService()不会重复调用onCreate()，此方法适合完成一些初始化工作；
* onStartComand()：服务启动时调用，此方法适合完成一些数据加载工作，比如会在此处创建一个线程用于下载数据或播放音乐；
* onBind()：服务被绑定时调用；
* onUnBind()：服务被解绑时调用；
* onDestroy()：服务停止时调用；

##### 25.谈一谈Fragment的生命周期？

* 参考回答：
* Fragment从创建到销毁整个生命周期中涉及到的方法依次为：onAttach()→onCreate()→ onCreateView()→onActivityCreated()→onStart()→onResume()→onPause()→onStop()→onDestroyView()→onDestroy()→onDetach()，其中和Activity有不少名称相同作用相似的方法，而不同的方法有:
* onAttach()：当Fragment和Activity建立关联时调用；
* onCreateView()：当fragment创建视图调用，在onCreate之后；
* onActivityCreated()：当与Fragment相关联的Activity完成onCreate()之后调用；
* onDestroyView()：在Fragment中的布局被移除时调用；
* onDetach()：当Fragment和Activity解除关联时调用；

##### 24.说下Activity生命周期 ？

* 参考解答：在正常情况下，Activity的常用生命周期就只有如下7个
* onCreate()：表示Activity正在被创建，常用来初始化工作，比如调用setContentView加载界面布局资源，初始化Activity所需数据等；
* onRestart()：表示Activity正在重新启动，一般情况下，当前Acitivty从不可见重新变为可见时，OnRestart就会被调用；
* onStart()：表示Activity正在被启动，此时Activity可见但不在前台，还处于后台，无法与用户交互；
* onResume()：表示Activity获得焦点，此时Activity可见且在前台并开始活动，这是与onStart的区别所在；
* onPause()：表示Activity正在停止，此时可做一些存储数据、停止动画等工作，但是不能太耗时，因为这会影响到新Activity的显示，onPause必须先执行完，新Activity的onResume才会执行；
* onStop()：表示Activity即将停止，可以做一些稍微重量级的回收工作，比如注销广播接收器、关闭网络连接等，同样不能太耗时；
* onDestroy()：表示Activity即将被销毁，这是Activity生命周期中的最后一个回调，常做回收工作、资源释放；
* 延伸：从整个生命周期来看，onCreate和onDestroy是配对的，分别标识着Activity的创建和销毁，并且只可能有一次调用；
* 从Activity是否可见来说，onStart和onStop是配对的，这两个方法可能被调用多次；
* 从Activity是否在前台来说，onResume和onPause是配对的，这两个方法可能被调用多次；
* 除了这种区别，在实际使用中没有其他明显区别；

##### 23.跨组件通信

* 参考回答：
* 跨组件通信场景：
* 第一种是组件之间的页面跳转 (Activity 到 Activity, Fragment 到 Fragment, Activity 到 Fragment, Fragment 到 Activity) 以及跳转时的数据传递 (基础数据类型和可序列化的自定义类类型)。
* 第二种是组件之间的自定义类和自定义方法的调用(组件向外提供服务)。

---

* 跨组件通信方案分析：
* 第一种组件之间的页面跳转实现简单，跳转时想传递不同类型的数据提供有相应的 API即可
* 第二种组件之间的自定义类和自定义方法的调用要稍微复杂点，需要 ARouter 配合架构中的 公共服务(CommonService) 实现：
* 提供服务的业务模块：
* 在公共服务(CommonService) 中声明 Service 接口 (含有需要被调用的自定义方法), 然后在自己的模块中实现这个 Service 接口, 再通过 ARouter API 暴露实现类。
* 使用服务的业务模块：
* 通过 ARouter 的 API 拿到这个 Service 接口(多态持有, 实际持有实现类), 即可调用 Service 接口中声明的自定义方法, 这样就可以达到模块之间的交互。
* 此外，可以使用 AndroidEventBus 其独有的 Tag, 可以在开发时更容易定位发送事件和接受事件的代码, 如果以组件名来作为 Tag 的前缀进行分组, 也可以更好的统一管理和查看每个组件的事件, 当然也不建议大家过多使用 EventBus。

---

* 如何管理过多的路由表？
* RouterHub 存在于基础库, 可以被看作是所有组件都需要遵守的通讯协议, 里面不仅可以放路由地址常量, 还可以放跨组件传递数据时命名的各种 Key 值, 再配以适当注释, 任何组件开发人员不需要事先沟通只要依赖了这个协议, 就知道了各自该怎样协同工作, 既提高了效率又降低了出错风险, 约定的东西自然要比口头上说强
* Tips: 如果您觉得把每个路由地址都写在基础库的 RouterHub 中, 太麻烦了, 也可以在每个组件内部建立一个私有 RouterHub, 将不需要跨组件的路由地址放入私有 RouterHub 中管理, 只将需要跨组件的路由地址放入基础库的公有 RouterHub 中管理, 如果您不需要集中管理所有路由地址的话, 这也是比较推荐的一种方式。

##### 22.ARouter路由原理：
* ARouter维护了一个路由表Warehouse，其中保存着全部的模块跳转关系，ARouter路由跳转实际上还是调用了startActivity的跳转，使用了原生的Framework机制，只是通过apt注解的形式制造出跳转规则，并人为地拦截跳转和设置跳转条件

##### 21.ThreadLocal的理解

* 可以保证线程的安全。在多个线程共享相同的数据的时候，会为每个线程创建单独的副本，在单独的副本上进行数据的操作，不会对其它线程的数据产生影响，保证了线程安全。

##### 20.HashMap HashSet HashTable的区别？

* 都是集合，底层都是Hash算法实现的。HashMap是Hashtable的替代品，这两个都是双列集合，而HashSet是单列集合。HashMap线程不安全、效率高、可以存储null键和null值；Hashtable线程安全，效率低，不可以存储null键和null值。

##### 19.如何让HashMap可以线程安全？
* HashMap 在并发执行 put 操作时会引起死循环，导致 CPU 利用率接近100%。因为多线程会导致 HashMap 的 Node 链表形成环形数据结构，一旦形成环形数据结构，Node 的 next 节点永远不为空，就会在获取 Node 时产生死循环。
* 使用下面三种替换方式：
* Hashtable
* ConcurrentHashMap
* Synchronized Map

##### 18.Android对HashMap做了优化后推出的新的容器类是什么？
* SparseArray
* 它要比 HashMap 节省内存，某些情况下比HashMap性能更好，按照官方问答的解释，主要是因为SparseArray不需要对key和value进行auto-boxing（将原始类型封装为对象类型，比如把int类型封装成Integer类型），结构比HashMap简单（SparseArray内部主要使用两个一维数组来保存数据，一个用来存key，一个用来存value）不需要额外的额外的数据结构（主要是针对HashMap中的HashMapEntry而言的）。

##### 17.Java多线程之间如何通信
* 等待唤醒机制

##### 16.线程池的实现机制
* 向线程池提交任务，会依次启动核心线程，如果提交的任务数超过了核心线程数，会将任务保存到阻塞队列中，如果阻塞队列也满了，且继续提交任务，则会创建新线程执行任务，直到任务数达到最大线程数。此时如果再提交任务的话会抛出异常或者直接丢弃任务。通过Executor.execute()无法得到返回值，通过ExecutorService.submit()可以得到返回值。

##### 15.RxJava中map和flatmap操作符的区别及底层实现
* Map返回的是结果集，flatmap返回的是包含结果集的Observable。Map只能一对一，flatmap可以一对多、多对多。
* RxJava是通过观察者模式实现的。

##### 14.对消息机制中Looper的理解
* Looper在消息机制中扮演的角色是创造无限循环从Messagequeue中取得消息然后分发。

##### 13.单例模式有哪些实现方式
* 饿汉模式(线程安全，调用效率高，但是不能延时加载)
* 懒汉模式(线程安全，调用效率不高，但是能延时加载)
* 双重检测锁模式(由于JVM底层模型原因，偶尔会出问题，不建议使用)
* 静态内部类式(线程安全，调用效率高，可以延时加载)
* 枚举类(线程安全，调用效率高，不能延时加载，可以天然的防止反射和反序列化调用)

##### 12.通过静态内部类实现单例模式有哪些优点
* 线程安全，调用效率高，可以延时加载

##### 11.synchronized volatile关键字有什么区别？以及还有哪些同样功能的关键字
* (1) volatile是变量修饰符，而synchronized则作用于一段代码或者方法。
* (2) volatile只是在线程内存和main memory(主内存)间同步某个变量的值；而synchronized通过锁定和解锁某个监视器同步所有变量的值。显然synchronized要比volatile消耗更多资源。
* const、final、lock

##### 10.界面卡顿的原因有哪些？
* UI线程(main)有耗时操作
* 视图渲染时间过长，导致卡顿

##### 9.造成OOM/ANR 的原因？
* OOM: （1）不恰当地使用static关键字 （2）内部类对Activity的引用 （3）大量Bitmap的使用会导致程序包运行时的内存消耗变大 （4）游标Cursor对象用完应该及时关闭 （5）加载对象过大 （6）相应资源过多，来不及释放。
* ANR: （1）在5秒内没有响应输入的事件(IO操作耗时、数据库操作复杂耗时、主线程非主线程产生死锁等待、网络加载/图片操作耗时、硬件操作耗时) （2）BroadcastReceiver在10秒内没有执行完毕(Service binder数量达到上限、Service忙导致超时无响应)

##### 8.Glide三级缓存
* 内存缓存，磁盘缓存、网络缓存（由于网络缓存严格来说不算是缓存的一种，故也称为二级缓存）。缓存的资源分为两种：原图(SOURCE)、处理图(RESULT)（默认）。
* 内存缓存：默认开启的，可以通过调用skipMemoryCache(true)来设置跳过内存缓存，缓存最大空间：每个进程可用的最大内存*0.4。（低配手机0.33）
* 磁盘缓存：分为四种：ALL(缓存原图)、NONE(什么都不缓存)、SOURCE(只缓存原图)、RESULT(之后处理图)，通过diskCacheStrategy(DiskCacheStrategy.ALL)来设置，缓存大小250M。

##### 7.数据库的操作类型有哪些，如何导入外部数据库？
* (1) 增删改查
* (2) 将外部数据库放在项目的res/raw目录下。因为安卓系统下数据库要放在data/data/packagename/databases的目录下,然后要做的就是将外部数据库导入到该目录下，操作方法是通过FileInputStream读取外部数据库，再用FileOutputStrean把读取到的东西写入到该目录下。

##### 6.是否使用过 IntentService，作用是什么， AIDL 解决了什么问题？
* (1) IntentService继承自Service。由于Service运行在主线程，无法进行耗时操作。所以你需要在Service中开启一个子线程，并且在子线程中运行。为了简化这一操作，Android中提供了IntentService来进行这一处理。通过查看IntentService的源码可以看到，在onCreate中，我们开启了一个HandlerThread线程，之后获取HandlerThread线程中的Looper，并通过这个Looper创建了一个Handler。然后在onStart方法中通过这个Handler将intent与startId作为Message的参数进行发送到消息队列中，然后交由Handler中的handleMessage中进行处理。由于在onStart方法是在主线程内运行的，而Handler是通过工作者线程HandlerThread中的Looper创建的。所以也就是在主线程中发送消息，在工作者接收到消息后便可以进行一些耗时的操作。
* (2) 进程间通信

##### 5.是否使用过本地广播，和全局广播有什么差别？
* 本地广播的数据在本应用范围内传播，不用担心隐私数据泄露的问题。不用担心别的应用伪造广播，造成安全隐患。相比在系统内发送全局广播，它更高效。

##### 4.Activity、 Window、 View 三者的差别， fragment 的特点？
* (1) Activity像一个工匠（控制单元），Window像窗户（承载模型），View像窗花（显示视图） LayoutInflater像剪刀，Xml配置像窗花图纸。
* (2) a. Fragment可以作为Activity界面的一部分组成出现；
* b. 可以在一个Activity中同时出现多个Fragment，并且一个Fragment也可以在多个Activity中使用；
* c. 在Activity运行过程中，可以添加、移除或者替换Fragment；
* d. Fragment可以响应自己的输入事件，并且有自己的生命周期，它们的生命周期会受宿主Activity的生命周期影响。

##### 3.Handler、 Thread 和 HandlerThread 的差别
* 从Android中Thread（java.lang.Thread -> java.lang.Object）描述可以看出，Android的Thread没有对Java的Thread做任何封装，但是Android提供了一个继承自Thread的类HandlerThread（android.os.HandlerThread -> java.lang.Thread），这个类对Java的Thread做了很多便利Android系统的封装。
* android.os.Handler可以通过Looper对象实例化，并运行于另外的线程中，Android提供了让Handler运行于其它线程的线程实现，也是就HandlerThread。HandlerThread对象start后可以获得其Looper对象，并且使用这个Looper对象实例Handler。

##### 2.Android性能优化

* 一、代码优化
* 1.使用AndroidLint分析结果进行相应优化
* 2.不使用枚举及IOC框架，反射性能低
* 3.常量加static
* 4.静态方法
* 5.减少不必要的对象、成员变量
* 6.尽量使用线程池
* 7.适当使用软引用和弱引用
* 8.尽量使用静态内部类，避免潜在的内存泄露
* 9.图片缓存，采用内存缓存LRUCache和硬盘缓存DiskLRUCache
* 10.Bitmap优化，采用适当分辨率大小并及时回收

---

*  二、布局优化
* 避免OverDraw过渡绘制
* 优化布局层级
* 避免嵌套过多无用布局
* 当我们在画布局的时候，如果能实现相同的功能，优先考虑相对布局，然后在考虑别的布局，不要用绝对布局。
* 使用标签把复杂的界面需要抽取出来
* 使用标签，因为它在优化UI结构时起到很重要的作用。目的是通过删减多余或者额外的层级，从而优化整个Android Layout的结构。核心功能就是减少冗余的层次从而达到优化UI的目的！
* ViewStub 是一个隐藏的，不占用内存空间的视图对象，它可以在运行时延迟加载布局资源文件。

---

* 三、ListView和GridView优化
* 1.采用ViewHolder复用convertView
* 2.避免在getView中执行耗时操作
* 3.列表在滑动状态时不加载图片
* 4.开启硬件加速

##### 1.Android内存泄漏
* 内存泄漏简单地说就是申请了一块内存空间，使用完毕后没有释放掉。它的一般表现方式是程序运行时间越长，占用内存越多，最终用尽全部内存，整个系统崩溃。由程序申请的一块内存，且没有任何一个指针指向它，那么这块内存就泄露了。可能的原因有：
* 1.注册没取消造成内存泄露，如：广播
* 2.静态变量持有Activity的引用
* 3.单例模式持有Activity的引用
* 4.查询数据库后没有关闭游标cursor
* 5.构造Adapter时，没有使用 convertView 重用
* 6.Bitmap对象不在使用时调用recycle()释放内存
* 7.对象被生命周期长的对象引用，如activity被静态集合引用导致activity不能释放
* 8.使用Handler造成的内存泄露
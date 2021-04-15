<template>
	<view class="content">
		<!-- 汶：数据双向绑定，数据改变会通知界面修改 -->
		<swiper indicator-dots circular>
			<swiper-item v-for="item in swipers" :key ="item.id">
				<image :src="item.img"> </image>
			</swiper-item>
		</swiper>
		<!-- 导航区域 -->
		<view class="nav">
			
			<view class="nav_item" v-for="(item,index) in navitems" :key="index" @click="navItemClick(item.path)">
				<view :class="item.icon"></view>
				<text>{{item.name}}</text>
			</view> 
			
		</view>
	
		<!-- 推荐商品 -->
		<view class="goods_view">
			<view class="title">
				推荐商品
			</view>
			<!-- 父向子，通过props传递参数 -->
			<good_list_component :goods='goodlist'></good_list_component>

		</view>
	</view>
	
	
</template>

<script>
	// goodListComponent是自定义的名字
	import goodListComponent from "../../components/good_list.vue"
	
	export default {
		data() {
			return {
				swipers: [],
				goodlist:[],
				navitems:[
					{
						icon:'iconfont icon-ziyuan',
						path:'/pages/good/good',
						name:'黑马超市'
					},
					{
						icon:'iconfont icon-guanyuwomen',
						path:'/pages/contact/contact',
						name:'联系我们'
					},
					{
						icon:'iconfont icon-tupian',
						path:'/pages/pic/pic',
						name:'社区图片'
					},
					{
						icon:'iconfont icon-shipin',
						path:'/pages/video/video',
						name:'学习视频'
					}
				]
			}
		},
		onLoad() {
			this.requestSwipers(),
			this.requestGoodslist()
		},
		// 汶:注册组件
		// good_list_component名字是自定义的,这里取什么名字,上面就用什么名字
		components:{
			'good_list_component':goodListComponent
		},
		methods: {
			async requestSwipers() {
				const res = await this.$myRequest({
					url:'/api/getlunbo'
				})
				this.swipers = res.data.message
				console.log(this.swipers)
			},
			async requestGoodslist() {
				const res = await this.$myRequest({
					url:'/api/getgoods?pageindex=1'
				})
				this.goodlist = res.data.message
				console.log(this.goodlist)
			},
				
			navItemClick(url){
				console.log(url)
				uni.navigateTo({
					url:url
				})
			}
			
		}
	}
</script>

<style lang='scss'>
	.content {
		swiper {
			width: 750rpx;
			height: 380rpx;
			image {
				width: 100%;
				height: 100%;
			}
		}
		 
	}
	
	.nav {
		display: flex;
		
		.nav_item {
			width: 25%; 
			text-align: center;
			
			view {
				width: 120rpx;
				height: 120rpx;
				border-radius: 60rpx;
				background-color: $shop-color;
				margin: 12px auto;
				line-height: 120rpx;
				color: #FFFFFF; 
				font-size: 50rpx;
				
				.icon-tupian {
					font-size: 45rpx;
				} 
			} 
			 
			text {
				font-size: 30rpx;
			}
		}
	}
	
	.goods_view {
		background-color: #eee;
		overflow: hidden;
		margin-top: 10px;
		.title {
			height: 50px;
			background-color: #fff;
			color: $shop-color;
			letter-spacing: 20px;
			text-align: center;
			line-height: 50px;
			margin: 7rpx 0;
		}

	}
</style>

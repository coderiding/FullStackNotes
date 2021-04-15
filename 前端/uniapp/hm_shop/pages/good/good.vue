<template>
	<view>
		<goodsComponent :goods="goodsList"></goodsComponent>
		<view class="bottom_line" v-if="flag">-----我是有底线的-----</view>
	</view>
</template>

<script>
	import goods_list_component from "../../components/good_list.vue"
	export default {
		data() {
			return {
				pageNumber:1,
				goodsList:[],
				flag:false
			}
		},
		components:{
			'goodsComponent':goods_list_component
		},
		methods: {
			async getGoodsData(callback) {
				const res = await this.$myRequest({
					url:'/api/getgoods?pageindex='+this.pageNumber
				})
				
				this.goodsList = [...this.goodsList,...res.data.message]
				callback && callback()
			}
		},
		onLoad() {
			this.getGoodsData()
		},
		onReachBottom() {
				
			if(this.goodsList.length < this.pageNumber*10){
				return this.flag = true
			}
			this.pageNumber++,
			this.getGoodsData()
		},
		onPullDownRefresh() {
			this.pageNumber = 1,
			this.goodsList = [],
			this.flag = false,
			this.getGoodsData(()=>{
				uni.stopPullDownRefresh()
			})
		}
	}
</script>

<style>
		
	.bottom_line {
		font-size: 28rpx;
		text-align: center;
		width: 100%;
		height: 50rpx;
		color: #ccc;
		line-height: 50rpx;
	}
</style>

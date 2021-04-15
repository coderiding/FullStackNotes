<template>
	<view >
		<view @click="clickItem(item.id)" class="news_item" v-for="(item,index) in newList" :key="index">
			<image class="img" :src="item.img_url"></image>
			<view class="right">
				<view class="tit">
					{{item.title}}
				</view>
				<view class="info">
					<text>阅读：{{item.add_time | fomatDate}}</text>
					<text>浏览：{{item.click}}</text>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
		
	export default {
		props:['newList'],
		filters:{
			fomatDate(date){
				const nDate = new Date(date)
				const y = nDate.getFullYear()
				const m = nDate.getMonth()
				const d = nDate.getDay()
				return y + "-" + m + "-" + d
			}
		},
		methods: {
			clickItem(id){
				console.log('abc='+id)
				this.$emit("goItemDetail",id)
			}
		}
	} 	
	
</script>

<style lang='scss'>
	.news_item{
		display: flex;
		margin: 20rpx 20rpx;
		border-bottom: 1px solid $shop-color;
		.img {
			min-width: 200rpx;
			max-width: 200rpx;
			height: 150rpx;
			background-color: #555555;
		}
		.right {
			margin-left: 15rpx;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
		}
		.tit {
			font-size: 33rpx;
		}
		.info {
			
			font-size: 28rpx;
			text:nth-child(2){
				margin-left: 15rpx;
			}
		}
	}
</style>

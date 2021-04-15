<template>
	<view class="goods_list" >
		<view class="goods_item" v-for="item in goods" :key="item.id">
			<!-- 目前图片地址已经全部失效 -->
			<image :src="item.img_url" mode=""></image>
			<view class="price">
				<text>￥{{item.sell_price}}</text>
				<text>￥{{item.market_price}}}</text>
			</view>
			
			<view class="goods_desc">
				{{item.title}}
			</view>
		</view>
		</view>
		
	</view>
	
</template>

<script>
	export default {
		props:['goods']
	}
</script>

<style lang='scss'>
	
	.goods_list {
		display: flex;
		flex-wrap: wrap;
		justify-content: space-between;
		padding: 0 15rpx;
		
		.goods_item {
			width: 355rpx;
			margin: 10rpx 0;
			padding: 15rpx;
			box-sizing: border-box;
			
			image {
				width: 80%;
				height: 150rpx;
				display: block;
				margin: auto;
			}
			.price {
				color: $shop-color;
				font-size: 36rpx;
				text:nth-child(2){
					color: #ccc;
					font-size: 28rpx;
					margin-left: 17rpx;
					text-decoration: line-through;
				}
				
			}
			.goods_desc {
				font-size: 28rpx;
				line-height: 50rpx;
				padding-bottom: 15rpx;
			}
		}
	
	}
		
</style>

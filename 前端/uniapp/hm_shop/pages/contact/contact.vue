<template>
	<view class="contact">
		<image class="img" src="http://www.itcast.cn/2018czydz/images/gywmban.jpg" mode=""></image>
		<view class="info">
			<view @click="phonecall">联系电话 8888112233 （点击拨打）</view>
			<view >广东省湖北是将联合大道11路包不包小区怎么二弟</view>
		</view>
		<map class="mapView" :latitude="latitude" :longitude="longitude" :scale="scale" :markers="makeM" ></map>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				'scale':13,
				latitude : 30.584461,
				longitude : 114.299559,
				makeM:[{ 
					latitude : 30.584461,
					longitude : 114.299559,
					iconPath: '../../static/hmlogo.png',
					width:30,
					height:30
				}]
			}
		},
		methods: {
			phonecall(){
				uni.makePhoneCall({
					phoneNumber:'8888112233'
				})
			}
			
		}
	}
</script>

<style lang = 'scss'>
	
.contact{
	.img{
		width: 100%;
		height: 160rpx;
	}	
	.info{
		padding: 10rpx 20rpx;
		
		font-size: 32rpx; 
		view{
			line-height: 80rpx;
			color: #333333;
		}
		
		
	}
	.mapView{
		margin: 18rpx 18rpx;
		width: 100%;
		height: 750rpx;
	}
}
</style>

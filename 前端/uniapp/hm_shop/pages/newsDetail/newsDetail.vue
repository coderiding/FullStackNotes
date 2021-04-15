<template>
	<view class="newsdetail">
		<view class="tit">
			{{messages.title}}
		</view>
		<view class="info">
			<text>浏览时间：{{messages.add_time}}</text>
			<text>点击量：{{messages.click}}</text>
		</view>
		<view class="content">
			<rich-text :nodes="messages.content"></rich-text>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				id:0,
				messages:{}
			}
		},
		methods: {
			async requestNewsDetail(){
					
				const res = await this.$myRequest({
					url:'/api/getnew/'+this.id
				})
				console.log(res)
				this.messages = res.data.message[0]
			}
		},
		onLoad(options) {
			console.log('9999'+options.id)
			this.id = options.id
			this.requestNewsDetail()
		}
	}
</script>

<style lang='scss'>
.newsdetail {
	font-size: 30rpx;
	padding: 20rpx 20rpx;
	.tit{
		text-align: center;
		width: 100%;
	}
	.info {
		display: flex;
		justify-content: space-between;
	}
	.content {
		margin-top: 20rpx;
		margin-left: 10rpx;
		margin-right: 10rpx;
	}
}
</style>

<template>
	<view class="picscroll">
		<scroll-view class="left" scroll-y>
			<view @click="clickCate(index,item.id)" :class="index===currentIndex ? 'active':'' " v-for="(item,index) in cates" :key="item.id">
				{{item.title}}
			</view> 
		</scroll-view>
		
		<scroll-view class="right" scroll-y>
			<view class="item" v-for="(item) in catesImages" :key="item.id">
				<image @click="checkImage(item.img_url)" class="picImage" src="https://t7.baidu.com/it/u=568562300,3718170440&fm=193&f=GIF" mode="scaleToFill"></image>
				
				<view class="picTitle">
					{{item.title}}
				</view>
				
			</view>
			
			<view v-if="catesImages.length ===0">暂无数据</view>
		</scroll-view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				cates:[],
				catesImages:[],
				currentIndex:0
			}
		},
		methods: {
			async getimgCategory(){
				const res = await this.$myRequest({
					url:'/api/getimgcategory'
				})
				console.log(res.data.message)
				this.cates = res.data.message
				this.getPicByCateID(this.cates[0].id)
			},
			async getPicByCateID(id){
				const res = await this.$myRequest({
					url:'/api/getimages/'+id
				})
				console.log(res.data.message)
				this.catesImages = res.data.message
			},
				
			clickCate(index,itemId){
				this.currentIndex=index
				console.log(index)
				this.getPicByCateID(itemId)
			},
			checkImage(currentImage){
					
				const urls = this.catesImages.map(item=>{
					return 'https://t7.baidu.com/it/u=568562300,3718170440&fm=193&f=GIF'
				})
				uni.previewImage({
					current:'https://t7.baidu.com/it/u=568562300,3718170440&fm=193&f=GIF',
					urls:urls
				})
			}
		},
		onLoad() {
			this.getimgCategory()
		}
	}
</script>

<style lang='scss'>
page{
	height: 100%;
}
.picscroll {
	height: 100%;
	display: flex;
	.left{
		width: 100px;
		height: 100%; 
		view{
			height: 68px;
			text-align: center;
			line-height: 50px;
		}
	}
	.right {
		margin: 20rpx 20rpx;
		height: 100%;
		.item{
			margin: 10 auto;
			.picImage {
				width: 100%;
				margin: 10px auto;
				border-radius: 4px;
			}
			.picTitle {
				font-size: 30rpx;
				line-height: 60rpx;
				
			}
		}
	}
}

.active {
	color: #fff;
	background-color: #B50303;
}
</style>

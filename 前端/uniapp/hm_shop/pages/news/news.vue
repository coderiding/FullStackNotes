<template>
	<view class="news">
		<news_itemCompontent :newList="newList" @goItemDetail="goDetail"></news_itemCompontent>
	</view>
</template>

<script>
	import newsListComponent from '../../components/news_item.vue'
	export default {
		data() {
			return {
				newList:[]
			}
		},
		methods: {
			async getNewsList(){
				const res = await this.$myRequest({
					url:'/api/getnewslist'
				})
				this.newList = res.data.message
			},
			goDetail(id){
				console.log(id)
				uni.navigateTo({
					url:'../newsDetail/newsDetail?id='+id
				})
			}
		},
		components:{
			'news_itemCompontent':newsListComponent
		},
		onLoad() {
			this.getNewsList()
		},
			
		
	}
</script>

<style lang='scss'>
.news{
	
}
</style>

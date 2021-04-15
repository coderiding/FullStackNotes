const BASE_URL = 'http://localhost:8082'
	
export const myRequest = (options) => {
		
	return new Promise((resole,reject) => {
		uni.request({
			url:BASE_URL + options.url,
			method:options.method || 'GET',
			data:options.data || {},
			success:(res) => {
				if (res.data.status !== 0) {
					return uni.showToast({
						title:'获取数据失败'
					})
				}
				resole(res)
			},
			fail:(err)=>{
				return uni.showToast({
					title:'获取数据失败'
				})
				reject(err)
			}
		})
	})
}
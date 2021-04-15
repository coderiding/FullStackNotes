var express = require('express')
var appData = require('./data.json')
var seller = appData.seller;
var goods = appData.goods;
var ratings = appData.ratings;

var apiRoutes = express.Router();
var app = express()

apiRoutes.get('/seller',function(req,res){
	res.json({
		errno:0,
		data:seller
	})
})

app.use('/api',apiRoutes)

app.listen(8888)

module.exports = app

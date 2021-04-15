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

apiRoutes.get('/goods',function(req,res){
	res.json({
		errno:0,
		data:goods
	})
})

apiRoutes.get('/ratings',function(req,res){
	res.json({
		errno:0,
		data:ratings
	})
})

app.use('/api',apiRoutes)

app.listen(8080)

module.exports = app

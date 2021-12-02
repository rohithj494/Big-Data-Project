'use strict';
const http = require('http');
var assert = require('assert');
const express= require('express');
const app = express();
const mustache = require('mustache');
const filesystem = require('fs');
const url = require('url');
const port = Number(process.argv[2]);

const hbase = require('hbase')
var hclient = hbase({ host: process.argv[3], port: Number(process.argv[4])})


function rowToMap(row) {
	if (row===null){
		var stats={"total_crimes":0, "total_arrests":0, "total_domestic":0}
	}else{
		var stats = {}
		row.forEach(function (item) {
			stats[item['column']] = Number(item['$'])
		});
	}
	return stats;
}

hclient.table('rohithj_yearly').row('0000X E 100 PL2001').get((error, value) => {
	console.info(rowToMap(value))
	console.info(value)
})


app.use(express.static('public'));
app.get('/delays.html',function (req, res) {
    const route=req.query['block'] + req.query['year'];
    console.log(route);
	hclient.table('rohithj_yearly').row(route).get(function (err, cells) {
		var total_vals;

		console.log(cells)
		const weatherInfo = rowToMap(cells);
		console.log(weatherInfo)
		function weather_delay() {
			var crimes = weatherInfo["crimes:total_crimes"];
			var arrests = weatherInfo["crimes:total_arrests"];
			//var domestic = weatherInfo["crimes:total_domestic"];
			if(crimes== 0)
				return " - ";
			return (arrests*100/crimes).toFixed(1); /* One decimal place */
		}

		function total_stats() {
			var crimes = total_vals["crimes:total_crimes"];
			var arrests = total_vals["crimes:total_arrests"];
			//var domestic = weatherInfo["crimes:total_domestic"];
			if(crimes== 0)
				return " - ";
			return (arrests*100/crimes).toFixed(1); /* One decimal place */
		}

		var template = filesystem.readFileSync("result.mustache").toString();
		hclient.table('rohithj_total').row(req.query['block']).get((error, value) => {
			total_vals= rowToMap(value)
			console.log(total_vals)
			var html = mustache.render(template,  {
				block : req.query['block'],
				year : req.query['year'],
				total_crimes: total_vals["crimes:total_crimes"],
				total_arrests: total_vals["crimes:total_arrests"],
				total_domestic: total_vals["crimes:total_domestic"],
				total_perc: total_stats(),
				crimes: weatherInfo["crimes:total_crimes"],
				arrests: weatherInfo["crimes:total_arrests"],
				domestic: weatherInfo["crimes:total_domestic"],
				arrest_per : weather_delay()
			});
			res.send(html);
		})

	});
});
	
app.listen(port);

const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
//const Promise = require('bluebird');
//const fs = Promise.promisifyAll(require('fs'));
var deviceUID;
var checkType;


var pool = mysql.createPool({
  //connectionLimit : 10,
  host     : 'localhost',
  user     : 'root',
  password : '',
  database : 'punchclock'
});
console.log(pool);

//const connection = await pool.createConnection();

// Starting our app.
const app = express();
const router = express.Router();
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: false })); // support encoded bodies
app.use('/', router);


Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};






// Creating a GET route that returns data from the 'users' table.
app.get('/devices', function (req, res) {
	//const connection = await pool.getConnection();
	console.log('Getting...');
    // Connecting to the database.
    pool.getConnection(function(err, connection){
		if(err) return res.send(400);
    
		/*return  p.getConnection()
		  
	  }).then(function(connection){*/

    // Executing the MySQL query (select all data from the 'users' table).
    connection.query("SELECT * FROM devicetable", function (error, results, fields) {
      // If some error occurs, we throw an error.
      if (error) throw error;

      // Getting the 'response' from the database and sending it to our route. This is were the data is.
      res.send(results)
    });
  });
  //connection.end();
});


app.post('/overview', function (req, res) {
	//const connection = await pool.getConnection();
	console.log('Getting times...');
    // Connecting to the database.
    pool.getConnection(function(err, connection){
		if(err) return res.send(400);
    
		/*return  p.getConnection()
		  
	  }).then(function(connection){*/

    // Executing the MySQL query (select all data from the 'users' table).
    connection.query("SELECT ID FROM devicetable WHERE device = '"+req.body.deviceID+"'", function (error, results, fields) {
		// If some error occurs, we throw an error.
		//if (error) throw error;

		// Getting the 'response' from the database and sending it to our route. This is were the data is.
		console.log(results);
		var string=JSON.stringify(results);
		var json =  JSON.parse(string);
		deviceUID = json[0].ID;
		console.log(deviceUID);

		connection.query("SELECT * FROM timetable WHERE deviceID = "+deviceUID+" ORDER BY UNIX_TIMESTAMP DESC", function (error, results, fields) {
			// If some error occurs, we throw an error.
			if (error) throw error;

			var stringX=JSON.stringify(results);
			var jsonX =  JSON.parse(stringX);
			var punches = [];
			for (i=0; i<Object.size(jsonX); i++){

				console.log(jsonX[i]);
				punches.push(jsonX[i].UNIX_TIMESTAMP);
				punches.push(jsonX[i].checkin_type);
				punches.push(jsonX[i].punch_method);
			};
	  
			// Getting the 'response' from the database and sending it to our route. This is were the data is.
			res.send(punches)
		  });

		});
  //connection.end();
	});
});




/////MANUAL PUNCH////////////

app.post('/manualpunch', function (req, res) {
	// Connecting to the database.
	//const connection = await pool.getConnection();
	console.log('Punching...');
	var stamp = new Date();
	//var stamper = stamp.parse()
    pool.getConnection(function(err, connection){
		if(err) return res.send(400);
    
		/*return  p.getConnection()
		  
	  }).then(function(connection){*/
		
	try{	
		stamp = new Date(Date.parse(stamp)-(req.body.settime*60000));
		if (isNaN(Math.round(stamp.getTime()/1000))) {
			console.log('Stamp is NaN!');
			throw error;
		};
		console.log(Math.round(stamp.getTime()/1000));
		connection.query("SELECT ID FROM devicetable WHERE device = '"+req.body.deviceID+"'", function (error, results, fields) {
			// If some error occurs, we throw an error.
			//if (error) throw error;

			// Getting the 'response' from the database and sending it to our route. This is were the data is.
			var string=JSON.stringify(results);
			var json =  JSON.parse(string);
			//console.log(json[0].ID);
			//deviceUID = json[0].ID;

			if (!json[0]){
				console.log('NO ID');

				connection.query("INSERT INTO devicetable VALUES (null, '"+req.body.deviceID+"')", function (error, results, fields) {
					// If some error occurs, we throw an error.
					if (error) throw error;
		
					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					//res.send(results)
				});
				connection.query("SELECT ID FROM devicetable WHERE device = '"+req.body.deviceID+"'", function (error, results, fields) {
					// If some error occurs, we throw an error.
					//if (error) throw error;
		
					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					console.log(results);
					string=JSON.stringify(results);
					json =  JSON.parse(string);
					deviceUID = json[0].ID;
					console.log(deviceUID);

					connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+0+", FROM_UNIXTIME ("+Math.round(stamp.getTime()/1000)+"), 'Manual')", function (error, results, fields) {
						// If some error occurs, we throw an error.
						if (error) throw error;
		
						// Getting the 'response' from the database and sending it to our route. This is were the data is.
						res.send(results)
					});

				});
				/*connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+req.body.checkintype+", null)", function (error, results, fields) {
					// If some error occurs, we throw an error.
					if (error) throw error;
	
					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					res.send(results)
				});*/


			}
			else{
				deviceUID = json[0].ID;

				connection.query("SELECT check_type FROM timetable WHERE deviceID = "+deviceUID+" ORDER BY UNIX_TIMESTAMP DESC LIMIT 1", function (error, results, fields) {

					var string2=JSON.stringify(results);
					var json2 =  JSON.parse(string2);
					checkType = json2[0].check_type;
					console.log('Checkin Type:'+checkType);


					if (checkType === 0){


						connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+1+", FROM_UNIXTIME ("+Math.round(stamp.getTime()/1000)+"), 'Manual')", function (error, results, fields) {
							// If some error occurs, we throw an error.
							if (error) throw error;
		
							// Getting the 'response' from the database and sending it to our route. This is were the data is.
							res.send(results)
						});

					}
					else{


						connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+0+", FROM_UNIXTIME ("+Math.round(stamp.getTime()/1000)+"), 'Manual')", function (error, results, fields) {
							// If some error occurs, we throw an error.
							if (error) throw error;
		
							// Getting the 'response' from the database and sending it to our route. This is were the data is.
							res.send(results)
						});

					}

				});


			
				/*connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+req.body.checkintype+", null)", function (error, results, fields) {
					// If some error occurs, we throw an error.
					if (error) throw error;

					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					res.send(results)
				});*/
			}
			
		});
		//connection.end();
		/*connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+req.body.checkintype+", null)", function (error, results, fields) {
			// If some error occurs, we throw an error.
			if (error) throw error;

			// Getting the 'response' from the database and sending it to our route. This is were the data is.
			//res.send(results)
		});*/
	}
	catch{

		console.log('Query ERROR');
		res.send('QUERY ERROR');
		
		
	};
});
});




/////APP PUNCH////////////

app.post('/punch', function (req, res) {
	// Connecting to the database.
	//const connection = await pool.getConnection();
	console.log('Punching...');
    pool.getConnection(function(err, connection){
		if(err) return res.send(400);
    
		/*return  p.getConnection()
		  
	  }).then(function(connection){*/
		
	try{	
		connection.query("SELECT ID FROM devicetable WHERE device = '"+req.body.deviceID+"'", function (error, results, fields) {
			// If some error occurs, we throw an error.
			//if (error) throw error;

			// Getting the 'response' from the database and sending it to our route. This is were the data is.
			var string=JSON.stringify(results);
			var json =  JSON.parse(string);
			//console.log(json[0].ID);
			//deviceUID = json[0].ID;

			if (!json[0]){
				console.log('NO ID');

				connection.query("INSERT INTO devicetable VALUES (null, '"+req.body.deviceID+"')", function (error, results, fields) {
					// If some error occurs, we throw an error.
					if (error) throw error;
		
					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					//res.send(results)
				});
				connection.query("SELECT ID FROM devicetable WHERE device = '"+req.body.deviceID+"'", function (error, results, fields) {
					// If some error occurs, we throw an error.
					//if (error) throw error;
		
					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					console.log(results);
					string=JSON.stringify(results);
					json =  JSON.parse(string);
					deviceUID = json[0].ID;
					console.log(deviceUID);

					connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+0+", null, 'Regular')", function (error, results, fields) {
						// If some error occurs, we throw an error.
						if (error) throw error;
		
						// Getting the 'response' from the database and sending it to our route. This is were the data is.
						res.send(results)
					});

				});
				/*connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+req.body.checkintype+", null)", function (error, results, fields) {
					// If some error occurs, we throw an error.
					if (error) throw error;
	
					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					res.send(results)
				});*/


			}
			else{
				deviceUID = json[0].ID;

				connection.query("SELECT check_type FROM timetable WHERE deviceID = "+deviceUID+" ORDER BY UNIX_TIMESTAMP DESC LIMIT 1", function (error, results, fields) {

					var string2=JSON.stringify(results);
					var json2 =  JSON.parse(string2);
					checkType = json2[0].check_type;
					console.log('Checkin Type:'+checkType);


					if (checkType === 0){


						connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+1+", null, 'Regular')", function (error, results, fields) {
							// If some error occurs, we throw an error.
							if (error) throw error;
		
							// Getting the 'response' from the database and sending it to our route. This is were the data is.
							res.send(results)
						});

					}
					else{


						connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+0+", null, 'Regular')", function (error, results, fields) {
							// If some error occurs, we throw an error.
							if (error) throw error;
		
							// Getting the 'response' from the database and sending it to our route. This is were the data is.
							res.send(results)
						});

					}

				});


			
				/*connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+req.body.checkintype+", null)", function (error, results, fields) {
					// If some error occurs, we throw an error.
					if (error) throw error;

					// Getting the 'response' from the database and sending it to our route. This is were the data is.
					res.send(results)
				});*/
			}
			
		});
		//connection.end();
		/*connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+req.body.checkintype+", null)", function (error, results, fields) {
			// If some error occurs, we throw an error.
			if (error) throw error;

			// Getting the 'response' from the database and sending it to our route. This is were the data is.
			//res.send(results)
		});*/
	}
	catch{

		console.log('Query ERROR');
		res.send('QUERY ERROR');
		
		
	};





		
		

    // Executing the MySQL query (select all data from the 'users' table).
	console.log(deviceUID);
    /*connection.query("INSERT INTO timetable VALUES (null, '"+req.body.name+"', "+deviceUID+", "+req.body.checkintype+", null)", function (error, results, fields) {
      // If some error occurs, we throw an error.
      if (error) throw error;

      // Getting the 'response' from the database and sending it to our route. This is were the data is.
      //res.send(results)
    });*/
  });
});


// Starting our server.
app.listen(3000, () => {
 console.log('Go to http://localhost:3000/devices to see the data.');
 console.log('Go to http://localhost:3000/punch to punch in/out.');
});
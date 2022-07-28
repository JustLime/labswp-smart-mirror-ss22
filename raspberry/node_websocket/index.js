const WebSocket = require('ws') // Websocket module
const fs = require('fs') // File writer module
const { networkInterfaces } = require('os'); // Network Interface for getting ip
const server = new WebSocket.Server({ port: 420 }) // Server on websocket with given port

// https://stackoverflow.com/questions/3653065/get-local-ip-address-in-node-js
// Function for listing IP adress of current device
const nets = networkInterfaces()
const results = Object.create(null)

for (const name of Object.keys(nets)) {
    for (const net of nets[name]) {
        const familyV4Value = typeof net.family === 'string' ? 'IPv4' : 4
        if (net.family === familyV4Value && !net.internal) {
            if (!results[name]) {
                results[name] = [];
            }
            results[name].push(net.address);
        }
    }
}

fs.readFile('/home/pi/mirror/labswp-gruppe-4-smart-mirror/raspberry/react-mirror/public/data/mirrorWidgets.json', 'utf-8', (err, localData) => { // Read local file for comparrison
    let ipText = ''
    if (err) {
        console.log(err)
        return;
    }
    if (localData == '') { // Checks if local json is empty
        ipText = '[' + JSON.stringify(results) + ']'
    }
    if (ipText != '') {
        fs.writeFileSync('/home/pi/mirror/labswp-gruppe-4-smart-mirror/raspberry/react-mirror/public/data/mirrorWidgets.json', ipText, function (err) { //Stringify JSON data and save if not equal to 
            if (err) {
                console.log(err)
            }
            console.log('LOG: Saved successfully')
        })
    }
})

console.log(results)

server.on('connection', socket => { // Create socket on connection
    socket.on('message', message => { // Execute message from socket
        try {
            const data = JSON.parse(message) //Parse received data to JSON
            dataString = JSON.stringify(data) //Convert JSON to string
            fs.readFile('/home/pi/mirror/labswp-gruppe-4-smart-mirror/raspberry/react-mirror/public/data/mirrorWidgets.json', 'utf-8', (err, localData) => { // Read local file for comparrison
                if (err) {
                    console.log(err)
                    return;
                }
                if (localData == dataString) { // Checks if local json is equal to received data
                    console.log("LOG: Old data is equal to new data")
                    return; // Return if data is equal
                }
                fs.writeFileSync('/home/pi/mirror/labswp-gruppe-4-smart-mirror/raspberry/react-mirror/public/data/mirrorWidgets.json', dataString, function (err) { //Stringify JSON data and save if not equal to 
                    if (err) {
                        console.log(err)
                    }
                    console.log('LOG: Saved successfully')
                })
            })
        } catch (error) {
            console.log(error)
        }
    })
})

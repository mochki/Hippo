const Datastore = require('@google-cloud/datastore');
const projectId = 'hippo-185304';
const datastore = Datastore({
  projectId: projectId,
  "credentials": {
    // "private_key": "-----BEGIN PRIVATE KEY-----" ... 
    "client_email": "connector@hippo-185304.iam.gserviceaccount.com",
  }
})
let key = datastore.key(['userdata', 'm']);

const moment = require('moment')
moment().format()
const then = moment.utc([2001, 0, 1, 0, 0, 0, 0]).valueOf()

const dash_button = require('node-dash-button');
const dash = dash_button(["78:e1:03:f3:d3:d6", "18:74:2e:50:7e:d0"], "wlan0", null, "udp");

console.log("Listening...");


dash.on("detected", function(dash_id) {
  if (dash_id === "78:e1:03:f3:d3:d6") {
    console.log("Maxwell Pressed");
    updateEvent("Contacts");
  } else if (dash_id === "18:74:2e:50:7e:d0") {
    console.log("Gatorade pressed");
    updateEvent("Called Parents");
  }
});

function updateEvent(name) {
  datastore.get(key, (err, entity) => {
    for (let event of entity.events) {
      if (event.name === name) {
        let now = moment().utc().valueOf();
        event.history.unshift((now-then)/1000);
      }
    }

    datastore.save(entity).then(() => {
      console.log(`${name} updated`)
    })
  })
}
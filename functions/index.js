const functions = require('firebase-functions');

const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.newZoneAdded = functions.firestore
    .document('Zones/{zoneId}')
    .onCreate((snap, context) => {
    const zoneColor = snap.data().zoneColor;
    var title = `A new ${zoneColor} zone has been added`;
    var body = "Tap to check it out"
    sendToAll(title,body);
});

exports.zoneUpdate = functions.firestore
    .document('Zones/{zoneId}')
    .onUpdate((change, context) => {
        var title,body;
        const updatedZone = change.after.data();
        const oldZone = change.before.data();
        const updatedColor = updatedZone.zoneColor;
        const oldColor = oldZone.zoneColor;
        const updatedNotification = updatedZone.notificationMsg;
        const oldNotification = oldZone.notificationMsg;
        if(updatedColor===oldColor){
            if(updatedNotification!==oldNotification){
                title = `${useAn(oldColor)} ${oldColor} Zone has just been updated`;
                body = `It is now ${useAn(updatedColor).toLowerCase()} ${updatedColor} Zone`;
                sendToAll(title,body);
            }
        }
        else{
            title = `${useAn(oldColor)} ${oldColor} Zone has just been updated`;
            body = `It is now ${useAn(updatedColor).toLowerCase()} ${updatedColor} Zone`;
            sendToAll(title,body);
        }
});


exports.deleteZone = functions.firestore
    .document('Zones/{zoneId}')
    .onDelete((snap, context) => {
      const deletedZone = snap.data();
      var zoneColor = deletedZone.zoneColor;
      var title = `${useAn(zoneColor)} ${zoneColor} zone has just been deleted`;
      var body = "Stay informed at all times";
      sendToAll(title,body);
});


function useAn(color){
    const vowels = ["a","e","i","o","u"];
    const firstLetter = color.charAt(0).toString().toLowerCase();
    var useAn=false;
    for (let index = 0; index < color.length; index++) {
        if(firstLetter=== vowels[index]){
            useAn=true;
            break;
        }
    }
    return useAn?"An":"A";
}

exports.zoneNotification = functions.firestore
.document('registeredUsers/{uid}')
.onUpdate((change, context) => {
    const newZoneUpdate = change.after.data();
    const token = change.after.data().token;
    if(newZoneUpdate.entered===true){
        var title = `You are currently in ${useAn(newZoneUpdate.zoneColor)} ${newZoneUpdate.zoneColor} zone`;
        var body = newZoneUpdate.zoneNotification
        sendNotification(title,body,token);
    }
});
//eM57mt7xkLc:APA91bHgrS_Cipdsvry0VRRx5vY-pcFzXSMoYcNaKagbj_BwvNZrWGSKKNdHrkv_ELoDJbKO1cPkOlRZyKbDA62UN5azovL1GNVOABYYVjPMWUdyndAM8zx9Iz4nib6LydGX1EzVu0iz

function sendToAll(title,body){
    admin.firestore().collection('tokens').doc('devtoken').get().then(snapshot =>{
        sendNotification(title,body,snapshot.data().tokenList);
        return null;
    }).catch(e=>console.log(e));
}


function sendNotification(title,body,tokens){
    var payload = {
        "notification":{
            "title":title,
            "body":body,
            "sound":"default",
            "icon":"information_button"
        },
        "data":{
            "sendername":"Zone Handler",
            "message":"Realtime Zone updates",
        }
    }

    return admin.messaging().sendToDevice(tokens,payload).then(
        response =>{
            console.log(response);
            return null;
        }
    ).catch(error =>{
        console.log(error);
    });
}


    /* admin.firestore().collection('tokens').doc('devtoken').get().then(
        snapshots =>{
            var token = snapshots.data().token1;
           
           // admin.messaging().sendToDevice()
          
        }
    ).catch(error =>{
        console.log(error);
    }); */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { topic } = require("firebase-functions/lib/providers/pubsub");

admin.initializeApp();

exports.sendGasAlert = functions.database
  .ref("/sensorverileri/gaz_kacagi")
  .onUpdate((change, context) => {
    const before = change.before.val();
    const after = change.after.val();

    if (before === 0 && after === 1) {
      const payload = {
        notification: {
          title: "Gaz Kaçağı Tespit Edildi!",
          body: "Lütfen ortamı havalandırın!",
        },
        android:{
          priority: "high"
        },
        topic: "gaz_kacagi",
      };

      return admin.messaging().send(payload);
    }

    return null;
  });
  exports.sendFireAlert = functions.database.ref("/sensorverileri/duman_kacagi")
  .onUpdate((change,context)=>{
    const before = change.before.val();
    const after = change.after.val();
    
    if(before === 0 && after ===1){
      const payload = {
        notification: {
          title: "Yangın Tehlikesi Tespit Edildi",
          body: "Lütfen 112 acil bildirimde bulununuz!",
        },
        android: {
          priority: "high"
        },
        topic: "duman_kacagi",
      };
      return admin.messaging().send(payload);
    }
    return null;
  });
  exports.sendWaterAlert = functions.database.ref("/sensorverileri/su_kacagi")
  .onUpdate((change,context)=>{
    const before = change.before.val();
    const after = change.after.val();
    if(before === 0 && after === 1){
      const payload = {
        notification: {
          title: "Su Kaçağı Tespit Edildi",
          body: "Lütfen su vanalarını kontrol ediniz",
        },
        android:{
          priority: "high"
        },
        topic: "su_kacagi"
      };
      return admin.messaging().send(payload);
    }
    return null;
  });
  exports.sendMoveAlert = functions.database.ref("/sensorverileri/hareket_kontrol")
  .onUpdate((change,context)=>{
    const before = change.before.val();
    const after = change.after.val();
    if(before === 0 && after === 1){
      const payload = {
        notification: {
          title: "Şüpheli Hareket Tespit Edildi",
          body: "Giriş ve çıkışları kontrol ediniz.",
        },
        android:{
          priority: "high"
        },
        topic: "hareket_kontrol"
      };
      return admin.messaging().send(payload);
    }
    return null;
  });
  

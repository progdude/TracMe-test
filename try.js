var FirebaseTokenGenerator = require("firebase-token-generator");
var tokenGenerator = new FirebaseTokenGenerator("9OQtG16WafL5hdVhlrdViFlONM3EltKlWdMVduMx");
var token = tokenGenerator.createToken({ uid: "uniqueId1", some: "arbitrary", data: "here" });
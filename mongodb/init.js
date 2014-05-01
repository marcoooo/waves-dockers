conn = new Mongo();
db = conn.getDB('deleteme');
db.metadata.find();
db.schemata.find();
db.addUser({ user: "iplant",
  pwd: "password",
  customData: { scope: "docker dev user" },
  roles: [ "readwrite" ]
});

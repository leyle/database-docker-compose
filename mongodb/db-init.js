db.createUser(
  {
    user: "dbuser",
    pwd: "dbpasswd",
    roles: [ { role: "readWrite", db: "dev" }],
    passwordDigestor: "server"
  }
)

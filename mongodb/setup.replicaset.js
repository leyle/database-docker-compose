// Connect to the admin database
db = db.getSiblingDB('admin');

// Authenticate as the admin user (if authentication is enabled)
db.auth('rootuser', 'rootpasswd');

// Define the replica set configuration
var config = {
    _id: "devRepl",
    members: [
        { _id: 0, host: "mgo0.x1c.pymom.com:27017" },
        { _id: 1, host: "mgo1.x1c.pymom.com:27018" },
        { _id: 2, host: "mgo2.x1c.pymom.com:27019" }
    ]
};

// Initiate the replica set
rs.initiate(config);

// Function to check replica set status and find primary
function checkReplicaSetStatus() {
    var status = rs.status();
    var primary = null;
    var allMembersReady = true;

    print("Checking replica set status...");

    for (var i = 0; i < status.members.length; i++) {
        var member = status.members[i];
        print("Member " + member.name + " state: " + member.stateStr);

        if (member.stateStr === "PRIMARY") {
            primary = member.name;
        }

        if (member.stateStr !== "PRIMARY" && member.stateStr !== "SECONDARY") {
            allMembersReady = false;
        }
    }

    if (primary) {
        print("Primary node is: " + primary);
    } else {
        print("No primary node found yet.");
    }

    return allMembersReady && primary !== null;
}

// Wait for the replica set to initialize and elect a primary
print("Waiting for replica set to initialize...");
var maxAttempts = 30;
var attempts = 0;
while (!checkReplicaSetStatus() && attempts < maxAttempts) {
    sleep(2000);  // Wait for 2 seconds before checking again
    attempts++;
}

if (attempts >= maxAttempts) {
    print("Replica set did not stabilize within the expected time.");
} else {
    print("Replica set is now stable with a primary node.");
}

// Final status check
rs.status();

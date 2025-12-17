// --- Configuration ---
var rootUser = "rootuser";
var rootPass = "rootpasswd";

var appUser = "dbuser";
var appPass = "dbpasswd";

var targetDBs = ["dc-event", "dp-event", "mq-event", "op-event"];

// --- 1. Connect and Authenticate ---
print(">>> Starting User Provisioning...");

db = db.getSiblingDB('admin');

// Try to authenticate. 
// If this is the very first run, auth might fail (Localhost Exception), which is fine.
// If users already exist, this ensures we have permission to create more.
try {
    db.auth(rootUser, rootPass);
    print("Authenticated as " + rootUser);
} catch (e) {
    print("Authentication skipped or failed (Normal if this is the first run).");
}

// --- 2. Ensure we are on the Primary Node ---
// We reuse logic similar to your replicaset script to ensure we can write.
function waitForPrimary() {
    var maxAttempts = 30;
    var attempts = 0;
    
    while (attempts < maxAttempts) {
        var isMaster = db.isMaster();
        if (isMaster.ismaster) {
            print("✅ Connected to Primary node.");
            return true;
        }
        print("⏳ Waiting for node to become Primary... (Attempt " + (attempts + 1) + ")");
        sleep(1000);
        attempts++;
    }
    return false;
}

if (!waitForPrimary()) {
    print("❌ ERROR: Could not find Primary node. Cannot create users.");
    quit(1); // Exit with error
}

// --- 3. Create Root Admin User ---
print("--- Provisioning Root User ---");
db = db.getSiblingDB('admin');

try {
    db.createUser({
        user: rootUser,
        pwd: rootPass,
        roles: [ { role: "root", db: "admin" } ]
    });
    print("✅ Created root user: " + rootUser);
} catch (err) {
    print("ℹ️  Root user already exists.");
}

// --- 4. Create App Users for each Database ---
print("--- Provisioning App Users ---");

targetDBs.forEach(function(dbName) {
    db = db.getSiblingDB(dbName); // Switch context
    
    try {
        db.createUser({
            user: appUser,
            pwd: appPass,
            roles: [ { role: "readWrite", db: dbName } ]
        });
        print("✅ Created user '" + appUser + "' in DB '" + dbName + "'");
    } catch (err) {
        print("ℹ️  User '" + appUser + "' already exists in '" + dbName + "'");
    }
});

print("🎉 User setup complete!");


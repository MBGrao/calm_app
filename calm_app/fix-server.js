const fs = require('fs');
const path = require('path');

const serverPath = path.join(__dirname, 'server.js');
let content = fs.readFileSync(serverPath, 'utf8');

// Fix all problematic lines
content = content.replace(
  /if \(process\.env\.NODE_ENV === " development \|\| process\.env\.NODE_ENV === production\) \{/g,
  'if (process.env.NODE_ENV === "development" || process.env.NODE_ENV === "production") {'
);

// Also fix the other occurrence
content = content.replace(
  /if \(process\.env\.NODE_ENV === "development"\) \{/g,
  'if (process.env.NODE_ENV === "development" || process.env.NODE_ENV === "production") {'
);

fs.writeFileSync(serverPath, content);
console.log('✅ Server.js file fixed successfully!');

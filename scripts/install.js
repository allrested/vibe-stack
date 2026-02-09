#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const readline = require('readline');
const crypto = require('crypto');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const ROOT_DIR = path.resolve(__dirname, '..');
const ENV_FILE = path.join(ROOT_DIR, '.env');
const EXAMPLE_ENV_FILE = path.join(ROOT_DIR, '.env.example');

console.clear();
console.log('\x1b[36m%s\x1b[0m', '🚀  Vibe Stack Installation Wizard  🚀');
console.log('----------------------------------------');

// Helper: Ask Question
const ask = (question, defaultVal) => {
  return new Promise((resolve) => {
    rl.question(`\x1b[32m?\x1b[0m ${question} ${defaultVal ? `\x1b[90m(${defaultVal})\x1b[0m ` : ''}: `, (answer) => {
      resolve(answer.trim() || defaultVal);
    });
  });
};

// Helper: Run Command
const run = (cmd) => {
  try {
    execSync(cmd, { stdio: 'inherit', cwd: ROOT_DIR });
  } catch (e) {
    console.error(`\x1b[31mError running command: ${cmd}\x1b[0m`);
    process.exit(1);
  }
};

async function main() {
  // 1. Check/Create .env
  let envContent = '';
  if (fs.existsSync(ENV_FILE)) {
    console.log('📝 Found existing .env file.');
    envContent = fs.readFileSync(ENV_FILE, 'utf8');
  } else {
    console.log('📝 Creating .env from example...');
    if (fs.existsSync(EXAMPLE_ENV_FILE)) {
      envContent = fs.readFileSync(EXAMPLE_ENV_FILE, 'utf8');
    } else {
      console.error('❌ .env.example not found!');
      process.exit(1);
    }
  }

  // 2. Select Services
  console.log('\nSelect services to enable (y/n):');
  const enableVibe = (await ask('Enable Vibe Server (AI Agent Platform)?', 'y')).toLowerCase() === 'y';
  const enableCode = (await ask('Enable VS Code Server?', 'y')).toLowerCase() === 'y';
  const enableMoltbot = (await ask('Enable OpenClaw (Moltbot AI Assistant)?', 'y')).toLowerCase() === 'y';
  const enableNetwork = (await ask('Enable Home Network Stack (Nginx + DNS)?', 'n')).toLowerCase() === 'y';

  let profiles = [];
  if (enableVibe) profiles.push('vibe');
  if (enableCode) profiles.push('code');
  if (enableMoltbot) profiles.push('moltbot');
  if (enableNetwork) {
    profiles.push('nginx');
    profiles.push('dns');
  }

  const profilesStr = profiles.join(',');
  console.log(`\n✅ Selected Profiles: \x1b[33m${profilesStr}\x1b[0m`);

  // 3. Update .env COMPOSE_PROFILES
  if (envContent.includes('COMPOSE_PROFILES=')) {
    envContent = envContent.replace(/COMPOSE_PROFILES=.*/, `COMPOSE_PROFILES=${profilesStr}`);
  } else {
    envContent += `\nCOMPOSE_PROFILES=${profilesStr}\n`;
  }

  // 4. Generate Token if missing
  if (!envContent.includes('OPENCLAW_GATEWAY_TOKEN') || envContent.includes('OPENCLAW_GATEWAY_TOKEN=')) { // Check empty or missing
    // Simple check, regex would be better but keeping it simple
  }

  // Basic token generation logic if placeholder exists
  if (envContent.includes('your-gateway-token')) {
    const token = crypto.randomBytes(32).toString('hex');
    envContent = envContent.replace('your-gateway-token', token);
    console.log(`🔑 Generated new Gateway Token.`);
  }

  fs.writeFileSync(ENV_FILE, envContent);
  console.log('💾 Configuration saved to .env');

  // 5. Run Docker Compose
  const startNow = (await ask('\nStart services now?', 'y')).toLowerCase() === 'y';

  if (startNow) {
    console.log('\n🚀 Starting Docker Containers...');
    run('docker compose up -d --remove-orphans');

    console.log('\n✨ Stack is running!');
    if (enableVibe) console.log(`   - Vibe Server:   http://localhost:4000`);
    if (enableCode) console.log(`   - VS Code:       http://localhost:8443`);
    if (enableMoltbot) {
      // Extract Token for display
      const tokenMatch = envContent.match(/OPENCLAW_GATEWAY_TOKEN=(.+)/);
      const token = tokenMatch ? tokenMatch[1].trim() : null;

      if (token) {
        console.log(`   - Moltbot:       http://localhost:18789`);
        console.log(`     \x1b[33m🔑 Dashboard:    http://localhost:18790/?token=${token}\x1b[0m`);
        console.log(`\n\x1b[36m📱 Moltbot Pairing Instructions:\x1b[0m`);
        console.log(`   1. Message your bot on WhatsApp/Telegram/Signal/Slack.`);
        console.log(`   2. When it replies with a pairing code, run this command:`);
        console.log(`      \x1b[32mdocker exec -it moltbot-gateway openclaw pairing list --channel <channel>\x1b[0m`);
        console.log(`      (Replace <channel> with whatsapp, telegram, etc.)`);
      } else {
        console.log(`   - Moltbot:       http://localhost:18789`);
      }
    }
    if (enableNetwork) {
      console.log(`   - Nginx Admin:   http://localhost:81`);
      console.log(`   - AdGuard:       http://localhost:8086`);
    }

    // Interactive Configuration for Moltbot
    if (enableMoltbot) {
      console.log('\n\x1b[36m🤖 Moltbot Configuration\x1b[0m');
      const configureNow = (await ask('Do you want to configure Moltbot agent (Model, API Keys) interacting with the container now?', 'y')).toLowerCase() === 'y';

      if (configureNow) {
        console.log('\n\x1b[33mEntering Moltbot container...\x1b[0m');
        console.log('You will be dropped into the OpenClaw configuration wizard.');
        console.log('Follow the on-screen instructions to set your Model (e.g. GLM) and API Keys.');
        console.log('When finished, type \x1b[1mexit\x1b[0m to return here.\n');

        // Use spawn with stdio inherit to attach to current TTY
        try {
          // We use 'docker exec -it' but we need to run it via child_process.spawn to keep interactivity
          // execSync captures output but doesn't handle interactive TTY well for complex wizards like this
          const { spawn } = require('child_process');

          // Using a promise wrapper for spawn
          await new Promise((resolve, reject) => {
            const child = spawn('docker', ['exec', '-it', 'moltbot-gateway', 'openclaw', 'onboard'], { stdio: 'inherit' });
            child.on('close', (code) => {
              console.log(`\nConfiguration wizard exited with code ${code}`);
              resolve();
            });
            child.on('error', (err) => {
              console.error('Failed to start configuration wizard:', err);
              resolve(); // Don't crash main script
            });
          });
        } catch (e) {
          console.error('Error launching interactive config:', e);
        }
      } else {
        console.log('\nYou can configure it later manually with:');
        console.log('\x1b[32mdocker exec -it moltbot-gateway openclaw onboard\x1b[0m');
      }
    }

  } else {
    console.log('\nSkipping start. Run "docker compose up -d" manually.');
  }

  rl.close();
}

main();

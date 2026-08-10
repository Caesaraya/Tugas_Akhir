module.exports = {
  apps: [{
    name: 'bakery-pos-api',
    script: './server.js',
    cwd: '/home/riffat_arfa/bakery-pos-api',
    env: {
      NODE_ENV: 'production',
      PORT: 3000,
      DB_HOST: 'localhost',
      DB_USER: 'bakery_user',
      DB_PASSWORD: 'BakeryPos2024!',
      DB_NAME: 'bakery_pos'
    }
  }]
};

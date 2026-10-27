const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.status(200).send('Phase 1 deployment application is running.');
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    application: 'phase1-deployment'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Application listening on port ${PORT}`);
});

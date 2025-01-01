require('dotenv').config({
  path: process.env.NODE_ENV === 'development' ? '.env.local' : '.env'
});
const express = require('express');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const cors = require('cors');

const app = express();

// Configuration CORS mise à jour
app.use(cors({
  origin: [
    'https://nothing-site-f3c7f.web.app',
    'https://nothing-site-f3c7f.firebaseapp.com',
    'http://localhost:3000',
    'http://localhost:56035',  // Ajout du port de votre app Flutter
    '*'  // Permet toutes les origines - à utiliser avec précaution en production
  ],
  methods: ['GET', 'POST', 'OPTIONS', 'PATCH', 'DELETE', 'PUT'],
  credentials: true,
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept', 'Origin']
}));

// Middleware pour les headers CORS supplémentaires
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version');
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }
  
  next();
});

app.use(express.json());

// Ajoutez une route de test
app.get('/api/test', (req, res) => {
  res.json({ message: 'API is working!' });
});

app.post('/api/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency, payment_method } = req.body;
    console.log('Received request:', { amount, currency, payment_method }); // Debug log

    if (payment_method === 'card') {
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: currency || 'usd',
            product_data: {
              name: 'NMAL Purchase',
            },
            unit_amount: Math.round(amount),
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: `${req.headers.origin}/success`,
        cancel_url: `${req.headers.origin}/cancel`,
      });

      console.log('Session created:', session); // Debug log
      res.json({ id: session.id });
    }
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log('Stripe Secret Key:', process.env.STRIPE_SECRET_KEY.substring(0, 10) + '...'); // Debug log
}); 
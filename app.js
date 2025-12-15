/*
 * Copyright (c) 2025 . All rights reserved.
 */

const express = require('express');
const path = require('path');
const exphbs = require('express-handlebars');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.PORT || 3000;
const host = '127.0.0.1'; // localhost

// Configurar Handlebars
app.engine('hbs', exphbs.engine({
  extname: 'hbs',
  defaultLayout: 'layout'    // => busca views/layouts/layout.hbs
}));
app.set('view engine', 'hbs');
app.set('views', './views');


// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Rutas principales
const homeController = require('./controllers/home');
const adminController = require('./controllers/admin');

app.get('/', homeController.home);
app.get('/servicios', homeController.servicios);
app.get('/admin', adminController.admin);
app.post('/admin/add-service', adminController.addService);

app.listen(port, host, () => {
  console.log(`Veterinaria app corriendo en http://${host}:${port}`);
});
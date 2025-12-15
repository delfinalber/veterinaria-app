/*
 * Copyright (c) 2025 . All rights reserved.
 */

exports.admin = (req, res) => {
  res.render('admin', { title: 'Admin' });
};
exports.addService = (req, res) => {
  const { username, password } = req.body;
  const ADMIN = 'admin';
  const PASSWORD = 'password';
  if (username === ADMIN && password === PASSWORD) {
    res.render('add-service', { 
      title: 'Agregar Servicio',
      loggedIn: true 
    });
  } else {
    res.render('admin', { 
      title: 'Login Admin',
      loggedIn: false 
    });
  }
};

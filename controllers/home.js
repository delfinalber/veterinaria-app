/*
 * Copyright (c) 2025 . All rights reserved.
 */

const servicios = [
  { nombre: 'Vacunación', descripcion: 'Vacunación completa para mascotas' },
  { nombre: 'Cirugías', descripcion: 'Cirugías generales y especializadas' },
  { nombre: 'Rayos X', descripcion: 'Diagnóstico por imágenes' }
];

exports.home = (req, res) => {
  res.render('home', { title: 'Veterinaria San Francisco' });
};

exports.servicios = (req, res) => {
  res.render('servicios', { title: 'Servicios' });
};
exports.getServicios = () => {
  return servicios;
};

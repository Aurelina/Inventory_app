

DROP DATABASE IF EXISTS `inventario`;

CREATE DATABASE `inventario` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `inventario`;

CREATE TABLE `sucursales` (
  `idSucursal` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plaza` varchar(30) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  PRIMARY KEY (`idSucursal`),
  UNIQUE KEY `plaza` (`plaza`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `usuarios` (
  `idUsuario` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idSucursal` int(10) unsigned NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `permisos` int(10) unsigned NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `username` (`username`),
  KEY `idSucursal` (`idSucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tecnicas` (
  `idTecnica` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idSucursal` int(10) unsigned NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  PRIMARY KEY (`idTecnica`),
  KEY `idSucursal` (`idSucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `categorias` (
  `idCategoria` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  PRIMARY KEY (`idCategoria`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `productos` (
  `idProducto` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idCategoria` int(10) unsigned NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `minimo` int(10) unsigned NOT NULL,
  `esBasico` tinyint(1) NOT NULL,
  PRIMARY KEY (`idProducto`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idCategoria` (`idCategoria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `almacen` (
  `idAlmacen` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idSucursal` int(10) unsigned NOT NULL,
  `idProducto` int(10) unsigned NOT NULL,
  `cantidadAlmacen` int(10) unsigned NOT NULL DEFAULT '0',
  `cantidadConsumo` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`idAlmacen`),
  KEY `idSucursal` (`idSucursal`),
  KEY `idProducto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `movimientos` (
  `idUsuario` int(10) unsigned NOT NULL,
  `idProducto` int(10) unsigned NOT NULL,
  `cantidad` int(10) unsigned NOT NULL,
  `tipo` tinyint(1) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `idUsuario` (`idUsuario`),
  KEY `idProducto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `asignacionbasicos` (
  `idUsuario` int(10) unsigned NOT NULL,
  `idTecnica` int(10) unsigned NOT NULL,
  `idProducto` int(10) unsigned NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `idUsuario` (`idUsuario`),
  KEY `idTecnica` (`idTecnica`),
  KEY `idProducto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `bajas` (
  `idUsuario` int(10) unsigned NOT NULL,
  `idProducto` int(10) unsigned NOT NULL,
  `cantidad` int(10) unsigned NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `idUsuario` (`idUsuario`),
  KEY `idProducto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `bajasbasicos` (
  `idUsuario` int(10) unsigned NOT NULL,
  `idTecnica` int(10) unsigned NOT NULL,
  `idProducto` int(10) unsigned NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `idUsuario` (`idUsuario`),
  KEY `idTecnica` (`idTecnica`),
  KEY `idProducto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `basicosenuso` (
  `idTecnica` int(10) unsigned NOT NULL,
  `idProducto` int(10) unsigned NOT NULL,
  `enUso` tinyint(1) NOT NULL,
  KEY `idProducto` (`idProducto`),
  KEY `idTecnica` (`idTecnica`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `tecnicas`
ADD CONSTRAINT `tecnicas_ibfk_1` FOREIGN KEY (`idSucursal`) REFERENCES `sucursales` (`idSucursal`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `usuarios`
ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`idSucursal`) REFERENCES `sucursales` (`idSucursal`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `productos`
ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`idCategoria`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `almacen`
ADD CONSTRAINT `almacen_ibfk_1` FOREIGN KEY (`idSucursal`) REFERENCES `sucursales` (`idSucursal`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `almacen_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `movimientos`
ADD CONSTRAINT `movimientos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `movimientos_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `asignacionbasicos`
ADD CONSTRAINT `asignacionbasicos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `asignacionbasicos_ibfk_2` FOREIGN KEY (`idTecnica`) REFERENCES `tecnicas` (`idTecnica`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `asignacionbasicos_ibfk_3` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `bajasbasicos`
ADD CONSTRAINT `bajasbasicos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `bajasbasicos_ibfk_2` FOREIGN KEY (`idTecnica`) REFERENCES `tecnicas` (`idTecnica`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `bajasbasicos_ibfk_3` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `bajas`
ADD CONSTRAINT `bajas_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `bajas_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `basicosenuso`
ADD CONSTRAINT `basicosenuso_ibfk_1` FOREIGN KEY (`idProducto`) REFERENCES `productos` (`idProducto`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `basicosenuso_ibfk_2` FOREIGN KEY (`idTecnica`) REFERENCES `tecnicas` (`idTecnica`) ON DELETE CASCADE ON UPDATE NO ACTION;
-- Llenando base de datos

-- Llenando sucursales
INSERT INTO `sucursales` (`idSucursal`, `plaza`, `ciudad`) VALUES
(1, 'Solana', 'San Cristobal'),
(2, 'Alpha', 'San Cristobal'),
(3, 'Serat', 'San Antonio'),
(4, 'Beta', 'Santo Domingo'),
(5, 'Oro', 'Barahona'),
(6, 'Silver', 'Monte plata'),
(7, 'Solana II', 'La vega'),
(8, 'Marbella', 'Santiago'),
(9, 'Sandra', 'San Souci'),
(10, 'Rey', 'San Juan');
-- Llenando tecnicas
INSERT INTO `tecnicas` (`idTecnica`, `idSucursal`, `nombre`, `apellido`) VALUES
(1, 1, 'Giovana', 'Flores'),
(2, 1, 'Miriam', 'de Jesus'),
(3, 1, 'Karla', 'Uribe'),
(4, 2, 'Norma', 'Ramirez');

-- Llenando usuarios
INSERT INTO `usuarios` (`idUsuario`, `idSucursal`, `username`, `password`, `permisos`, `nombre`, `apellido`, `status`) VALUES
(1, 1, 'gabrielat', '12345678', 2, 'Gabriela Gricelda', 'Ramirez Perez', 1),
(2, 1, 'duniam', '12345678', 1, 'Dunia', 'Medrano', 1),
(3, 2, 'lourdesa', '12345678', 1, 'Lourdes', 'Archuleta', 1),
(4, 1, 'yadirar', '12345678', 0, 'Yadira', 'Rodriguez', 1),
(5, 1, 'berenicev', '12345678', 0, 'Berenice', 'Garcia', 1),
(6, 2, 'irman', '12345678', 0, 'Irma', 'Lopez', 1);
-- Llenando categorias
INSERT INTO `categorias` (`idCategoria`, `nombre`, `descripcion`) VALUES
(1, 'Gelish', 'Categoria Gelish' ),
(2, 'Goldwell', 'Categoria Goldwell' ),
(3, 'Guadalajara', 'Categoria Guadalajara' ),
(4, 'Morgan Taylor', 'Categoria Morgan Taylor' ),
(5, 'Nioxin', 'Categoria Nioxin' ),
(6, 'Pestaña', 'Categoria Pestaña' ),
(7, 'Prohesion', 'Categoria Prohesion' ),
(8, 'Seche', 'Categoria Seche' );
-- Llenando productos
INSERT INTO `productos` (`idProducto`,`idCategoria`, `nombre`, `descripcion`, `codigo`, `minimo`, `esBasico`) VALUES
(1, 4, "All White Now", "15ml", "50000" , 1, 0 ),
(2, 4, "Heaven Sent", "15ml", "50001" , 1, 0 ),
(3, 4, "In The Nude", "15ml", "50002" , 1, 0 ),
(4, 4, "One And Only", "15ml", "50003" , 1, 0 ),
(5, 4, "I'm Charmed", "15ml", "50004" , 1, 0 ),
(6, 4, "Sugar Fix", "15ml", "50005" , 1, 0 ),
(7, 4, "Simply Irresistible", "15ml", "50006" , 1, 0 ),
(8, 4, "Adorned In Diamonds", "15ml", "50007" , 1, 0 ),
(9, 4, "Sweet Surrender", "15ml", "50008" , 1, 0 ),
(10, 4, "La Dolce Vita", "15ml", "50009" , 1, 0 ),
(11, 4, "Make Me Blush", "15ml", "50010" , 1, 0 ),
(12, 4, "Luxe Be A Lady", "15ml", "50011" , 1, 0 ),
(13, 4, "Sweetest Thing", "15ml", "50012" , 1, 0 ),
(14, 4, "New Romance", "15ml", "50013" , 1, 0 ),
(15, 4, "Lip Service", "15ml", "50014" , 1, 0 );
-- Llenando productos
INSERT INTO `almacen` (`idAlmacen`,`idProducto`, `idSucursal` ) VALUES
( 1, 1, 1 ),
( 2, 2, 1 ),
( 3, 3, 1 ),
( 4, 4, 1 ),
( 5, 5, 1 ),
( 6, 6, 1 ),
( 7, 7, 1 ),
( 8, 8, 1 ),
( 9, 9, 1 ),
( 10, 10, 1 ),
( 11, 11, 1 ),
( 12, 12, 1 ),
( 13, 13, 1 ),
( 14, 14, 1 ),
( 15, 15, 1 );

-- Consultar todos los productos
select * from productos;

-- Consultar todos los usuarios
select * from usuarios;
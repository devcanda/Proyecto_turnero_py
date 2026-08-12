-- phpMyAdmin SQL Dump
-- Versión Refactorizada para InnoDB e Integridad Referencial
-- --------------------------------------------------------

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas_especiales`
--

CREATE TABLE `areas_especiales` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consultorios`
--

CREATE TABLE `consultorios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidades_medicas`
--

CREATE TABLE `especialidades_medicas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos_siau`
--

CREATE TABLE `modulos_siau` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pacientes`
--

CREATE TABLE `pacientes` (
  `id` int(11) NOT NULL,
  `tipo_doc` enum('C.C','T.I','C.E','P.A','R.C') NOT NULL DEFAULT 'C.C',
  `numero_identificacion` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `embarazo` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reinicios_turnero`
--

CREATE TABLE `reinicios_turnero` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `motivo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `categoria` varchar(50) DEFAULT NULL,
  `visible` enum('SI','NO') DEFAULT 'NO',
  `categoria_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_dia`
--

CREATE TABLE `servicios_dia` (
  `id` int(11) NOT NULL,
  `servicio_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `jornada` enum('mañana','tarde') NOT NULL DEFAULT 'mañana',
  `registrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_jornada`
--

CREATE TABLE `servicios_jornada` (
  `id` int(11) NOT NULL,
  `servicio_id` int(11) NOT NULL,
  `jornada` enum('manana','tarde') NOT NULL,
  `fecha` date NOT NULL,
  `creado_por` int(11) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turnos`
--

CREATE TABLE `turnos` (
  `id` int(11) NOT NULL,
  `paciente_id` int(11) NOT NULL,
  `servicio` varchar(50) NOT NULL,
  `nomenclatura` varchar(20) NOT NULL,
  `estado` varchar(32) NOT NULL,
  `hora_inicio_atencion` datetime DEFAULT NULL,
  `hora_fin_atencion` datetime DEFAULT NULL,
  `motivo_finalizacion` varchar(255) DEFAULT NULL,
  `observaciones_finalizacion` text DEFAULT NULL,
  `numero_turno` int(11) NOT NULL,
  `llamado_en` datetime DEFAULT NULL,
  `consultorio` varchar(20) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha` date NOT NULL DEFAULT curdate(),
  `hora` time NOT NULL DEFAULT curtime(),
  `hora_llamado_siau` datetime DEFAULT NULL,
  `destino_remision` varchar(50) DEFAULT NULL,
  `hora_remision_siau` datetime DEFAULT NULL,
  `hora_programada_consulta` time DEFAULT NULL,
  `hora_asignada` time DEFAULT NULL,
  `preferencial` tinyint(1) DEFAULT 0,
  `atendido_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre_completo` varchar(100) DEFAULT NULL,
  `cargo` varchar(100) DEFAULT NULL,
  `usuario` varchar(100) NOT NULL,
  `clave` varchar(255) NOT NULL,
  `rol` enum('admin','medico','siau') NOT NULL,
  `especialidad_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Índices para tablas volcadas
--

ALTER TABLE `areas_especiales`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

ALTER TABLE `consultorios`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `especialidades_medicas`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `modulos_siau`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pacientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tipo_doc` (`tipo_doc`,`numero_identificacion`),
  ADD UNIQUE KEY `numero_identificacion` (`numero_identificacion`);

ALTER TABLE `reinicios_turnero`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_categoria` (`categoria_id`);

ALTER TABLE `servicios_dia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `servicio_id` (`servicio_id`),
  ADD KEY `registrado_por` (`registrado_por`),
  ADD KEY `idx_servicios_jornada_fecha` (`fecha`,`jornada`,`servicio_id`),
  ADD KEY `idx_serviciosdia_fecha_jornada_servicio` (`fecha`,`jornada`,`servicio_id`);

ALTER TABLE `servicios_jornada`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unq_servicio_fecha_jornada` (`fecha`,`jornada`,`servicio_id`),
  ADD KEY `servicio_id` (`servicio_id`),
  ADD KEY `creado_por` (`creado_por`);

ALTER TABLE `turnos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `paciente_id` (`paciente_id`),
  ADD KEY `idx_turnos_fecha_servicio_estado` (`fecha`,`servicio`,`estado`),
  ADD KEY `idx_turnos_hora_llamado` (`hora_llamado_siau`);

ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD KEY `fk_especialidad_id` (`especialidad_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

ALTER TABLE `areas_especiales` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `categorias` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `consultorios` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `especialidades_medicas` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `modulos_siau` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `pacientes` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `reinicios_turnero` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `servicios` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `servicios_dia` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `servicios_jornada` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `turnos` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `usuarios` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas (FOREIGN KEYS)
--

--
-- Filtros para la tabla `reinicios_turnero`
--
ALTER TABLE `reinicios_turnero`
  ADD CONSTRAINT `fk_reinicios_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD CONSTRAINT `fk_servicios_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `servicios_dia`
--
ALTER TABLE `servicios_dia`
  ADD CONSTRAINT `fk_servicios_dia_servicio` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `servicios_jornada`
--
ALTER TABLE `servicios_jornada`
  ADD CONSTRAINT `fk_servicios_jornada_servicio` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `turnos`
--
ALTER TABLE `turnos`
  ADD CONSTRAINT `fk_turnos_paciente` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_especialidad` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades_medicas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_resumen_diario_servicio`
--
DROP TABLE IF EXISTS `v_resumen_diario_servicio`;
CREATE VIEW `v_resumen_diario_servicio` AS 
SELECT 
  `turnos`.`fecha` AS `fecha`, 
  `turnos`.`servicio` AS `servicio`, 
  sum(`turnos`.`estado` = 'EN_ESPERA') AS `en_espera`, 
  sum(`turnos`.`estado` = 'LLAMADO') AS `llamados`, 
  sum(`turnos`.`estado` = 'EN_ATENCION') AS `en_atencion`, 
  sum(`turnos`.`estado` = 'FINALIZADO') AS `finalizados`, 
  sum(`turnos`.`estado` in ('REMITIDO_SIAU','REMATIDO_SIAU')) AS `remitidos` 
FROM `turnos` 
GROUP BY `turnos`.`fecha`, `turnos`.`servicio`;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
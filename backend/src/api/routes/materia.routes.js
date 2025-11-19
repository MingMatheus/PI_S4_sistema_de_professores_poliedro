const express = require("express")
const router = express.Router()

const materiaController = require("../controllers/materia.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas públicas

// Rotas protegidas

// Rotas restritas
router.post(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  materiaController.createMateria
)

router.get(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  materiaController.getMateriaById
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  materiaController.getTodasMaterias
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  materiaController.updateMateriaById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  materiaController.deleteMateriaById
)

module.exports = router

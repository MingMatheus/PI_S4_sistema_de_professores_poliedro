const express = require("express")
const router = express.Router()

const notaController = require("../controllers/nota.controller")
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
  notaController.createNota
)

router.get(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  notaController.getNotaById
)

router.get(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  notaController.getTodasNotas
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  notaController.updateNotaById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  notaController.deleteNotaById
)

module.exports = router
